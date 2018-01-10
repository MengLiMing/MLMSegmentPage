//
//  MLMSegmentScroll.m
//  MLMSegmentPage
//
//  Created by my on 2017/2/6.
//  Copyright © 2017年 my. All rights reserved.
//

#import "MLMSegmentScroll.h"
#import "SegmentPageHead.h"

@interface MLMSegmentScroll () <NSCacheDelegate,UIScrollViewDelegate>
{
    CGFloat start_offset_x;
}
@property (nonatomic, strong) NSCache *viewsCache;//存储页面(使用计数功能)
@property (nonatomic, strong) NSMutableArray *viewsArray;

@end

@implementation MLMSegmentScroll

#pragma mark - init Method
- (instancetype)initWithFrame:(CGRect)frame vcOrViews:(NSArray *)sources {
    if (self = [super initWithFrame:frame]) {
        _viewsArray = [sources mutableCopy];
        [self defaultSet];
    }
    return self;
}

#pragma mark - default setting
- (void)defaultSet {
    WEAK(weakSelf, self)
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.bounces = NO;
    self.delegate = weakSelf;
    [self setContentSize:CGSizeMake(_viewsArray.count *self.width, self.height)];
    
    _countLimit = _viewsArray.count;
}

#pragma mark - viewsCache
- (NSCache *)viewsCache {
    if (!_viewsCache) {
        WEAK(weakSelf, self)
        _viewsCache = [[NSCache alloc] init];
        _viewsCache.countLimit = _countLimit;
        _viewsCache.delegate = weakSelf;
        _viewsCache.evictsObjectsWithDiscardedContent = YES;
    }
    return _viewsCache;
}


#pragma mark - default add View 
- (void)createView {
    _showIndex = MIN(_viewsArray.count-1, MAX(0, _showIndex));
    [self setContentOffset:CGPointMake(_showIndex * self.frame.size.width, 0)];
    
    if (_loadAll) {
        NSInteger startIndex;
        if (_viewsArray.count-_showIndex > _countLimit) {
            startIndex = _showIndex;
        } else {
            startIndex = _viewsArray.count - _countLimit;
        }
        for (NSInteger i = startIndex; i < startIndex + _countLimit; i ++) {
            [self addViewCacheIndex:i];
        }
    } else {
        [self setContentOffset:CGPointMake(_showIndex*self.width, 0) animated:NO];
    }
}

#pragma mark - changeSource
- (void)changeSource:(NSArray *)sources {
    _viewsArray = [sources mutableCopy];
    _countLimit = MIN(_countLimit, _viewsArray.count);
    
    self.viewsCache.countLimit = _countLimit;
    [self.viewsCache removeAllObjects];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self createView];
}



//- (void)addVcOrViews:(NSArray *)sources {
//    NSInteger startIndex = _viewsArray.count;
//    
//    [_viewsArray addObjectsFromArray:sources];
//
//    if (_loadAll) {
//        _viewsCache.countLimit = _viewsArray.count;
//        for (NSInteger i = startIndex; i < _viewsArray.count; i ++) {
//            [self addViewCacheIndex:i];
//        }
//    }
//    [self setContentSize:CGSizeMake(_viewsArray.count *self.width, self.height)];
//}


