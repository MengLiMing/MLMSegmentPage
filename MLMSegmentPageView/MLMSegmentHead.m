//
//  MLMSegmentHead.m
//  MLMSegmentPage
//
//  Created by my on 16/11/4.
//  Copyright © 2016年 my. All rights reserved.
//

#import "MLMSegmentHead.h"
#import "SegmentPageHead.h"


#define SCROLL_WIDTH (self.width - _moreButton_width)
#define SCROLL_HEIGHT (self.height - _bottomLineHeight)

#define CURRENT_WIDTH(s) [titleWidthArray[s] floatValue]

static CGFloat arrow_H = 6;//箭头高
static CGFloat arrow_W = 18;//箭头宽

static CGFloat animation_time = .3;

@interface MLMSegmentHead ()

/*------------其他设置------------*/
/**
 *  MLMSegmentHeadStyle
 */
@property (nonatomic, assign) MLMSegmentHeadStyle headStyle;

/**
 *  MLMSegmentHeadStyle
 */
@property (nonatomic, assign) MLMSegmentLayoutStyle layoutStyle;

@end

@implementation MLMSegmentHead
{
    NSMutableArray *titlesArray;///标题数组
    UIScrollView *titlesScroll;

    NSMutableArray *buttonArray;//按钮数组
    NSMutableArray *backImgArray;//背景图数组

    
    UIView *lineView;//下划线view
    CAShapeLayer *arrow_layer;//箭头layer
    
    UIView *slideView;//滑块View
    UIScrollView *slideScroll;
    
    
    UIView *bottomLineView;//分割线
    
    NSInteger currentIndex;//当前选中的按钮
    
    //在与外侧scroll关联时，动画结束之后将其设置为NO
    BOOL isSelected;//区分点击还是滑动
    
    
    //button宽度的数组，总宽度
    NSMutableArray *titleWidthArray;
    CGFloat sum_width;
    
    //用来判断向左向右
    CGFloat endScale;
}

#pragma mark - initMethod
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles {
    return [self initWithFrame:frame titles:titles headStyle:SegmentHeadStyleDefault];
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles headStyle:(MLMSegmentHeadStyle)style {
    return [self initWithFrame:frame titles:titles headStyle:style layoutStyle:MLMSegmentLayoutDefault];
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles headStyle:(MLMSegmentHeadStyle)style layoutStyle:(MLMSegmentLayoutStyle)layout {
    if (self = [super initWithFrame:frame]) {
        _headStyle = style;
        _layoutStyle = layout;
        titlesArray = [titles mutableCopy];
        [self initCustom];
    }
    return self;
}

#pragma mark - custom init
- (void)initCustom {
    _headColor = [UIColor whiteColor];
    _selectColor = [UIColor blackColor];
    _deSelectColor = [UIColor lightGrayColor];
    
    _moreButton_width = 0;
    
    buttonArray = [NSMutableArray array];
    backImgArray = [NSMutableArray array];
    _showIndex = 0;
    
    _fontSize = 13;
    _fontScale = 1;
    
    _singleW_Add = 20;
    
    _lineColor = _selectColor;
    _lineHeight = 2.5;
    _lineScale = 1;
    
    _arrowColor = _selectColor;
    
    _slideHeight = SCROLL_HEIGHT;
    _slideColor = _deSelectColor;
    
    _slideCorner = _slideHeight/2;
    
    _slideScale = 1;
    _maxTitles = 5.0;
    
    _bottomLineColor = [UIColor grayColor];
    _bottomLineHeight = 1;

}

- (void)changeTitle:(NSArray *)titles {
    titlesArray = [titles mutableCopy];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self defaultAndCreateView];
}


#pragma mark - layout
- (void)defaultAndCreateView {
    if (!titleWidthArray) {
        titleWidthArray = [NSMutableArray arrayWithCapacity:titlesArray.count];
    }
    [titleWidthArray removeAllObjects];
    
    _maxTitles = _maxTitles>titlesArray.count?titlesArray.count:_maxTitles;

    
    [self titlesWidth];

    if (_equalSize) {
        self.width = sum_width+_moreButton_width;
        
        if (titlesScroll) {
            titlesScroll.width = SCREEN_WIDTH;
        }
        
        if (slideScroll) {
            slideScroll.width = SCREEN_WIDTH;
        }
    }
    
    //判断总宽度
    if (sum_width > SCROLL_WIDTH && _layoutStyle== MLMSegmentLayoutCenter) {
        _layoutStyle = MLMSegmentLayoutLeft;
    }
    
    _showIndex = MIN(titlesArray.count-1, MAX(0, _showIndex));

    [self createView];
    
    if (_showIndex != 0) {
        currentIndex = _showIndex;
        [self changeContentOffset];
        [self changeBtnFrom:0 to:currentIndex];
    }

}


#pragma mark - 根据文字计算宽度
- (void)titlesWidth {
    sum_width = 0;
    CGFloat width = SCROLL_WIDTH/_maxTitles;
    for (NSString *title in titlesArray) {
        if (_layoutStyle != MLMSegmentLayoutDefault) {
            width = [self titleWidth:title];
        }
        [titleWidthArray addObject:@(width)];
        sum_width += width;
    }
}

- (CGFloat)titleWidth:(NSString *)title {
    CGFloat sys_font = _fontScale>1?_fontSize*_fontScale:_fontSize;
    return [title boundingRectWithSize:CGSizeMake(MAXFLOAT, CGRectGetHeight(self.frame)) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:sys_font]} context:nil].size.width + _singleW_Add;
}

