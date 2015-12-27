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

@implementation ZSWSuffixTextView {
    BOOL _suffixLabelPositionIsDirty;
    BOOL _placeholderLabelPositionIsDirty;
}

@synthesize suffixTextColor = _suffixTextColor; // so we know if the user set it, or if we inherited

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
    _suffixLabelPositionIsDirty = YES;
    _placeholderLabelPositionIsDirty = YES;
    
    self.suffixSpacing = 5.0;
    
    self.placeholderLabel = [[UILabel alloc] init];
    self.placeholderLabel.font = self.font;
    self.placeholderTextColor = [UIColor colorWithWhite:0.70 alpha:1.0];
    [self addSubview:self.placeholderLabel];
    
    Class labelClass = NSClassFromString(@"ZSWTappableLabel");
    if (!labelClass) {
        labelClass = [UILabel class];
    }
    
    self.suffixLabel = [[labelClass alloc] init];
    self.suffixLabel.numberOfLines = 0;
    self.suffixLabel.font = self.font;
    self.suffixLabel.textColor = self.textColor;
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

- (CGRect)insetBounds {
    CGRect insetRect = UIEdgeInsetsInsetRect(UIEdgeInsetsInsetRect(self.bounds, self.textContainerInset), self.contentInset);
    return CGRectInset(insetRect, self.textContainer.lineFragmentPadding, 0);
}

- (void)invalidateCaches {
    [self invalidateCachesForStates:ZSWSuffixStatePlaceholder | ZSWSuffixStateSuffix];
}

- (void)invalidateCachesForStates:(ZSWSuffixState)states {
    if (states & ZSWSuffixStatePlaceholder) {
        _placeholderLabelPositionIsDirty = YES;
        [self setNeedsLayout];
    }
    
    if (states & ZSWSuffixStateSuffix || states & ZSWSuffixStatePlaceholder) {
        _suffixLabelPositionIsDirty = YES;
        [self setNeedsLayout];
    }
}

- (void)updatePlaceholderFrameIfNeeded {
    if (!_placeholderLabelPositionIsDirty) {
        return;
    }
    
    UITextRange *range = [self textRangeFromPosition:self.beginningOfDocument toPosition:self.beginningOfDocument];
    
    CGRect firstRect = [self firstRectForRange:range];
    
    CGFloat remainingWidth = CGRectGetMaxX(self.insetBounds) - CGRectGetMinX(firstRect);
    
    CGSize sizeThatFits = [self.placeholderLabel sizeThatFits:CGSizeMake(remainingWidth, CGFLOAT_MAX)];
    // todo: why is it lying about this size?
    sizeThatFits.width = MIN(sizeThatFits.width, remainingWidth);
    
    _placeholderLabelPositionIsDirty = NO;
    self.placeholderLabel.frame = (CGRect){firstRect.origin, sizeThatFits};
}

