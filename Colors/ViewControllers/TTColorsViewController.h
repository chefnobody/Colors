//
//  TTColorsViewController.h
//  Colors
//
//  Created by Aaron Connolly on 1/25/15.
//  Copyright (c) 2015 Top Turn Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTColor.h"

@interface TTColorsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView * tableView;

- (instancetype)initWithColors:(NSArray *)colors;

- (TTColor *)colorForSelectedRow;
- (void)selectRowAtLocation:(CGPoint)location;
- (void)selectRowWithColor:(TTColor *)color;
- (UILabel *)labelForSelectedRow;

@end
