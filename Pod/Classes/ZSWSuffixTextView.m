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

@property (nonatomic) NSLayoutConstraint *placeholderTop;
@property (nonatomic) NSLayoutConstraint *placeholderLeading;

@property (nonatomic) NSLayoutConstraint *suffixTop;
@property (nonatomic) NSLayoutConstraint *suffixLeading;
@property (nonatomic) NSLayoutConstraint *suffixWidth;
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
    self.suffixSpacing = 5.0;
    
    self.placeholderLabel = [[UILabel alloc] init];
    self.placeholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.placeholderLabel.font = self.font;
    self.placeholderTextColor = [UIColor colorWithWhite:0.70 alpha:1.0];
    [self addSubview:self.placeholderLabel];
    
    Class labelClass = NSClassFromString(@"ZSWTappableLabel");
    if (!labelClass) {
        labelClass = [UILabel class];
    }
    
    self.suffixLabel = [[labelClass alloc] init];
    self.suffixLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.suffixLabel.numberOfLines = 0;
    self.suffixLabel.font = self.font;
    self.suffixLabel.textColor = self.textColor;
    [self addSubview:self.suffixLabel];
    
    self.placeholderTop = ^{
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.placeholderLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        [self addConstraint:constraint];
        return constraint;
    }();
    
    self.placeholderLeading = ^{
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.placeholderLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
        [self addConstraint:constraint];
        return constraint;
    }();
    
    self.suffixTop = ^{
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.suffixLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        [self addConstraint:constraint];
        return constraint;
    }();
    
    self.suffixLeading = ^{
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.suffixLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
        [self addConstraint:constraint];
        return constraint;
    }();
    
    self.suffixWidth = ^{
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.suffixLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0];
        [self addConstraint:constraint];
        return constraint;
    }();
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textViewDidChange_ZSW)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self];

    [self invalidateCaches];
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
    _suffixLabelPositionIsDirty = YES;
    _placeholderLabelPositionIsDirty = YES;
    [self setNeedsUpdateConstraints];
}

- (void)updatePlaceholderConstraintsIfNeeded {
    if (!_placeholderLabelPositionIsDirty) {
        return;
    }
    
    UITextRange *range = [self textRangeFromPosition:self.beginningOfDocument toPosition:self.beginningOfDocument];
    CGRect firstRect = [self firstRectForRange:range];
    
    self.placeholderLeading.constant = CGRectGetMinX(firstRect);
    self.placeholderTop.constant = CGRectGetMinY(firstRect);
    
    _placeholderLabelPositionIsDirty = NO;
}

- (NSAttributedString *)updatedSuffixStringForPriorRect:(CGRect *)priorRect {
    __block NSRange effectiveRange = NSMakeRange(0, self.suffix.length);
    
    NSMutableParagraphStyle *paragraphStyle = [[self.attributedSuffix attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:&effectiveRange] mutableCopy];
    
    if (!paragraphStyle) {
        paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    }
    
    // Get the indent inside our label's positioning, since the priorRect includes bounds insets
    CGRect insetBounds = self.insetBounds;
    CGFloat indent = CGRectGetMaxX(*priorRect) - CGRectGetMinX(insetBounds);
    // Custom-provided spacing, too.
    indent += self.suffixSpacing;
    
    if (indent >= CGRectGetWidth(insetBounds)) {
        CGFloat lineHeight = self.suffixLabel.font.lineHeight;
        lineHeight *= paragraphStyle.lineHeightMultiple ?: 1.0;
        lineHeight = MIN(MAX(lineHeight, paragraphStyle.minimumLineHeight), paragraphStyle.maximumLineHeight ?: CGFLOAT_MAX);
        
        priorRect->origin.y += lineHeight + paragraphStyle.lineSpacing;
        paragraphStyle.firstLineHeadIndent = 0;
    } else {
        paragraphStyle.firstLineHeadIndent = indent;
    }
    
    NSMutableAttributedString *updatedString = [self.attributedSuffix mutableCopy];
    [updatedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:effectiveRange];
    return updatedString;
}

- (void)updateSuffixLabelConstraintsIfNeeded {
    if (!_suffixLabelPositionIsDirty) {
        return;
    }
    
    CGRect priorRect;
    
    if (self.suffixState & ZSWSuffixStatePlaceholder) {
        priorRect = self.placeholderLabel.frame;
    } else {
        priorRect = CGRectOffset([self caretRectForPosition:self.endOfDocument], 0, 1);
    }
    
    self.suffixLabel.attributedText = [self updatedSuffixStringForPriorRect:&priorRect];
    
    CGRect insetBounds = self.insetBounds;
    self.suffixTop.constant = CGRectGetMinY(priorRect);
    self.suffixLeading.constant = CGRectGetMinX(insetBounds);
    self.suffixWidth.constant = CGRectGetWidth(insetBounds);
    
    _suffixLabelPositionIsDirty = NO;
}

- (void)updateConstraints {
    ZSWSuffixState state = self.suffixState;
    
    self.placeholderLabel.hidden = !(state & ZSWSuffixStatePlaceholder);
    self.suffixLabel.hidden = !(state & ZSWSuffixStateSuffix);
    
    [self updatePlaceholderConstraintsIfNeeded];
    [self updateSuffixLabelConstraintsIfNeeded];
    
    [super updateConstraints];
}

- (void)layoutSubviews {
    struct {
        CGRect start;
        CGRect end;
        BOOL changed;
    } placeholder, suffix;
    
    placeholder.start = self.placeholderLabel.frame;
    suffix.start = self.suffixLabel.frame;
    [super layoutSubviews];
    placeholder.end = self.placeholderLabel.frame;
    suffix.end = self.suffixLabel.frame;
    
    placeholder.changed = !CGRectEqualToRect(placeholder.start, placeholder.end);
    suffix.changed = !CGRectEqualToRect(suffix.start, suffix.end);
    
    if (placeholder.changed) {
        // Rare case, so don't bother trying to make this faster. It'll just take another pass.
        [self invalidateCaches];
    }
    
    if (suffix.changed) {
        self.contentSize = self.contentSize; // force update
    }
}

- (void)textViewDidChange_ZSW {
    ZSWSuffixState suffixState = self.suffixState;
    ZSWSuffixState visibleState = self.visibleSuffixState;

    if (suffixState != visibleState) {
        [self invalidateCaches];
    } else if (suffixState & ZSWSuffixStateSuffix) {
        // Any text change means we need to update the suffix string.
        [self invalidateCaches];
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
    [self invalidateCaches];
}

- (void)setSuffixSpacing:(CGFloat)suffixSpacing {
    _suffixSpacing = suffixSpacing;
    [self invalidateCaches];
}

- (NSAttributedString *)attributedSuffix {
    return self.suffixLabel.attributedText;
}

- (void)setAttributedSuffix:(NSAttributedString *)attributedSuffix {
    self.suffixLabel.attributedText = attributedSuffix;
    [self invalidateCaches];
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
