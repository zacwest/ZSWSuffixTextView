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

@property (null_resettable, nonatomic) IBInspectable UIFont *placeholderFont;
@property (null_resettable, nonatomic) IBInspectable UIColor *placeholderTextColor;

@property (nullable, nonatomic) IBInspectable NSString *placeholder;
@property (nullable, nonatomic) IBInspectable NSAttributedString *attributedPlaceholder;

@property (nullable, nonatomic) IBInspectable NSString *suffix;
@property (nullable, nonatomic) IBInspectable NSAttributedString *attributedSuffix;

@end

NS_ASSUME_NONNULL_END