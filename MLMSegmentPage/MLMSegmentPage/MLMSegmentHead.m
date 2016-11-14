//
//  MLMSegmentHead.m
//  MLMSegmentPage
//
//  Created by my on 16/11/4.
//  Copyright © 2016年 my. All rights reserved.
//

#import "MLMSegmentHead.h"
#import "SegmentPageHead.h"


#define SCROLL_WIDTH self.frame.size.width
#define SCROLL_HEIGHT self.frame.size.height - _bottomLineHeight
static CGFloat arrow_H = 6;//箭头高
static CGFloat arrow_W = 18;//箭头宽

static CGFloat animation_time = .3;

@implementation MLMSegmentHead
{
    
    NSArray *titlesArray;///标题数组
    CGFloat buttonWidth;//每一个button的宽度
    
    NSMutableArray *buttonArray;//按钮数组

    UIScrollView *titlesScroll;
    
    UIView *lineView;//下划线view
    CAShapeLayer *arrow_layer;//箭头layer
    
    UIView *slideView;//滑块View
    UIScrollView *slideScroll;
    
    
    UIView *bottomLineView;//分割线
    
    NSInteger currentIndex;
    
    NSInteger isSelected;//区分点击还是滑动
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles headStyle:(MLMSegmentHeadStyle)style {
    if (self = [super initWithFrame:frame]) {
        _headStyle = style;
        titlesArray = titles;
        [self initCustom];
    }
    return self;
}


#pragma mark - custom init
- (void)initCustom {
        
    _headColor = [UIColor whiteColor];
    _selectColor = [UIColor blackColor];
    _deSelectColor = [UIColor lightGrayColor];
    
    
    buttonArray = [NSMutableArray array];
    _showIndex = 0;
    
    _fontSize = 13;
    _fontScale = 1;
    
    _lineColor = _selectColor;
    _lineHeight = 2.5;
    _lineScale = 1;
    
    _arrowColor = _selectColor;
    
    _slideHeight = SCROLL_HEIGHT;
    _slideColor = _deSelectColor;
    
    _slideCorner = _slideHeight/2;
    
    _slideScale = 1;
    _maxTitles = 5;
    
    _bottomLineColor = [UIColor grayColor];
    _bottomLineHeight = 1;

}

#pragma mark - layout
- (void)layoutSubviews {
    [super layoutSubviews];
    
    _maxTitles = _maxTitles>titlesArray.count?titlesArray.count:_maxTitles;
    buttonWidth = SCROLL_WIDTH/_maxTitles;
    
    currentIndex = _showIndex;
    
    [self createView];
}


#pragma mark - create View
- (void)createView {
    if (titlesScroll) {
        [titlesScroll removeFromSuperview];
    }
    
    _fontScale = _headStyle==SegmentHeadStyleSlide?1:_fontScale;
    titlesScroll = [self titlesScroll:NO];
    [self addSubview:titlesScroll];
    
    if (bottomLineView) {
        [bottomLineView removeFromSuperview];
    }
    if (_bottomLineHeight) {
        bottomLineView = [self bottomLineView];
        [self addSubview:bottomLineView];
    }
    
    switch (_headStyle) {
        case SegmentHeadStyleLine:
        {
            if (lineView) {
                [lineView removeFromSuperview];
            }
            lineView = [self lineView];
            [titlesScroll addSubview:lineView];
        }
            break;
        case SegmentHeadStyleArrow:
        {

            if (lineView) {
                [lineView removeFromSuperview];
            }
            _lineHeight = arrow_H;
            _lineScale = 1;
            lineView = [self lineView];
            lineView.backgroundColor = [UIColor clearColor];
            [titlesScroll addSubview:lineView];
            
            arrow_layer = [[CAShapeLayer alloc] init];
            arrow_layer.fillColor = _arrowColor.CGColor;
            [lineView.layer addSublayer:arrow_layer];
            [self drawLayer:arrow_layer];


        }
            break;
        case SegmentHeadStyleSlide:
        {
            if (slideView) {
                [slideView removeFromSuperview];
            }
            slideView = [self slideView];
            [titlesScroll addSubview:slideView];
        }
            break;
        default:
            break;
    }
    
    [self changeTitleScrollByScale:_showIndex/(CGFloat)titlesArray.count];
    [self changeLinePointByScale:_showIndex/(CGFloat)titlesArray.count];
}

#pragma mark - drow arrow
- (void)drawLayer:(CAShapeLayer *)layer {
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, nil, (buttonWidth - arrow_W)/2, arrow_H);
    CGPathAddLineToPoint(path, nil, buttonWidth/2, 0);
    CGPathAddLineToPoint(path, nil, (buttonWidth + arrow_W)/2, arrow_H);
    CGPathCloseSubpath(path);
    layer.path = path;
    CGPathRelease(path);
}


