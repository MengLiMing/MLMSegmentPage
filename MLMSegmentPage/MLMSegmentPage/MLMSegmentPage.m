//
//  MLMSegmentPage.m
//  MLMSegmentPage
//
//  Created by my on 16/11/4.
//  Copyright © 2016年 my. All rights reserved.
//

#import "MLMSegmentPage.h"

@interface MLMSegmentPage () <NSCacheDelegate,MLMSegmentHeadDelegate,UIScrollViewDelegate>
{
    NSArray *titlesArray;
    NSArray *viewsArray;
    
    NSInteger currentIndex;
}
@property (nonatomic, strong) NSCache *viewsCache;//存储页面(使用计数功能)
@property (nonatomic, strong) MLMSegmentHead *headView;
@property (nonatomic, strong) UIScrollView *viewsScroll;

@end

@implementation MLMSegmentPage

#pragma mark - init
- (instancetype)initSegmentWithFrame:(CGRect)frame
                         titlesArray:(NSArray *)titles
                           vcOrviews:(NSArray *)views {
    if (self = [super initWithFrame:frame]) {
        titlesArray = [titles copy];
        viewsArray = [views copy];
        [self defaultSet];
    }
    return self;
}

#pragma mark - 默认
- (void)defaultSet {
    _countLimit = titlesArray.count;

    _headStyle = SegmentHeadStyleLine;

    _headHeight = 50;
    currentIndex = 0;
    
    _headColor = [UIColor whiteColor];
    _selectColor = [UIColor blackColor];
    _deselectColor = [UIColor lightGrayColor];
    
    _showIndex = 0;
    
    _fontSize = 13;
    _fontScale = 1;
    
    _lineHeight = 2.5;
    _lineScale = 1;
    
    
    _slideHeight = _headHeight*.8;
    _slideColor = _deselectColor;
    _slideCorner = _slideHeight/2;
    _slideScale = 1;
    _maxTitleNum = 5;
    
    _bottomLineColor = [UIColor grayColor];
    _bottomLineHeight = 1;
    
}

#pragma mark - viewsCache
- (NSCache *)viewsCache {
    if (!_viewsCache) {
        _viewsCache = [[NSCache alloc] init];
        _viewsCache.countLimit = _countLimit;
        _viewsCache.delegate = self;
    }
    return _viewsCache;
}

#pragma mark - headView
- (MLMSegmentHead *)headView {
    if (!_headView) {
        _headView = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, _headHeight) titles:titlesArray headStyle:_headStyle];
        _headView.delegate = self;
    }
    return _headView;
}


#pragma mark - layoutsubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    if (_headStyle == SegmentHeadStyleLine) {
        _lineColor = _selectColor;
    }
    
    if (_headStyle == SegmentHeadStyleArrow) {
        _arrowColor = _selectColor;
    }
    
    if (_headStyle == SegmentHeadStyleSlide) {
        _slideColor = _deselectColor;
    }
    
    
    [self createView];
}


#pragma mark - createView
- (void)createView {
    _countLimit = MAX(1, MIN(_countLimit, titlesArray.count));
    
    self.headView.headStyle = _headStyle;
    _headView.headColor = _headColor;
    _headView.selectColor = _selectColor;
    _headView.deSelectColor = _deselectColor;
    _headView.fontSize = _fontSize;
    _headView.fontScale = _fontScale;
    _headView.showIndex = MIN(titlesArray.count-1, MAX(0, _showIndex));
    
    currentIndex = _headView.showIndex;
    
    _headView.lineColor = _lineColor;
    _headView.lineHeight = _lineHeight;
    _headView.lineScale = _lineScale;
    
    _headView.arrowColor = _arrowColor;
    
    _headView.slideColor = _slideColor;
    _headView.slideHeight = _slideHeight;
    _headView.slideCorner = _slideCorner;
    _headView.slideScale = _slideScale;
    
    _headView.maxTitles = _maxTitleNum;
    
    _headView.bottomLineHeight = _bottomLineHeight;
    _headView.bottomLineColor = _bottomLineColor;
    
    [self addSubview:_headView];
    [self createViewsScroll];
    
    
    [self defaultViewCache];

}


#pragma mark - create_scroll
- (void)createViewsScroll {
    _viewsScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _headHeight, self.frame.size.width, self.frame.size.height - _headHeight)];
    _viewsScroll.showsVerticalScrollIndicator = NO;
    _viewsScroll.showsHorizontalScrollIndicator = NO;
    _viewsScroll.bounces = NO;
    _viewsScroll.delegate = self;
    _viewsScroll.pagingEnabled = YES;
    [_viewsScroll setContentOffset:CGPointMake(_showIndex * self.frame.size.width, 0)];
    [_viewsScroll setContentSize:CGSizeMake(titlesArray.count *_viewsScroll.frame.size.width, _viewsScroll.frame.size.height)];
    [self addSubview:_viewsScroll];
}



