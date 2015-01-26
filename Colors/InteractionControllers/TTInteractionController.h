//
//  TTInteractionController.h
//  Colors
//
//  Created by Aaron Connolly on 1/25/15.
//  Copyright (c) 2015 Top Turn Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

/*
 IMPORTANT: Assumes that parent view controller is working inside a navigation controller
 */

@interface TTInteractionController : UIPercentDrivenInteractiveTransition <UINavigationControllerDelegate, UIGestureRecognizerDelegate>

// Parent vc is needed to wire up gesture recognizer. without the GR you have no interactivity
- (id)initWithParentViewController:(UIViewController *)parentViewController;

// Pushes view controller non-interactively
- (void)push;


@end
