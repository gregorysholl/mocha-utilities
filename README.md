# MochaUtilities

[![CI Status](http://img.shields.io/travis/gregorysholl/MochaUtilities.svg?style=flat)](https://travis-ci.org/gregorysholl/MochaUtilities)
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

Most (if not all) public methods from the Util classes are static. In case it isn't, it will be explicitly described so here.

MochaUtilities is divided in subpods which are listed bellow:

- [Basic](#basic)
- [Core](#core)
- [Images](#images)
- [Network](#network)

### Basic

The Basic pod contains, as the name implies, the most basic classes and extensions that not only help the users as well as those building the library. This specific pod can but should not be used on its own since it does not provide much to users.

#### MochaException

The `MochaException` enum type is used internally in the MochaUtilities to be more concise in what issue might have occurred. It is associated to the Swift's `Error` type, so it can be thrown as an error.

#### String+Basic

#### MochaLogger

### Core

The Core pod provides access to the most used features during iOS programming.

#### String+Core

#### Preferences

#### AppUtil

#### DeviceUtil

#### KeyboardUtil

#### NavigationBarUtil

#### NumberUtil

The `NumberUtil` class helps to work with numeric values in `String?` (optional String) format. It can convert to specific number types or check if the given `String?` can be represented as a number.

For conversion, the methods available are `toInteger(_:, with:)`, `toFloat(_:, with:)` and `toDouble(_:, with:)` and `toNumber(_:, with:)`. In case the given `String?` is nil or cannot be converted to the wanted number type, a default value will be returned instead. If the default value is not passed, it will be zero by default.

The example bellow show how the `toInteger(_:, with:)` method works. The other methods described above work similarly to their types.

```swift
import MochaUtilities

func convertStrings() {
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
}
```

Another method available is `isNumber(_:)` which return a boolean if the given `String?` can be converted to a number type.

```swift
import MochaUtilities

func checkNumberStrings() {
  let numberString = "3.1415"
  print(NumberUtil.isNumber(numberString))
  //prints true
  
  let nonNumberString = "3.1415.pi"
  print(NumberUtil.isNumber(nonNumberString))
  //prints false
}
```

#### OrientationUtil

#### StatusBarUtil

#### TabBarUtil

#### NotificationUtil

### Images

The Images pod helps with a few image related methods.

#### UIColor+Image

#### ImageUtil

#### PrintScreenUtil

### Network

The Network pod contains classes aimed to help with Internet related processes, such as HTTP requests.

#### Http Helper

`HttpHelper` assists with handling HTTP/HTTPS requests and responses. It is constructed under the Builder pattern. The Builder is an inner class of the `HttpHelper`. The following code demonstrates how to make a simple GET request.

```swift
import MochaUtilities

func getSomeData() {
  let handler = { (data: Data?, error: Error?) in
    //handle response information
  }
  //directly get the reference to HttpHelper
  let httpHelper = HttpHelper.Builder().setUrl("http://www.google.com").setCompletionHandler(handler).build()
  httpHelper.get()
}
```

The following should be taken into consideration before usage:

- The Builder methods `setUrl(_: String)` and `setCompletionHandler(_: @escaping HttpCompletionHandler)` are **mandatory**. If not set, the request will fail or will not return the received response.
- The type `HttpCompletionHandler` is defined as the closure `(_ data: Data?, _ error: Error?) -> Void`.
- The request's `contentType` defaults to `application/json`.
- The request's `timeout` defaults to 60 seconds.
- The request's `encoding` defaults to UTF-8.
- Other possible configurations are `setParameters(_: [String: Any])`, `setHeader(_: [String: String])`, `setBasicAuth(username: String, password: String)`, `setCertificate(_: Data?, with: String?)`, `setTrustAll(_: Bool)` and `setHostDomain(_: String)`.

To set the Basic Authentication header into your HTTP request, use the `setBasicAuth(username: String, password: String)` method as follows:

```swift
import MochaUtilities

func getDataWithBasicAuth() {
  let httpHelper = HttpHelper.Builder().setUrl(someUrl).setCompletionHandler(someHandler).setBasicAuth(username: "request_basic_auth_usr", password: "request_basic_auth_pwd").build()
  httpHelper.get()
}
```

If necessary, retain the reference to the `HttpHelper.Builder` class before using the `build()` method. It might become necessary to configure the request according to some parameters. For example:

```swift
import MochaUtilities

func doHttpRequest(needsBasicAuth: Bool, addDefaultHeader: Bool) {
  let handler = { (data: Data?, error: Error?) in
    //handle response information
  }
  //directly get the reference to HttpHelper
  let builder = HttpHelper.Builder().setUrl("http://www.google.com").setCompletionHandler(handler)
  if needsBasicAuth {
    builder.setBasicAuth(username: "request_basic_auth_usr", password: "request_basic_auth_pwd")
  }
  if addDefaultHeader {
    builder.setHeader(["default_header_key": "default_header_value"])
  }
  ...
  let httpHelper = builder.build()
  httpHelper.get()
}
```

More examples will be included as the documentation grows.

#### Browser Util

To open the default browser of the device, use the `openUrl(_: String?)`. If the given String is nil or is not valid, no action is taken.

```swift
import MochaUtilities

@IBAction func onClickOpenBrowser(sender: Any?) {
  let url = "http..."
  BrowserUtil.openUrl(url)
}
```

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
