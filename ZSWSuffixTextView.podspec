Pod::Spec.new do |s|
  s.name             = "ZSWSuffixTextView"
  s.version          = "1.0"
  s.summary          = "UITextView subclass which displays a suffix after editable text and a placeholder"
  s.description      = <<-DESC
                        ZSWSuffixTextView is a `UITextView` subclass which supports suffix text, appended after the editable area, and placeholder text, for when nothing has been entered.

                        You can use either of these independently, or together.
                        Read more: https://github.com/zacwest/ZSWSuffixTextView
                       DESC
  s.homepage         = "https://github.com/zacwest/ZSWSuffixTextView"
  s.license          = 'MIT'
  s.author           = { "Zachary West" => "zacwest@gmail.com" }
  s.source           = { :git => "https://github.com/zacwest/ZSWSuffixTextView.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/zacwest'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.default_subspecs = 'Core'

  s.subspec 'Core' do |core|
    core.source_files = 'ZSWSuffixTextView/Core/**/*.{h,m}'
    core.public_header_files = 'ZSWSuffixTextView/Core/**/*.h'
  end

  s.subspec 'Tappable' do |tappable|
    tappable.dependency 'ZSWSuffixTextView/Core'
    tappable.dependency 'ZSWTappableLabel', '>= 1.3'
    tappable.source_files = 'ZSWSuffixTextView/Tappable/**/*.{h,m}'
    tappable.public_header_files = 'ZSWSuffixTextView/Tappable/**/*.h'
  end
end
