Pod::Spec.new do |s|
  s.name             = "ZSWSuffixTextView"
  s.version          = "1.0"
  s.summary          = "UITextView subclass which displays a suffix after editable text"
  s.description      = <<-DESC
                        ZSWSuffixTextView allows you to set a suffix string, or non-editable text to be
                        appended after the editable text inside the text view.
                        Read more: https://github.com/zacwest/ZSWSuffixTextView
                       DESC
  s.homepage         = "https://github.com/zacwest/ZSWSuffixTextView"
  s.license          = 'MIT'
  s.author           = { "Zachary West" => "zacwest@gmail.com" }
  s.source           = { :git => "https://github.com/zacwest/ZSWSuffixTextView.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/zacwest'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'ZSWSuffixTextView/**/*'
end
