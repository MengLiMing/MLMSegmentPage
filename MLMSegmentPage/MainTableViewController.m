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
    
    NSArray *layoutList;
}
@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    styleList = @[
                  @"SegmentHeadStyleDefault",
                  @"SegmentHeadStyleLine",
                  @"SegmentHeadStyleArrow",
                  @"SegmentHeadStyleSlide"
                  ];
    
    layoutList = @[
                   @"MLMSegmentLayoutDefault",
                   @"MLMSegmentLayoutCenter",
                   @"MLMSegmentLayoutLeft"
                   ];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return layoutList.count;
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
    vc.layout = indexPath.section;
    vc.title = styleList[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    label.text = layoutList[section];
    label.backgroundColor = [UIColor groupTableViewBackgroundColor];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}
@end
