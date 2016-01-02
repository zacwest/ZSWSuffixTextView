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

static NSString *const ZSWTappableLabelClassName = @"ZSWTappableLabel";

@interface ZSWSuffixTextView()
@property (nonatomic) UILabel *placeholderLabel;
@property (nonatomic) UILabel *suffixLabel;

// placeholder label wants to be pinned to right _or_ left,
// but not all (so we don't have to modify its text alignment)
// which requires a superview that has left/right/top/bottom scroll view
// constraints, see https://developer.apple.com/library/ios/technotes/tn2154/_index.html
@property (nonatomic) UIView *containerForPlaceholder;
@property (nonatomic) NSLayoutConstraint *placeholderTop;
@property (nonatomic) NSLayoutConstraint *placeholderLeft;
@property (nonatomic) NSLayoutConstraint *placeholderRight;

@property (nonatomic) NSLayoutConstraint *suffixTop;
@property (nonatomic) NSLayoutConstraint *suffixLeft;
@property (nonatomic) NSLayoutConstraint *suffixWidth;
@end

@implementation ZSWSuffixTextView
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
    
    self.containerForPlaceholder = [[UIView alloc] initWithFrame:self.bounds];
    self.containerForPlaceholder.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.containerForPlaceholder.userInteractionEnabled = NO;
    [self addSubview:self.containerForPlaceholder];
     
    // We create a width-appropriate frame because at least our width needs to be
    // correct for the first pass when we generate the head indent on the label
    CGRect widthAppropriateFrame = CGRectMake(0, 0, CGRectGetWidth(UIEdgeInsetsInsetRect(self.bounds, self.completeEdgeInsets)), 0);
    
    self.placeholderLabel = [[UILabel alloc] initWithFrame:widthAppropriateFrame];
    self.placeholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.placeholderLabel.font = self.font;
    self.placeholderTextColor = nil;
    [self.containerForPlaceholder addSubview:self.placeholderLabel];
    
    Class tappableClass = NSClassFromString(ZSWTappableLabelClassName);
    if (tappableClass) {
        self.suffixLabel = [[tappableClass alloc] initWithFrame:widthAppropriateFrame];
        [self.suffixLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(suffixGesture:)]];
        [self.suffixLabel addGestureRecognizer:^{
            UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(suffixGesture:)];
            gr.numberOfTapsRequired = 2;
            return gr;
        }()];
        [self.suffixLabel addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(suffixGesture:)]];
    } else {
        self.suffixLabel = [[UILabel alloc] initWithFrame:widthAppropriateFrame];
    }
    
    self.suffixLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.suffixLabel.numberOfLines = 0;
    self.suffixLabel.font = self.font;
    self.suffixLabel.textColor = self.textColor;
    [self addSubview:self.suffixLabel];
    
    // we use placeholder sized to fit because we want to know when its text changes
    // e.g. if the user changes the placeholder text after initially setting it,
    // so if we set it to fit the whole width we'd have to inspect changes and
    // blah blah. easier to just let autolayout do the guessing.
    
    // we need the container anyway to constrain the suffix width to match, because
    // autolayout is annoying with scrollviews.
    
    self.placeholderTop = ^{
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.placeholderLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.containerForPlaceholder attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        [self addConstraint:constraint];
        return constraint;
    }();
    
    self.placeholderLeft = ^{
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.placeholderLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.containerForPlaceholder attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        [self addConstraint:constraint];
        return constraint;
    }();
    
    self.placeholderRight = ^{
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.placeholderLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.containerForPlaceholder attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        [self addConstraint:constraint];
        return constraint;
    }();
    
    self.suffixTop = ^{
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.suffixLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        [self addConstraint:constraint];
        return constraint;
    }();
    
    self.suffixLeft = ^{
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.suffixLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        [self addConstraint:constraint];
        return constraint;
    }();
    
    self.suffixWidth = ^{
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.suffixLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.containerForPlaceholder attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
        [self addConstraint:constraint];
        return constraint;
    }();
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textViewDidChange_ZSW)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputModeDidChange_ZSW)
                                                 name:UITextInputCurrentInputModeDidChangeNotification
                                               object:nil];
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

