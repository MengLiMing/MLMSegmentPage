//
//  MLMSegmentHead.h
//  MLMSegmentPage
//
//  Created by my on 16/11/4.
//  Copyright © 2016年 my. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    /**
     *  默认
     */
    SegmentHeadStyleDefault,
    /**
     *  line(下划线)
     */
    SegmentHeadStyleLine,
    /**
     *  arrow(箭头)
     */
    SegmentHeadStyleArrow,
    /**
     *  Slide(滑块)
     */
    SegmentHeadStyleSlide,
} MLMSegmentHeadStyle;

@protocol MLMSegmentHeadDelegate <NSObject>

/**
 *  selected
 *
 *  @param index index
 */
- (void)didSelectedIndex:(NSInteger)index;

@end


@interface MLMSegmentHead : UIView
///style
@property (nonatomic, assign) MLMSegmentHeadStyle headStyle;

///背景颜色
@property (nonatomic, strong) UIColor *headColor;
///选择状态下的颜色
@property (nonatomic, strong) UIColor *selectColor;
///未选中状态下的颜色
@property (nonatomic, strong) UIColor *deSelectColor;
///字体大小
@property (nonatomic, assign) CGFloat fontSize;
///缩放比例，默认为1
@property (nonatomic, assign) CGFloat fontScale;
///默认显示0
@property (nonatomic, assign) NSInteger showIndex;

/*下划线风格*/
///下划线的颜色
@property (nonatomic, strong) UIColor *lineColor;
///下划线高度
@property (nonatomic, assign) CGFloat lineHeight;
///下划线占比
@property (nonatomic, assign) CGFloat lineScale;

/*箭头风格*/
///箭头颜色
@property (nonatomic, strong) UIColor *arrowColor;

/*滑块风格*/
///滑块颜色
@property (nonatomic, strong) UIColor *slideColor;
///滑块高度
@property (nonatomic, assign) CGFloat slideHeight;
///滑块圆角
@property (nonatomic, assign) CGFloat slideCorner;
///滑块占比
@property (nonatomic, assign) CGFloat slideScale;


///边线
@property (nonatomic, assign) CGFloat bottomLineHeight;
@property (nonatomic, strong) UIColor *bottomLineColor;

///设置超过多少个title的时候，可以滑动
@property (nonatomic, assign) NSInteger maxTitles;

///代理
@property (nonatomic, weak) id<MLMSegmentHeadDelegate> delegate;

/**
 *  init method
 *
 *  @param frame  frame
 *  @param titles titles array
 *  @param style  SegmentHeadStyle
 *
 *  @return SegmentHeadView
 */
- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray *)titles
                    headStyle:(MLMSegmentHeadStyle)style;

/**
 *  set currentIndex
 *
 *  @param index currendIndex
 */
- (void)setSelectIndex:(NSInteger)index;

/**
 *  animation by scale
 *
 *  @param scale scale
 */
- (void)changePointScale:(CGFloat)scale;


- (UIView *)getScrollLineView;
- (UIView *)getBottomLineView;



@end
