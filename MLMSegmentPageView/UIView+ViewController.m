//
//  UIView+ViewController.m
//  MLMSegmentPage
//
//  Created by MAC on 2017/5/18.
//  Copyright © 2017年 my. All rights reserved.
//

#import "UIView+ViewController.h"

@implementation UIView (ViewController)

- (UIViewController *)viewController {
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        } else if ([next isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)next;
            return nav.viewControllers.lastObject;
        }
        next = next.nextResponder;
    }while (next != nil);
    return nil;
}

@end