//#pragma mark - 添加按钮
//- (void)addMoreTitles:(NSArray *)moreTitles {
//    if (_layoutStyle == MLMSegmentLayoutCenter) {
//        return;
//    }
//    
//    CGFloat start_x = sum_width;
//    CGFloat start_index = titleWidthArray.count;
//    
//    //添加到数组，并计算宽度
//    for (NSInteger i = 0; i < moreTitles.count; i ++) {
//        NSString *title = moreTitles[i];
//        CGFloat width = [self titleWidth:title];
//        [titleWidthArray addObject:@(width)];
//        sum_width += width;
//        
//        [titlesArray addObject:title];
//    }
//    
//    [self createBtn:titlesArray addScroll:titlesScroll startX:start_x start_index:start_index];
//    if (_headStyle == SegmentHeadStyleSlide) {
//        [self createBtn:titlesArray addScroll:slideScroll startX:start_x start_index:start_index];
//    }
//    
//    
//    [self setSelectIndex:currentIndex];
//}

#pragma mark - create View
- (void)createView {

    _fontScale = _headStyle==SegmentHeadStyleSlide?1:_fontScale;
    titlesScroll = [self customScroll];
    [self scrollViewSubviews:titlesScroll];
    [self addSubview:titlesScroll];
    
    
    if (_moreButton_width != 0) {
        _moreButton = [[UIView alloc] init];
        _moreButton.frame = CGRectMake(CGRectGetMaxX(titlesScroll.frame), 0, _moreButton_width, titlesScroll.height);
        [self addSubview:_moreButton];
    }
    
    if (_bottomLineHeight) {
        bottomLineView = [self bottomLineView];
        [self addSubview:bottomLineView];
    }
    
    switch (_headStyle) {
        case SegmentHeadStyleLine:
        {
            lineView = [self lineView];
            [titlesScroll addSubview:lineView];
            
        }
            break;
        case SegmentHeadStyleArrow:
        {
            _lineHeight = arrow_H;
            _lineScale = 1;
            lineView = [self lineView];
            lineView.backgroundColor = [UIColor clearColor];
            [titlesScroll addSubview:lineView];
            //arrow
            [self drawArrowLayer];
            arrow_layer.position = CGPointMake(lineView.width/2, lineView.height/2);
            [lineView.layer addSublayer:arrow_layer];
        }
            break;
        case SegmentHeadStyleSlide:
        {
            slideView = [self slideView];
            [titlesScroll addSubview:slideView];
        }
            break;
        default:
            break;
    }
    
}



#pragma mark - drow arrow
- (void)drawArrowLayer {
    arrow_layer = [[CAShapeLayer alloc] init];
    arrow_layer.bounds = CGRectMake(0, 0, arrow_W, arrow_H);
    [arrow_layer setFillColor:_arrowColor.CGColor];
    UIBezierPath *arrowPath = [UIBezierPath bezierPath];
    [arrowPath moveToPoint:CGPointMake(arrow_W/2, 0)];
    [arrowPath addLineToPoint:CGPointMake(arrow_W, arrow_H)];
    [arrowPath addLineToPoint:CGPointMake(0, arrow_H)];
    [arrowPath closePath];
    arrow_layer.path = arrowPath.CGPath;
}

