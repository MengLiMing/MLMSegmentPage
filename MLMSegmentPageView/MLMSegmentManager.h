//
//  MLMSegmentManager.h
//  MLMSegmentPage
//
//  Created by my on 2017/2/5.
//  Copyright © 2017年 my. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLMSegmentHead.h"
#import "MLMSegmentScroll.h"
#import "SegmentPageHead.h"


@interface MLMSegmentManager : NSObject

/**
 * 绑定两个view
 */
+ (void)associateHead:(MLMSegmentHead *)head
           withScroll:(MLMSegmentScroll *)scroll
           completion:(void(^)())completion;

+ (void)associateHead:(MLMSegmentHead *)head
           withScroll:(MLMSegmentScroll *)scroll
     contentChangeAni:(BOOL)ani
           completion:(void(^)())completion
            selectEnd:(void(^)(NSInteger index))selectEnd;


@end
