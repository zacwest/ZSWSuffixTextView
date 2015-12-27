//
//  ZSWViewController.m
//  ZSWSuffixTextView
//
//  Created by Zachary West on 12/26/2015.
//  Copyright (c) 2015 Zachary West. All rights reserved.
//

#import "ZSWViewController.h"
@import ZSWSuffixTextView;

@interface ZSWViewController ()
@property (weak, nonatomic) IBOutlet ZSWSuffixTextView *suffixTextView;

@end

@implementation ZSWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.suffixTextView.placeholder = @"Hello I am a very long placeholder label that wraps";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
