# ZSWSuffixTextView

<!-- [![CI Status](http://img.shields.io/travis/Zachary West/ZSWSuffixTextView.svg?style=flat)](https://travis-ci.org/Zachary West/ZSWSuffixTextView) -->
[![Version](https://img.shields.io/cocoapods/v/ZSWSuffixTextView.svg?style=flat)](http://cocoapods.org/pods/ZSWSuffixTextView)
[![License](https://img.shields.io/cocoapods/l/ZSWSuffixTextView.svg?style=flat)](http://cocoapods.org/pods/ZSWSuffixTextView)
[![Platform](https://img.shields.io/cocoapods/p/ZSWSuffixTextView.svg?style=flat)](http://cocoapods.org/pods/ZSWSuffixTextView)

ZSWSuffixTextView is a `UITextView` subclass which supports:

- Suffix text, appended after the editable area
- Placeholder text, for when nothing has been entered

You can use either of these independently, or together. This is done without modifying any text so your delegates do not need modification for text processing. It's a drop-in replacement.

<img src="http://i.imgur.com/c2CAcmU.gif" width="320" height="142">

You can view the [header file](https://github.com/zacwest/ZSWSuffixTextView/blob/master/ZSWSuffixTextView/Core/ZSWSuffixTextView.h) for more detailed documentation on configuration, or view the [example project](https://github.com/zacwest/ZSWSuffixTextView/blob/master/Example/ZSWSuffixTextView) for general usage.

## Placeholder

You can set placeholder text and text color. Other attributes for the placeholder text are inherited from the text view.

```swift
var placeholderTextColor: UIColor! // defaults to 70% black
var placeholder: String?
```

You may update the placeholder text at any time.

## Suffix text

You can set an `NSString` or `NSAttributedString` version of the suffix text. By default, the font and color attributes are inherited from the text view.

```swift
var suffixTextColor: UIColor! // defaults to same as text
var suffix: String?
var attributedSuffix: NSAttributedString?
var suffixSpacing: CGFloat
```

If you use an attributed version, be aware that the `NSParagraphStyle` will be modified (or added) to handle positioning (via `firstLineHeadIndent`) and forced right-to-left (via `baseWritingDirection`).

## Tappable

With the `Tappable` subspec, this class uses [ZSWTappableLabel](https://github.com/zacwest/ZSWTappableLabel). This allows regions of your suffix text to be tappable, similar to the Facebook status updating screen. This is done via two exposed properties:

```swift
var suffixTapDelegate: ZSWTappableLabelTapDelegate?
var suffixLongPressDelegate: ZSWTappableLabelLongPressDelegate?
```

For more information on setting up tappable regions, refer to the [documentation](https://github.com/zacwest/ZSWTappableLabel/blob/master/README.md) for the tappable label.


## Right-to-left

ZSWSuffixTextView supports right-to-left text input for the placeholder and the suffix text. 

<img src="http://i.imgur.com/qmuWJO4.png" width="320" height="143">

If you provide left-to-right text for either, they are forced to behave like right-to-left.

## Installation

ZSWSuffixTextView is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line(s) to your Podfile:

```ruby
pod "ZSWSuffixTextView", "~> 1.0"
pod "ZSWSuffixTextView/Tappable", "~> 1.0" # for tap support
```

## License

ZSWSuffixTextView is available under the [MIT license](https://github.com/zacwest/ZSWSuffixTextView/blob/master/LICENSE).
