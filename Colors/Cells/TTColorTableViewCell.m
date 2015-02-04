//
//  TTColorTableViewCell.m
//  Colors
//
//  Created by Aaron Connolly on 1/26/15.
//  Copyright (c) 2015 Top Turn Software. All rights reserved.
//

#import "TTColorTableViewCell.h"

@implementation TTColorTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    
    // if you don't mind a little performance hit,
    // you can show a little depth when transitioning by uncommenting this:
    /*
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, -2);
    self.layer.shadowRadius = 1.0;
    self.layer.shadowOpacity = 0.8;
     */
}

- (UIEdgeInsets)layoutMargins {
    return UIEdgeInsetsZero;
}

@end
