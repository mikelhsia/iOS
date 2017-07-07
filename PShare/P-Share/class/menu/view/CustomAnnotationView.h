//
//  CustomAnnotationView.h
//  P-Share
//
//  Created by 杨继垒 on 15/9/28.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "CustomCalloutView.h"

@protocol MyAnnotationViewTapDelegate <NSObject>

- (void)myAnnotationTapWithIndex:(int)index;

- (void)myAnnotationTapForNavigationWithIndex:(int)index;

@end


@interface CustomAnnotationView : MAAnnotationView

@property (nonatomic, readonly) CustomCalloutView *calloutView;

@property (nonatomic,strong) UILabel *parkStateLabel;

@property (nonatomic,weak) id<MyAnnotationViewTapDelegate> myDelegate;

@end





