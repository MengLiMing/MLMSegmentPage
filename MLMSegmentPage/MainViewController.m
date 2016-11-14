//
//  MainViewController.m
//  MLMSegmentPage
//
//  Created by my on 16/11/4.
//  Copyright © 2016年 my. All rights reserved.
//

#import "MainViewController.h"
#import "ViewController.h"

@interface MainViewController () <MLMSegmentPageDelegate>
{
    NSArray *list;
}
@property (strong, nonatomic) UIScrollView *scrollHead;

@property (nonatomic, strong) MLMSegmentPage *pageView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
        
    list = @[@"一个按钮",
             @"两个按钮",
             @"三个按钮",
             @"四个按钮",
             @"五个按钮",
             @"六个按钮",
             @"七个按钮",
             @"八个按钮",
             @"九个按钮",
             @"十个按钮",
             ];
    
    _pageView = [[MLMSegmentPage alloc] initSegmentWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) titlesArray:list vcOrviews:[self vcArr]];
    _pageView.headStyle = _style;
    _pageView.delegate = self;
    
    switch (_style) {
        case SegmentHeadStyleDefault:
        {
            _pageView.loadAll = YES;
            
            _pageView.fontScale = 1.2;
            _pageView.fontSize = 12;
            
            _pageView.showIndex = 3;
            
            
            _pageView.deselectColor = [UIColor grayColor];
            _pageView.selectColor = [UIColor blackColor];
        }
            break;
        case SegmentHeadStyleLine:
        {
            _pageView.loadAll = YES;
            _pageView.countLimit = 5;
            
            _pageView.fontScale = .85;
            _pageView.fontSize = 14;

            _pageView.lineScale = .9;
            _pageView.lineHeight = 2;
            
            _pageView.deselectColor = [UIColor grayColor];
            _pageView.selectColor = [UIColor blackColor];
        }
            break;
        case SegmentHeadStyleArrow:
        {            
            _pageView.fontScale = 1;
            
            _pageView.maxTitleNum = 4;
            _pageView.countLimit = 4;
            
            _pageView.deselectColor = [UIColor grayColor];
            _pageView.selectColor = [UIColor blackColor];
        }
            break;
        case SegmentHeadStyleSlide:
        {
            
            _pageView.headHeight = 50;
            _pageView.slideHeight = 50 * 0.8;
//            _pageView.slideCorner = 0;
            _pageView.fontSize = 12;
            _pageView.slideScale = .95;
            
            _pageView.selectColor = [UIColor whiteColor];
            _pageView.deselectColor = [UIColor blackColor];
        }
            break;
        default:
            break;
    }
    

    
    [self.view addSubview:_pageView];
    
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
             @"ViewController"];
}

- (NSArray *)vcArr {
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < list.count; i ++) {
        ViewController *vc = [ViewController new];
        vc.index = i;
        [arr addObject:vc];
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
             @"View"];
}



- (NSArray *)viewArr {
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < list.count; i ++) {
        UIView *view = [NSClassFromString(@"View") new];
        [arr addObject:view];
    }
    return arr;
}


#pragma mark - delegate
- (void)scrollThroughIndex:(NSInteger)index {
//    NSLog(@"scroll through %@",@(index));
}

- (void)selectedIndex:(NSInteger)index {
//    NSLog(@"select %@",@(index));
}

@end
