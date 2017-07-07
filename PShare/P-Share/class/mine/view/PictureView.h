//
//  PictureView.h
//  P-Share
//
//  Created by VinceLee on 15/12/14.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PictureViewTapImageDelegate <NSObject>

- (void)pictureViewTapImageWithIndex:(NSInteger)index;

@end

@interface PictureView : UIView

@property (weak, nonatomic) IBOutlet UIScrollView *carPictureScrollView;
- (IBAction)lefiBtnClick:(id)sender;
- (IBAction)rightBtnClick:(id)sender;

@property (nonatomic,strong)NSArray *imageArray;
@property (nonatomic,weak)id<PictureViewTapImageDelegate> delegate;
- (void)configDataWithArray:(NSArray *)imageArray;

@end
