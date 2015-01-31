//
//  TTColorViewController.h
//  Colors
//
//  Created by Aaron Connolly on 1/26/15.
//  Copyright (c) 2015 Top Turn Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTColor.h"

@interface TTColorViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel * colorLabel;
@property (nonatomic) TTColor * color;

- (instancetype)initWithColor:(TTColor *)color;
- (UILabel *)labelForColor;

@end
