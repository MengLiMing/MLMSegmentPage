//
//  UIView+EasyFrame.h
//  MLMSegmentPage
//
//  Created by my on 2017/2/4.
//  Copyright © 2017年 my. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (EasyFrame)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign, readonly) CGFloat bottomFromSuperView;
@end
