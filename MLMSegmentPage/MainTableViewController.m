//
//  MainTableViewController.m
//  MLMSegmentPage
//
//  Created by my on 2016/11/14.
//  Copyright © 2016年 my. All rights reserved.
//

#import "MainTableViewController.h"
#import "MainViewController.h"

@interface MainTableViewController ()
{
    NSArray *styleList;
}
@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"MLMSegmentPage";
    styleList = @[
                  @"SegmentHeadStyleDefault",
                  @"SegmentHeadStyleLine",
                  @"SegmentHeadStyleArrow",
                  @"SegmentHeadStyleSlide"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return styleList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"reuseIdentifier"];
    }
    cell.textLabel.text = styleList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MainViewController *vc = [MainViewController new];
    vc.style = indexPath.row;
    vc.title = styleList[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
