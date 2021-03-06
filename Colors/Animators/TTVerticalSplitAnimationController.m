//
//  TTVerticalSplitAnimationController.m
//  Colors
//
//  Created by Aaron Connolly on 1/25/15.
//  Copyright (c) 2015 Top Turn Software. All rights reserved.
//

#import "TTVerticalSplitAnimationController.h"
#import "TTColorsViewController.h"
#import "TTColorViewController.h"
#import "UIColor+TTExtensions.h"

#define TTRectSetY( r, y )  CGRectMake( r.origin.x, y, r.size.width, r.size.height )

@implementation TTVerticalSplitAnimationController

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 1.0f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    UIView * containerView = transitionContext.containerView;
    
    if ( self.isPushing ) {
        
        TTColorsViewController * colorsViewController = (TTColorsViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        TTColorViewController * colorViewController = (TTColorViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

        // set container view background color
        containerView.backgroundColor = colorViewController.color.color;
        
        // Add to vc below from vc
        [containerView insertSubview:colorViewController.view belowSubview:colorsViewController.view];
        
        // get selected cell from table
        UITableView * tableView = colorsViewController.tableView;
        NSIndexPath * selectedIndexPath = [tableView indexPathForSelectedRow];
        UITableViewCell * selectedCell = [tableView cellForRowAtIndexPath:selectedIndexPath];
        
        // blank out the backgrounds of the table view and it's parent view and the cell
        tableView.backgroundColor = [UIColor clearColor];
        colorsViewController.view.backgroundColor = [UIColor clearColor];
        selectedCell.alpha = 0.0;
        
        // row of selected cell relative to visible cells
        NSInteger selectedRowRelativeToVisibleCells = [self relativeRowInTableView:tableView forVisibleCell:selectedCell];
        
        // number of cells above this one = row count because row is a 0 based index.
        NSInteger topCellCount = selectedRowRelativeToVisibleCells;
        
        // number of cells below this one = (total count-1 'for zero based index')-selected row
        NSInteger bottomCellCount = (tableView.visibleCells.count-1) - selectedRowRelativeToVisibleCells;
         
        // calculate distances that cells should move in order to be off-screen
        CGFloat topDistance = topCellCount * CGRectGetHeight(selectedCell.frame);
        CGFloat bottomDistance = bottomCellCount * CGRectGetHeight(selectedCell.frame);
        
        // prepare to animate label into place
        UILabel * label = [colorsViewController labelForSelectedRow];
        label.textAlignment = NSTextAlignmentCenter;
        label.frame = [containerView convertRect:label.frame fromView:tableView];
        [containerView insertSubview:label belowSubview:colorsViewController.view];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            [tableView.visibleCells enumerateObjectsUsingBlock:^(UITableViewCell * cell, NSUInteger idx, BOOL *stop) {
                if ( cell != selectedCell ) {
                    
                    NSIndexPath * cellIndexPath = [tableView indexPathForCell:cell];
                    
                    if (cellIndexPath.row < selectedIndexPath.row) {
                        // move cells up by subtracting height and distance
                        cell.frame = TTRectSetY(cell.frame, (CGRectGetMinY(cell.frame) - topDistance));
                    }else{
                        // move cells down by adding height and distance
                        cell.frame = TTRectSetY(cell.frame, CGRectGetMinY(cell.frame) + bottomDistance);
                    }
                }
            }];
            
            // set final position, color and size of label
            label.center = colorViewController.view.center;
            label.textColor = [colorViewController.color.color isTooDarkForBlackText] ? [UIColor whiteColor] : [UIColor blackColor];
            label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:30.0];
            
        } completion:^(BOOL finished) {
            
            // remove label from container view
            [label removeFromSuperview];
            
            // restore selected cell's alpha
            selectedCell.alpha = 1.0;
            
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
        
    } else {

        TTColorViewController * colorViewController = (TTColorViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        TTColorsViewController * colorsViewController = (TTColorsViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        // insert to vc above from vc
        [containerView insertSubview:colorsViewController.view aboveSubview:colorViewController.view];
        
        // get color from details view controller
        TTColor * color = colorViewController.color;
        
        // select row with given color
        [colorsViewController selectRowWithColor:color];
        
        // get selected cell from table
        UITableView * tableView = colorsViewController.tableView;
        NSIndexPath * selectedIndexPath = [tableView indexPathForSelectedRow];
        UITableViewCell * selectedCell = [tableView cellForRowAtIndexPath:selectedIndexPath];
        
        // if selected cell is not visible scroll it into view and retrieve it again
        if ( ! [tableView.visibleCells containsObject:selectedCell] )
        {
            [tableView scrollToRowAtIndexPath:selectedIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
            selectedCell = [tableView cellForRowAtIndexPath:selectedIndexPath];
        }
        
        // hide the cell
        selectedCell.alpha = 0.0;
        
        // row of selected cell relative to visible cells
        NSInteger selectedRowRelativeToVisibleCells = [self relativeRowInTableView:tableView forVisibleCell:selectedCell];
        
        // number of cells above this one = row count because row is a 0 based index.
        NSInteger topCellCount = selectedRowRelativeToVisibleCells;
        
        // number of cells below this one = (total count-1 'for zero based index')-selected row
        NSInteger bottomCellCount = (tableView.visibleCells.count-1) - selectedRowRelativeToVisibleCells;
        
        // calculate distances that cells should move in order to be off-screen
        CGFloat topDistance = topCellCount * CGRectGetHeight(selectedCell.frame);
        CGFloat bottomDistance = bottomCellCount * CGRectGetHeight(selectedCell.frame);
        
        // store cell's original frames, them move cells off screen
        NSMutableArray * originalCellFrames = [NSMutableArray array];
        
        for(UITableViewCell * c in tableView.visibleCells) {
            
            // save original frame
            [originalCellFrames addObject:[NSValue valueWithCGRect:c.frame]];
            
            if ( c != selectedCell ) {
                
                NSIndexPath * cellIndexPath = [tableView indexPathForCell:c];
                
                if (cellIndexPath.row < selectedIndexPath.row) {
                    // move cells up
                    c.frame = TTRectSetY(c.frame, (CGRectGetMinY(c.frame) - topDistance));      // subtract height and distance
                }else{
                    // move cells down
                    c.frame = TTRectSetY(c.frame, CGRectGetMinY(c.frame) + bottomDistance);     // add height and distance
                }
            }
        }
        
        // grab a copy of the label from colors view, convert its frame
        // to the frame of the container view, then insert it below the
        // colors view controller
        UILabel * label = [[UILabel alloc] initWithFrame:colorViewController.colorLabel.frame];
        label.textAlignment = colorViewController.colorLabel.textAlignment;
        label.text = colorViewController.colorLabel.text;
        label.font = colorViewController.colorLabel.font;
        label.textColor = colorViewController.colorLabel.textColor;
        label.frame = [containerView convertRect:label.frame fromView:colorViewController.view];
        [containerView insertSubview:label aboveSubview:colorViewController.view];
        
        // hide existing color label
        colorViewController.colorLabel.hidden = YES;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            // convert cell frame to container view
            selectedCell.frame = [containerView convertRect:selectedCell.frame fromView:colorsViewController.tableView];
            
            label.center = CGPointMake(CGRectGetMidX(selectedCell.frame), CGRectGetMidY(selectedCell.frame));
            label.font = [UIFont fontWithName:@"Helvetica-Neue" size:12.0];
            
            // move cells back into view
            for(UITableViewCell * c in tableView.visibleCells) {
                NSInteger rowRelativeToVisibleCells = [self relativeRowInTableView:tableView forVisibleCell:c];
                
                // reset all cell frames to original
                c.frame = [[originalCellFrames objectAtIndex:rowRelativeToVisibleCells] CGRectValue];
            }
            
        } completion:^(BOOL finished) {
            
            // show target cell
            selectedCell.alpha = 1.0;

            // remove label from container
            [label removeFromSuperview];
            
            // show the label again
            colorViewController.colorLabel.hidden = NO;
            
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
}

#pragma mark - Custom methods

- (NSInteger)relativeRowInTableView:(UITableView *)tableView forVisibleCell:(UITableViewCell *)cell {
    
    NSInteger row = 0;
    
    for(UITableViewCell * c in tableView.visibleCells) {
        if (c == cell) {
            return row;
        }
        row++;
    }
    return row;
}

@end
