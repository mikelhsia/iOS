//
//  UserInfoViewController.m
//  P-Share
//
//  Created by 杨继垒 on 15/9/8.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UIImageView+WebCache.h"

#define BLACK ([UIColor blackColor])
#define GRAY  ([UIColor lightGrayColor])
#define sex (@"sex")
#define address (@"address")


@interface UserInfoViewController ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    BOOL _isEditing;
    
    UILabel *_nameLabel;
    
    UILabel *_titleLabel;
    
    NSString *_selectType;
    
    UIActionSheet *_actionSheet;
    
    BOOL _fromCamera;
    
    UIAlertView *_alert;
    
    //用户信息
    NSString *_userName;
    NSString *_userId;
    NSString *_userPhone;
    NSNumber *_userSex;
    NSString *_userJob;
    NSString *_userPlace;
    NSString *_userEmail;
    UIImage  *_userImage;
    
    MBProgressHUD *_mbView;
    
    UIView *_clearBackView;
}

@property (nonatomic,strong)NSMutableArray *sexArray;
@property (nonatomic,strong)NSMutableArray *addressArray;

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setDufault];
    
    [self createKeyboardTopView];
    
    _selectType = sex;
    [self loadPickerViewData];
    
    ALLOC_MBPROGRESSHUD;
}

- (void)loadPickerViewData
{
    self.sexArray = [NSMutableArray arrayWithObjects:@"先生",@"女士", nil];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Provineces" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
    self.addressArray = [NSMutableArray arrayWithArray:array];
    
    self.grayBackView.hidden = YES;
    self.userPickerView.hidden = YES;
    self.userPickerView.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePickerView:)];
    [self.grayBackView addGestureRecognizer:tap];
}

- (void)hidePickerView:(UITapGestureRecognizer *)sender
{
    self.grayBackView.hidden = YES;
    self.userPickerView.hidden = YES;
}

//设置默认值
- (void)setDufault
{
    self.userHeaderImageView.layer.cornerRadius = 45;
    self.userHeaderImageView.layer.masksToBounds = YES;
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    self.headerView.backgroundColor = MAIN_COLOR;
    
    _isEditing = NO;
    
    self.userPhoneTextfield.userInteractionEnabled = NO;
    self.userPhoneTextfield.textColor = GRAY;
    
    self.userNameTextField.textColor = GRAY;
    self.userNameTextField.userInteractionEnabled = NO;
    
    self.userJobTextField.textColor = GRAY;
    self.userJobTextField.userInteractionEnabled = NO;
    
    self.userEmailTextField.textColor = GRAY;
    self.userEmailTextField.userInteractionEnabled = NO;
    
    self.userSexLabel.textColor = GRAY;
    self.userPlaceLabel.textColor = GRAY;
    
    self.sexRightImageView.hidden = YES;
    self.placeRightImageView.hidden = YES;
    
    self.integralNumLabel.textColor = MAIN_COLOR;
    //设置用户基本信息
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    _userName = [userDefaultes objectForKey:customer_nickname];
    self.userNameTextField.text = _userName;
    _userId = [userDefaultes objectForKey:customer_id];
    self.userID.text = _userId;
    _userPhone = [userDefaultes objectForKey:customer_mobile];
    self.userPhoneTextfield.text = _userPhone;
    _userSex = [userDefaultes objectForKey:customer_sex];
    if ([_userSex integerValue] == 3) {
        
    }else if ([_userSex integerValue] == 1){
        self.userSexLabel.text = @"先生";
    }else if ([_userSex integerValue] == 2){
        self.userSexLabel.text = @"女士";
    }
    _userJob = [userDefaultes objectForKey:customer_job];
    self.userJobTextField.text = _userJob;
    _userPlace = [userDefaultes objectForKey:customer_region];
    if (_userPlace.length != 0) {
        self.userPlaceLabel.text = _userPlace;
    }
    _userEmail = [userDefaultes objectForKey:customer_email];
    self.userEmailTextField.text = _userEmail;
    
    NSString *imageString = [userDefaultes objectForKey:customer_head];
    if (imageString.length > 5) {
        [self.userHeaderImageView sd_setImageWithURL:[userDefaultes objectForKey:customer_head] placeholderImage:[UIImage imageNamed:@"defaultHeaderImage"]];
    }
}

- (void)createKeyboardTopView
{
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    myView.backgroundColor = MAIN_COLOR;
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 45, 20)];
    _nameLabel.textColor = [UIColor whiteColor];
    [myView addSubview:_nameLabel];
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, SCREEN_WIDTH-100, 20)];
    _titleLabel.backgroundColor = [UIColor whiteColor];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.layer.cornerRadius = 3;
    _titleLabel.layer.masksToBounds = YES;
    [myView addSubview:_titleLabel];
    
    UIImageView *tickImageVIew = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-30, 14, 17, 12)];
    tickImageVIew.image = [UIImage imageNamed:@"tick"];
    [myView addSubview:tickImageVIew];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(SCREEN_WIDTH-40, 0, 40, 40);
    [btn addTarget:self action:@selector(hideKeyBoard:) forControlEvents:UIControlEventTouchUpInside];
    [myView addSubview:btn];
    
