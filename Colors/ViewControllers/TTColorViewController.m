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
    self.colorLabel.text = @"";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"TTColorViewController - view will appear");

    self.view.backgroundColor = self.color.color;
    self.colorLabel.textColor = [self.color.color isTooDarkForBlackText] ? [UIColor whiteColor] : [UIColor blackColor];
    self.colorLabel.layer.borderColor = [UIColor yellowColor].CGColor;
    self.colorLabel.layer.borderWidth = 1.0f;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"TTColorViewController - view did appear");
    
    self.colorLabel.text = self.color.name;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSLog(@"TTColorViewController - view will disappear");
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    NSLog(@"TTColorViewController - view did disappear");
}


@end
