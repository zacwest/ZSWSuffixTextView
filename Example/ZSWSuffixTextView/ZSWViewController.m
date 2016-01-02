//
//  ZSWViewController.m
//  ZSWSuffixTextView
//
//  Created by Zachary West on 12/26/2015.
//  Copyright (c) 2015 Zachary West. All rights reserved.
//

#import "ZSWViewController.h"
@import ZSWSuffixTextView;

@interface ZSWViewController () <ZSWTappableLabelTapDelegate, ZSWTappableLabelLongPressDelegate>
@property (weak, nonatomic) IBOutlet ZSWSuffixTextView *suffixTextView;

@end

@implementation ZSWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSMutableAttributedString *string = [self.suffixTextView.attributedSuffix mutableCopy];
    [string addAttribute:ZSWTappableLabelTappableRegionAttributeName value:@YES range:NSMakeRange(0, string.string.length)];
    [string addAttribute:ZSWTappableLabelHighlightedBackgroundAttributeName value:[UIColor colorWithWhite:0.5 alpha:1.0] range:NSMakeRange(0, string.string.length)];
    self.suffixTextView.attributedSuffix = string;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tappableLabel:(ZSWTappableLabel *)tappableLabel
        tappedAtIndex:(NSInteger)idx
       withAttributes:(NSDictionary<NSString *, id> *)attributes {
    
}

- (void)tappableLabel:(ZSWTappableLabel *)tappableLabel longPressedAtIndex:(NSInteger)idx withAttributes:(NSDictionary<NSString *,id> *)attributes {
    
}

@end
