//
//  ZSWSuffixTextView+Tappable.m
//  Pods
//
//  Created by Zachary West on 1/1/16.
//
//

#import <ZSWSuffixTextView/ZSWSuffixTextView.h>

@import ZSWTappableLabel;

@interface ZSWSuffixTextView()
// hacky private import, go!
@property (nonatomic) ZSWTappableLabel *suffixLabel;
@end

@implementation ZSWSuffixTextView(Tappable)

#pragma mark - ZSWTappableLabel methods

- (id<ZSWTappableLabelTapDelegate>)suffixTapDelegate {
    return self.suffixLabel.tapDelegate;
}

- (void)setSuffixTapDelegate:(id<ZSWTappableLabelTapDelegate>)suffixTapDelegate {
    self.suffixLabel.tapDelegate = suffixTapDelegate;
}

- (id<ZSWTappableLabelLongPressDelegate>)suffixLongPressDelegate {
    return self.suffixLabel.longPressDelegate;
}

- (void)setSuffixLongPressDelegate:(id<ZSWTappableLabelLongPressDelegate>)suffixLongPressDelegate {
    self.suffixLabel.longPressDelegate = suffixLongPressDelegate;
}

@end
