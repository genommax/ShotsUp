# ShotsUP – alternative iOS Dribbble client


ShotsUP is an open-source prototype for Dribbble, wrote on Swift and builded on Clean architecture.

<p align=center>
![](dsup.mov.gif)
</p>

## *Usage*

To get started and run the app, you need to follow these simple steps:

Open the ShotsUp workspace in Xcode.
Sign up for a Dribbble account.
Register a new Dribbble application (a new Client Access Token will be generated for the application).
Setup Client Access Token. For this exist three way:
	1. In project folder run _pod install_ and set token
	2. In project folder execute next command
	pod keys set DribbbleClientID YOUR_VALUE
	pod keys set DribbbleClientSecret YOUR_VALUE
	pod keys set DribbbleClientAccessToken YOUR_VALUE
	3. Set tokens DribbbleClientID, DribbbleClientSecret, DribbbleClientAccessToken in DribbbleAPIConfig struct.
Run ShotsUp on your iOS device or Simulator.

## *Compatibility*

* This project is written in Swift 3.0+ and requires Xcode 9+ to build and run.
* ShotsUp runs on iOS 11+.

## *Dependencies*

Under the hood is a little CocoaPods.
* Moya
* IGListKit
* RealmSwift
* Moya-ObjectMapper
* Kingfisher
* Reusable
* HGPlaceholders
* SwiftMessages
* ActiveLabel

## *About*

Created by Maxim Liashenko -  [genommax (Maxim Liashenko) · GitHub](https://github.com/genommax)
Other links:
* [www.kruk.agency](https://www.kruk.agency)
* [behance.net](https://www.behance.net/krukagency)
* [dribbble.com](https://dribbble.com/genommax)
* [linkedin.com](https://www.linkedin.com/in/maximlyashenko/)
* [medium.com](https://medium.com/@genommax)

## *License*

The library is available as open source under the terms of the MIT License.