#pragma mark - create customScroll
- (UIScrollView *)customScroll {
    if (!titlesArray) {
        return nil;
    }
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCROLL_WIDTH, SCROLL_HEIGHT)];
    scroll.contentSize = CGSizeMake(MAX(SCROLL_WIDTH, sum_width), SCROLL_HEIGHT);
    scroll.backgroundColor = _headColor;
    scroll.showsVerticalScrollIndicator = NO;
    scroll.showsHorizontalScrollIndicator  = NO;
    scroll.bounces = NO;
    return scroll;
}


#pragma mark - titlesScroll subviews - yes or slideScroll subviews - no
- (void)scrollViewSubviews:(UIScrollView*)scroll {
    BOOL titles = [scroll isEqual:titlesScroll];

    CGFloat start_x = 0;
    
    if (_layoutStyle == MLMSegmentLayoutCenter) {
        //计算布局的起点
        start_x = SCROLL_WIDTH/2;
        for (NSInteger i = 0; i < titleWidthArray.count/2; i ++) {
            start_x -= CURRENT_WIDTH(i);
        }
        if (titlesArray.count%2 != 0) {
            start_x -= CURRENT_WIDTH(titleWidthArray.count/2)/2;
        }
    }
    [self createBtn:titlesArray addScroll:scroll startX:start_x start_index:0];
    
    if (titles && _headStyle != SegmentHeadStyleSlide) {
        UIButton *curBtn = buttonArray[_showIndex];
        if (_fontScale != 1) {
            curBtn.titleLabel.font = [UIFont systemFontOfSize:_fontSize*_fontScale];
        }
        [curBtn setTintColor:_selectColor];
    }
}

#pragma mark - createBtn
- (void)createBtn:(NSArray *)titlesArr addScroll:(UIScrollView*)scroll startX:(CGFloat)start_x start_index:(NSInteger)start_index {
    BOOL titles = [scroll isEqual:titlesScroll];
    CGFloat width;
    for (NSInteger i = start_index; i < titlesArr.count; i ++) {
        width = CURRENT_WIDTH(i);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:titlesArr[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:_fontSize];
        button.frame = CGRectMake(start_x, 0, width, SCROLL_HEIGHT);
        start_x += width;
        if (titles) {
            [button setTintColor:_deSelectColor];
            [button addTarget:self action:@selector(selectedHeadTitles:) forControlEvents:UIControlEventTouchUpInside];
            [buttonArray addObject:button];
            
            //
            UIImageView *imgV = [[UIImageView alloc] initWithFrame:button.frame];
            [scroll addSubview:imgV];
            [backImgArray addObject:imgV];
            
        } else {
            [button setTintColor:_selectColor];
        }
        [scroll addSubview:button];
    }
    scroll.contentSize = CGSizeMake(MAX(SCROLL_WIDTH, sum_width), SCROLL_HEIGHT);
}


- (void)setBackImages:(NSArray *)backImages {
    _backImages = backImages;
    NSInteger count = MIN(backImages.count, backImgArray.count);
    for (NSInteger i = 0; i < count; i ++) {
        UIImageView *imageV = backImgArray[i];
        [imageV setImage:backImages[i]];
        if (i == currentIndex) {
            imageV.alpha = 1;
        } else {
            imageV.alpha = 0;
        }
    }
}


#pragma mark - create Line
- (UIView *)lineView {
    _lineScale = fabs(_lineScale)>1?1:fabs(_lineScale);
    
    CGFloat line_w = CURRENT_WIDTH(currentIndex);
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, SCROLL_HEIGHT-_lineHeight, line_w*_lineScale, _lineHeight)];
    UIButton *current_btn = buttonArray[currentIndex];
    line.center = CGPointMake(current_btn.center.x, line.center.y);
    line.backgroundColor = _lineColor;
    return line;
}

#pragma mark - bottom Line
- (UIView *)bottomLineView {
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, SCROLL_HEIGHT, self.width, _bottomLineHeight)];
    line.backgroundColor = _bottomLineColor;
    return line;
}

