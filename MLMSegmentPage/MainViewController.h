//
//  MainViewController.h
//  MLMSegmentPage
//
//  Created by my on 16/11/4.
//  Copyright © 2016年 my. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLMSegmentManager.h"

@interface MainViewController : UIViewController

@property (nonatomic, assign) MLMSegmentHeadStyle style;
@property (nonatomic, assign) MLMSegmentLayoutStyle layout;

@end
