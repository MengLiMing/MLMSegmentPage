//
//  MLMSegmentScroll.h
//  MLMSegmentPage
//
//  Created by my on 2017/2/6.
//  Copyright © 2017年 my. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MLMSegmentScrollDelegate <NSObject>

///滑动结束
- (void)scrollEndIndex:(NSInteger)index;
///动画结束
- (void)animationEndIndex:(NSInteger)index;
///偏移的百分比
- (void)scrollOffsetScale:(CGFloat)scale;

@end


@interface MLMSegmentScroll : UIScrollView

///第一次进入是否加载,YES加载countLimit个页面，默认 - NO
@property (nonatomic, assign) BOOL loadAll;
///缓存页面数目，默认 - all
@property (nonatomic, assign) NSInteger countLimit;
///默认显示开始的位置，默认 - 1
@property (nonatomic, assign) NSInteger showIndex;

///delegate
@property (nonatomic, weak) id<MLMSegmentScrollDelegate> segDelegate;
///blcok
@property (nonatomic, copy) void(^scrollEnd)(NSInteger);
@property (nonatomic, copy) void(^animationEnd)(NSInteger);
@property (nonatomic, copy) void(^offsetScale)(CGFloat);


- (instancetype)initWithFrame:(CGRect)frame vcOrViews:(NSArray *)sources;

/**
 * 创建之后，初始化
 */
- (void)createView;

@end