- (BOOL)isEffectivelyRightToLeftAtTextPosition:(UITextPosition *)textPosition {
    BOOL isViewRTL = ^{
        UIUserInterfaceLayoutDirection direction;
        
        if ([self respondsToSelector:@selector(semanticContentAttribute)]) {
            direction = [UIView userInterfaceLayoutDirectionForSemanticContentAttribute:self.semanticContentAttribute];
        } else {
            direction = [UIApplication sharedApplication].userInterfaceLayoutDirection;
        }
        
        switch (direction) {
            case UIUserInterfaceLayoutDirectionLeftToRight:
                return NO;
            case UIUserInterfaceLayoutDirectionRightToLeft:
                return YES;
        }
    }();
    
    BOOL isWritingRTL = ^{
        switch ([self baseWritingDirectionForPosition:textPosition inDirection:UITextStorageDirectionForward]) {
            case UITextWritingDirectionNatural:
                return isViewRTL;
            case UITextWritingDirectionLeftToRight:
                return NO;
            case UITextWritingDirectionRightToLeft:
                return YES;
        }
    }();
    
    return isWritingRTL;
}

- (UIEdgeInsets)completeEdgeInsets {
    CGFloat lineFragmentPadding = self.textContainer.lineFragmentPadding;
    
    UIEdgeInsets contentInset = self.contentInset;
    // No content inset on top because we base off {0,0} no matter what
    contentInset.top = 0;
    
    UIEdgeInsets insets = self.textContainerInset;
    insets.left += lineFragmentPadding + contentInset.left;
    insets.right += lineFragmentPadding + contentInset.right;
    insets.top += contentInset.top;
    insets.bottom += contentInset.bottom;
    
    return insets;
}

- (void)updatePlaceholderConstraints {
    BOOL isRTL = [self isEffectivelyRightToLeftAtTextPosition:self.beginningOfDocument];
    self.placeholderRight.active = isRTL;
    self.placeholderLeft.active = !isRTL;
    
    UIEdgeInsets completeInsets = self.completeEdgeInsets;
    
    if (isRTL) {
        self.placeholderRight.constant = -completeInsets.right;
    } else {
        self.placeholderLeft.constant = completeInsets.left;
    }

    self.placeholderTop.constant = completeInsets.top;
}