#pragma mark - create TitlesScroll
- (UIScrollView *)titlesScroll:(BOOL)select {
    if (!titlesArray) {
        return nil;
    }
    if (!select) {
        [buttonArray removeAllObjects];
    }

    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCROLL_WIDTH, SCROLL_HEIGHT)];
    scroll.contentSize = CGSizeMake(titlesArray.count * buttonWidth, SCROLL_HEIGHT);
    scroll.backgroundColor = _headColor;
    scroll.showsVerticalScrollIndicator = NO;
    scroll.showsHorizontalScrollIndicator  = NO;
    scroll.bounces = NO;
    
    for (NSInteger i = 0; i < titlesArray.count; i ++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:titlesArray[i] forState:UIControlStateNormal];
        button.frame = CGRectMake(i * buttonWidth, 0, buttonWidth, SCROLL_HEIGHT);
        if (select) {
            button.titleLabel.font = [UIFont systemFontOfSize:_fontSize*_fontScale];
            [button setTitleColor:_selectColor forState:UIControlStateNormal];
        } else {
            button.titleLabel.font = [UIFont systemFontOfSize:_fontSize];
            [button setTitleColor:_selectColor forState:UIControlStateSelected];
            [button setTitleColor:_deSelectColor forState:UIControlStateNormal];
            [button addTarget:self action:@selector(selectedHeadTitles:) forControlEvents:UIControlEventTouchUpInside];
            if (i==_showIndex) {
                if (_fontScale != 1) {
                    button.transform = CGAffineTransformMakeScale(_fontScale, _fontScale);
                }
                button.selected = _headStyle != SegmentHeadStyleSlide;
            }
            [buttonArray addObject:button];
        }
        [scroll addSubview:button];
    }
    
    return scroll;
}


#pragma mark - create Line
- (UIView *)lineView {
    _lineScale = fabs(_lineScale)>1?1:fabs(_lineScale);
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake((1-_lineScale)*buttonWidth/2, SCROLL_HEIGHT-_lineHeight, buttonWidth*_lineScale, _lineHeight)];
    line.backgroundColor = _lineColor;
    return line;
}

#pragma mark - bottom Line
- (UIView *)bottomLineView {
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, SCROLL_HEIGHT, SCROLL_WIDTH, _bottomLineHeight)];
    line.backgroundColor = _bottomLineColor;
    return line;
}

#pragma mark - create slide
- (UIView *)slideView {
    UIView *slide = [[UIView alloc] initWithFrame:CGRectMake((1-_slideScale)*buttonWidth/2, (SCROLL_HEIGHT-_slideHeight)/2, buttonWidth*_slideScale, _slideHeight)];
    
    slide.layer.cornerRadius = MIN(_slideCorner, _slideHeight/2);
    slide.clipsToBounds = YES;
    slide.backgroundColor = _slideColor;
    slideScroll = [self titlesScroll:YES];
    slideScroll.userInteractionEnabled = NO;
    slideScroll.frame = CGRectMake(-(1-_slideScale)*buttonWidth/2, -(SCROLL_HEIGHT - _slideHeight)/2, SCROLL_WIDTH, SCROLL_HEIGHT);
    slideScroll.backgroundColor = [UIColor clearColor];
    [slide addSubview:slideScroll];
    return slide;
}

#pragma mark - button Action
- (void)selectedHeadTitles:(UIButton *)button {
    NSInteger selectIndex = [buttonArray indexOfObject:button];
    //repeat click
    if (selectIndex == currentIndex) {
        return;
    }
    
    if (_headStyle != SegmentHeadStyleSlide) {
        [UIView animateWithDuration:animation_time animations:^{
            //before
            NSInteger lastIndex = currentIndex;
            UIButton *lastBtn = [buttonArray objectAtIndex:lastIndex];
            lastBtn.selected = NO;
            if (_fontScale != 1) {
                lastBtn.transform = CGAffineTransformMakeScale(1, 1);
            }
        }];
    }
    
    currentIndex = selectIndex;

    //titlescroll
    [UIView animateWithDuration:animation_time animations:^{
        CGFloat scale = currentIndex/(CGFloat)titlesArray.count;
        [self changeTitleScrollByScale:scale];
        [self changeLinePointByScale:scale];
    }];
    
    if (_headStyle != SegmentHeadStyleSlide) {
        [UIView animateWithDuration:animation_time animations:^{
            UIButton *currentBtn = [buttonArray objectAtIndex:currentIndex];
            if (_fontScale != 1) {
                currentBtn.transform = CGAffineTransformMakeScale(_fontScale, _fontScale);
            }
            currentBtn.selected = YES;
        }];
    }
    isSelected = YES;
    if ([self.delegate respondsToSelector:@selector(didSelectedIndex:)]) {
        [self.delegate didSelectedIndex:currentIndex];
    }
}
#pragma mark - set index
- (void)setSelectIndex:(NSInteger)index {
    currentIndex = index;
    if (_headStyle != SegmentHeadStyleSlide) {
        for (UIButton *button in buttonArray) {
            if ([buttonArray indexOfObject:button] != currentIndex) {
                if (_fontScale != 1) {
                    button.transform = CGAffineTransformMakeScale(1, 1);
                }
                button.selected = NO;
            }
        }
    }
    
    isSelected = NO;
}