#pragma mark - create slide
- (UIView *)slideView {
    CGFloat slide_w = CURRENT_WIDTH(currentIndex);

    UIView *slide = [[UIView alloc] initWithFrame:CGRectMake(0, (SCROLL_HEIGHT-_slideHeight)/2, slide_w*_slideScale, _slideHeight)];

    UIButton *current_btn = buttonArray[currentIndex];
    slide.center = CGPointMake(current_btn.center.x, slide.center.y);
    slide.clipsToBounds = YES;
    slide.layer.cornerRadius = MIN(_slideCorner, _slideHeight/2);
    slide.backgroundColor = _slideColor;
    slideScroll = [self customScroll];
    [self scrollViewSubviews:slideScroll];
    slideScroll.userInteractionEnabled = NO;
    slideScroll.backgroundColor = [UIColor clearColor];
    CGRect convertRect = [slide convertRect:titlesScroll.frame fromView:titlesScroll.superview];
    slideScroll.frame = CGRectMake(convertRect.origin.x, -(SCROLL_HEIGHT - _slideHeight)/2, SCROLL_WIDTH, SCROLL_HEIGHT);
    [slide addSubview:slideScroll];
    return slide;
}

#pragma mark - button Action
- (void)selectedHeadTitles:(UIButton *)button {
    NSInteger selectIndex = [buttonArray indexOfObject:button];
    [self changeIndex:selectIndex completion:YES];

}

#pragma mark - 点击结束
- (void)animationEnd {
    isSelected = NO;
}

#pragma mark - set index
- (void)setSelectIndex:(NSInteger)index {
//    if (index == currentIndex) {
//        return;
//    }
//    //before
//    NSInteger before = currentIndex;
//    currentIndex = index;
//    [self changeContentOffset];
//    //select
//    [UIView animateWithDuration:animation_time animations:^{
//        [self changeBtnFrom:before to:currentIndex];
//    } completion:^(BOOL finished) {
//    }];
//    isSelected = YES;
//    if ([self.delegate respondsToSelector:@selector(didSelectedIndex:)]) {
//        [self.delegate didSelectedIndex:currentIndex];
//    } else if (self.selectedIndex) {
//        self.selectedIndex(currentIndex);
//    }
    
    [self changeIndex:index completion:NO];
}

- (void)changeIndex:(NSInteger)index completion:(BOOL)completion {
    if (index == currentIndex) {
        return;
    }
    //before
    NSInteger before = currentIndex;
    currentIndex = index;
    [self changeContentOffset];
    //select
    [UIView animateWithDuration:animation_time animations:^{
        [self changeBtnFrom:before to:currentIndex];
    } completion:^(BOOL finished) {
    }];
    isSelected = YES;
    
    if (completion) {
        if ([self.delegate respondsToSelector:@selector(didSelectedIndex:)]) {
            [self.delegate didSelectedIndex:currentIndex];
        } else if (self.selectedIndex) {
            self.selectedIndex(currentIndex);
        }
    }

}


- (void)changeContentOffset {
    if (sum_width > SCROLL_WIDTH) {
        UIButton *currentBtn = buttonArray[currentIndex];
        if (currentBtn.center.x<SCROLL_WIDTH/2) {
            [titlesScroll setContentOffset:CGPointMake(0, 0) animated:YES];
        } else if (currentBtn.center.x > (sum_width-SCROLL_WIDTH/2)) {
            [titlesScroll setContentOffset:CGPointMake(sum_width-SCROLL_WIDTH, 0) animated:YES];
        } else {
            [titlesScroll setContentOffset:CGPointMake(currentBtn.center.x - SCROLL_WIDTH/2, 0) animated:YES];
        }
    }
}

- (void)changeBtnFrom:(NSInteger)from to:(NSInteger)to {
    UIButton *before_btn = buttonArray[from];
    UIButton *select_btn = buttonArray[to];
    if (_headStyle != SegmentHeadStyleSlide) {
        [before_btn setTintColor:_deSelectColor];
        [select_btn setTintColor:_selectColor];
    }
    
    if (_fontScale) {
        before_btn.titleLabel.font = [UIFont systemFontOfSize:_fontSize];
        select_btn.titleLabel.font = [UIFont systemFontOfSize:_fontSize*_fontScale];
    }
    
    if (lineView) {
        lineView.width = select_btn.width*_lineScale;
        lineView.center = CGPointMake(select_btn.center.x, lineView.center.y);
    }
    
    if (arrow_layer) {
        arrow_layer.position = CGPointMake(lineView.width/2, lineView.height/2);
    }
    
    if (slideView) {
        //slide位置变化
        slideView.width = select_btn.width*_slideScale;
        slideView.center = CGPointMake(select_btn.center.x, slideView.center.y);
        //偏移
        CGRect convertRect = [slideView convertRect:titlesScroll.frame fromView:titlesScroll];
        slideScroll.frame = CGRectMake(convertRect.origin.x, convertRect.origin.y, slideScroll.contentSize.width, slideScroll.contentSize.height);
    }
    
    if (_hadBackImg) {
        UIImageView *before_img = backImgArray[from];
        UIImageView *select_img = backImgArray[to];
        
        before_img.alpha = 0;
        select_img.alpha = 1;
    }
}

