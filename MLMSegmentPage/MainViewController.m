//
//  MainViewController.m
//  MLMSegmentPage
//
//  Created by my on 16/11/4.
//  Copyright © 2016年 my. All rights reserved.
//

#import "MainViewController.h"
#import "ViewController.h"

@interface MainViewController ()
{
    NSArray *list;
}

@property (nonatomic, strong) MLMSegmentHead *segHead;
@property (nonatomic, strong) MLMSegmentScroll *segScroll;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSInteger segStyle = _layout*4 + _style;
    
    SEL sel = NSSelectorFromString([NSString stringWithFormat:@"segmentStyle%ld",(long)segStyle]);
    if ([self respondsToSelector:sel]) {
        [self performSelector:sel];
    }
}

/**********均分**********/
#pragma mark - 均分默认
- (void)segmentStyle0 {
    list = @[@"推荐",
             @"视频",
             @"科技",
             @"美容瘦身",
             @"互联网",
             @"值得买",
             @"购物街",
             @"体育",
             @"游戏",
             @"文玩"
             ];
    
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40) titles:list headStyle:_style layoutStyle:_layout];
    _segHead.fontScale = 1.1;
    _segHead.showIndex = 4;
    
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segHead.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(_segHead.frame)) vcOrViews:[self vcArr:list.count]];
    _segScroll.loadAll = YES;
    
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        [self.view addSubview:_segHead];
        [self.view addSubview:_segScroll];
    }];
}

#pragma mark - 均分下划线
- (void)segmentStyle1 {
    list = @[@"推荐",
             @"视频",
             @"科技",
             @"美容瘦身",
             @"互联网"
             ];
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40) titles:list headStyle:_style layoutStyle:_layout];
    _segHead.fontScale = .85;
    _segHead.fontSize = 14;
    _segHead.lineScale = .9;
    
    
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segHead.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(_segHead.frame)) vcOrViews:[self vcArr:list.count]];
    _segScroll.loadAll = NO;
    _segScroll.showIndex = 2;
    
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        [self.view addSubview:_segHead];
        [self.view addSubview:_segScroll];
    }];
}

#pragma mark - 均分箭头
- (void)segmentStyle2 {
    list = @[@"推荐",
             @"视频",
             @"科技",
             @"美容瘦身",
             @"互联网"
             ];
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40) titles:list headStyle:_style layoutStyle:_layout];
    _segHead.fontScale = .85;
    _segHead.fontSize = 14;
    _segHead.maxTitles = 3;
    
    
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segHead.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(_segHead.frame)) vcOrViews:[self vcArr:list.count]];
    _segScroll.loadAll = NO;
    
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        [self.view addSubview:_segHead];
        [self.view addSubview:_segScroll];
    }];
}


#pragma mark - 均分滑块
- (void)segmentStyle3 {
    list = @[@"推荐",
             @"视频",
             @"科技",
             @"美容瘦身",
             @"互联网",
             @"值得买",
             @"购物街",
             @"体育",
             @"游戏",
             @"文玩"
             ];
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40) titles:list headStyle:_style layoutStyle:_layout];
    _segHead.slideHeight = 40 * .9;
    _segHead.fontSize = 14;
    _segHead.slideScale = .9;
    _segHead.selectColor = [UIColor whiteColor];
    _segHead.deSelectColor = [UIColor blackColor];
    _segHead.slideColor = [UIColor blackColor];
    
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segHead.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(_segHead.frame)) vcOrViews:[self vcArr:list.count]];
    _segScroll.loadAll = NO;
    
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        [self.view addSubview:_segHead];
        [self.view addSubview:_segScroll];
    }];
}

/**********居中，头部菜单较少时使用，设置较多时，则变为left样式**********/
#pragma mark - 居中默认
- (void)segmentStyle4 {
    list = @[@"推荐",
             @"视频"
             ];
    
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40) titles:list headStyle:_style layoutStyle:_layout];
    _segHead.fontScale = 1.1;
    
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segHead.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(_segHead.frame)) vcOrViews:[self vcArr:list.count]];
    _segScroll.loadAll = YES;
    
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        [self.view addSubview:_segHead];
        [self.view addSubview:_segScroll];
    }];
}

#pragma mark - 居中下划线
- (void)segmentStyle5 {
    list = @[@"推荐",
             @"美容瘦身",
             @"科技"
             ];
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44) titles:list headStyle:_style layoutStyle:_layout];
    _segHead.headColor = [UIColor clearColor];
    _segHead.fontScale = .85;
    _segHead.fontSize = 14;
    _segHead.lineScale = .9;
    _segHead.equalSize = YES;
    _segHead.bottomLineHeight = 0;


    
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) vcOrViews:[self vcArr:list.count]];
    _segScroll.loadAll = NO;
    _segScroll.showIndex = 2;
    
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        self.navigationItem.titleView = _segHead;
        [self.view addSubview:_segScroll];
    }];
}

