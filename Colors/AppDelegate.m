//
//  AppDelegate.m
//  Colors
//
//  Created by Aaron Connolly on 1/25/15.
//  Copyright (c) 2015 Top Turn Software. All rights reserved.
//

#import "AppDelegate.h"
#import "TTColorsViewController.h"
#import "TTColor.h"
#import "UIColor+TTExtensions.h"
#import "TTAnimatorFactory.h"
#import "TTVerticalSplitAnimationController.h"
#import "TTColorViewController.h"
#import "TTColorsViewController.h"

@interface AppDelegate ()

@property (nonatomic) UINavigationController * navigationController;
@property (nonatomic) TTColorsViewController * colorsViewController;
@property (nonatomic) NSArray * colors;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // register the animation controller with the factory for the two vc's it should interact with
    [[TTAnimatorFactory sharedInstance] registerAnimationControllerClass:[TTVerticalSplitAnimationController class]
                                            forParentViewControllerClass:[TTColorsViewController class]
                                                childViewControllerClass:[TTColorViewController class]];
    
    [[TTAnimatorFactory sharedInstance] registerAnimationControllerClass:[TTVerticalSplitAnimationController class]
                                            forParentViewControllerClass:[TTColorViewController class]
                                                childViewControllerClass:[TTColorsViewController class]];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.colors = [self setUpColors];
    self.colorsViewController = [[TTColorsViewController alloc] initWithColors:self.colors];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.colorsViewController];
    self.window.rootViewController = self.navigationController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];    return YES;
}

#pragma mark - Custom methods

- (NSMutableArray *)setUpColors {
    NSMutableArray * colors = [NSMutableArray array];
    
    TTColor * color = nil;
    
    for (int i = 0; i < 255; i=i+10){
        CGFloat fraction = i/255.0;
        UIColor * rgbColor = [UIColor colorWithRed:fraction green:fraction blue:fraction alpha:1.0f];
        color = [[TTColor alloc] initWithColor:rgbColor name:[rgbColor hexString]];
        [colors addObject:color];
    }
    
    return colors;
}
@end
