//
//  TriangleView.m
//  CGPathExample
//
//  Created by Puppylpy on 2/25/16.
//  Copyright © 2016 Puppylpy. All rights reserved.
//

#import "TriangleView.h"

@implementation TriangleView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor grayColor] set];
    UIRectFill([self bounds]);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 75, 10);
    CGContextAddLineToPoint(context, 10, 150);
    CGContextAddLineToPoint(context, 160, 150);
    CGContextAddLineToPoint(context, 10, 75);
    CGContextClosePath(context);
    
    [[UIColor redColor] setFill];
    [[UIColor blackColor] setStroke];
    
    CGContextDrawPath(context, kCGPathFillStroke);
}

@end
