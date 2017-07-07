//
//  AddCarInfoViewController.m
//  P-Share
//
//  Created by 杨继垒 on 15/9/7.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import "AddCarInfoViewController.h"

@interface AddCarInfoViewController ()<UITextFieldDelegate>
{
    UIView *_backView;
    
    UIView *_keyBoardView;
    
    NSString *_letterSelect;//选中的字母
    
    NSString *_provinceSelect;//选中的省份
    
    UIAlertView *_alert;
    
    NSInteger _lastProvinceIndex;
    NSInteger _lastLetterIndex;
    
    MBProgressHUD *_mbView;
    
    UIView *_clearBackView;
}
@end

@implementation AddCarInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUI];
    
    [self createMyKeyBoard];
    
    ALLOC_MBPROGRESSHUD;
}

- (void)setUI
{
    _lastLetterIndex = -2;
    _lastProvinceIndex = -2;
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    self.headerView.backgroundColor = MAIN_COLOR;
    
    self.sureBtn.backgroundColor = MAIN_COLOR;
    self.sureBtn.layer.cornerRadius = 4;
    self.sureBtn.layer.masksToBounds = YES;
    
    
}

- (void)tapBackView:(UITapGestureRecognizer *)sender
{
    CGRect frame = _keyBoardView.frame;
    frame.origin.y = SCREEN_HEIGHT;
    
    _backView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        _keyBoardView.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)createMyKeyBoard
{
    NSInteger btn_W_H = (SCREEN_WIDTH - 2*12 - 8*4)/9; //按钮的宽、高
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _backView.backgroundColor = [UIColor blackColor];
    _backView.alpha = 0.3;
    [self.view addSubview:_backView];
    
    //给_backView添加点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackView:)];
    [_backView addGestureRecognizer:tap];
    
    NSInteger keyBoardViewH = 12+(btn_W_H+8)*7+8;
    _keyBoardView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, keyBoardViewH)];
    _keyBoardView.backgroundColor = COLOR_WITH_RGB(212, 212, 212);
    [self.view addSubview:_keyBoardView];
    
    NSArray *titleArray =@[@[@"沪",@"京",@"渝",@"津",@"豫",@"湘",@"赣",@"苏",@"浙"],@[@"晋",@"鲁",@"皖",@"琼",@"甘",@"辽",@"黑",@"冀",@"吉"],@[@"陕",@"鄂",@"闽",@"滇",@"川",@"桂",@"粤",@"青",@"宁"],@[@"蒙",@"藏",@"新",@"贵"]];
    NSArray *numArray =@[@[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I"],@[@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R"],@[@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"]];
    
    //横向间距 4   纵向间距8
    for (int i=0; i<titleArray.count; i++) {
        for (int j=0; j<[titleArray[i] count]; j++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn.layer.cornerRadius = 4;
            btn.layer.masksToBounds = YES;
            btn.layer.borderWidth = 0.5;
            btn.layer.borderColor = MAIN_COLOR.CGColor;
            btn.tag = i*9 + j + 10;
            [btn setBackgroundColor:[UIColor whiteColor]];
            [btn setTintColor:[UIColor blackColor]];
            [btn setTitle:[NSString stringWithFormat:@"%@",titleArray[i][j] ] forState:UIControlStateNormal];
            [btn setFrame:CGRectMake( 12+(btn_W_H+4)*j, 12+(btn_W_H+8)*i, btn_W_H, btn_W_H)];
            [btn addTarget:self action:@selector(selectProvince:) forControlEvents:UIControlEventTouchUpInside];
            [_keyBoardView addSubview:btn];
        }
    }
    NSInteger beginY = 12+(btn_W_H+8)*4+4;
    for (int i=0; i<numArray.count; i++) {
        for (int j=0; j<[numArray[i] count]; j++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn.layer.cornerRadius = 4;
            btn.layer.masksToBounds = YES;
            btn.layer.borderWidth = 0.5;
            btn.layer.borderColor = MAIN_COLOR.CGColor;
            btn.tag = i*9 + j + 100;
            [btn setBackgroundColor:[UIColor whiteColor]];
            [btn setTintColor:[UIColor blackColor]];
            [btn setTitle:[NSString stringWithFormat:@"%@",numArray[i][j] ] forState:UIControlStateNormal];
            [btn setFrame:CGRectMake( 12+(btn_W_H+4)*j, beginY+(btn_W_H+8)*i, btn_W_H, btn_W_H)];
            [btn addTarget:self action:@selector(selectLetter:) forControlEvents:UIControlEventTouchUpInside];
            [_keyBoardView addSubview:btn];
        }
    }
    
    _backView.hidden = YES;
    _provinceSelect = @"";
    _letterSelect = @"";
}

- (void)selectProvince:(UIButton *)btn
{
    UIButton *lastBtn = (UIButton *)[self.view viewWithTag:_lastProvinceIndex];
    if (lastBtn) {
        [lastBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    _lastProvinceIndex = btn.tag;
    
    [btn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    _provinceSelect = btn.titleLabel.text;
    self.carAddressTextField.text = [NSString stringWithFormat:@"%@%@",_provinceSelect,_letterSelect];
}

- (void)selectLetter:(UIButton *)btn
{
    UIButton *lastBtn = (UIButton *)[self.view viewWithTag:_lastLetterIndex];
    if (lastBtn) {
        [lastBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    _lastLetterIndex = btn.tag;
    
    [btn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    _letterSelect = btn.titleLabel.text;
    self.carAddressTextField.text = [NSString stringWithFormat:@"%@%@",_provinceSelect,_letterSelect];
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

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)carAddressBtnClick:(id)sender {
    [self.carAddressTextField resignFirstResponder];
    [self.carNumTextField resignFirstResponder];
    [self.carTypeTextField resignFirstResponder];
    [self.userNumberTextField resignFirstResponder];
    
    NSInteger btn_W_H = (SCREEN_WIDTH - 2*12 - 8*4)/9; //按钮的宽、高
    NSInteger keyBoardViewH = 12+(btn_W_H+8)*7+8;
    
    CGRect frame = _keyBoardView.frame;
    frame.origin.y = SCREEN_HEIGHT - keyBoardViewH;
    
    _backView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        _keyBoardView.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:self.carNumTextField]) {
        NSUInteger lengthOfString = string.length;
        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {//只允许数字输入
            unichar character = [string characterAtIndex:loopIndex];
            if (character < 48) return NO; // 48 unichar for 0
            if (character < 65 && character > 57) return NO; // 57 unichar for 9    65 unichar for A
            if (character > 90) return NO; // 90 unichar for Z
        }
        // Check for total length
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        if (proposedNewLength > 5 && string.length != 0) return NO;//限制长度
        
        return YES;
    }else if ([textField isEqual:self.userNumberTextField]){
        // Check for non-numeric characters
        NSUInteger lengthOfString = string.length;
        for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {//只允许数字输入
            unichar character = [string characterAtIndex:loopIndex];
            if (character == 88) {
                return YES;
            }
            if (character < 48) return NO; // 48 unichar for 0
            if (character > 57) return NO; // 57 unichar for 9
        }
        // Check for total length
        NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
        if (proposedNewLength > 18 && string.length != 0) return NO;//限制长度
        return YES;
    }
    return YES;
}

- (IBAction)sureBtnClick:(id)sender {
    
    if (self.carAddressTextField.text.length != 2) {
        ALERT_VIEW(@"归属地正确格式为'沪A'");
        _alert = nil;
    }else if (self.carNumTextField.text.length != 5){
        ALERT_VIEW(@"车牌号为5位");
        _alert = nil;
    }else if (self.carTypeTextField.text.length == 0){
        ALERT_VIEW(@"车型不能为空");
        _alert = nil;
    }else {
        if (self.userNumberTextField.text.length == 0) {
            self.userNumberTextField.text = @" ";
        }
        BEGIN_MBPROGRESSHUD;
        //---------------------------网路请求-----
        AFHTTPRequestOperationManager *tempManager = [AFHTTPRequestOperationManager manager];
        tempManager.requestSerializer = [AFJSONRequestSerializer serializer];
        tempManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSString *carNumber = [NSString stringWithFormat:@"%@%@",self.carAddressTextField.text,self.carNumTextField.text];
        NSString *carType = self.carTypeTextField.text;
        
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        NSString *userId = [userDefaultes objectForKey:customer_id];
        NSDictionary *paramDic = @{customer_id:userId,car_brand:carType,car_number:carNumber,car_color:@1,car_size:@1,owner_id_number:self.userNumberTextField.text};
        
        NSString *urlString = [ADD_CAR_URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [tempManager GET:urlString parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             
             id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
             if ([result isKindOfClass:[NSDictionary class]])
             {
                 NSDictionary *dict = result;
                 
                 if ([dict[@"code"] isEqualToString:@"000000"])
                 {
                     [self.navigationController popViewControllerAnimated:YES];
                 }else{
                     MyLog(@"%@",dict[@"msg"]);
                 }
                 MyLog(@"%@",dict);
             }
             END_MBPROGRESSHUD;
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             MyLog(@"%@",error);
             END_MBPROGRESSHUD;
         }];
        //---------------------------网路请求
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.carAddressTextField resignFirstResponder];
    [self.carNumTextField resignFirstResponder];
    [self.carTypeTextField resignFirstResponder];
    [self.userNumberTextField resignFirstResponder];
}

- (void)dealloc
{
    
}

@end








