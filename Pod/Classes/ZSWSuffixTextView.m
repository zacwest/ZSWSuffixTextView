//
//  ZSWSuffixTextView.m
//  Pods
//
//  Created by Zachary West on 12/26/15.
//
//

#import "ZSWSuffixTextView.h"

typedef NS_OPTIONS(NSInteger, ZSWSuffixState) {
    ZSWSuffixStateNone = 0,
    ZSWSuffixStatePlaceholder = 0b1,
    ZSWSuffixStateSuffix = 0b10
};

@interface ZSWSuffixTextView()
@property (nonatomic) UILabel *placeholderLabel;
@property (nonatomic) UILabel *suffixLabel;
@end

@implementation ZSWSuffixTextView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self suffixTextViewCommonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self suffixTextViewCommonInit];
    }
    return self;
}

- (void)suffixTextViewCommonInit {
    self.placeholderLabel = [[UILabel alloc] init];
    [self addSubview:self.placeholderLabel];
    
    Class labelClass = NSClassFromString(@"ZSWTappableLabel");
    if (!labelClass) {
        labelClass = [UILabel class];
    }
    
    self.suffixLabel = [[labelClass alloc] init];
    self.suffixLabel.numberOfLines = 0;
    [self addSubview:self.suffixLabel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textViewDidChange_ZSW)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self];
    [self textViewDidChange_ZSW];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (ZSWSuffixState)suffixState {
    ZSWSuffixState state = ZSWSuffixStateNone;
    
    if (self.text.length == 0 && self.placeholderLabel.text.length > 0) {
        state |= ZSWSuffixStatePlaceholder;
    }
    
    if (self.suffixLabel.text.length > 0) {
        state |= ZSWSuffixStateSuffix;
    }
    
    return state;
}

- (ZSWSuffixState)visibleSuffixState {
    ZSWSuffixState state = ZSWSuffixStateNone;
    
    if (!self.placeholderLabel.isHidden) {
        state |= ZSWSuffixStatePlaceholder;
    }
    
    if (!self.suffixLabel.isHidden) {
        state |= ZSWSuffixStateSuffix;
    }
    
    return state;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    ZSWSuffixState state = self.visibleSuffixState;
    
    if (state & ZSWSuffixStatePlaceholder) {
        CGRect caretRect = [self caretRectForPosition:self.beginningOfDocument];
        CGFloat remainingWidth = CGRectGetMaxX(self.bounds) - CGRectGetMinX(caretRect) - self.textContainerInset.right;
        self.placeholderLabel.frame = (CGRect){caretRect.origin, CGSizeMake(remainingWidth, self.placeholderLabel.font.lineHeight)};
    }
    
    if (state & ZSWSuffixStateSuffix) {
        CGRect priorRect;
        
        if (state & ZSWSuffixStatePlaceholder) {
            CGSize desiredSize = [self.placeholderLabel sizeThatFits:self.placeholderLabel.bounds.size];
            priorRect = (CGRect){self.placeholderLabel.frame.origin, desiredSize};
        } else {
            priorRect = [self caretRectForPosition:self.endOfDocument];
        }

        __block NSRange effectiveRange = NSMakeRange(0, self.suffix.length);
        
        NSMutableParagraphStyle *paragraphStyle = ^NSMutableParagraphStyle *{
            NSParagraphStyle *existingStyle = [self.attributedSuffix attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:&effectiveRange];
            
            if (!existingStyle) {
                existingStyle = [NSParagraphStyle defaultParagraphStyle];
            }
            
            return [existingStyle mutableCopy];
        }();
        
        paragraphStyle.firstLineHeadIndent = CGRectGetMaxX(priorRect) - self.textContainerInset.left;
        
        NSMutableAttributedString *updatedString = [self.attributedSuffix mutableCopy];
        [updatedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:effectiveRange];
        self.suffixLabel.attributedText = updatedString;
        
        CGFloat width = CGRectGetWidth(UIEdgeInsetsInsetRect(self.bounds, self.textContainerInset));
        CGSize sizeThatFits = [self.suffixLabel sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
        
        self.suffixLabel.frame = CGRectMake(self.textContainerInset.left, CGRectGetMinY(priorRect), width, sizeThatFits.height);
    }
}

- (void)textViewDidChange_ZSW {
    ZSWSuffixState suffixState = self.suffixState;
    ZSWSuffixState visibleState = self.visibleSuffixState;
    
    if (suffixState != visibleState) {
        self.placeholderLabel.hidden = !(suffixState & ZSWSuffixStatePlaceholder);
        self.suffixLabel.hidden = !(suffixState & ZSWSuffixStateSuffix);
        [self setNeedsLayout];
    } else if (suffixState & ZSWSuffixStateSuffix) {
        // Always layout when we have a suffix set, because its position changes
        [self setNeedsLayout];
    }
}

#pragma mark - Wrappers

- (NSString *)placeholder {
    return self.placeholderLabel.text;
}

- (void)setPlaceholder:(NSString *)placeholder {
    self.placeholderLabel.text = placeholder;
}

- (NSAttributedString *)attributedPlaceholder {
    return self.placeholderLabel.attributedText;
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder {
    self.placeholderLabel.attributedText = attributedPlaceholder;
}

- (UIFont *)placeholderFont {
    return self.placeholderLabel.font;
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    self.placeholderLabel.font = placeholderFont;
}

- (UIColor *)placeholderTextColor {
    return self.placeholderLabel.textColor;
}

- (void)setPlaceholderTextColor:(UIColor *)placeholderTextColor {
    self.placeholderLabel.textColor = placeholderTextColor;
}

- (NSString *)suffix {
    return self.suffixLabel.text;
}

- (void)setSuffix:(NSString *)suffix {
    self.suffixLabel.text = suffix;
    [self setNeedsLayout];
}

- (NSAttributedString *)attributedSuffix {
    return self.suffixLabel.attributedText;
}

- (void)setAttributedSuffix:(NSAttributedString *)attributedSuffix {
    self.suffixLabel.attributedText = attributedSuffix;
    [self setNeedsLayout];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self textViewDidChange_ZSW];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    [self textViewDidChange_ZSW];
}

@end