- (void)updateSuffixLabelFrameIfNeeded {
    if (!_suffixLabelPositionIsDirty) {
        return;
    }
    
    CGRect priorRect;
    
    if (self.suffixState & ZSWSuffixStatePlaceholder) {
        priorRect = self.placeholderLabel.frame;
    } else {
        priorRect = CGRectOffset([self caretRectForPosition:self.endOfDocument], 0, 1);
    }
    
    __block NSRange effectiveRange = NSMakeRange(0, self.suffix.length);
    
    NSMutableParagraphStyle *paragraphStyle = [[self.attributedSuffix attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:&effectiveRange] mutableCopy];
    
    if (!paragraphStyle) {
        paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    }
    
    // Get the indent inside our label's positioning, since the priorRect includes bounds insets
    CGFloat indent = CGRectGetMaxX(priorRect) - CGRectGetMinX(self.insetBounds);
    // Custom-provided spacing, too.
    indent += self.suffixSpacing;
    
    if (indent >= CGRectGetWidth(self.insetBounds)) {
        CGFloat lineHeight = self.suffixLabel.font.lineHeight;
        lineHeight *= paragraphStyle.lineHeightMultiple ?: 1.0;
        lineHeight = MIN(MAX(lineHeight, paragraphStyle.minimumLineHeight), paragraphStyle.maximumLineHeight ?: CGFLOAT_MAX);
        
        priorRect.origin.y += lineHeight + paragraphStyle.lineSpacing;
        paragraphStyle.firstLineHeadIndent = 0;
    } else {
        paragraphStyle.firstLineHeadIndent = indent;
    }
    
    NSMutableAttributedString *updatedString = [self.attributedSuffix mutableCopy];
    [updatedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:effectiveRange];
    self.suffixLabel.attributedText = updatedString;
    
    CGFloat width = CGRectGetWidth(self.insetBounds);
    CGSize sizeThatFits = [self.suffixLabel sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
    
    _suffixLabelPositionIsDirty = NO;
    self.suffixLabel.frame = CGRectMake(CGRectGetMinX(self.insetBounds), CGRectGetMinY(priorRect), width, sizeThatFits.height);
    
    self.contentSize = self.contentSize; // force an update
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    ZSWSuffixState state = self.suffixState;
    
    if (state & ZSWSuffixStatePlaceholder) {
        [self updatePlaceholderFrameIfNeeded];
        self.placeholderLabel.hidden = NO;
    } else {
        self.placeholderLabel.hidden = YES;
    }
    
    if (state & ZSWSuffixStateSuffix) {
        [self updateSuffixLabelFrameIfNeeded];
        self.suffixLabel.hidden = NO;
    } else {
        self.suffixLabel.hidden = YES;
    }
}

- (void)textViewDidChange_ZSW {
    ZSWSuffixState suffixState = self.suffixState;
    ZSWSuffixState visibleState = self.visibleSuffixState;

    if (suffixState != visibleState) {
        [self invalidateCachesForStates:suffixState - visibleState];
    } else if (suffixState & ZSWSuffixStateSuffix) {
        // Any text change means we need to update the suffix string.
        [self invalidateCachesForStates:ZSWSuffixStateSuffix];
    }
}

#pragma mark -

- (void)setContentSize:(CGSize)contentSize {
    ZSWSuffixState visibleState = self.suffixState;
    
    if (visibleState & ZSWSuffixStateSuffix) {
        CGSize updatedSize = contentSize;
        updatedSize.height = CGRectGetMaxY(self.suffixLabel.frame);
        if (!CGSizeEqualToSize(self.contentSize, updatedSize)) {
            [super setContentSize:updatedSize];
        }
    } else {
        [super setContentSize:contentSize];
    }
}

#pragma mark - Wrappers

- (NSString *)placeholder {
    return self.placeholderLabel.text;
}

- (void)setPlaceholder:(NSString *)placeholder {
    self.placeholderLabel.text = placeholder;
    [self invalidateCachesForStates:ZSWSuffixStatePlaceholder];
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
    [self invalidateCachesForStates:ZSWSuffixStateSuffix];
}

- (void)setSuffixSpacing:(CGFloat)suffixSpacing {
    _suffixSpacing = suffixSpacing;
    [self invalidateCachesForStates:ZSWSuffixStateSuffix];
}

- (NSAttributedString *)attributedSuffix {
    return self.suffixLabel.attributedText;
}

- (void)setAttributedSuffix:(NSAttributedString *)attributedSuffix {
    self.suffixLabel.attributedText = attributedSuffix;
    [self invalidateCachesForStates:ZSWSuffixStateSuffix];
}

- (UIColor *)suffixTextColor {
    return self.suffixLabel.textColor;
}

- (void)setSuffixTextColor:(UIColor *)suffixTextColor {
    _suffixTextColor = suffixTextColor;
    self.suffixLabel.textColor = suffixTextColor;
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    
    self.placeholderLabel.font = font;
    self.suffixLabel.font = font;
    
    [self invalidateCaches];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self invalidateCaches];
}

- (void)setTextColor:(UIColor *)textColor {
    [super setTextColor:textColor];
    
    if (!_suffixTextColor) {
        self.suffixLabel.textColor = textColor;
    }
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    
    self.placeholderLabel.font = self.font;
    self.suffixLabel.font = self.font;
    
    if (!_suffixTextColor) {
        self.suffixLabel.textColor = self.textColor;
    }
    
    [self invalidateCaches];
}

@end