#pragma mark - animation
//外部关联的scrollView变化
- (void)changePointScale:(CGFloat)scale {
    if (isSelected) {
        return;
    }
    if (scale<0) {
        return;
    }
    //区分向左 还是向右
    BOOL left = endScale > scale;
    endScale = scale;
    
    //1.将scale变为对应titleScroll的titleScale
    //每个view所占的百分比
    CGFloat per_view = 1.0/(CGFloat)titlesArray.count;
    //下标
    NSInteger changeIndex = scale/per_view + (left?1:0);
    NSInteger nextIndex = changeIndex + (left?-1:1);
    //超出范围
    if (nextIndex >= titlesArray.count || changeIndex >= titlesArray.count) {
        return;
    }
    //currentbtn
    UIButton *currentBtn = buttonArray[changeIndex];
    UIButton *nextBtn = buttonArray[nextIndex];
    //startscla
    CGFloat start_scale = 0;
    for (NSInteger i = 0; i < nextIndex; i++) {
        start_scale += CURRENT_WIDTH(i)/sum_width;
    }
    //滑动选中位置所占的相对百分比
    CGFloat current_title_Scale = CURRENT_WIDTH(changeIndex)/sum_width;
    //单个view偏移的百分比
    CGFloat single_offset_scale = (scale - per_view*changeIndex)/per_view;
    //转换成对应title的百分比
    CGFloat titleScale = single_offset_scale * current_title_Scale + start_scale;
    //变化的百分比
    CGFloat change_scale = (left?-1:1)*(titleScale - start_scale)/current_title_Scale;
    

    switch (_headStyle) {
        case SegmentHeadStyleDefault:
        case SegmentHeadStyleLine:
        case SegmentHeadStyleArrow:
        {
            if (lineView) {
                //lineView位置变化
                lineView.width = [self widthChangeCurWidth:CURRENT_WIDTH(changeIndex) nextWidth:CURRENT_WIDTH(nextIndex) changeScale:change_scale endScale:_lineScale];
                CGFloat center_x = [self centerChanegCurBtn:currentBtn nextBtn:nextBtn changeScale:change_scale];
                lineView.center = CGPointMake(center_x, lineView.center.y);
            }
            if (arrow_layer) {
                arrow_layer.position = CGPointMake(lineView.width/2, lineView.height/2);
            }
            //颜色变化
            [self colorChangeCurBtn:currentBtn nextBtn:nextBtn changeScale:change_scale];
            //字体大小变化
            [self fontChangeCurBtn:currentBtn nextBtn:nextBtn changeScale:change_scale];
            //背景图片
            if (_hadBackImg) {
                UIImageView *current_img = backImgArray[changeIndex];
                UIImageView *next_img = backImgArray[nextIndex];
                [self backImgCurImg:current_img nextImg:next_img changeScale:change_scale];
            }
        }
            break;
        case SegmentHeadStyleSlide:
        {
            //slide位置变化
            slideView.width = [self widthChangeCurWidth:CURRENT_WIDTH(changeIndex) nextWidth:CURRENT_WIDTH(nextIndex) changeScale:change_scale endScale:_slideScale];
            CGFloat center_x = [self centerChanegCurBtn:currentBtn nextBtn:nextBtn changeScale:change_scale];
            slideView.center = CGPointMake(center_x, slideView.center.y);
            //偏移
            CGRect convertRect = [slideView convertRect:titlesScroll.frame fromView:titlesScroll];
            slideScroll.frame = CGRectMake(convertRect.origin.x, convertRect.origin.y, slideScroll.contentSize.width, slideScroll.contentSize.height);
        }
            break;
        default:
            break;
    }
}


