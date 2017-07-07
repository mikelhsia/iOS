//
//  CustomCalloutView.m
//  P-Share
//
//  Created by 杨继垒 on 15/9/28.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import "CustomCalloutView.h"

#define kArrorHeight        10
#define KWidth  self.bounds.size.width
#define KHeight self.bounds.size.height
@interface CustomCalloutView ()

@property (nonatomic, strong) UILabel *mySubtitleLabel;
@property (nonatomic, strong) UILabel *myTitleLabel;
//@property (nonatomic, strong) UILabel *parkStateLabel;
@property (nonatomic, strong) UILabel *parkDistanceLabel;

@end

@implementation CustomCalloutView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)drawRect:(CGRect)rect
{
    
    [self drawInContext:UIGraphicsGetCurrentContext()];
    
    self.layer.shadowColor = [[UIColor grayColor] CGColor];
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    
}

- (void)drawInContext:(CGContextRef)context
{
    
    CGContextSetLineWidth(context, 2.0);
//    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:255 green:255 blue:0255 alpha:0.8].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    
    [self getDrawPath:context];
    CGContextFillPath(context);
    
}

- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
    CGFloat radius = 6.0;
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    maxy = CGRectGetMaxY(rrect)-kArrorHeight;
    
    CGContextMoveToPoint(context, midx+kArrorHeight, maxy);
    CGContextAddLineToPoint(context,midx, maxy+kArrorHeight);
    CGContextAddLineToPoint(context,midx-kArrorHeight, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    self.myTitleLabel = [MyUtil createLabelFrame:CGRectMake(10, 15, KWidth-90, 20) title:@"恒积大厦" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:18] textAlignment:NSTextAlignmentLeft numberOfLine:1];
    [self addSubview:self.myTitleLabel];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(KWidth-70, 5, 1, KHeight-20)];
    lineView1.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineView1];
    
    self.mySubtitleLabel = [MyUtil createLabelFrame:CGRectMake(10, 45, (KWidth-70)/2-10, 15) title:@"剩余车位:999" textColor:[MyUtil colorWithHexString:@"035aa4"] font:[UIFont systemFontOfSize:13] textAlignment:NSTextAlignmentLeft numberOfLine:1];
    [self addSubview:self.mySubtitleLabel];
    
//    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake((KWidth-70)/2, 45, 1, 15)];
//    lineView2.backgroundColor = [UIColor lightGrayColor];
//    [self addSubview:lineView2];
    
    self.parkDistanceLabel = [MyUtil createLabelFrame:CGRectMake((KWidth-70)-35-10, 45, 35, 15) title:@"可代泊" textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:10] textAlignment:NSTextAlignmentCenter numberOfLine:1];
    self.parkDistanceLabel.backgroundColor = [MyUtil colorWithHexString:@"fac000"];
    [self addSubview:self.parkDistanceLabel];
    
//    self.parkStateLabel = [MyUtil createLabelFrame:CGRectMake(KWidth-85, 5+3, 45, 15) title:@"99" textColor:[UIColor grayColor] font:[UIFont systemFontOfSize:13] textAlignment:NSTextAlignmentLeft numberOfLine:1];
//    [self addSubview:self.parkStateLabel];
    UIImageView *rightImageView = [MyUtil createImageViewFrame:CGRectMake(KWidth-45, 15, 20, 20) imageName:@"mapNavigationImage"];
    [self addSubview:rightImageView];
    
    UILabel *navigationLabel = [MyUtil createLabelFrame:CGRectMake(KWidth-60, 40, 50, 20) title:@"导航" textColor:[MyUtil colorWithHexString:@"035aa4"] font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentCenter numberOfLine:1];
    [self addSubview:navigationLabel];
}

- (void)setMySubtitle:(NSString *)mySubtitle
{
    
}

- (void)setMyTitle:(NSString *)myTitle
{
    self.myTitleLabel.text = myTitle;
}

- (void)setParkDistance:(NSString *)parkDistance
{
    self.mySubtitleLabel.text = [NSString stringWithFormat:@"距离:%@",parkDistance];
}

- (void)setParkState:(NSString *)parkState
{
    //是否可代泊
    if ([parkState isEqualToString:@"2"]) {
        self.parkDistanceLabel.hidden = NO;
    }else{
        self.parkDistanceLabel.hidden = YES;
    }
}


@end








