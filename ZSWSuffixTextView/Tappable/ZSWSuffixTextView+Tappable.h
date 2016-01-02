//
//  ZSWSuffixTextView+Tappable.h
//  Pods
//
//  Created by Zachary West on 1/1/16.
//
//

#import <ZSWSuffixTextView/ZSWSuffixTextView.h>
@import ZSWTappableLabel;

@interface ZSWSuffixTextView(Tappable)

@property (nullable, nonatomic) IBOutlet id<ZSWTappableLabelTapDelegate> suffixTapDelegate;
@property (nullable, nonatomic) IBOutlet id<ZSWTappableLabelLongPressDelegate> suffixLongPressDelegate;

@end
