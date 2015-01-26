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

#define TTRectSetY( r, y )  CGRectMake( r.origin.x, y, r.size.width, r.size.height )

@implementation TTVerticalSplitAnimationController

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    UIView * containerView = transitionContext.containerView;
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if ( self.isPushing ) {
        
        // Add to vc below from vc
        [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
        
        // get selected cell from table
        UITableView * tableView = ((TTColorsViewController*)fromViewController).tableView;
        NSIndexPath * selectedIndexPath = [tableView indexPathForSelectedRow];
        UITableViewCell * selectedCell = [tableView cellForRowAtIndexPath:selectedIndexPath];
        
        // blank out the backgrounds of both the table view and it's parent view
        tableView.backgroundColor = [UIColor clearColor];
        fromViewController.view.backgroundColor = [UIColor clearColor];
        
        selectedCell.alpha = 0.0;           // blank out the cell
        
        NSInteger selectedRowRelativeToVisibleCells = [self relativeRowInTableView:tableView forVisibleCell:selectedCell];
        NSInteger topCellCount = selectedRowRelativeToVisibleCells;   // number of cells above this one = row count because row is a 0 based index.
        NSInteger bottomCellCount = (tableView.visibleCells.count-1) - selectedRowRelativeToVisibleCells;     // number of cells below this one = (total count-1 'for zero based index')-selected row
        
        // calculate distances that cells should move in order to be off-screen
        CGFloat topDistance = topCellCount * CGRectGetHeight(selectedCell.frame);
        CGFloat bottomDistance = bottomCellCount * CGRectGetHeight(selectedCell.frame);
        
        /*NSLog(@"selected row relative to visible cells: %i", selectedRowRelativeToVisibleCells);
         NSLog(@"selected cell row %i", selectedIndexPath.row);
         NSLog(@"top cell count %i", topCellCount);
         NSLog(@"bottom cell count %i", bottomCellCount);
         NSLog(@"cell height: %f", selectedCell.frame.size.height);
         NSLog(@"top distance: %f", topDistance);
         NSLog(@"bottom distance: %f", bottomDistance);*/
        
        // Prepare to animate label into place
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            // find all visible cells except the one selected and move them out of view
            for(UITableViewCell * c in tableView.visibleCells) {
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
            
            // set final place of animated label
            
        } completion:^(BOOL finished) {
            
            // Reload only visible rows
            [tableView reloadRowsAtIndexPaths:[tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationNone];
            
            // remove label from container view
            
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
        
    } else {
        
        // insert to vc above from vc
        [containerView insertSubview:toViewController.view aboveSubview:fromViewController.view];
        
        // get color from details view controller
        TTColor * color = ((TTColorViewController *)fromViewController).color;
        
        // select row with given color
        [((TTColorsViewController *)toViewController) selectRowWithColor:color];
        
        // get selected cell from table
        UITableView * tableView = ((TTColorsViewController*)toViewController).tableView;
        NSIndexPath * selectedIndexPath = [tableView indexPathForSelectedRow];
        UITableViewCell * selectedCell = [tableView cellForRowAtIndexPath:selectedIndexPath];
        //NSLog(@"selected index path: %@", selectedIndexPath);
        
        // if selected cell is not visible scroll it into view and retrieve it again
        if ( ! [tableView.visibleCells containsObject:selectedCell] )
        {
            [tableView scrollToRowAtIndexPath:selectedIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
            selectedCell = [tableView cellForRowAtIndexPath:selectedIndexPath];
        }
        
        selectedCell.alpha = 0.0;           // blank out the cell
        
        NSInteger selectedRowRelativeToVisibleCells = [self relativeRowInTableView:tableView forVisibleCell:selectedCell]; // row of selected cell relative to visible cells
        NSInteger topCellCount = selectedRowRelativeToVisibleCells;   // number of cells above this one = row count because row is a 0 based index.
        NSInteger bottomCellCount = (tableView.visibleCells.count-1) - selectedRowRelativeToVisibleCells;     // number of cells below this one = (total count-1 'for zero based index')-selected row
        
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
        
        /*NSLog(@"selected row relative to visible cells: %i", selectedRowRelativeToVisibleCells);
         NSLog(@"selected cell row %i", selectedIndexPath.row);
         NSLog(@"top cell count %i", topCellCount);
         NSLog(@"bottom cell count %i", bottomCellCount);
         NSLog(@"cell height: %f", selectedCell.frame.size.height);
         NSLog(@"top distance: %f", topDistance);
         NSLog(@"bottom distance: %f", bottomDistance);*/
        
        // prepare to animate label into place
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            // convert cell frame to container view
            selectedCell.frame = [containerView convertRect:selectedCell.frame fromView:((TTColorsViewController*)toViewController).tableView];

            // animate label
            
            // move cells back into view
            for(UITableViewCell * c in tableView.visibleCells) {
                NSInteger rowRelativeToVisibleCells = [self relativeRowInTableView:tableView forVisibleCell:c];
                
                NSLog(@"reset frame to: %@", NSStringFromCGRect([[originalCellFrames objectAtIndex:rowRelativeToVisibleCells] CGRectValue]));
                // reset all cell frames to original
                c.frame = [[originalCellFrames objectAtIndex:rowRelativeToVisibleCells] CGRectValue];
            }
            
        } completion:^(BOOL finished) {
            
            // show target cell
            selectedCell.alpha = 1.0;

            // remove label from container
            
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
