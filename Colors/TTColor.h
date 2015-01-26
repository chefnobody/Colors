//
//  TTColor.h
//  Colors
//
//  Created by Aaron Connolly on 1/25/15.
//  Copyright (c) 2015 Top Turn Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface TTColor : NSObject

@property (nonatomic) UIColor * color;
@property (nonatomic) NSString * name;

- (instancetype)initWithColor:(UIColor *)color name:(NSString *)name;

@end