//inputAccessoryView：将自定义的视图和textView联系起来
    self.userNameTextField.inputAccessoryView = myView;
    self.userJobTextField.inputAccessoryView = myView;
    self.userEmailTextField.inputAccessoryView = myView;
    self.userPhoneTextfield.inputAccessoryView = myView;
    
    [self.userNameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.userJobTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.userEmailTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.userPhoneTextfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.userNameTextField resignFirstResponder];
    [self.userJobTextField resignFirstResponder];
    [self.userEmailTextField resignFirstResponder];
    [self.userPhoneTextfield resignFirstResponder];
}

- (void)textFieldDidChange:(UITextField *)textField
{
    _titleLabel.text = textField.text;
}


- (void)hideKeyBoard:(UIButton *)btn
{
    [self.userNameTextField resignFirstResponder];
    [self.userJobTextField resignFirstResponder];
    [self.userEmailTextField resignFirstResponder];
    [self.userPhoneTextfield resignFirstResponder];
}


#pragma mark -----UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.userNameTextField]) {
        _nameLabel.text = @"昵称:";
    }else if ([textField isEqual:self.userJobTextField]){
        _nameLabel.text = @"职业:";
    }else if ([textField isEqual:self.userEmailTextField]){
        _nameLabel.text = @"邮箱:";
    }else if ([textField isEqual:self.userPhoneTextfield]){
        _nameLabel.text = @"手机:";
        
        ALERT_VIEW(@"更改后的手机号将作为您新的登录账号!")
        _alert = nil;
    }
    _titleLabel.text = textField.text;
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

//进入编辑状态
- (IBAction)editingBtnClick:(id)sender {
    
    _isEditing = !_isEditing;
    
    if (_isEditing) {
        //----------换图片
        self.rightImageViewWidth.constant = 17;
        self.rightImageViewHeight.constant = 12;
        self.editingImageView.image = [UIImage imageNamed:@"tick"];
        
        self.userPhoneTextfield.textColor = BLACK;
        self.userPhoneTextfield.userInteractionEnabled = YES;
        
        self.userNameTextField.textColor = BLACK;
        self.userNameTextField.userInteractionEnabled = YES;
        
        self.userJobTextField.textColor = BLACK;
        self.userJobTextField.userInteractionEnabled = YES;
        
        self.userEmailTextField.textColor = BLACK;
        self.userEmailTextField.userInteractionEnabled = YES;
        
//        if (![self.userSexLabel.text isEqualToString:@"请选择性别"]) {
            self.userSexLabel.textColor = BLACK;
//        }
//        if (![self.userPlaceLabel.text isEqualToString:@"请选择城市"]) {
            self.userPlaceLabel.textColor = BLACK;
//        }
        
        self.sexRightImageView.hidden = NO;
        self.placeRightImageView.hidden = NO;
    }else{
        if ([MyUtil isMobileNumber:self.userPhoneTextfield.text]) {
            
            //----------换图片
            self.rightImageViewWidth.constant = 17;
            self.rightImageViewHeight.constant = 17;
            self.editingImageView.image = [UIImage imageNamed:@"editing"];
            
            self.userPhoneTextfield.textColor = GRAY;
            self.userPhoneTextfield.userInteractionEnabled = NO;
            
            self.userNameTextField.textColor = GRAY;
            self.userNameTextField.userInteractionEnabled = NO;
            
            self.userJobTextField.textColor = GRAY;
            self.userJobTextField.userInteractionEnabled = NO;
            
            self.userEmailTextField.textColor = GRAY;
            self.userEmailTextField.userInteractionEnabled = NO;
            
            self.userSexLabel.textColor = GRAY;
            self.userPlaceLabel.textColor = GRAY;
            
            self.sexRightImageView.hidden = YES;
            self.placeRightImageView.hidden = YES;
            
            //----------------------------保存数据
            [self updataUserInfoWithGet];
        }else
        {
            ALERT_VIEW(@"请输入正确手机号");
            _alert = nil;
        }
        
    }
    
}

