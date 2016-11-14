//
//  ViewController.m
//  MLMSegmentPage
//
//  Created by my on 2016/11/11.
//  Copyright © 2016年 my. All rights reserved.
//

#import "ViewController.h"
#import "SegmentPageHead.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UILabel *indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 40 - 50 - 64, SCREEN_WIDTH, 40)];
    indexLabel.backgroundColor = [UIColor redColor];
    indexLabel.textAlignment = NSTextAlignmentCenter;
    indexLabel.text = [NSString stringWithFormat:@"%@",@(_index)];
    [self.view addSubview:indexLabel];
    // Do any additional setup after loading the view.
    NSLog(@"init vc");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
