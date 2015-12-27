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

@property (null_resettable, nonatomic) IBInspectable UIColor *placeholderTextColor;
@property (nullable, nonatomic) IBInspectable NSString *placeholder;

@property (null_resettable, nonatomic) IBInspectable UIColor *suffixTextColor;
@property (nullable, nonatomic) IBInspectable NSString *suffix;
@property (nullable, nonatomic) IBInspectable NSAttributedString *attributedSuffix;
@property (nonatomic) IBInspectable CGFloat suffixSpacing; // between typed text and suffix string, default 5.0

@end

NS_ASSUME_NONNULL_END