//
//  CustomNoParkView.m
//  P-Share
//
//  Created by VinceLee on 15/12/1.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import "CustomNoParkView.h"

#define kArrorHeight        10
#define KWidth  self.bounds.size.width
#define KHeight self.bounds.size.height

@interface CustomNoParkView ()
{
    UILabel *_titleLabel;
}
@end

@implementation CustomNoParkView


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
    CGContextSetFillColorWithColor(context, [UIColor grayColor].CGColor);
    
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
    _titleLabel = [MyUtil createLabelFrame:CGRectMake(0, 0, KWidth, KHeight-10) title:@"开发中,敬请期待" textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:15] textAlignment:NSTextAlignmentCenter numberOfLine:1];
    
    [self addSubview:_titleLabel];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end




