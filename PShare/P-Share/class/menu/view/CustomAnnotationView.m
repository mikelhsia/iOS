//
//  CustomAnnotationView.m
//  P-Share
//
//  Created by 杨继垒 on 15/9/28.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import "CustomAnnotationView.h"
#import "MyPointAnnotation.h"
#import "CustomNoParkView.h"

@interface CustomAnnotationView ()
{
    CustomNoParkView *_noParkView;
}
@property (nonatomic, strong, readwrite) CustomCalloutView *calloutView;

@end

@implementation CustomAnnotationView

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _parkStateLabel = [MyUtil createLabelFrame:CGRectMake(6, 9, 30, 20) title:@"999" textColor:MAIN_COLOR font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentCenter numberOfLine:1];
        
        [self addSubview:_parkStateLabel];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }
    MyPointAnnotation *annotation = (MyPointAnnotation *)self.annotation;
    if ([annotation.subtitle isEqualToString:@"1"]) {
        //待入场
        if (selected) {
            if (_noParkView == nil) {
                _noParkView = [[CustomNoParkView alloc] initWithFrame:CGRectMake(0, 0, 130, 40)];
                _noParkView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,-CGRectGetHeight(_noParkView.bounds) / 2.f + self.calloutOffset.y);
            }
            [self addSubview:_noParkView];
        }else{
            [_noParkView removeFromSuperview];
        }
    }else{
        //入场
        if (selected)
        {
            if (self.calloutView == nil)
            {
                self.calloutView = [[CustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, 260, 80)];
                self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,-CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                btn.frame = CGRectMake(0, 0, 200, 80);
                [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
                [self.calloutView addSubview:btn];
                
                UIButton *navigationBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                navigationBtn.frame = CGRectMake(200, 0, 60, 80);
                [navigationBtn addTarget:self action:@selector(navigationBtnAction) forControlEvents:UIControlEventTouchUpInside];
                [self.calloutView addSubview:navigationBtn];
            }
            self.calloutView.myTitle = annotation.title;
            self.calloutView.parkState = annotation.parkState;
            
            int distance = [annotation.parkDistance intValue];
            if (distance < 1000) {
                self.calloutView.parkDistance = [NSString stringWithFormat:@"%d米",distance];
            }else{
                distance = distance/1000;
                self.calloutView.parkDistance = [NSString stringWithFormat:@"%d千米",distance];
            }
            self.calloutView.mySubtitle = annotation.subtitle;
            
            [self addSubview:self.calloutView];
        }
        else
        {
            [self.calloutView removeFromSuperview];
        }
    }
    
    [super setSelected:selected animated:animated];
}

- (void)btnAction
{
    if (self.myDelegate) {
        MyPointAnnotation *annotation = (MyPointAnnotation *)self.annotation;
        int parkID = [annotation.parkID intValue];
        
        [self.myDelegate myAnnotationTapWithIndex:parkID];
    }
}

- (void)navigationBtnAction
{
    if (self.myDelegate) {
        MyPointAnnotation *annotation = (MyPointAnnotation *)self.annotation;
        int parkID = [annotation.parkID intValue];
        
        [self.myDelegate myAnnotationTapForNavigationWithIndex:parkID];
    }
}

@end





