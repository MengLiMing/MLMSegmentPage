//
//  MLMSegmentManager.m
//  MLMSegmentPage
//
//  Created by my on 2017/2/5.
//  Copyright © 2017年 my. All rights reserved.
//

#import "MLMSegmentManager.h"


@implementation MLMSegmentManager

+ (void)associateHead:(MLMSegmentHead *)head
           withScroll:(MLMSegmentScroll *)scroll
           completion:(void(^)())completion {

    NSInteger showIndex;
    showIndex = head.showIndex?head.showIndex:scroll.showIndex;
    head.showIndex = scroll.showIndex = showIndex;
    
    head.selectedIndex = ^(NSInteger index) {
        [scroll setContentOffset:CGPointMake(index*scroll.width, 0) animated:YES];
    };
    [head defaultAndCreateView];

    scroll.scrollEnd = ^(NSInteger index) {
        [head setSelectIndex:index];
    };
    scroll.animationEnd = ^(NSInteger index) {
        [head animationEnd];
    };
    scroll.offsetScale = ^(CGFloat scale) {
        [head changePointScale:scale];
    };
    [scroll createView];
    
    if (completion) {
        completion();
    }
    
    UIView *view = head.nextResponder?head:scroll;
    UIViewController *currentVC = [view viewController];
    currentVC.automaticallyAdjustsScrollViewInsets = NO;
}


@end
