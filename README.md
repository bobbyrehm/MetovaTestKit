# Metova Test Kit

[![Build Status](https://travis-ci.org/metova/MetovaTestKit.svg)](https://travis-ci.org/metova/MetovaTestKit)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/MetovaTestKit.svg)](https://img.shields.io/cocoapods/v/MetovaTestKit.svg)
[![Documentation](https://img.shields.io/cocoapods/metrics/doc-percent/MetovaTestKit.svg)](http://cocoadocs.org/docsets/MetovaTestKit/)
[![Coverage Status](https://coveralls.io/repos/github/metova/MetovaTestKit/badge.svg?branch=master)](https://coveralls.io/github/metova/MetovaTestKit?branch=master)
[![Platform](https://img.shields.io/cocoapods/p/MetovaTestKit.svg?style=flat)](http://cocoadocs.org/docsets/MetovaTestKit)
[![Twitter](https://img.shields.io/badge/twitter-@Metova-3CAC84.svg)](http://twitter.com/metova)

Metova Test Kit is a collection of useful test helpers, primarily designed around turning crashing tests into failing tests.

-----

## Requirements

- Swift 2.2
- iOS 8.0

-----

## Installation

Metova Test Kit is available through [CocoaPods](http://cocoapods.org).

Metova Test Kit is intended to be used with unit testing targets.  To install it, add MTK your project's Podfile:

```ruby
# your app's pods
# pod ThunderCats
# pod SwiftCats

target 'YourAppTests', :exclusive => true do
  pod 'MTK'
end
```

And run `pod install`

If you would like to test a beta version of Metova Test Kit, you can install the latest from develop:

```ruby
pod 'MTK', :git => 'https://github.com/metova/MetovaTestKit.git', :branch => 'develop'
```

-----

## Usage

#### MTKTestable

Metova Test Kit defines the `MTKTestable` protocol.  Correct implementation of this protocol allows for functional unit testing.  It abstracts away the set up and tear down code into extensions of the types you want to test, and allows for functional unit tests.

```swift
func testOutlets() {
    HomeViewControllerClass.test { testVC in
        XCTAssertNotNil(testVC.userameTextField)
        XCTAssertNotNil(testVC.passwordTextField)
        XCTAssertNotNil(testVC.loginButton)
    }
}
```

#### Testing exceptions

You can use Metova Test Kit to assert that code that should not throw exceptions doesn't.  Without MTK, this would result in the entire test suite crashing.  With MTK, this is just a failed test, and you still get to run the rest of the test suite.

```swift
MTKAssertNoException {
    // code that should not throw exceptions
    // results in passing test if no exceptions are thrown
    // results in failing test if exceptions are thrown
}
```

You can also pass a message to print on failure.

```swift
MTKAssertNoException(message: "Exception was thrown.") {
    // code that should not throw exceptions
    // results in passing test if no exceptions are thrown
    // results in failing test if exceptions are thrown
}
```

You can also test code to verify that exceptions are thrown, and can do this without crashing your test suite.  If you do not care about the specific exception but only want to verify that the code block throws an exception, you can use `MTKAssertException`:

```swift
MTKAssertException {
    // code that should throw exceptions
    // results in passing test if an exception is thrown
    // results in a failing test if this closure returns without throwing
}
```

Like `MTKAssertNoException`, this function also accepts a message:

```swift
MTKAssertException(message: "No exception was thrown.") {
    // code that should throw exceptions
    // results in passing test if an exception is thrown
    // results in a failing test if this closure returns without throwing
}
```

You can also use `MTKCatchException` to obtain a thrown exception to verify it was the correct exception.

```swift
let exception = MTKCatchException {
    // code that may or may not throw an exception 
}
```

If the closure did not throw an exception, the function returns `nil`.  Otherwise, it returns an instance of `NSException` which you can verify is the exception you expected your block to throw.

-----

## Credits

Metova Test Kit is owned and maintained by [Metova Inc.](https://metova.com)

[Contributors](https://github.com/Metova/MetovaTestKit/graphs/contributors)

## License

Metova Test Kit is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