- (NSAttributedString *)suffixStringAfterUpdatingPriorRect:(inout CGRect *)priorRect isRTL:(BOOL)isRTL {
    __block NSRange effectiveRange = NSMakeRange(0, self.suffix.length);
    
    NSMutableParagraphStyle *paragraphStyle = [[self.attributedSuffix attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:&effectiveRange] mutableCopy];
    
    if (!paragraphStyle) {
        paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    }
    
    // We have to force baseWritingDirection because although the user may be entering
    // RTL text, the label text we've been provided is LTR, which would cause overlapping
    paragraphStyle.baseWritingDirection = isRTL ? NSWritingDirectionRightToLeft : NSWritingDirectionLeftToRight;
    
    CGFloat indent = -self.suffixLeft.constant;
    
    if (isRTL) {
        indent += CGRectGetWidth(self.bounds) - CGRectGetMinX(*priorRect);
    } else {
        indent += CGRectGetMaxX(*priorRect);
    }
    
    indent += self.suffixSpacing;
    
    if (indent >= CGRectGetWidth(self.suffixLabel.bounds)) {
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
    
    BOOL isOS9 = [[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){ .majorVersion = 9 }];
    BOOL endsWithNewline = [updatedString.string hasSuffix:@"\n"];
    
    if (!isOS9 && !endsWithNewline) {
        // iOS 8 needs a newline at the end to handle wrapping when the string is too short
        // to hit multiple lines, or else it calculates the wrong height ignoring inset
        [updatedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n" attributes:nil]];
    }
    
    return updatedString;
}

- (void)updateSuffixLabelConstraints {
    CGRect priorRect = CGRectZero;
    BOOL isRTL = NO;
    
    if (self.suffixState & ZSWSuffixStatePlaceholder) {
        CGSize placeholderSize = self.placeholderLabel.intrinsicContentSize;
        isRTL = [self isEffectivelyRightToLeftAtTextPosition:self.beginningOfDocument];
        
        if (self.placeholderLeft.isActive) {
            priorRect = CGRectMake(self.placeholderLeft.constant, self.placeholderTop.constant, placeholderSize.width, placeholderSize.height);
        } else {
            priorRect = CGRectMake(CGRectGetMaxX(self.bounds) + self.placeholderRight.constant - placeholderSize.width, self.placeholderTop.constant, placeholderSize.width, placeholderSize.height);
        }
    } else {
        priorRect = CGRectOffset([self caretRectForPosition:self.endOfDocument], 0, 1);
        isRTL = [self isEffectivelyRightToLeftAtTextPosition:self.endOfDocument];
    }
    
    CGRect originlessBounds = (CGRect){CGPointZero, self.bounds.size};
    CGRect insetBounds = UIEdgeInsetsInsetRect(originlessBounds, self.completeEdgeInsets);
    
    self.suffixLeft.constant = CGRectGetMinX(insetBounds);
    self.suffixWidth.constant = -(CGRectGetMaxX(originlessBounds) - CGRectGetMaxX(insetBounds) + CGRectGetMinX(insetBounds));
    
    self.suffixLabel.attributedText = [self suffixStringAfterUpdatingPriorRect:&priorRect isRTL:isRTL];
    self.suffixTop.constant = CGRectGetMinY(priorRect);
}

- (void)updateConstraints {
    ZSWSuffixState state = self.suffixState;
    
    self.placeholderLabel.hidden = !(state & ZSWSuffixStatePlaceholder);
    self.suffixLabel.hidden = !(state & ZSWSuffixStateSuffix);
    
    [self updatePlaceholderConstraints];
    [self updateSuffixLabelConstraints];
    
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
        [self setNeedsUpdateConstraints];
    }
    
    if (suffix.changed) {
        self.contentSize = self.contentSize; // force update
    }
}

- (void)textViewDidChange_ZSW {
    ZSWSuffixState suffixState = self.suffixState;
    ZSWSuffixState visibleState = self.visibleSuffixState;

    if (suffixState != visibleState) {
        [self setNeedsUpdateConstraints];
    } else if (suffixState & ZSWSuffixStateSuffix) {
        // Any text change means we need to update the suffix string.
        [self setNeedsUpdateConstraints];
    }
}

- (void)inputModeDidChange_ZSW {
    [self setNeedsUpdateConstraints];
}

- (void)suffixGesture:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        UITapGestureRecognizer *tapGR = (UITapGestureRecognizer *)gestureRecognizer;
        if (tapGR.numberOfTapsRequired == 2) {
            [[UIMenuController sharedMenuController] setTargetRect:[self caretRectForPosition:self.beginningOfDocument] inView:self];
            [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
        } else if ([UIMenuController sharedMenuController].menuVisible) {
            [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
        }
    }
    
    [self becomeFirstResponder];
}

#pragma mark -

#pragma mark Placeholder

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
    self.placeholderLabel.textColor = placeholderTextColor ?: [UIColor colorWithWhite:0.70 alpha:1.0];
}

#pragma mark Suffix

- (NSString *)suffix {
    return self.suffixLabel.text;
}

- (void)setSuffix:(NSString *)suffix {
    self.suffixLabel.text = suffix;
    [self setNeedsUpdateConstraints];
}

- (void)setSuffixSpacing:(CGFloat)suffixSpacing {
    _suffixSpacing = suffixSpacing;
    [self setNeedsUpdateConstraints];
}

- (NSAttributedString *)attributedSuffix {
    return self.suffixLabel.attributedText;
}

- (void)setAttributedSuffix:(NSAttributedString *)attributedSuffix {
    self.suffixLabel.attributedText = attributedSuffix;
    [self setNeedsUpdateConstraints];
}

- (UIColor *)suffixTextColor {
    return self.suffixLabel.textColor;
}

- (void)setSuffixTextColor:(UIColor *)suffixTextColor {
    _suffixTextColor = suffixTextColor;
    self.suffixLabel.textColor = suffixTextColor ?: self.textColor;
}

#pragma mark - Overrides

- (void)setContentSize:(CGSize)contentSize {
    ZSWSuffixState visibleState = self.suffixState;
    
    if (visibleState & ZSWSuffixStateSuffix) {
        CGSize updatedSize = contentSize;
        updatedSize.height = CGRectGetMaxY(self.suffixLabel.frame) + self.textContainerInset.bottom;
        if (!CGSizeEqualToSize(self.contentSize, updatedSize)) {
            [super setContentSize:updatedSize];
        }
    } else {
        [super setContentSize:contentSize];
    }
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    
    self.placeholderLabel.font = font;
    self.suffixLabel.font = font;
    
    [self setNeedsUpdateConstraints];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self setNeedsUpdateConstraints];
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
    
    [self setNeedsUpdateConstraints];
}

@end