#pragma mark - animation
- (void)changePointScale:(CGFloat)scale {
    //The percentage of each button
    CGFloat per_btn = 1/(CGFloat)titlesArray.count;
    //end scale,begin scale
    CGFloat scale_end = (titlesArray.count-1)*per_btn + per_btn/3;
    CGFloat scale_begin = 0 - per_btn/3;
    if (scale<scale_begin || scale>scale_end) {
        return;
    }
    if (isSelected) {
        return;
    }
    [self changeLinePointByScale:scale];

    //index by scale
    NSInteger curIndex = [@((scale+(1/(CGFloat)titlesArray.count)/2)*titlesArray.count) integerValue];
    if (_headStyle != SegmentHeadStyleSlide) {
        //offset
        CGFloat start_offset = scale - per_btn*curIndex;
        //Scaling rate
        CGFloat scale_rate = fabs(start_offset)/(per_btn)*(_fontScale-1);
        
        if (start_offset>=-per_btn && start_offset <= per_btn) {
            //index of next btn
            NSInteger changeBtnIndex = curIndex + (start_offset<0?-1:1);
            if (changeBtnIndex>=0 && changeBtnIndex < titlesArray.count) {
                UIButton *btn = [buttonArray objectAtIndex:changeBtnIndex];
                if (_fontScale != 1) {
                    btn.transform = CGAffineTransformMakeScale(1+scale_rate, 1+scale_rate);
                }
                btn.selected = fabs(start_offset) > per_btn/2;
            }
            
            if (curIndex>=0 && curIndex < titlesArray.count) {
                UIButton *curBtn = [buttonArray objectAtIndex:curIndex];
                if (_fontScale != 1) {
                    curBtn.transform = CGAffineTransformMakeScale(_fontScale-scale_rate, _fontScale-scale_rate);
                }
                curBtn.selected = fabs(start_offset) < per_btn/2;
            }
        }
        
    }
    [self changeTitleScrollByScale:scale];
}


#pragma mark - change titlesScroll
- (void)changeTitleScrollByScale:(CGFloat)scale {
    if (titlesArray.count > _maxTitles) {
        CGFloat end_offset = titlesScroll.contentSize.width - titlesScroll.frame.size.width;
        //offset by scale
        CGFloat scroll_offset = scale*titlesScroll.contentSize.width - titlesScroll.frame.size.width/2 + buttonWidth/2;
        //left - start_offset
        scroll_offset = scroll_offset<0?0:scroll_offset;
        //right - end_offset
        scroll_offset = scroll_offset>end_offset?end_offset:scroll_offset;
        [titlesScroll setContentOffset:CGPointMake(scroll_offset, 0)];
    }
}
#pragma mark - change line arrow slide
- (void)changeLinePointByScale:(CGFloat)scale {
    CGFloat point_x = scale*titlesScroll.contentSize.width;
    switch (_headStyle) {
        case SegmentHeadStyleLine:
        case SegmentHeadStyleArrow:
        {
            lineView.center = CGPointMake(point_x+buttonWidth/2, lineView.center.y);
        }
            break;
        case SegmentHeadStyleSlide:
        {
            slideView.center = CGPointMake(point_x+buttonWidth/2, slideView.center.y);
            slideScroll.contentOffset = CGPointMake(point_x, 0);
        }
            break;
        default:
            break;
    }
}

#pragma mark - lineView
- (UIView *)getBottomLineView {
    return lineView;
}


- (UIView *)getScrollLineView {
    return bottomLineView;
}

#pragma mark - dealloc
- (void)dealloc {
    arrow_layer.delegate = nil;
    [arrow_layer removeFromSuperlayer];
    arrow_layer = nil;
}
@end
