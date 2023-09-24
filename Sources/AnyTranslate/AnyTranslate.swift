//
//  AnyTranslate.swift
//  Babelfish
//
//  Created by Sergey Dikarev on 9/23/23.
//

import Foundation
import Combine

public class AnyTranslate {
    static var shared = AnyTranslate()
    private var token: String = ""
    private var languageCode: String = ""
    public let anytranslatePublisher = PassthroughSubject<(String, String), Never>()

    public func initiate(token: String) {
        self.token = token
    }
    
    private func languageNameEng() -> String {
        let currentLocale = Locale.preferredLocale()
        let locale: Locale = Locale(identifier: "en")
        //print("currentLocale.identifier", currentLocale.identifier, locale.localizedString(forLanguageCode: currentLocale.identifier))
        return locale.localizedString(forLanguageCode: languageCode.isEmpty ? currentLocale.identifier : languageCode) ?? "English"
        
    }
    
    public func applyLanguage(_ code: String) {
        languageCode = code
    }
    
    public func isAnyTranslating() -> Bool {
        return UserDefaults.standard.bool(forKey: "anytranslate.apply")
    }
    
    public func applyAnyTranslation(_ flag: Bool) {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            if key.hasPrefix("anytranslate.") && key != "anytranslate.apply" {
                UserDefaults.standard.setValue(nil, forKey: key)
            }
        }
        UserDefaults.standard.set(flag, forKey: "anytranslate.apply")
        if !flag {
            DispatchQueue.main.async {
                self.anytranslatePublisher.send(("", ""))
            }
        }
    }
    
    private func valueFromCache(key: String) -> String?
    {
        return UserDefaults.standard.string(forKey: "anytranslate.\(key)")
    }
    
    public func Translate(_ key: String) -> String {
        return anyTranslate(text: key)
    }

    public func Translate(_ key: String, _ arguments: CVarArg...) -> String {
        return String.init(format: anyTranslate(text: key), arguments: arguments)
    }
    
    private func anyTranslate(text: String) -> String {
        let flag = UserDefaults.standard.bool(forKey: "anytranslate.apply")
        if !flag {
            return text
        }
        
        if let value = valueFromCache(key: text) {
            guard flag == true else {
                return text
            }
            return value
        } else {
            Task {
                do {
                    if let value = try await generateText(idea: text, language: languageNameEng()) {
                        UserDefaults.standard.set(value, forKey: "anytranslate.\(text)")
                        DispatchQueue.main.async {
                            self.anytranslatePublisher.send((text, value))
                        }
                    }
                } catch {
                    print(error)
                }
            }
            return text

        }
    }
    
    private func generateText(idea: String, language: String) async throws -> String? {
        
        guard !token.isEmpty else {
            throw AnyTranslateAPIError.unauthorized
        }
        
        let session = URLSession.shared
        let url = URL(string: "https://anytranslate.thebabel.fish/api/v1/anytranslate")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        guard let jsonBody = try? JSONEncoder().encode(AnyTranslateRequest(text: idea, language: language)) else {
            throw AnyTranslateAPIError.unableToEncodeJSONData
        }
        
        request.httpBody = jsonBody
        
        do {
            let (data, _) = try await session.data(for: request)
            //Log(NSString(string: String(decoding: data, as: UTF8.self)))
            let response = try JSONDecoder().decode(AnyTranslateResponse.self, from: data)
            return response.anytranslate
        }
        catch(let error)
        {
            throw AnyTranslateAPIError.httpError(message: error.localizedDescription)
        }
        
        
       
    }
}

public extension String {
    func anyTranslated(_ arguments: CVarArg ...) -> String {
        String(format: AnyTranslate.shared.Translate(self), arguments)
    }
}


extension Locale {
    static func preferredLocale() -> Locale {
        guard let preferredIdentifier = Locale.preferredLanguages.first else {
            return Locale.current
        }
        return Locale(identifier: preferredIdentifier)
    }
}


struct AnyTranslateRequest: Encodable {
    let text: String
    let language: String
}

struct AnyTranslateResponse: Decodable {
    let anytranslate: String
}

public enum AnyTranslateAPIError: Error {
  case identityTokenMissing
  case unableToDecodeIdentityToken
  case unableToEncodeJSONData
  case unableToDecodeJSONData
  case unauthorized
  case invalidResponse
  case httpError(message: String)
  case httpErrorWithStatus(status: Int)

}
