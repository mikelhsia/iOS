//
//  HomeViewController.h
//  P-Share
//
//  Created by VinceLee on 15/11/18.
//  Copyright © 2015年 杨继垒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarqueeLabel.h"

@interface HomeViewController : UIViewController
//滚动图片


@property (nonatomic,strong)NSTimer *myTimer;

//存放图片名称的不可变数组
@property(nonatomic,strong)NSMutableArray *pictureArray;

//轮播图片的背景view
@property (weak, nonatomic) IBOutlet UIView *scrollVBgView;
//scrollView：展示轮播图片
@property (weak, nonatomic) IBOutlet UIScrollView *parkingScrollView;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *infoView;//消息View
@property (weak, nonatomic) IBOutlet MarqueeLabel *infoTitleLabel;//消息标题
@property (weak, nonatomic) IBOutlet UITextView *infoDetailTextView;//消息详情
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoHeightConstraint;//消息View高度
@property (weak, nonatomic) IBOutlet UIButton *closeInfoBtn;
@property (weak, nonatomic) IBOutlet UIImageView *downArrowImage;
@property (weak, nonatomic) IBOutlet UIImageView *upArrowImage;
@property (weak, nonatomic) IBOutlet UIView *infoClearView;

@property (weak, nonatomic) IBOutlet UIView *imageTopGrayView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *parkingImageConstraint;//车场照片View的高
@property (weak, nonatomic) IBOutlet UIImageView *editingImageView;//编辑图标
@property (weak, nonatomic) IBOutlet UIButton *editingBtn;//编辑按钮
@property (weak, nonatomic) IBOutlet UILabel *parkingNumLabel;//停车场 车位数
@property (weak, nonatomic) IBOutlet UIImageView *addImageView;//首次添加图标
@property (weak, nonatomic) IBOutlet UILabel *addParkingLabel;//添加停车场Label
@property (weak, nonatomic) IBOutlet UILabel *parkingNameLabel;//停车场名字
@property (weak, nonatomic) IBOutlet UIButton *addBtn;//添加按钮
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numLabelWidth;

@property (weak, nonatomic) IBOutlet UIView *nearByParkingView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nearbyViewConstraint;
@property (weak, nonatomic) IBOutlet UILabel *nearbyLabel;//附近的停车场
@property (weak, nonatomic) IBOutlet UILabel *addLabel;//请添加停车场
@property (weak, nonatomic) IBOutlet UIImageView *nearbyRightImage;//右指箭头
@property (weak, nonatomic) IBOutlet UIButton *nearbyOrAddBtn;//附近或添加的按钮
- (IBAction)nearbyOrAddBtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *parkingListView;
@property (weak, nonatomic) IBOutlet UIImageView *listParkingImage;
@property (weak, nonatomic) IBOutlet UILabel *listParkingTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *listParkingPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *listBoolParkingLabel;
@property (weak, nonatomic) IBOutlet UILabel *listdistanceLabel;

@property (weak, nonatomic) IBOutlet UIView *grayGrayView;


- (IBAction)parkingDetailBtnClick:(id)sender;
- (IBAction)navBtnClick:(id)sender;
- (IBAction)moreParkingBtnClick:(id)sender;


- (IBAction)mineBtnClick:(id)sender;//个人中心
- (IBAction)homeRightBtnClick:(id)sender;//二维码
- (IBAction)getInfoBtnClick:(id)sender;//查看消息点击
- (IBAction)closeInfoBtnClick:(id)sender;//关闭消息

- (IBAction)editingBtnClick:(id)sender;//修改显示点击
- (IBAction)addBtnClick:(id)sender;//首次添加点击

- (IBAction)quickPayBtnClick:(id)sender;//快捷支付按钮点击


@end



