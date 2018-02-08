# MochaUtilities

[![Version](https://img.shields.io/cocoapods/v/MochaUtilities.svg?style=flat)](http://cocoapods.org/pods/MochaUtilities)
[![License](https://img.shields.io/cocoapods/l/MochaUtilities.svg?style=flat)](http://cocoapods.org/pods/MochaUtilities)
[![Platform](https://img.shields.io/cocoapods/p/MochaUtilities.svg?style=flat)](http://cocoapods.org/pods/MochaUtilities)

MochaUtilities is library written in Swift intended to help iOS developers during coding.

**This README is still in progress and therefore does not fully documents all classes and methods available.**

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Contribution](#contribution)
- [Author](#author)
- [License](#license)

## Features

MochaUtilities is designed to help iOS developers in as many common needs as possible. During the construction of an iOS project, developers often need the same boilerplate code. This library aims to reduce such code. It does not use any other library from CocoaPods as dependency, since its purpose is to help with more general coding problems.

Please note that to use any functionality of MochaUtilities, a `import MochaUtilities` **must** be included at the file's header.

Most (if not all) public methods from the Util classes are static. In case it isn't, it will be explicitly described so here.

MochaUtilities is divided in subpods which are listed bellow:

- [Basic](#basic)
- [Brazil](#brazil)
- [Core](#core)
- [Images](#images)
- [Network](#network)

### Basic

The Basic subpod contains, as the name implies, the most basic classes and extensions that not only help the users as well as those building the library. This specific pod can but should not be used on its own since it does not provide much to users.

#### MochaException

The `MochaException` enum type is used internally in the MochaUtilities to be more concise in what issue might have occurred. It is associated to the Swift's `Error` type, so it can be thrown as an error.

`MochaException` has the following possible values:

- ioException: Used whenever the [HttpHelper](#httphelper) has encountered a problem, except for the error specified in the appSecurityTransportException described bellow.
- fileNotFoundException: Used whenever the given file reference or path was not found inside the application's bundle or documents. Mainly used in the [BundleUtil](#bundleutil) and [DocumentsUtil](#documentsutil) classes.
- appSecurityTransportException: Used whenever [HttpHelper](#httphelper) requests data but access to the given URL is not permitted through the project's App Security Transport value in Info.plist.
- notImplemented: Used whenever a prior method or class inheritance is required but was not implemented.
- domainException: Used whenever any value or convertion inside MochaUtilities is invalid. This specific value might be removed for version 1.0.
- genericException: Used whenever an unespecified error occurs.

#### String+Basic

An extension for the `String` class that will be used throughout the MochaUtilities implementations. It consists of the get-only properties `length` and `isNotEmpty`, and the method `equalsIgnoreCase(_:).`

The `length` property returns, as expected, the length of the `String`. It might be removed when this Pod supports Swift 4. The `isNotEmpty` simply return if the `String` is not empty. Though this information can accessed through `!someString.isEmpty`, it helps for a more readable code.

```swift
let lenth = "my_length".length
//length = 9

"".isNotEmpty
//false

"Non Empty String".isNotEmpty
//true
```

The `equalsIgnoreCase(_:)` method compares the `String` itself to another given `String` without taking cases into consideration. This method can also compare non-English words.

```swift
let someText = "lorem ipsum"
let otherText = "Lorem Ipsum"
print(someText.equalsIgnoreCase(otherText))
//prints true since both Strings are essentially the same except one is capitalized

let heart = "coração"
let hearts = "corações"
print(heart.equalsIgnoreCase(hearts))
//prints false since both Strings varies at the end
```

#### MochaLogger

The default logging class used by MochaUtilities. It uses the Singleton pattern. Its public methods are `changeTag(to:)`, `removeTag()` and `log(_:)`. The default tag used is `Mocha`.

Whenever a message is logged through `MochaLogger`, it adds a prefix `[<given_tag>]`, if and only if the `removeTag()` was not called. Therefore, by default if it logs `message`, the console will print `[Mocha] message`.

```swift
MochaLogger.log("This is a test.")
//prints [Mocha] This is a test.

MochaLogger.changeTag(to: "New Tag")
MochaLogger.log("Trying out a new tag.")
//prints [New Tag] Trying out a new tag.

MochaLogger.removeTag()
MochaLogger.log("Works just like print.")
//prints Works just like print.
```

### Brazil

The Brazil subpod provides specific functionalities for Brazilian developers.

#### CpfUtil

This class is responsible for applying or removing CPF (Cadastro de Pessoa Física) mask from `String`. It can also check whether a given `String?` is a valid CPF.

For masking and unmasking a `String?`, use `mask(_:)` and `unmask(_:)` respectively. If the given value cannot be masked or unmasked, these methods will return an empty `String` instead.

There is also a method for checking if a given `String?` has the mask applied to it or not.

```swift
let masked = CpfUtil.mask("12345678900")
//masked equals 123.456.879-00

let unmasked = CpfUtil.unmask("123.456.789-00")
//unmasked equals 12345678900
```

The `isValid(_:)` method, as it suggests, checks whether a given `String?` is a valid CPF. If the given `String?` is nil, empty or cannot be converted to numeric value, it returns `false`.

```swift
let maskedCheck = CpfUtil.isValid("000.000.000-00")
//maskedCheck is true

let unmaskedCheck = CpfUtil.isValid("00000000000")
//unmaskedCheck is also true
```

### Core

The Core subpod provides access to the most used features during iOS programming.

#### String+Core

#### UIColor+Core

#### Preferences

#### AppUtil

#### BundleUtil

#### DateUtil

#### DeviceUtil

#### DocumentsUtil

#### FileUtil

#### KeyboardUtil

#### NavigationBarUtil

#### NumberUtil

The `NumberUtil` class helps to work with numeric values in `String?` (optional String) format. It can convert to specific number types.

For conversion, the methods available are `toInteger(_:, with:)`, `toFloat(_:, with:)` and `toDouble(_:, with:)` and `toNumber(_:, with:)`. In case the given `String?` is nil or cannot be converted to the wanted number type, a default value will be returned instead. If the default value is not passed, it will be zero by default.

The example bellow show how the `toInteger(_:, with:)` method works. The other methods described above work similarly to their types.

```swift
let integerString = "123"
let integer = NumberUtil.toInteger(integerString)
//integer is an Int with value 123

let nonIntegerString = "4a5"
let defaultValue = NumberUtil.toInteger(nonIntegerString)
//since no extra argument was given and nonIntegerString cannot be converted to an integer,
//defaultValue will be 0 (zero)

let anotherDefaultValue = NumberUtil.toInteger(nonIntegerString, with: -1)
//since nonIntegerString cannot be converted to an integer,
//anotherDefaultValue will be -1
```

#### OrientationUtil

#### StatusBarUtil

#### TabBarUtil

#### NotificationUtil

### Images

The Images subpod helps with a few image related problems.

#### UIColor+Image

#### ImageUtil

#### PrintScreenUtil

### Network

The Network subpod contains classes aimed to help with Internet related processes, such as HTTP requests.

#### MochaEmailAttachment

#### HttpHelper

`HttpHelper` assists with handling HTTP/HTTPS requests and responses. It is constructed under the Builder pattern. The Builder is an inner class of the `HttpHelper` class. The following code demonstrates how to make a simple GET request.

```swift
let handler = { (data: Data?, error: Error?) in
//handle response information
}

//directly get the reference to HttpHelper
let httpHelper = HttpHelper.builder.url("http://www.google.com").completionHandler(handler).build()
httpHelper.get()
```

The following should be taken into consideration before usage:

- The Builder methods `url(_: String)` and `completionHandler(_: @escaping HttpCompletionHandler)` are **mandatory** for all requests. If not set, the request will fail or will not return the received response.
- The type `HttpCompletionHandler` is defined as the closure `(_ data: Data?, _ error: Error?) -> Void`.
- The request's `contentType` defaults to `application/json`.
- The request's `timeout` defaults to 60 seconds.
- The request's `encoding` defaults to UTF-8.
- Other possible configurations are `parameters(_:)`, `header(_:)`, `basicAuth(username:, password:)`, `certificate(_:, with:)`, `trustAll(_:)` and `hostDomain(_:)`.

To set the Basic Authentication header into your HTTP request, use the `basicAuth(username: String, password: String)` method as follows:

```swift
let httpHelper = HttpHelper.builder.url(someUrl).completionHandler(someHandler)
  .basicAuth(username: "request_basic_auth_usr", password: "request_basic_auth_pwd").build()
httpHelper.get()
```

If necessary, retain the reference to the `HttpHelper.Builder` class before using the `build()` method. It might become necessary to configure the request according to some parameters. For example:

```swift
func doHttpRequest(needsBasicAuth: Bool, addDefaultHeader: Bool) {
  let handler = { (data: Data?, error: Error?) in
    //handle response information
  }
  //directly get the reference to HttpHelper
  let builder = HttpHelper.builder.url("http://www.google.com").completionHandler(handler)
  if needsBasicAuth {
    builder.basicAuth(username: "request_basic_auth_usr", password: "request_basic_auth_pwd")
  }
  if addDefaultHeader {
    builder.header(["default_header_key": "default_header_value"])
  }
  ...
  let httpHelper = builder.build()
  httpHelper.get()
}
```

More examples will be included as the documentation grows.

#### EmailUtilDelegate

The protocol used to communicate the caller class and [EmailUtil](#emailutil). Its methods are `onEmailSuccess()`, `onEmailCancelled()` and `onEmailFailed()`, all of which are of mandatory implementation.

#### BrowserUtil

To open the default browser of the device, use the `openUrl(_: String?)`. If the given String is nil or is not valid, no action is taken.

```swift
@IBAction func onClickOpenBrowser(sender: Any?) {
  let url = "http..."
  BrowserUtil.openUrl(url)
}
```

#### EmailUtil

## Requirements

- iOS 8.0+
- Xcode 8.1+
- Swift 3.0+

## Installation

MochaUtilities is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "MochaUtilities"
```

In case only one specific module is needed, add the following line to your Podfile:

```ruby
pod "MochaUtilities/<NAME_OF_MODULE>"
```

For more information about the available modules, check the [Features](#features) section.

## Contribution

If you have suggestions, improvements or issues to submit (whether about the code or this README), feel free to contact me or send a pull request.

This library follows the [Swift Style Guide](https://github.com/raywenderlich/swift-style-guide). Before submitting any code, verify if it also follows this guideline. In case you find any code already submitted that does not follow the guideline, also feel free to contact me or send a pull request.

Only commits in English are accepted.

## Author

Gregory Sholl e Santos

gregorysholl@gmail.com

## License

MochaUtilities is available under the MIT license. See the LICENSE file for more info.
