//
//  MLMSegmentPage.h
//  MLMSegmentPage
//
//  Created by my on 16/11/4.
//  Copyright © 2016年 my. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SegmentPageHead.h"


@protocol MLMSegmentPageDelegate <NSObject>

///滑动经过
- (void)scrollThroughIndex:(NSInteger)index;
///点击
- (void)selectedIndex:(NSInteger)index;

@end

@interface MLMSegmentPage : UIView

///第一次进入是否加载,YES加载countLimit个页面，默认 - NO
@property (nonatomic, assign) BOOL loadAll;
///缓存页面数目，默认 - all
@property (nonatomic, assign) NSInteger countLimit;


///顶部样式，默认 - SegmentHeadStyleDefault
@property (nonatomic, assign) MLMSegmentHeadStyle headStyle;
///顶部背景颜色，默认 - groupTableViewBackgroundColor
@property (nonatomic, strong) UIColor *headColor;
///顶部高度，默认 - 50
@property (nonatomic, assign) CGFloat headHeight;



///选中颜色，默认 - blackColor
@property (nonatomic, strong) UIColor *selectColor;
///未选中颜色，默认 - lightGrayColor
@property (nonatomic, strong) UIColor *deselectColor;
///字体大小，默认 - 13
@property (nonatomic, assign) CGFloat fontSize;
///缩放比例,非滑块模式下,选中标题字体缩放比例，默认 - 1
@property (nonatomic, assign) CGFloat fontScale;
///默认显示开始的位置，默认 - 1
@property (nonatomic, assign) NSInteger showIndex;


///下划线的颜色,默认 - selectedColor
@property (nonatomic, strong) UIColor *lineColor;
///下划线高度，默认 - 2.5
@property (nonatomic, assign) CGFloat lineHeight;
///下划线占比,默认 - 1
@property (nonatomic, assign) CGFloat lineScale;


///箭头颜色，默认 - selectedColor
@property (nonatomic, strong) UIColor *arrowColor;

///滑块颜色，默认 - deselectedColor
@property (nonatomic, strong) UIColor *slideColor;
///滑块高度，默认 - 头部按钮的高度* .8
@property (nonatomic, assign) CGFloat slideHeight;
///滑块圆角，默认 - slideHeight/2
@property (nonatomic, assign) CGFloat slideCorner;
///滑块占比,默认 - 1
@property (nonatomic, assign) CGFloat slideScale;


///设置当前屏幕最多显示的按钮数,默认 - 5
@property (nonatomic, assign) NSInteger maxTitleNum;

///分割线高度,默认 - 1
@property (nonatomic, assign) CGFloat bottomLineHeight;
///分割线颜色，默认 - grayColor
@property (nonatomic, strong) UIColor *bottomLineColor;

///delegate
@property (nonatomic, weak) id<MLMSegmentPageDelegate> delegate;

- (instancetype)initSegmentWithFrame:(CGRect)frame
                         titlesArray:(NSArray *)titles
                           vcOrviews:(NSArray *)views;

@end
