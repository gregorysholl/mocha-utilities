# MochaUtilities

[![CI Status](http://img.shields.io/travis/gregorysholl/MochaUtilities.svg?style=flat)](https://travis-ci.org/gregorysholl/MochaUtilities)
[![Version](https://img.shields.io/cocoapods/v/MochaUtilities.svg?style=flat)](http://cocoapods.org/pods/MochaUtilities)
[![License](https://img.shields.io/cocoapods/l/MochaUtilities.svg?style=flat)](http://cocoapods.org/pods/MochaUtilities)
[![Platform](https://img.shields.io/cocoapods/p/MochaUtilities.svg?style=flat)](http://cocoapods.org/pods/MochaUtilities)

MochaUtilities is library written in Swift intended to help iOS developers during coding.

**This README is still in progress and therefore does not fully documents all classes and methods available.**

- [Features](#features)
- [Component Libraries](#component-libraries)
- [Requirements](#requirements)
- [Contribution](#contribution)
- [Author](#author)
- [License](#license)

## Features

MochaUtilities is designed to help iOS developers in as many common needs as possible. During the construction of an iOS project, developers often need the same boilerplate code. This library aims to reduce such code. It does not use any other library from CocoaPods as dependency, since its purpose is to help with more general coding problems.

MochaUtilities is divided in subpods which are listed bellow:

- [Basic](#basic)
- [Core](#core)
- [Images](#images)
- [Network](#network)

### Basic

The Basic pod contains, as the name implies, the most basic classes and extensions that not only help the users as well as those building the library. This specific pod can but should not be used alone since it does not provide much to users.

### Core

The Core pod provides access to the most used features during iOS programming.

### Images

The Images pod helps with a few image related methods.

### Network

The Network pod contains classes aimed to help with Internet related processes, such as HTTP requests.

#### Http Helper

The HttpHelper class assists with handling HTTP/HTTPS requests and responses. It is constructed under the Builder pattern. The following code demonstrates how to make a simple GET request.

```swift
import MochaUtilities

func getSomeData() {
  let handler = { data, error in
    //handle response information
  }
  let httpHelper = HttpHelper.Builder().setUrl("http://www.google.com").setCompletionHandler(handler).build()
  httpHelper.get()
}
```

#### Browser Utils

To open the default browser of the device, use the following method.

```swift
BrowserUtils.openUrl(_: String?)
```

Other possible configurations are `setParameters(_: [String: Any])`, `setContentType(_: String)`, `setTimeout(_: TimeInterval)`, `setEncoding(_: String.Encoding)`, `setHeader(_: [String: String])`, `setBasicAuth(username: String, password: String)`, `setCertificate(_: Data?, with: String?)`, `setTrustAll(_: Bool)` and `setHostDomain(_: String)`. More examples will be included as the documentation grows.

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
pod "MochaUtilities/<NAME_OF_MODULE>
```

For more information about the available modules, check the [Features](#features) section.

## Contribution

If you have suggestions, improvements or issues to submit (whether about the code or this README), feel free to contact me or send a pull request.

This library follows the [Swift Style Guide](https://github.com/raywenderlich/swift-style-guide). Before submitting any code, verify if it also follows this guideline. In case you find any code already submitted that does not follow the guideline, also feel free to contact me or send a pull request.

## Author

Gregory Sholl e Santos, gregorysholl@gmail.com

## License

MochaUtilities is available under the MIT license. See the LICENSE file for more info.
