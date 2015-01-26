//
//  TTVerticalSplitAnimationController.m
//  Colors
//
//  Created by Aaron Connolly on 1/25/15.
//  Copyright (c) 2015 Top Turn Software. All rights reserved.
//

#import "TTVerticalSplitAnimationController.h"
#import "TTColorsViewController.h"

@implementation TTVerticalSplitAnimationController

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    /*UIView * containerView = transitionContext.containerView;
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
        
        NSInteger selectedRowRelativeToVisibleCells = [self relativeRowForVisibleCell:selectedCell FromTableView:tableView];    // row of selected cell relative to visible cells
        NSInteger topCellCount = selectedRowRelativeToVisibleCells;   // number of cells above this one = row count because row is a 0 based index.
        NSInteger bottomCellCount = (tableView.visibleCells.count-1) - selectedRowRelativeToVisibleCells;     // number of cells below this one = (total count-1 'for zero based index')-selected row
        
        // calculate distances that cells should move in order to be off-screen
        CGFloat topDistance = topCellCount * CGRectGetHeight(selectedCell.frame);
        CGFloat bottomDistance = bottomCellCount * CGRectGetHeight(selectedCell.frame);
        */
        /*NSLog(@"selected row relative to visible cells: %i", selectedRowRelativeToVisibleCells);
         NSLog(@"selected cell row %i", selectedIndexPath.row);
         NSLog(@"top cell count %i", topCellCount);
         NSLog(@"bottom cell count %i", bottomCellCount);
         NSLog(@"cell height: %f", selectedCell.frame.size.height);
         NSLog(@"top distance: %f", topDistance);
         NSLog(@"bottom distance: %f", bottomDistance);*/
        /*
        // create car image view and add below from view controller
        UIImageView * carImageView = [((TTListViewController *)fromViewController) imageViewForSelectedRow];
        carImageView.frame = [containerView convertRect:carImageView.frame fromView:tableView];
        [containerView insertSubview:carImageView belowSubview:fromViewController.view];
        
        // get stopping x,y of vehicle image
        CGPoint stoppingPoint = ((TTDetailsViewController* )toViewController).carImageView.frame.origin;
        stoppingPoint = [containerView convertPoint:stoppingPoint fromView:toViewController.view];
        
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
            
            carImageView.frame = CGRectMake(stoppingPoint.x, stoppingPoint.y, 320, 240);    // Hard coded values is a bit of a hack. Transforms would be cleaner, right?
            
        } completion:^(BOOL finished) {
            
            // Reload only visible rows
            [tableView reloadRowsAtIndexPaths:[tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationNone];
            [carImageView removeFromSuperview];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
        
    } else {
        
        // insert to vc above from vc
        [containerView insertSubview:toViewController.view aboveSubview:fromViewController.view];
        
        // get car from details view controller
        NSDictionary * car = ((TTDetailsViewController*)fromViewController).car;
        
        // select car row to go back to
        [((TTListViewController *)toViewController) selectRowWithCar:car];
        
        // get selected cell from table
        UITableView * tableView = ((TTListViewController*)toViewController).tableView;
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
        
        NSInteger selectedRowRelativeToVisibleCells = [self relativeRowForVisibleCell:selectedCell FromTableView:tableView];    // row of selected cell relative to visible cells
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
        */
        /*NSLog(@"selected row relative to visible cells: %i", selectedRowRelativeToVisibleCells);
         NSLog(@"selected cell row %i", selectedIndexPath.row);
         NSLog(@"top cell count %i", topCellCount);
         NSLog(@"bottom cell count %i", bottomCellCount);
         NSLog(@"cell height: %f", selectedCell.frame.size.height);
         NSLog(@"top distance: %f", topDistance);
         NSLog(@"bottom distance: %f", bottomDistance);*/
        /*
        // get image from details view
        UIImageView * carImageView = [[UIImageView alloc] initWithImage:((TTDetailsViewController*)fromViewController).carImageView.image];
        carImageView.frame = [containerView convertRect:carImageView.frame fromView:((TTDetailsViewController*)fromViewController).carImageView];
        [containerView insertSubview:carImageView aboveSubview:fromViewController.view];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            // convert cell frame to container view
            selectedCell.frame = [containerView convertRect:selectedCell.frame fromView:((TTListViewController*)toViewController).tableView];
            carImageView.center = CGPointMake(CGRectGetMidX(selectedCell.frame), CGRectGetMidY(selectedCell.frame));
            
            CGAffineTransform scaleTransform = CGAffineTransformMakeScale(2.0, 2.0);
            CGAffineTransform translateTransform = CGAffineTransformMakeTranslation(40.0, 0.0);     // offset x by 40 ;. See TTCarTableViewCell.xib for offset in original image
            carImageView.transform = CGAffineTransformConcat(scaleTransform, translateTransform);
            
            // move cells back into view
            for(UITableViewCell * c in tableView.visibleCells) {
                NSInteger rowRelativeToVisibleCells = [self relativeRowForVisibleCell:c FromTableView:tableView];
                NSLog(@"reset frame to: %@", NSStringFromCGRect([[originalCellFrames objectAtIndex:rowRelativeToVisibleCells] CGRectValue]));
                // reset all cell frames to original
                c.frame = [[originalCellFrames objectAtIndex:rowRelativeToVisibleCells] CGRectValue];
            }
            
        } completion:^(BOOL finished) {
            
            // show target cell
            selectedCell.alpha = 1.0;
            
            [carImageView removeFromSuperview];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }*/
}

#pragma mark - Custom methods

- (NSInteger)relativeRowForVisibleCell:(UITableViewCell *)cell FromTableView:(UITableView *)tableView {
    
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