#pragma mark -- 每次更改数据之后都要进行数据的上传更新
- (void)updataUserInfoWithGet
{
    BEGIN_MBPROGRESSHUD;
    //---------------------------网路请求----保存数据
    AFHTTPRequestOperationManager *tempManager = [AFHTTPRequestOperationManager manager];
    tempManager.requestSerializer = [AFJSONRequestSerializer serializer];
    tempManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    _userName = self.userNameTextField.text;
    _userPhone = self.userPhoneTextfield.text;
    if ([self.userSexLabel.text isEqualToString:@"先生"]) {
        _userSex = @1;
    }else if ([self.userSexLabel.text isEqualToString:@"女士"]){
        _userSex = @2;
    }else{
        _userSex = @3;
    }
    _userJob = self.userJobTextField.text;
    _userPlace = self.userPlaceLabel.text;
    _userEmail = self.userEmailTextField.text;
#pragma mark -- 年龄在此处是测试数据
    NSDictionary *paramDic = @{customer_id:_userId,customer_nickname:_userName,customer_sex:_userSex,customer_job:_userJob,customer_region:_userPlace,customer_mobile:_userPhone,customer_email:_userEmail,customer_age:@18};
    
    NSString *urlString = [SET_USER_INFO stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [tempManager GET:urlString parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if ([result isKindOfClass:[NSDictionary class]])
         {
             NSDictionary *dict = result;
             
             if ([dict[@"code"] isEqualToString:@"000000"])
             {
                 NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                 NSDictionary *infoDict = dict[@"datas"];
                 [userDefaults setObject:infoDict[@"customer_id"] forKey:customer_id];
                 [userDefaults setObject:infoDict[@"customer_mobile"] forKey:customer_mobile];
                 [userDefaults setObject:infoDict[@"customer_email"] forKey:customer_email];
                 [userDefaults setObject:infoDict[@"customer_region"] forKey:customer_region];
                 [userDefaults setObject:infoDict[@"customer_nickname"] forKey:customer_nickname];
                 NSNumber *num = infoDict[@"customer_sex"];
                 [userDefaults setObject:num forKey:customer_sex];
                 [userDefaults setObject:infoDict[@"customer_job"] forKey:customer_job];
                 [userDefaults synchronize];
//                 使用通知来及时更改数据
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"updataSideMenuHeader" object:nil];
             }else{
                 
             }
             MyLog(@"%@",dict);
         }
         END_MBPROGRESSHUD;
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         MyLog(@"555555555请求失败");
         END_MBPROGRESSHUD;
     }];
    //---------------------------网路请求
}

