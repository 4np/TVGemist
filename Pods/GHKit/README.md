# GHKit - GitHub Kit

[![Build Status](https://travis-ci.org/4np/GHKit.svg?branch=master)](https://travis-ci.org/4np/GHKit)
[![Release](https://img.shields.io/github/release/4np/GHKit.svg)](https://github.com/4np/GHKit/releases/latest)
[![Commits Since](https://img.shields.io/github/commits-since/4np/GHKit/0.0.2.svg?maxAge=3600)](https://github.com/4np/GHKit/commits/master)
[![Platform](https://img.shields.io/badge/platform-tvOS%2011-green.svg?maxAge=3600)](https://developer.apple.com/tvos/)
[![Swift](https://img.shields.io/badge/language-Swift-ed523f.svg?maxAge=3600)](https://swift.org)
[![Open Issues](https://img.shields.io/github/issues/4np/GHKit.svg?maxAge=3600)](https://github.com/4np/GHKit/issues)
[![Closed Issues](https://img.shields.io/github/issues-closed/4np/GHKit.svg?maxAge=3600)](https://github.com/4np/GHKit/issues?q=is%3Aissue+is%3Aclosed)

A Swift 4 Framework for checking for new releases of open source tvOS / iOS / macOS applications, released using GitHub.

## Installation

### Cocoapods

Using cocoapods is the most common way of installing frameworks. Add something similar to the following lines to your `Podfile`. You may need to adjust based on your platform, version/branch etc.

```
source 'https://github.com/CocoaPods/Specs.git'
platform :tvos, '11.0'
use_frameworks!

pod 'NPOKit', :git => 'https://github.com/4np/GHKit.git'
```

### Swift Package Manager

Add the following entry to your package's dependencies:

```swift
.package(url: "https://github.com/4np/GHKit.git", from: "0.0.2")
```

## Setup

`GHKit` was built to work automatically after the initial configuration by running whenever a view controller _did_ load.

All you need to do is configure `GHKit` in your `AppDelegate`'s `application:didFinishLaunchingWithOptions:`. The one method you need to configure is 

```
public func configure(withUser: String, repository: String, shouldIncludePreReleases: Bool, applicationBundle: Bundle, interval: TimeInterval? = nil)
```

| argument                 | description                                            | default value |
|--------------------------|--------------------------------------------------------|---------------|
| withUser                 | GitHub username                                        | n/a           |
| repository               | GitHub Repository name (for this user)                 | n/a           |
| shouldIncludePreReleases | Whether or not to check for pre-releases               | false         |
| applicationBundle        | Your app's bundle (e.g. `Bundle.main`)                 | n/a           |
| interval                 | How often a check for new releases should be performed | daily         |

Version checking and reporting will happen automatically whenever the interval has passed and the user will be prompted to download the latest release.

### Example

```
//
//  AppDelegate.swift
//  TVGemist
//
//  Created by Jeroen Wesbeek on 06/02/2018.
//  Copyright © 2018 Jeroen Wesbeek. All rights reserved.
//

import UIKit
import GHKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // check for new releases every 6 hours
        GHKit.shared.configure(withUser: "4np", repository: "TVGemist", shouldIncludePreReleases: false, applicationBundle: Bundle.main, interval: TimeInterval(exactly: 60 * 60 * 6))
        return true
    }

	...
}
```

### Debugging

In order you test, you could change the interval to 10 seconds (`TimeInterval(exactly: 10)`)

## How does it work?

`GHKit` will [Swizzle](http://nshipster.com/method-swizzling/) `UIViewController`'s `viewDidLoad` method to check for new releases _if_ the interval has passed. It uses the application bundle's version to check against the available GitHub releases and notify the end user if a new version is available. _Note that `GHKit` only reports that a new release is available; it does not download or install anything!_

# Contributing to GHKit

Before sending a pull request, make sure you used the same coding style and that you have linted your code using the most recent [SwiftLint](https://github.com/realm/SwiftLint) release:

```
$ swiftlint
...
Done linting! Found 0 violations, 0 serious in 11 files.
```


# License

See the accompanying [LICENSE](LICENSE) for more information.

```
Copyright 2018 Jeroen Wesbeek

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