#pragma mark - 居中箭头
- (void)segmentStyle6 {
    list = @[@"推荐",
             @"互联网",
             @"值得买",
             @"科技"
             ];
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40) titles:list headStyle:_style layoutStyle:_layout];
    _segHead.fontScale = .85;
    _segHead.fontSize = 14;
    _segHead.maxTitles = 3;
    
    
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segHead.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(_segHead.frame)) vcOrViews:[self vcArr:list.count]];
    _segScroll.loadAll = NO;
    
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        [self.view addSubview:_segHead];
        [self.view addSubview:_segScroll];
    }];
}


#pragma mark - 居中滑块
- (void)segmentStyle7 {
    list = @[@"推荐",
             @"视频"
             ];
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30) titles:list headStyle:_style layoutStyle:_layout];
    _segHead.fontSize = 14;
    _segHead.bottomLineHeight = 0;
    _segHead.selectColor = [UIColor whiteColor];
    _segHead.deSelectColor = [UIColor blackColor];
    _segHead.slideColor = [UIColor blackColor];
    _segHead.equalSize = YES;
    _segHead.headColor = [UIColor redColor];
    _segHead.layer.cornerRadius = 30/2;
    _segHead.layer.masksToBounds = YES;
    [self.view addSubview:_segHead];
    
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) vcOrViews:[self vcArr:list.count]];
    _segScroll.loadAll = NO;
    [self.view addSubview:_segScroll];
    
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        self.navigationItem.titleView = _segHead;
        [self.view addSubview:_segScroll];
        
    }];
}


/**********居左，头部菜单较少时使用，设置较多时，则变为left样式**********/
#pragma mark - 居左默认
- (void)segmentStyle8 {
    list = @[@"推荐",
             @"视频"
             ];
    
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40) titles:list headStyle:_style layoutStyle:_layout];
    _segHead.fontScale = 1.1;
    
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segHead.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(_segHead.frame)) vcOrViews:[self vcArr:list.count]];
    _segScroll.loadAll = YES;
    
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        [self.view addSubview:_segHead];
        [self.view addSubview:_segScroll];
    }];
}

#pragma mark - 居左下划线
- (void)segmentStyle9 {
    list = @[@"推荐",
             @"美容瘦身",
             @"科技"
             ];
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40) titles:list headStyle:_style layoutStyle:_layout];
    _segHead.fontScale = .85;
    _segHead.fontSize = 14;
    _segHead.lineScale = .9;
    
    
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segHead.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(_segHead.frame)) vcOrViews:[self vcArr:list.count]];
    _segScroll.loadAll = NO;
    _segScroll.showIndex = 2;
    
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        [self.view addSubview:_segHead];
        [self.view addSubview:_segScroll];
    }];
}

#pragma mark - 居左箭头
- (void)segmentStyle10 {
    list = @[@"推荐",
             @"互联网",
             @"值得买",
             @"科技"
             ];
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40) titles:list headStyle:_style layoutStyle:_layout];
    _segHead.fontScale = .85;
    _segHead.fontSize = 14;
    _segHead.maxTitles = 3;

    
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segHead.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(_segHead.frame)) vcOrViews:[self vcArr:list.count]];
    _segScroll.loadAll = NO;
    
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        [self.view addSubview:_segHead];
        [self.view addSubview:_segScroll];
    }];
}


#pragma mark - 居左滑块
- (void)segmentStyle11 {
    list = @[@"推荐",
             @"视频",
             @"科技",
             @"美容瘦身",
             @"互联网",
             @"值得买",
             @"购物街",
             @"体育",
             @"游戏",
             @"文玩"
             ];
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40) titles:list headStyle:_style layoutStyle:_layout];
    _segHead.slideHeight = 40 * .9;
    _segHead.fontSize = 14;
    _segHead.slideScale = .9;
    _segHead.selectColor = [UIColor whiteColor];
    _segHead.deSelectColor = [UIColor blackColor];
    _segHead.slideColor = [UIColor blackColor];
    
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segHead.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(_segHead.frame)) vcOrViews:[self vcArr:list.count]];
    _segScroll.addTiming = SegmentAddScale;
    _segScroll.addScale = 0.1;
    _segScroll.loadAll = NO;
    
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll contentChangeAni:NO completion:^{
        [self.view addSubview:_segHead];
        [self.view addSubview:_segScroll];
    } selectEnd:^(NSInteger index) {
        NSLog(@"第%ld个视图,有什么操作?",index);
    }];
}


#pragma mark - 数据源
- (NSArray *)vcArr:(NSInteger)count {
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < count; i ++) {
        ViewController *vc = [ViewController new];
        vc.index = i;
        [arr addObject:vc];
    }
    return arr;
}


- (NSArray *)viewArr:(NSInteger)count {
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < count; i ++) {
        UIView *view = [NSClassFromString(@"View") new];
        [arr addObject:view];
    }
    return arr;
}

- (NSArray *)viewNameArr {
    return @[@"View",
             @"View",
             @"View",
             @"View",
             @"View",
             @"View",
             @"View",
             @"View",
             @"View",
             @"View"
             ];
}

- (NSArray *)vcnameArr {
    return @[@"ViewController",
             @"ViewController",
             @"ViewController",
             @"ViewController",
             @"ViewController",
             @"ViewController",
             @"ViewController",
             @"ViewController",
             @"ViewController",
             @"ViewController"
             ];
}

@end