#pragma mark -- 上传从相册所选择的图片
- (void)updataUserInfoWithPost:(NSData *)imageData
{
    BEGIN_MBPROGRESSHUD;
    //---------------------------网路请求----保存数据
    AFHTTPRequestOperationManager *tempManager = [AFHTTPRequestOperationManager manager];
    tempManager.requestSerializer = [AFJSONRequestSerializer serializer];
    tempManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    _userName = self.userNameTextField.text;
    _userPhone = self.userPhoneTextfield.text;
    if ([self.userSexLabel.text isEqualToString:@"先生"]) {
        _userSex = @1;
    }else if ([self.userSexLabel.text isEqualToString:@"女士"]){
        _userSex = @2;
    }else{
        _userSex = @3;
    }
    _userJob = self.userJobTextField.text;
    _userPlace = self.userPlaceLabel.text;
    _userEmail = self.userEmailTextField.text;
    NSDictionary *paramDic = @{customer_id:_userId,customer_nickname:_userName,customer_sex:_userSex,customer_job:_userJob,customer_region:_userPlace,customer_mobile:_userPhone,customer_email:_userEmail,customer_age:@18};
    
    NSString *urlString = [SET_USER_INFO stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    
    [tempManager POST:urlString parameters:paramDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        //第四个参数:@"image/png"
        //第三个参数:随便给一个名字以.png结尾
        //第二个参数:参数名
        NSDate *nowData = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-ddHH:mm:ss"];
        NSString *imageName = [formatter stringFromDate:nowData];
        
        [formData appendPartWithFileData:imageData name:@"file" fileName:imageName mimeType:@"image/jpeg"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([result isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dict = result;
            
            if ([dict[@"code"] isEqualToString:@"000000"])
            {
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSDictionary *infoDict = dict[@"datas"];
                [userDefaults setObject:infoDict[@"customer_id"] forKey:customer_id];
                [userDefaults setObject:infoDict[@"customer_mobile"] forKey:customer_mobile];
                [userDefaults setObject:infoDict[@"customer_email"] forKey:customer_email];
                [userDefaults setObject:infoDict[@"customer_region"] forKey:customer_region];
                [userDefaults setObject:infoDict[@"customer_nickname"] forKey:customer_nickname];
                NSNumber *num = infoDict[@"customer_sex"];
                [userDefaults setObject:num forKey:customer_sex];
                [userDefaults setObject:infoDict[@"customer_job"] forKey:customer_job];
                
                if ([infoDict[@"customer_head"] length] > 5) {
                    NSString *imageString = [infoDict[@"customer_head"] substringToIndex:[infoDict[@"customer_head"] length]-1];
                    [userDefaults setObject:imageString forKey:customer_head];
                }
                [userDefaults synchronize];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updataSideMenuHeader" object:nil];
            }else{
                
            }
            MyLog(@"%@",dict);
        }
        END_MBPROGRESSHUD;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        MyLog(@"9999999999请求失败");
        END_MBPROGRESSHUD;
    }];
    //---------------------------网路请求
}

- (IBAction)sexBtnClick:(id)sender {
    [self.userNameTextField resignFirstResponder];
    [self.userJobTextField resignFirstResponder];
    [self.userEmailTextField resignFirstResponder];
    [self.userPhoneTextfield resignFirstResponder];
    
    if (_isEditing) {
//        if ([self.userSexLabel.text isEqualToString:@"请选择性别"]) {
//            self.userSexLabel.text = @"";
//        }
        self.userSexLabel.textColor = BLACK;
        _selectType = sex;
        self.grayBackView.hidden = NO;
        self.userPickerView.hidden = NO;
        [self.userPickerView reloadAllComponents];
    }
    
}

- (IBAction)placeBtnClick:(id)sender {
    [self.userNameTextField resignFirstResponder];
    [self.userJobTextField resignFirstResponder];
    [self.userEmailTextField resignFirstResponder];
    [self.userPhoneTextfield resignFirstResponder];
    
    if (_isEditing) {
//        if ([self.userPlaceLabel.text isEqualToString:@"请选择城市"]) {
//            self.userPlaceLabel.text = @"";
//        }
        self.userPlaceLabel.textColor = BLACK;
        _selectType = address;
        self.grayBackView.hidden = NO;
        self.userPickerView.hidden = NO;
        [self.userPickerView reloadAllComponents];
    }
}

#pragma mark  UIActionSheet选择照片相关
- (IBAction)tapHeaderImageView:(id)sender {
        _actionSheet = [[UIActionSheet alloc]
                   initWithTitle:@"请选择照片"
                   delegate:self
                   cancelButtonTitle:@"取消"
                   destructiveButtonTitle:nil
                   otherButtonTitles:@"拍照",@"相册", nil];
    [_actionSheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self takePhotoByCamera];
            _fromCamera = YES;
            break;
        case 1:
            [self takePhotoByLibrary];
            _fromCamera = NO;
            break;
        default:
            break;
    }
}
#pragma mark - ImagePicker相关
- (void)takePhotoByCamera {
    //判断照相是否可用
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return;
    }else {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }
}
- (void)takePhotoByLibrary {
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

//图片剪切
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}
#pragma mark -- 上传的头像是否允许编辑（设置为允许）
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if ([info objectForKey:UIImagePickerControllerOriginalImage]) {
        UIImage *image = nil;
//        image = [info objectForKey:UIImagePickerControllerOriginalImage];
        image = [info objectForKey:UIImagePickerControllerEditedImage];
        //如果是拍照则保存到相册
        if (_fromCamera) {
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        }
        //图片剪切
        CGSize imagesize = image.size;
        imagesize.height =400;
        imagesize.width =400;
        //对图片大小进行压缩--
        image = [self imageWithImage:image scaledToSize:imagesize];
        
//        NSData *imageData = UIImagePNGRepresentation(image);
//        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//        [userDefault setObject:imageData forKey:customer_head];
        [self.userHeaderImageView setImage:image];
        
        NSData *imageData = UIImageJPEGRepresentation(image, 0.2);
        [self updataUserInfoWithPost:imageData];
        
        //通知发送消息，更新侧滑页头像
        NSNotification *notification = [[NSNotification alloc]initWithName:@"updataSideMenuHeader" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
}
//用户点击取消时调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    if (!error) {
    }
    else
    {
    }
}



#pragma mark UIPickViewDatasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([_selectType isEqualToString:sex]) {
        return self.sexArray.count;
    }else{
        return self.addressArray.count;
    }
}

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    if ([_selectType isEqualToString:sex]) {
//        return self.sexArray[row];
//    }else{
//        return self.addressArray[row][@"ProvinceName"];
//    }
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([_selectType isEqualToString:sex]) {
        self.userSexLabel.text = self.sexArray[row];
    }else{
        self.userPlaceLabel.text = self.addressArray[row][@"ProvinceName"];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    
    if ([_selectType isEqualToString:sex]) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [self.sexArray objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:15];
        myView.backgroundColor = [UIColor clearColor];
    }
    else if([_selectType isEqualToString:address]){
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = self.addressArray[row][@"ProvinceName"];
        myView.font = [UIFont systemFontOfSize:15];
        myView.backgroundColor = [UIColor clearColor];
    }
    return myView;
}

@end







