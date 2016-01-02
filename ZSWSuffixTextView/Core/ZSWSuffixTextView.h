//
//  ZSWSuffixTextView.h
//  Pods
//
//  Created by Zachary West on 12/26/15.
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE
@interface ZSWSuffixTextView : UITextView

/*!
 * @brief The color of the placeholder
 *
 * The default value is 70% white at 1.0 alpha.
 */
@property (null_resettable, nonatomic) IBInspectable UIColor *placeholderTextColor;
/*!
 * @brief The placeholder string
 */
@property (nullable, nonatomic) IBInspectable NSString *placeholder;

/*!
 * @brief The color of the suffix text
 *
 * This is exposed mostly for convenience if you do not wish to use
 * an attributed string directly. By default, the suffix will inherit
 * the \ref textColor of the text view.
 */
@property (null_resettable, nonatomic) IBInspectable UIColor *suffixTextColor;

/*!
 * @brief The suffix text
 *
 * On iOS 8, a newline is forcibly appended to this string to deal with iOS bugs.
 */
@property (nullable, nonatomic) IBInspectable NSString *suffix;
/*!
 * @brief Attributed suffix text
 *
 * The following values in an NSParagraphStyleAttributeName will be
 * modified by the view:
 *
 * - baseWritingDirection will be forced to .LeftToRight or .RightToLeft
 *   depending on the user's writing direction.
 * - firstLineHeadIndent will be modified to a value to adjust the label
 *   positioning for the inputted text/placeholder.
 *
 * If you wish to set a custom head indent, you may wish to set a \ref suffixSpacing.
 *
 * On iOS 8, a newline is forcibly appended to this string to deal with iOS bugs.
 */
@property (nullable, nonatomic) IBInspectable NSAttributedString *attributedSuffix;

/*!
 * @brief Suffix spacing
 *
 * You have a couple options to deal with spacing:
 * 1. Provide a space (`@" "`) at the beginning of the suffix string.
 * 2. Provide a constant value for suffixSpacing.
 * 3. Get the bounding rect for `@" "` and pass this in.
 *
 * It's likely you will want a custom spacing, so it is exposed here. The default
 * value is 5.0.
 */
@property (nonatomic) IBInspectable CGFloat suffixSpacing;

@end

NS_ASSUME_NONNULL_END
