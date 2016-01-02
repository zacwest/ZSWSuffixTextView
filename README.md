# ZSWSuffixTextView

<!-- [![CI Status](http://img.shields.io/travis/Zachary West/ZSWSuffixTextView.svg?style=flat)](https://travis-ci.org/Zachary West/ZSWSuffixTextView) -->
[![Version](https://img.shields.io/cocoapods/v/ZSWSuffixTextView.svg?style=flat)](http://cocoapods.org/pods/ZSWSuffixTextView)
[![License](https://img.shields.io/cocoapods/l/ZSWSuffixTextView.svg?style=flat)](http://cocoapods.org/pods/ZSWSuffixTextView)
[![Platform](https://img.shields.io/cocoapods/p/ZSWSuffixTextView.svg?style=flat)](http://cocoapods.org/pods/ZSWSuffixTextView)

ZSWSuffixTextView is a `UITextView` subclass which exposes two main features:

- A suffix string, appended to the end of the editable area
- A placeholder for the editable area

This is done without modifying any text inside the text view, so your delegates don't need to worry about the specifics; it's a drop-in replacement.

<img src="http://i.imgur.com/c2CAcmU.gif" style="width: 320px; height: 142px;">

## Tappable

Using the `Tappable` submodule, this library uses [ZSWTappableLabel](https://github.com/zacwest/ZSWTappableLabel) for suffix text. With this label change, you can make substrings of your suffix tappable or long-pressable, similar to the Facebook status updating screen.

You can see what's exposed in this subspec in the [ZSWSuffixTextView+Tappable](https://github.com/zacwest/ZSWSuffixTextView/blob/master/ZSWSuffixTextView/Tappable/ZSWSuffixTextView+Tappable.h) header. For more information on setting up tappable regions, refer to the [documentation](https://github.com/zacwest/ZSWTappableLabel/blob/master/README.md) for the tappable label.

## Right-to-left

ZSWSuffixTextView supports right-to-left text input for the placeholder and the suffix text. If you provide left-to-right text for the placeholder or suffix, they are forced to behave like right-to-left.

<img src="http://i.imgur.com/qmuWJO4.png" style="width: 320px; height: 143px;">

## Installation

ZSWSuffixTextView is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line(s) to your Podfile:

```ruby
pod "ZSWSuffixTextView", "~> 1.0"
pod "ZSWSuffixTextView/Tappable", "~> 1.0" # for tap support
```

## License

ZSWSuffixTextView is available under the [MIT license](https://github.com/zacwest/ZSWSuffixTextView/blob/master/LICENSE).
