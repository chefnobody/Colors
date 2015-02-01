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
}

- (UIEdgeInsets)layoutMargins {
    return UIEdgeInsetsZero;
}

@end
