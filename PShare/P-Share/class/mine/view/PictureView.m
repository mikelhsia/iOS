//
//  PictureView.m
//  P-Share
//
//  Created by VinceLee on 15/12/14.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import "PictureView.h"
#import "UIImageView+WebCache.h"

@implementation PictureView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


//代码创建
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createImageView];
    }
    return self;
}
//xib创建
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self createImageView];
    }
    return self;
}

- (void)createImageView
{
    
}

- (void)configDataWithArray:(NSArray *)imageArray
{
    self.imageArray = [NSArray arrayWithArray:imageArray];
    
    self.carPictureScrollView.showsHorizontalScrollIndicator = NO;
    
    NSInteger imageWidth_H = ((SCREEN_WIDTH-45*2)-15*2)/3;
    NSInteger image_Y = (self.carPictureScrollView.frame.size.height - imageWidth_H)/2;
    
    for (int i=0; i<self.imageArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((imageWidth_H+15)*i, image_Y, imageWidth_H, imageWidth_H)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageArray[i]]];
        imageView.tag = i + 10;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageAction:)];
        [imageView addGestureRecognizer:tapGesture];
        [self.carPictureScrollView addSubview:imageView];
    }
    
    NSInteger content_W = self.imageArray.count * imageWidth_H + (self.imageArray.count-1)*15;
    self.carPictureScrollView.contentSize = CGSizeMake(content_W, self.carPictureScrollView.frame.size.height);
}

- (void)tapImageAction:(UITapGestureRecognizer *)sender
{
    if (self.delegate) {
        [self.delegate pictureViewTapImageWithIndex:sender.view.tag-10];
    }
}

- (IBAction)lefiBtnClick:(id)sender {
    NSInteger imageWidth_H = ((SCREEN_WIDTH-45*2)-15*2)/3;
    
    CGPoint pictureContentSet = self.carPictureScrollView.contentOffset;
    if (self.carPictureScrollView.contentOffset.x < imageWidth_H+15) {
        pictureContentSet.x = 0;
    }else{
        pictureContentSet.x -= imageWidth_H+15;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.carPictureScrollView.contentOffset = pictureContentSet;
    }];
}

- (IBAction)rightBtnClick:(id)sender {
    NSInteger imageWidth_H = ((SCREEN_WIDTH-45*2)-15*2)/3;
    
    CGPoint pictureContentSet = self.carPictureScrollView.contentOffset;
    if (self.imageArray.count >= 4) {
        if (self.carPictureScrollView.contentOffset.x > (imageWidth_H+15)*(self.imageArray.count-4)) {
            pictureContentSet.x = (imageWidth_H+15)*(self.imageArray.count-3);
        }else{
            pictureContentSet.x += imageWidth_H+15;
        }
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.carPictureScrollView.contentOffset = pictureContentSet;
    }];
}
@end





