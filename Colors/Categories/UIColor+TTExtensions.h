//
//  UIColor+TTExtensions.h
//  Colors
//
//  Created by Aaron Connolly on 1/26/15.
//  Copyright (c) 2015 Top Turn Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (TTExtensions)

- (NSString *)hexString;
- (BOOL)isTooDarkForBlackText;

@end