#pragma mark - 长度变化
- (CGFloat)widthChangeCurWidth:(CGFloat)curWidth nextWidth:(CGFloat)nextWidth changeScale:(CGFloat)changeScale endScale:(CGFloat)endscale{
    //改变的宽度
    CGFloat change_width = curWidth - nextWidth;
    //宽度变化
    CGFloat width = curWidth*endscale - changeScale * change_width;
    return width;
}

#pragma mark - 中心位置的变化
- (CGFloat)centerChanegCurBtn:(UIButton *)curBtn nextBtn:(UIButton *)nextBtn changeScale:(CGFloat)changeScale {
    //lineView改变的中心
    CGFloat change_center = nextBtn.center.x - curBtn.center.x;
    //lineView位置变化
    CGFloat center_x = curBtn.center.x + changeScale * change_center;
    return center_x;
}

#pragma mark - 字体大小变化
- (void)fontChangeCurBtn:(UIButton *)curBtn nextBtn:(UIButton *)nextBtn changeScale:(CGFloat)changeScale{
    //button字体改变的大小
    CGFloat btn_font_change = _fontSize*(_fontScale - 1);
    //大小变化
    CGFloat next_font = _fontSize + changeScale*btn_font_change;
    CGFloat cur_font = _fontSize*_fontScale - changeScale*btn_font_change;
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:next_font];
    curBtn.titleLabel.font = [UIFont systemFontOfSize:cur_font];
}

#pragma mark - 颜色变化
- (void)colorChangeCurBtn:(UIButton *)curBtn nextBtn:(UIButton *)nextBtn changeScale:(CGFloat)changeScale {
    //button选中颜色
    CGFloat sel_red;
    CGFloat sel_green;
    CGFloat sel_blue;
    CGFloat sel_alpha;
    //button未选中的颜色
    CGFloat de_sel_red;
    CGFloat de_sel_green;
    CGFloat de_sel_blue;
    CGFloat de_sel_alpha;
    
    if ([_selectColor getRed:&sel_red green:&sel_green blue:&sel_blue alpha:&sel_alpha] && [_deSelectColor getRed:&de_sel_red green:&de_sel_green blue:&de_sel_blue alpha:&de_sel_alpha]) {
        //颜色的变化的大小
        CGFloat red_changge = sel_red - de_sel_red;
        CGFloat green_changge = sel_green - de_sel_green;
        CGFloat blue_changge = sel_blue - de_sel_blue;
        CGFloat alpha_changge = sel_alpha - de_sel_alpha;
        //颜色变化
        [nextBtn setTintColor:[UIColor colorWithRed:de_sel_red + red_changge*changeScale
                                               green:de_sel_green + green_changge*changeScale
                                                blue:de_sel_blue + blue_changge*changeScale
                                               alpha:de_sel_alpha + alpha_changge*changeScale]];

        [curBtn setTintColor:[UIColor colorWithRed:sel_red - red_changge*changeScale
                                              green:sel_green - green_changge*changeScale
                                               blue:sel_blue - blue_changge*changeScale
                                              alpha:sel_alpha - alpha_changge*changeScale]];
    }
}

#pragma mark - 背景图渐变
- (void)backImgCurImg:(UIImageView *)curback nextImg:(UIImageView *)nextback changeScale:(CGFloat)changeScale {

    //alpha变化
    CGFloat next_alpha = changeScale;
    CGFloat cur_alpha = 1 - changeScale;
    
    nextback.alpha = next_alpha>.8?1.:next_alpha;
    curback.alpha = cur_alpha<.2?0:cur_alpha;

}


#pragma mark - get sumWidth
- (CGFloat)getSumWidth {
    return sum_width;
}

#pragma mark - lineView
- (UIView *)getLineView {
    return lineView;
}

- (UIView *)getBottomLineView {
    return bottomLineView;
}
- (UIView *)getScrollLineView {
    if (_headStyle == SegmentHeadStyleLine) {
        return lineView;
    } else {
        return nil;
    }
}


#pragma mark - dealloc
- (void)dealloc {
    arrow_layer.delegate = nil;
    [arrow_layer removeFromSuperlayer];
    arrow_layer = nil;
}

- (UIScrollView *)titlesScroll {
    return titlesScroll;
}

- (NSArray *)buttons {
    return buttonArray;
}

@end
