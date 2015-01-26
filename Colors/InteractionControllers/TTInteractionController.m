//
//  TTInteractionController.m
//  Colors
//
//  Created by Aaron Connolly on 1/25/15.
//  Copyright (c) 2015 Top Turn Software. All rights reserved.
//

#import "TTInteractionController.h"
#import "TTColorViewController.h"
#import "TTColorsViewController.h"
#import "TTBaseAnimationController.h"
#import "TTAnimatorFactory.h"

@interface TTInteractionController()

@property (nonatomic, strong) UIViewController * parentViewController;
@property (nonatomic, assign, getter = isPushing) BOOL pushing;
@property (nonatomic, assign, getter = isInteractive) BOOL interactive;

@end

@implementation TTInteractionController

- (id)initWithParentViewController:(UIViewController *)parentViewController {
    self = [super init];
    if (self) {
        
        // Override navigationController's delegate
        _parentViewController = parentViewController;
        _parentViewController.navigationController.delegate = self;
        
        // it's necessary to hook the gesture recognizer here, rather than inside the animator class
        UIPanGestureRecognizer * panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(userDidPan:)];
        [_parentViewController.view addGestureRecognizer:panGestureRecognizer];
    }
    
    return self;
}

- (void)push {
    // For non-interactive transiations
    
    self.pushing = YES;
    
    TTColorViewController * colorViewController = [[TTColorViewController alloc] initWithNibName:@"TTColorViewController" bundle:nil];
    
    // Add gesture recognizer for pop
    UIPanGestureRecognizer * panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(userDidPan:)];
    [colorViewController.view addGestureRecognizer:panGestureRecognizer];
    
    TTColor * color = [((TTColorsViewController *)self.parentViewController) colorForSelectedRow];
    colorViewController.color = color;
    
    [self.parentViewController.navigationController pushViewController:colorViewController animated:YES];
}

#pragma mark - UINavigationControllerDelegate methods

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    
    // Only provide a transitioning animator for pushes
    if (operation == UINavigationControllerOperationPush) {
        
        self.pushing = YES;
        
        TTBaseAnimationController * animationController = [[TTAnimatorFactory sharedInstance] animationControllerForParentViewControllerClass:[fromVC class]
                                                                                                                     childViewControllerClass:[toVC class]];
        animationController.pushing = YES;
        
        return animationController;
        
    }else if (operation == UINavigationControllerOperationPop) {
        
        TTBaseAnimationController * animationController = [[TTAnimatorFactory sharedInstance] animationControllerForParentViewControllerClass:[fromVC class]
                                                                                                                     childViewControllerClass:[toVC class]];
        return animationController;
    }
    
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    NSLog(@"navigationController:interactionControllerForAnimationController: %@ - interactive: %i", animationController, self.isInteractive);
    if ( self.isInteractive ) {
        return self;
    }
    return nil;
}

#pragma mark - UIGestureRecognizerDelegate methods

- (void)userDidPan:(UIPanGestureRecognizer *)recognizer {
    
    // view for parent controller, not the parent's navigation
    UIView * view = ((TTColorsViewController *)self.parentViewController).tableView;
    
    if ( recognizer.state == UIGestureRecognizerStateBegan ) {
        
        self.interactive = YES;
        
        CGPoint location = [recognizer locationInView:view];
        CGPoint velocity = [recognizer velocityInView:view];
        
        if ( location.x < CGRectGetMidX(view.bounds) && velocity.x > 10 ) {
            
            //NSLog(@"gesture began! pushing %i", self.pushing);
            
            self.pushing = YES;
            
            // Push to details
            TTColorViewController * colorViewController = [[TTColorViewController alloc] initWithNibName:NSStringFromClass([TTColorViewController class]) bundle:nil];
            
            // add gesture recognizer
            UIPanGestureRecognizer * panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(userDidPan:)];
            [colorViewController.view addGestureRecognizer:panGestureRecognizer];
            [self.parentViewController.navigationController pushViewController:colorViewController animated:YES];
            
            //NSLog(@"selected point: %@", NSStringFromCGPoint(location));
            
            // Set selected cell for location
            [((TTColorsViewController *)self.parentViewController) selectRowAtLocation:location];
            
            // Get color for selected row
            TTColor * color = [((TTColorsViewController *)self.parentViewController) colorForSelectedRow];
            //NSLog(@"color: %@", color);
            colorViewController.color = color;
            
        } else {
            
            self.pushing = NO;
            
            // This is a pop, not a push.
            [self.parentViewController.navigationController popViewControllerAnimated:YES];
        }
        
    } else if ( recognizer.state == UIGestureRecognizerStateChanged ) {
        
        CGPoint translation = [recognizer translationInView:view];
        CGFloat percentComplete = fabs(translation.x / (CGRectGetWidth(view.bounds) / 2) ); // calculate on only a half/width
        
        if (percentComplete >= 1.0) {
            percentComplete = .99;
        }
        
        //NSLog(@"percent complete: %f", percentComplete);
        
        [self updateInteractiveTransition:percentComplete];
        
    } else if ( recognizer.state == UIGestureRecognizerStateEnded ) {
        
        CGPoint velocity = [recognizer velocityInView:view];
        
        if ( self.isPushing ) {
            
            if ( velocity.x > 10 ) {
                [self finishInteractiveTransition];
            } else {
                [self cancelInteractiveTransition];
            }
        } else {
            
            if ( velocity.x < 10 ) {
                [self finishInteractiveTransition];
            } else {
                [self cancelInteractiveTransition];
            }
        }
        
        self.interactive = NO;
        self.pushing = NO;
    }
}

#pragma mark Custom methods

- (NSString *)stringForUINavigationControllerOperation:(UINavigationControllerOperation)operation {
    NSString * operationString = nil;
    switch (operation) {
        case 0:
            operationString = @"None";
            break;
        case 1:
            operationString = @"Push";
            break;
        case 2:
            operationString = @"Pop";
            break;
    }
    return operationString;
}

@end
