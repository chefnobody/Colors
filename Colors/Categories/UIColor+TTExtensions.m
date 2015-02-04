//
//  UIColor+TTExtensions.m
//  Colors
//
//  Created by Aaron Connolly on 1/26/15.
//  Copyright (c) 2015 Top Turn Software. All rights reserved.
//

#import "UIColor+TTExtensions.h"

@implementation UIColor (TTExtensions)

- (NSString *)hexString {
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    NSString *hexString=[NSString stringWithFormat:@"%02X%02X%02X", (int)(r * 255), (int)(g * 255), (int)(b * 255)];
    return hexString;
}

- (BOOL)isTooDarkForBlackText {
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    CGFloat red = components[0];
    CGFloat green = components[1];
    CGFloat blue = components[2];
    CGFloat luminance = (0.2126 * red) + (0.7152 * green) + (0.0722 * blue);
    return (luminance <= 0.5);
}

@end
