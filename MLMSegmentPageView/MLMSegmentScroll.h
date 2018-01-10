//
//  MLMSegmentScroll.h
//  MLMSegmentPage
//
//  Created by my on 2017/2/6.
//  Copyright © 2017年 my. All rights reserved.
//

#import <UIKit/UIKit.h>

//添加子视图的时机
typedef enum : NSUInteger {
    SegmentAddNormal,//滑动或者动画结束
    SegmentAddScale//根据设置滑动百分比添加0-1
} SegmentAddTiming;

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

///添加时机,默认动画或者滑动结束添加
@property (nonatomic, assign) SegmentAddTiming addTiming;
///SegmentAddScale 时使用
@property (nonatomic, assign) CGFloat addScale;


///给一些vc设置属性，在创建的时候,在viewController或view传入的是类名的时候使用
@property (nonatomic, copy) void(^initSource)(id vcOrview, NSInteger index);


- (instancetype)initWithFrame:(CGRect)frame vcOrViews:(NSArray *)sources;

- (void)changeSource:(NSArray *)sources;


/**
 * 创建之后，初始化
 */
- (void)createView;

- (NSInteger)currentIndex;
- (id)currentVcOrView;

@end
