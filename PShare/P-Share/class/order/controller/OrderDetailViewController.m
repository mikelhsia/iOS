//
//  OrderDetailViewController.m
//  P-Share
//
//  Created by 杨继垒 on 15/9/14.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "JZAlbumViewController.h"

@interface OrderDetailViewController ()

@property (nonatomic,strong)NSMutableArray *imageArray;

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    self.headerView.backgroundColor = MAIN_COLOR;
    
    self.parkerHeaderImageView.layer.cornerRadius = 47;
    self.parkerHeaderImageView.layer.masksToBounds = YES;
    
    self.imageArray = [NSMutableArray array];
    
    [self loadData];
    
}

- (void)loadData
{
    self.parkerNameLabel.text = self.parkModel.parker_name;
    self.parkerTitleLabel.text = [NSString stringWithFormat:@"职务:%@",self.parkModel.parker_level];
    self.parkerChargeLabel.text = [NSString stringWithFormat:@"负责区域:%@",self.parkModel.parking_Name];
    self.parderPhoneLabel.text = self.parkModel.parker_mobile;
    self.orderDataLabel.text = self.parkModel.create_at;
//    self.parkingTimeLabel.text = self.parkModel.order_duration;
    self.payNumLabel.text = [NSString stringWithFormat:@"%0.2f元",self.parkModel.order_total_fee];
    self.carNumLabel.text = self.parkModel.car_Number;
    
    NSArray *modelImages = [self.parkModel.order_path componentsSeparatedByString:@","];
    [self.imageArray addObjectsFromArray:modelImages];
    [self.imageArray removeObject:@""];
    if (self.parkModel.parking_path.length > 5) {
        NSString *imageString = [self.parkModel.parking_path substringToIndex:[self.parkModel.parking_path length]-1];
        [self.imageArray addObject:imageString];
    }
    
    [self setCarImage];
}

- (void)setCarImage
{
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
    JZAlbumViewController *jzAlbumCtrl = [[JZAlbumViewController alloc] init];
    jzAlbumCtrl.imgArr = self.imageArray;
    jzAlbumCtrl.currentIndex = sender.view.tag-10;
    [self presentViewController:jzAlbumCtrl animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)callBtnClick:(id)sender {
    MyLog(@"打电话");
}

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)leftBtnClick:(id)sender {
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




