//
//  TTColorViewController.m
//  Colors
//
//  Created by Aaron Connolly on 1/26/15.
//  Copyright (c) 2015 Top Turn Software. All rights reserved.
//

#import "TTColorViewController.h"
#import "UIColor+TTExtensions.h"

@interface TTColorViewController ()


@end

@implementation TTColorViewController

- (instancetype)initWithColor:(TTColor *)color {
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if ( self ) {
        self.color = color;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Color";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = self.color.color;
    self.colorLabel.text = self.color.name;
    self.colorLabel.textColor = [self.color.color isTooDarkForBlackText] ? [UIColor whiteColor] : [UIColor blackColor];
}


@end
