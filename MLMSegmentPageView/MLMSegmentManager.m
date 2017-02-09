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
    [MLMSegmentManager associateHead:head withScroll:scroll completion:completion selectEnd:nil];
}


+ (void)associateHead:(MLMSegmentHead *)head
           withScroll:(MLMSegmentScroll *)scroll
           completion:(void(^)())completion
            selectEnd:(void(^)(NSInteger index))selectEnd {
    NSInteger showIndex;
    showIndex = head.showIndex?head.showIndex:scroll.showIndex;
    head.showIndex = scroll.showIndex = showIndex;
    
    head.selectedIndex = ^(NSInteger index) {
        [scroll setContentOffset:CGPointMake(index*scroll.width, 0) animated:YES];
        if (selectEnd) {
            selectEnd(index);
        }
    };
    [head defaultAndCreateView];
    
    scroll.scrollEnd = ^(NSInteger index) {
        [head setSelectIndex:index];
        if (selectEnd) {
            selectEnd(index);
        }
    };
    scroll.animationEnd = ^(NSInteger index) {
        [head animationEnd];
    };
    scroll.offsetScale = ^(CGFloat scale) {
        [head changePointScale:scale];
    };
    
    if (completion) {
        completion();
    }
    [scroll createView];
    
    UIView *view = head.nextResponder?head:scroll;
    UIViewController *currentVC = [view viewController];
    currentVC.automaticallyAdjustsScrollViewInsets = NO;
}


@end
