//
//  TTColorsViewController.m
//  Colors
//
//  Created by Aaron Connolly on 1/25/15.
//  Copyright (c) 2015 Top Turn Software. All rights reserved.
//

#import "TTColorsViewController.h"
#import "TTColor.h"
#import "TTColorTableViewCell.h"
#import "UIColor+TTExtensions.h"
#import "TTColorViewController.h"
#import "TTInteractionController.h"

@interface TTColorsViewController ()

@property (nonatomic) NSArray * colors;
@property (nonatomic) TTInteractionController * interactionController;
@property (nonatomic) BOOL suppressSelection;

@end

@implementation TTColorsViewController

- (instancetype)initWithColors:(NSArray *)colors {
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if ( self ) {
        self.colors = colors;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Colors";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // set up table view
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    UINib * xib = [UINib nibWithNibName:NSStringFromClass([TTColorTableViewCell class]) bundle:nil];
    [self.tableView registerNib:xib forCellReuseIdentifier:@"ColorCell"];
    
    // set up interaction controller
    self.interactionController = [[TTInteractionController alloc] initWithParentViewController:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"TTColorsViewController - view will appear");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"TTColorsViewController - view did appear");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSLog(@"TTColorsViewController - view will disappear");
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    NSLog(@"TTColorsViewController - view did disappear");
}


#pragma mark UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.colors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTColorTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ColorCell" forIndexPath:indexPath];
    TTColor * color = [self.colors objectAtIndex:indexPath.row];
    cell.textLabel.text = color.name;
    cell.backgroundColor = color.color;
    cell.textLabel.textColor = [color.color isTooDarkForBlackText] ? [UIColor whiteColor] : [UIColor blackColor];
    return cell;
}

#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TTColor * color = [self.colors objectAtIndex:indexPath.row];
    TTColorViewController * colorViewController = [[TTColorViewController alloc] initWithColor:color];
    [self.navigationController pushViewController:colorViewController animated:YES];
}

#pragma mark Helper methods

- (TTColor *)colorForSelectedRow {
    NSIndexPath * selectedIndexPath = [self.tableView indexPathForSelectedRow];
    TTColor * color = [self.colors objectAtIndex:selectedIndexPath.row];
    return color;
}

- (void)selectRowAtLocation:(CGPoint)location {
    NSIndexPath * tappedIndexPath = [self.tableView indexPathForRowAtPoint:location];
    self.suppressSelection = YES;
    [self.tableView selectRowAtIndexPath:tappedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    self.suppressSelection = NO;
}

- (void)selectRowWithColor:(TTColor *)color {
    NSInteger row = [self.colors indexOfObject:color];
    NSIndexPath * colorIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
    self.suppressSelection = YES;
    [self.tableView selectRowAtIndexPath:colorIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    self.suppressSelection = NO;
}

- (UILabel *)labelForSelectedRow {
    NSIndexPath * selectedIndexPath = [self.tableView indexPathForSelectedRow];
    UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:selectedIndexPath];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 44)];
    label.text = cell.textLabel.text;

    // convert the cell label view's frame from the cell to the table and assign it to our new image view
    label.frame = [self.tableView convertRect:cell.textLabel.frame fromView:cell];
    
    NSLog(@"color text label frame after conversion: %@", NSStringFromCGRect(label.frame));
    
    return label;
}

@end
