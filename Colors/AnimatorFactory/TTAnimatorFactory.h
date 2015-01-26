//
//  TTAnimatorFactory.h
//  Colors
//
//  Created by Aaron Connolly on 1/26/15.
//  Copyright (c) 2015 Top Turn Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface TTAnimatorFactory : NSObject

+ (id)sharedInstance;

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForParentViewControllerClass:(Class)parentViewControllerClass
                                                                    childViewControllerClass:(Class)childViewController;

- (void)registerAnimationControllerClass:(Class)animationControllerClass
            forParentViewControllerClass:(Class)parentViewControllerClass
                childViewControllerClass:(Class)childViewControllerClass;

@end
