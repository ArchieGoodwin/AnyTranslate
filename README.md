# AnyTranslate
Translate UI on the fly to any user language 

# AnyTranslate Swift API Package

The AnyTranslate Swift API Package empowers iOS and macOS developers to seamlessly translate UI text elements into any user's preferred language. This versatile API offers caching capabilities and allows you to specify the target language for translation. To use the API, you must initiate it with your authentication token.
Request token by email: nerowolfe@wilderdevs.com

## Introduction

As you expand the global reach of your iOS and macOS applications, catering to users from various regions becomes essential. The AnyTranslate Swift API Package simplifies the process of language translation for UI text, ensuring a more inclusive and user-friendly experience. With caching and language configuration options, you can optimize performance and tailor content for different locales.

See in acton: https://drive.google.com/file/d/1wjSm04kmU8g60P-UJXlQh3Qj-bY5s73i/view?usp=share_link

## Key Features

### 1. Text Translation
Translate any text elements into any language supported by the API.

### 2. Caching
Efficiently cache translated text to enhance performance and reduce API requests.

### 3. Language Configuration
Set the target language for translation, enabling localization for different regions.

### 4. Authentication
Secure your API access using authentication tokens for added protection.

## Getting Started

To get started with the AnyTranslate Swift API Package, follow these steps:

1. **subscribe**: Register for an API account to obtain your authentication token.

2. **Installation**: Add the AnyTranslate Swift Package to your iOS or macOS project.

3. **Initialization**: Initiate the API with your authentication token using `AnyTranslate.shared.initiate(token: your_token)`.

4. **Translation**: Translate UI text elements using the `.anyTranslated()` method or `anyTranslated(_ arguments: CVarArg ...)` method. Translation automatically will appear instead of given text after UI refresh and after some time (2-5 sec, only first time, after that cached value will be shown). 

5. **Language Configuration**: Set the target language for translation using `AnyTranslate.shared.applyLanguage("en-US")` to match the user's preference if needed.

6. **Swicth off/on**: Translation can be switchedon/off using method `AnyTranslate.shared.applyAnyTranslation(true/false)`. Current translation status can be checked with `AnyTranslate.shared.isAnyTranslating()`.

## Installation

You can easily integrate the AnyTranslate Swift API Package into your iOS or macOS project using Swift Package Manager.

```swift
import PackageDescription

let package = Package(
    name: "YourAppName",
    dependencies: [
        .package(url: "https://github.com/ArchieGoodwin/AnyTranslate", from: "1.0.1")
    ],
    targets: [
        .target(name: "YourAppTarget", dependencies: ["AnyTranslate"])
    ]
)
```

## Usage

1. **Text Translation**: Translate UI text elements using the `.anyTranslated()` method or `anyTranslated(_ arguments: CVarArg ...)` method. Translation automatically will appear instead of given text after UI refresh (only first time, after that cached value will be shown). 

2. **Caching**: The API automatically caches translations to improve performance. No additional setup is required.

3. **Language Configuration**: Use `AnyTranslate.shared.applyLanguage("en-US")` to set the target language for translation. If not set, the API will use the language for the current user's locale.

## Examples

### Translate UI Text

```swift
import AnyTranslate

// Initialize AnyTranslate with your authentication token
AnyTranslate.shared.initiate(token: "your_token")

// Translate UI text
Text("Hello, World!".anyTranslated())
```

## Contact Us

If you have any questions, encounter issues, or need further assistance, please contact our support team at nerowolfe@wilderdevs.com.

We're excited to help you provide a more inclusive and accessible user experience for your global audience with the AnyTranslate Swift API Package for iOS and macOS!
