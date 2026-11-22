# RTInteractivePush

[![Swift Package](https://github.com/rickytan/RTInteractivePush/actions/workflows/swift-package.yml/badge.svg)](https://github.com/rickytan/RTInteractivePush/actions/workflows/swift-package.yml)
[![Version](https://img.shields.io/cocoapods/v/RTInteractivePush.svg?style=flat)](http://cocoapods.org/pods/RTInteractivePush)
[![License](https://img.shields.io/cocoapods/l/RTInteractivePush.svg?style=flat)](http://cocoapods.org/pods/RTInteractivePush)
[![Platform](https://img.shields.io/cocoapods/p/RTInteractivePush.svg?style=flat)](http://cocoapods.org/pods/RTInteractivePush)

Enjoy the interactive poping feature of `UINavigationController`? But where is the missing interactive pushing? Here it is.

## Example

![ScreenCap](https://user-images.githubusercontent.com/1250207/27914013-7a103aba-6294-11e7-949d-a3fb340e86ce.gif)

```objective-c
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.rt_enableInteractivePush = YES;
    ...
}

- (nullable __kindof UIViewController *)rt_nextSiblingController
{
    return [[YourNewViewController alloc] init];
}
```

## Requirements
- iOS 11.0+
- Xcode 12+ for Swift Package Manager

## Installation

### Swift Package Manager

In Xcode, choose **File > Add Packages...** and enter
`https://github.com/rickytan/RTInteractivePush.git`. Select the `master` branch
and add the `RTInteractivePush` product to your target. Once a release containing
Swift Package support is available, you can select that version instead.

To add the package in a `Package.swift` manifest:

```swift
dependencies: [
    .package(url: "https://github.com/rickytan/RTInteractivePush.git", .branch("master"))
],
targets: [
    .target(
        name: "YourTarget",
        dependencies: [.product(name: "RTInteractivePush", package: "rtinteractivepush")]
    )
]
```

Import the module with `import RTInteractivePush` in Swift or
`@import RTInteractivePush;` in Objective-C. If you link the library as a static
archive, add `-ObjC` to your app target's **Other Linker Flags** so that its
Objective-C categories are loaded.

### CocoaPods

RTInteractivePush remains available through [CocoaPods](http://cocoapods.org):

```ruby
pod "RTInteractivePush"
```

## Author

Ricky Tan, ricky.tan.xin@gmail.com

## License

InteractivePush is available under the MIT license. See the LICENSE file for more info.
