//
//  TTAnimatorFactory.m
//  Colors
//
//  Created by Aaron Connolly on 1/26/15.
//  Copyright (c) 2015 Top Turn Software. All rights reserved.
//

#import "TTAnimatorFactory.h"

@interface TTAnimatorFactory()

@property (nonatomic, strong) NSMutableDictionary * animationControllerLookUp;

@end

@implementation TTAnimatorFactory

+ (id)sharedInstance {
    static TTAnimatorFactory * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)init {
    self = [super init];
    if ( self != nil ){
        // initailization
        _animationControllerLookUp = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)registerAnimationControllerClass:(Class)animationControllerClass forParentViewControllerClass:(Class)parentViewControllerClass childViewControllerClass:(Class)childViewControllerClass {
    
    // Key example: "TTListViewController->TTDetailsViewController"
    NSString * key = [NSString stringWithFormat:@"%@->%@", NSStringFromClass(parentViewControllerClass), NSStringFromClass(childViewControllerClass)];
    [_animationControllerLookUp setObject:NSStringFromClass(animationControllerClass) forKey:key];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForParentViewControllerClass:(Class)parentViewControllerClass childViewControllerClass:(Class)childViewControllerClass {
    
    NSString * key = [NSString stringWithFormat:@"%@->%@", NSStringFromClass(parentViewControllerClass), NSStringFromClass(childViewControllerClass)];
    NSString * animationControllerClassName = [_animationControllerLookUp objectForKey:key];
    id<UIViewControllerAnimatedTransitioning> animationController = (id<UIViewControllerAnimatedTransitioning>)[[NSClassFromString(animationControllerClassName) alloc] init];
    return animationController;
}

@end
