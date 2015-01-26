//
//  TTBaseAnimationController.h
//  Colors
//
//  Created by Aaron Connolly on 1/25/15.
//  Copyright (c) 2015 Top Turn Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface TTBaseAnimationController : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign, getter = isPushing) BOOL pushing;

@end
