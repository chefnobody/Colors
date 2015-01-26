//
//  TTColorViewController.m
//  Colors
//
//  Created by Aaron Connolly on 1/26/15.
//  Copyright (c) 2015 Top Turn Software. All rights reserved.
//

#import "TTColorViewController.h"

@interface TTColorViewController ()

@property (strong, nonatomic) IBOutlet UILabel *colorLabel;

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
    
    self.colorLabel.text = self.color.name;
}


@end
