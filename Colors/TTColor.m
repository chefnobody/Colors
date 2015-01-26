//
//  TTColor.m
//  Colors
//
//  Created by Aaron Connolly on 1/25/15.
//  Copyright (c) 2015 Top Turn Software. All rights reserved.
//

#import "TTColor.h"

@implementation TTColor

- (instancetype)initWithColor:(UIColor *)color name:(NSString *)name{
    self = [super init];
    if ( self ) {
        self.color = color;
        self.name = name;
    }
    return self;
}

@end