#pragma mark - addView
- (void)addViewCacheIndex:(NSInteger)index {
    id object = _viewsArray[index];
    if ([object isKindOfClass:[NSString class]]) {
        Class class = NSClassFromString(object);
        if ([class isSubclassOfClass:[UIViewController class]]) {//vc
            UIViewController *vc = [class new];
            if (self.initSource) {
                self.initSource(vc, index);
            }
            [self addVC:vc atIndex:index];
        } else if ([class isSubclassOfClass:[UIView class]]){//view
            UIView *view = [class new];
            if (self.initSource) {
                self.initSource(view, index);
            }
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
    if (![self.viewsCache objectForKey:@(index)]) {
        [self.viewsCache setObject:vc forKey:@(index)];
    }
    
    vc.view.frame = CGRectMake(index*self.width, 0, self.width, self.height);
    [self.viewController addChildViewController:vc];
    [self addSubview:vc.view];
}

#pragma mark - addview
- (void)addView:(UIView *)view atIndex:(NSInteger)index {
    if (![self.viewsCache objectForKey:@(index)]) {
        [self.viewsCache setObject:view forKey:@(index)];
    }
    view.frame = CGRectMake(index*self.width, 0, self.width, self.height);
    [self addSubview:view];
}


- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated {
    [super setContentOffset:contentOffset animated:animated];
    NSInteger currentIndex = contentOffset.x/self.frame.size.width;
    if (!animated) {
        if ([self.segDelegate respondsToSelector:@selector(animationEndIndex:)]) {
            [self.segDelegate animationEndIndex:currentIndex];
        } else if (self.animationEnd) {
            self.animationEnd(currentIndex);
        }
    }
    if (![_viewsCache objectForKey:@(currentIndex)]) {
        [self addViewCacheIndex:currentIndex];
    }
}

#pragma mark - scrollDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    start_offset_x = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scale = self.contentOffset.x/self.contentSize.width;
    if ([self.segDelegate respondsToSelector:@selector(scrollOffsetScale:)]) {
        [self.segDelegate scrollOffsetScale:scale];
    } else if (self.offsetScale) {
        self.offsetScale(scale);
    }
    
    if (_addTiming == SegmentAddScale) {
        NSInteger currentIndex = self.contentOffset.x/self.frame.size.width;
        BOOL left = start_offset_x>=self.contentOffset.x;
        NSInteger next_index = MAX(MIN(_viewsArray.count-1, left?currentIndex:currentIndex+1), 0);
        if (fabs(scale*_viewsArray.count-next_index)<(1-_addScale)) {
            if (![_viewsCache objectForKey:@(next_index)]) {
                [self addViewCacheIndex:next_index];
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //滑动结束
    NSInteger currentIndex = self.contentOffset.x/self.frame.size.width;
    if ([self.segDelegate respondsToSelector:@selector(scrollEndIndex:)]) {
        [self.segDelegate scrollEndIndex:currentIndex];
    } else if (self.scrollEnd) {
        self.scrollEnd(currentIndex);
    }
    
    CGFloat scale = self.contentOffset.x/self.contentSize.width;
    if ([self.segDelegate respondsToSelector:@selector(scrollOffsetScale:)]) {
        [self.segDelegate scrollOffsetScale:scale];
    } else if (self.offsetScale) {
        self.offsetScale(scale);
    }
    
    if (_addTiming == SegmentAddNormal) {
        if (![_viewsCache objectForKey:@(currentIndex)]) {
            [self addViewCacheIndex:currentIndex];
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    //动画结束
    NSInteger currentIndex = self.contentOffset.x/self.frame.size.width;
    if ([self.segDelegate respondsToSelector:@selector(animationEndIndex:)]) {
        [self.segDelegate animationEndIndex:currentIndex];
    } else if (self.animationEnd) {
        self.animationEnd(currentIndex);
    }
}

#pragma mark - NSCacheDelegate
-(void)cache:(NSCache *)cache willEvictObject:(id)obj {
    //进入后台不清理
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        return;
    }
    if (self.subviews.count > self.countLimit) {
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
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (self.contentOffset.x <= 0) {
        if ([otherGestureRecognizer.delegate isKindOfClass:NSClassFromString(@"_FDFullscreenPopGestureRecognizerDelegate")]) {
            return YES;
        }
    }
    return NO;
}

- (NSInteger)currentIndex {
    return self.contentOffset.x/self.frame.size.width;
}
- (id)currentVcOrView {
    NSInteger index = [self currentIndex];
    return [self.viewsCache objectForKey:@(index)];
}

#pragma mark - dealloc
- (void)dealloc {
    self.delegate = nil;
    [_viewsCache removeAllObjects];
    _viewsCache.delegate = nil;
    _viewsCache = nil;
}

@end