- (void)defaultViewCache {
    if (_loadAll) {
        NSInteger startIndex;
        if (viewsArray.count-_showIndex > _countLimit) {
            startIndex = _showIndex;
        } else {
            startIndex = _showIndex - (_countLimit - (viewsArray.count-_showIndex));
        }
        for (NSInteger i = startIndex; i < startIndex + _countLimit; i ++) {
            [self addViewCacheIndex:i];
        }
    } else {
        [self addViewCacheIndex:_showIndex];
    }

}

#pragma mark - createByVC
- (void)addViewCacheIndex:(NSInteger)index {
    id object = viewsArray[index];
    if ([object isKindOfClass:[NSString class]]) {
        Class class = NSClassFromString(object);
        if ([class isSubclassOfClass:[UIViewController class]]) {//vc
            UIViewController *vc = [class new];
            [self addVC:vc atIndex:index];
        } else if ([class isSubclassOfClass:[UIView class]]){//view
            UIView *view = [class new];
            [self addView:view atIndex:index];
        } else {
            NSLog(@"please enter the correct name of class!");
        }
    } else {
        if ([object isKindOfClass:[UIViewController class]]) {
            [self addVC:object atIndex:index];
        } else if ([object isKindOfClass:[UIView class]]) {
            [self addView:object atIndex:index];
        } else {
            NSLog(@"this class was not found!");
        }
    }

}

#pragma mark - addvc
- (void)addVC:(UIViewController *)vc atIndex:(NSInteger)index {
    NSLog(@"add - %@",@(index));
    [self.viewsCache setObject:vc forKey:@(index)];

    vc.view.frame = CGRectMake(index*_viewsScroll.frame.size.width, 0, _viewsScroll.frame.size.width, _viewsScroll.frame.size.height);
    [self.viewController addChildViewController:vc];
    [_viewsScroll addSubview:vc.view];
    

}

#pragma mark - addview
- (void)addView:(UIView *)view atIndex:(NSInteger)index {
    [self.viewsCache setObject:view forKey:@(index)];
    
    view.frame = CGRectMake(index*_viewsScroll.frame.size.width, 0, _viewsScroll.frame.size.width, _viewsScroll.frame.size.height);
    [_viewsScroll addSubview:view];
}



#pragma mark - scrolldelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:_viewsScroll]) {
        CGFloat scale = scrollView.contentOffset.x/scrollView.contentSize.width;
        [_headView changePointScale:scale];
        NSInteger curIndex = [@((scale+(1/(CGFloat)titlesArray.count)/2)*titlesArray.count) integerValue];
        if ([self.delegate respondsToSelector:@selector(scrollThroughIndex:)]) {
            [self.delegate scrollThroughIndex:curIndex];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isEqual:_viewsScroll]) {
        //滑动结束
        currentIndex = scrollView.contentOffset.x/scrollView.frame.size.width;
        [_headView setSelectIndex:currentIndex];
        if (![_viewsCache objectForKey:@(currentIndex)]) {
            [self addViewCacheIndex:currentIndex];
        }
        if ([self.delegate respondsToSelector:@selector(selectedIndex:)]) {
            [self.delegate selectedIndex:currentIndex];
        }
    }

}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if ([scrollView isEqual:_viewsScroll]) {
        //动画结束
        currentIndex = scrollView.contentOffset.x/scrollView.frame.size.width;
        [_headView setSelectIndex:currentIndex];
        if (![_viewsCache objectForKey:@(currentIndex)]) {
            [self addViewCacheIndex:currentIndex];
        }
    }
}


#pragma mark - SegmentHeadViewDelegate
- (void)didSelectedIndex:(NSInteger)index {
    [_viewsScroll setContentOffset:CGPointMake(index*self.frame.size.width, 0) animated:YES];
    if ([self.delegate respondsToSelector:@selector(selectedIndex:)]) {
        [self.delegate selectedIndex:index];
    }
    
}

#pragma mark - NSCacheDelegate
-(void)cache:(NSCache *)cache willEvictObject:(id)obj {
    NSLog(@"remove - %@",NSStringFromClass([obj class]));
    if ([obj isKindOfClass:[UIViewController class]]) {
        UIViewController *vc = obj;
        [vc.view removeFromSuperview];
        vc.view = nil;
        [vc removeFromParentViewController];
    } else {
        UIView *vw = obj;
        [vw removeFromSuperview];
        vw = nil;
    }
}

#pragma mark - dealloc
- (void)dealloc {
    _viewsCache.delegate = nil;
    _viewsCache = nil;
}

@end
