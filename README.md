SobrKit
=======

SobrKit is a collection of UIKit, Foundation and other extensions written in Swift.

## API Breaking Changes
SobrKit does not depend on Alamofire anymore! This will break (maybe) your app. If your app depends on the Alamofire extensions of SobrKit, be sure to use the 1.x version!


## Features
- Bind UI elements to your model directly in Interface Builder
- Convenience methods on Foundation classes

## Requirements
- iOS 8.0+
- Xcode 7

## Communication
- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Installation

> **Embedded frameworks require a minimum deployment target of iOS 8 or OS X Mavericks.**

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects.

CocoaPods 0.36 adds supports for Swift and embedded frameworks. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate Alamofire into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'SobrKit'
```

Then, run the following command:

```bash
$ pod install
```

> SobrKit will install `pod 'Alamofire', '~> 1.2'` as dependency.

## Usage

See [SobrKit-Example](https://github.com/softwarebrauerei/SobrKit-Example) for details.


## Authors

- Silas Knobel, https://github.com/katunch
- Domenic Benz, https://github.com/domenicbenz

## License

SobrKit is available under the MIT license. See the LICENSE file for more info.
