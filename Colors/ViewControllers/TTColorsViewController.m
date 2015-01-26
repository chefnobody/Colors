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

@interface TTColorsViewController ()

@property (nonatomic) NSArray * colors;

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
    TTColor * color = [self.colors objectAtIndex:indexPath.row];
    TTColorViewController * colorViewController = [[TTColorViewController alloc] initWithColor:color];
    [self.navigationController pushViewController:colorViewController animated:YES];
}

@end
