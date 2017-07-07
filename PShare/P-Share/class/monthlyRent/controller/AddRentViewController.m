//
//  AddRentViewController.m
//  P-Share
//
//  Created by 杨继垒 on 15/9/13.
//  Copyright (c) 2015年 杨继垒. All rights reserved.
//

#import "AddRentViewController.h"
#import "AddRentCell.h"
#import "ChoiceCarViewController.h"
#import "AddressViewController.h"
#import "ParkingModel.h"

@interface AddRentViewController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,SelectedParking,SelectedCar>
{
    UIView *footerView;
        
    NSString *_pickerViewType;
    
    NSString *_selectedProvince;
    NSString *_selectCity;
    NSString *_selectArea;
    NSString *_selectMonth;
    NSString *_beginTimeData;
    NSString *_endTimeData;
    NSString *_selectPayType;
    NSString *_selectPrice;
    
    ParkingModel *_selectParkingModel;
    CarModel     *_selectCarModel;
    
    //回调选中的小区
    NSString *_selectParking;
    NSString *_selectCar;
    
    NSInteger _selectProvinceIndex;
    
    NSString *_nowYear;
    
    UIAlertView *_alert;
    
    MBProgressHUD *_mbView;
    UIView *_clearBackView;
    
    BOOL _haveSelected;
    
}
@property (nonatomic,strong)NSDictionary *areaDic;

@property (nonatomic,strong)NSMutableArray *countryArray;
@property (nonatomic,strong)NSMutableArray *provinceArray;
@property (nonatomic,strong)NSMutableArray *cityArray;
@property (nonatomic,strong)NSMutableArray *monthArray;
//@property (nonatomic,strong)NSMutableArray *payTypeArray;

@property (nonatomic,copy)NSString *selectName;

@end

@implementation AddRentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setDefaultUI];
    
    [self createTableViewFooterView];
    
    ALLOC_MBPROGRESSHUD;
    //加载pickerView数据
    [self loadPickerViewData];
}

- (void)loadPickerViewData
{
    _haveSelected = NO;
    
    _selectedProvince = @"";
    _selectCity = @"";
    _selectPayType = @"";
    _selectCar = @"";
    _selectPrice = @"";
    _selectArea = @"";
    
    self.countryArray = [NSMutableArray arrayWithObject:@"中国"];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"area" ofType:@"plist"];
    _areaDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSArray *components = [_areaDic allKeys];
    NSArray *sortedArray = [components sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSMutableArray *provinceTmp = [[NSMutableArray alloc] init];
    for (int i=0; i<[sortedArray count]; i++) {
        NSString *index = [sortedArray objectAtIndex:i];
        NSArray *tmp = [[_areaDic objectForKey: index] allKeys];
        [provinceTmp addObject: [tmp objectAtIndex:0]];
    }
    
    self.provinceArray = [[NSMutableArray alloc] initWithArray: provinceTmp];
    
    NSString *index = [sortedArray objectAtIndex:0];
    NSString *selected = [self.provinceArray objectAtIndex:0];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [[_areaDic objectForKey:index]objectForKey:selected]];
    
    NSArray *cityArray = [dic allKeys];
    NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [cityArray objectAtIndex:0]]];
    self.cityArray = [[NSMutableArray alloc] initWithArray: [cityDic allKeys]];
    
//    _selectedProvince = [self.provinceArray objectAtIndex: 0];
    
    //时间数据源   @"yyyy-MM-dd HH:mm:ss"
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM";
    NSString *dateStr = [formatter stringFromDate:date];
    int nowDate = [dateStr intValue];
    
    //起始时间数据源
    self.monthArray = [NSMutableArray array];
    for (int i=nowDate; i<=12; i++) {
        if (i<10) {
            [self.monthArray addObject:[NSString stringWithFormat:@"0%d",i]];
        }else{
            [self.monthArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    //获取当前年份
    formatter.dateFormat = @"yyyy";
    _nowYear = [formatter stringFromDate:date];
    
    //选择类型数据源
//    self.payTypeArray = [NSMutableArray arrayWithObjects:@"产权",@"月租", nil];
    
}

- (void)setDefaultUI
{
    self.view.backgroundColor = BACKGROUND_COLOR;
    self.addRenttableView.backgroundColor = BACKGROUND_COLOR;
    self.headerView.backgroundColor = MAIN_COLOR;
    self.addRenttableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.grayBackView.hidden = YES;
    self.addRentPickerView.hidden = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePickerView:)];
    [self.grayBackView addGestureRecognizer:tap];
}

- (void)hidePickerView:(UITapGestureRecognizer *)sender
{
    self.grayBackView.hidden = YES;
    self.addRentPickerView.hidden = YES;
}

//添加的 footerView
- (void)createTableViewFooterView
{
    footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
    footerView.backgroundColor = BACKGROUND_COLOR;
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    sureBtn.frame = CGRectMake(15, 23, SCREEN_WIDTH - 30, 43);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn setBackgroundColor:MAIN_COLOR];
    sureBtn.layer.cornerRadius = 4;
    sureBtn.layer.masksToBounds = YES;
    [footerView addSubview:sureBtn];
    
    [sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.addRenttableView.tableFooterView = footerView;
}



#pragma mark -----按钮的点击事件
//添加确认按钮点击
- (void)sureBtnClick:(UIButton *)btn
{
    if (_selectParking.length == 0){
        ALERT_VIEW(@"请选择小区");
        _alert = nil;
        return;
    }else if (_selectCar.length == 0){
        ALERT_VIEW(@"请选择车牌");
        _alert = nil;
        return;
    }else if (_selectMonth.length == 0){
        ALERT_VIEW(@"请选择缴费月份");
        _alert = nil;
        return;
    }else if (_selectName.length == 0){
        ALERT_VIEW(@"请填写姓名");
        _alert = nil;
        return;
    }
    
    if (_selectPayType.length == 0 || _selectPrice.length == 0) {
        ALERT_VIEW(@"无车牌号对应单价");
        _alert = nil;
        return;
    }
    
    BEGIN_MBPROGRESSHUD;
    //---------------------------网路--提交订单
    AFHTTPRequestOperationManager *tempManager = [AFHTTPRequestOperationManager manager];
    tempManager.requestSerializer = [AFJSONRequestSerializer serializer];
    tempManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSString *userId = [userDefaultes objectForKey:customer_id];
    
    _beginTimeData = [NSString stringWithFormat:@"%@/%@/01",_nowYear,_selectMonth];
    int nowDay = [self getDayWithYear:[_nowYear intValue] month:[_selectMonth intValue]];
    _endTimeData = [NSString stringWithFormat:@"%@/%@/%d",_nowYear,_selectMonth,nowDay];
    
    if (_selectArea.length == 0) {
        _selectArea = @"中国 上海市 上海市";
    }
    
    NSDictionary *paramDic = @{customer_id:userId,@"villageId":_selectParkingModel.parking_Id,@"carNumber":_selectCar,@"village_name":_selectParking,@"price":_selectPrice,@"order_type":_selectPayType,@"area":_selectArea,@"county":@"上海市",@"validity_start_time":_beginTimeData,@"validity_end_time":_endTimeData,@"timequantum":@"1",@"customer_name":_selectName};
    
    NSString *urlString = [POST_RENT_ORDER stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
         }
         END_MBPROGRESSHUD;
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         MyLog(@"1111111%@",error);
         END_MBPROGRESSHUD;
     }];
    //---------------------------网路请求
}


#pragma mark -----UITableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_haveSelected) {
        return 7;
    }else{
        return 5;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"addRentCellId";
    AddRentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AddRentCell" owner:self options:nil]lastObject];
    }
    cell.rightTextField.userInteractionEnabled = NO;
    cell.rightImageView.hidden = NO;
    if (_haveSelected) {
        switch (indexPath.row) {
            case 0:
                cell.leftLabel.text = @"缴费类型:";
                if ([_selectPayType isEqualToString:@"0"]) {
                    cell.rightTextField.text = @"产权";
                }else if ([_selectPayType isEqualToString:@"1"]){
                    cell.rightTextField.text = @"月租";
                }else
                {
                    cell.rightTextField.text = _selectPayType;
                }
                cell.rightImageView.hidden = YES;
                break;
            case 1:
                cell.leftLabel.text = @"国、省、市:";
                cell.rightTextField.placeholder = @"请选择区域";
                
                if (_selectedProvince.length != 0 || _selectCity.length != 0) {
                    _selectArea = [NSString stringWithFormat:@"中国 %@ %@",_selectedProvince,_selectCity];
                    cell.rightTextField.text = _selectArea;
                }else{
                    cell.rightTextField.text = @"";
                }
                break;
            case 2:
                cell.leftLabel.text = @"小区:";
                cell.rightTextField.placeholder = @"请选择小区";
                if (_selectParkingModel) {
                    _selectParking = _selectParkingModel.parking_Name;
                    cell.rightTextField.text = _selectParking;
                }else{
                    cell.rightTextField.text = @"";
                }
                break;
            case 3:
                cell.leftLabel.text = @"车牌:";
                cell.rightTextField.placeholder = @"请选择车牌";
                if (_selectCarModel) {
                    _selectCar = _selectCarModel.car_Number;
                    cell.rightTextField.text = _selectCar;
                }else{
                    cell.rightTextField.text = @"";
                }
                break;
            case 4:
                cell.leftLabel.text = @"缴费月份:";
                cell.rightTextField.placeholder = @"请选择缴费月份";
                
                if (_selectMonth.length != 0) {
                    cell.rightTextField.text = [NSString stringWithFormat:@"%@年 %@月",_nowYear,_selectMonth];
                }else{
                    cell.rightTextField.text = @"";
                }
                break;
            case 5:
                cell.leftLabel.text = @"姓名:";
                cell.rightTextField.placeholder = @"请输入姓名";
                cell.rightTextField.userInteractionEnabled = YES;
                cell.rightImageView.hidden = YES;
                if (_selectName.length != 0) {
                    cell.rightTextField.text = _selectName;
                }else{
                    cell.rightTextField.text = @"";
                }
                break;
            case 6:
                cell.leftLabel.text = @"月单价:";
                cell.rightImageView.hidden = YES;
                if (_selectPrice.length != 0) {
                    cell.rightTextField.text = [NSString stringWithFormat:@"%@元",_selectPrice];
                }else
                {
                    cell.rightTextField.text = _selectPrice;
                }
                break;
            default:
                break;
        }
        
        if (indexPath.row == 5) {
            __weak AddRentCell *weakCell = cell;
            __weak AddRentViewController *weakSelf = self;
            cell.transmitNameValue = ^{
                weakSelf.selectName = weakCell.rightTextField.text;
                [weakSelf.addRenttableView reloadData];
            };
        }
    }else{
        switch (indexPath.row) {
            case 0:
                cell.leftLabel.text = @"国、省、市:";
                cell.rightTextField.placeholder = @"请选择区域";
                
                if (_selectedProvince.length != 0 || _selectCity.length != 0) {
                    _selectArea = [NSString stringWithFormat:@"中国 %@ %@",_selectedProvince,_selectCity];
                    cell.rightTextField.text = _selectArea;
                }
                break;
            case 1:
                cell.leftLabel.text = @"小区:";
                cell.rightTextField.placeholder = @"请选择小区";
                if (_selectParkingModel) {
                    _selectParking = _selectParkingModel.parking_Name;
                }
                if (_selectParking) {
                    cell.rightTextField.text = _selectParking;
                }
                break;
            case 2:
                cell.leftLabel.text = @"车牌:";
                cell.rightTextField.placeholder = @"请选择车牌";
                if (_selectCarModel) {
                    _selectCar = _selectCarModel.car_Number;
                    cell.rightTextField.text = _selectCar;
                }
                break;
            case 3:
                cell.leftLabel.text = @"缴费月份:";
                cell.rightTextField.placeholder = @"请选择缴费月份";
                
                if (_selectMonth.length != 0) {
                    cell.rightTextField.text = [NSString stringWithFormat:@"%@年 %@月",_nowYear,_selectMonth];
                }
                break;
            case 4:
                cell.leftLabel.text = @"姓名:";
                cell.rightTextField.placeholder = @"请输入姓名";
                cell.rightTextField.userInteractionEnabled = YES;
                cell.rightImageView.hidden = YES;
                if (_selectName.length != 0) {
                    cell.rightTextField.text = _selectName;
                }
                break;
            default:
                break;
        }
        
        if (indexPath.row == 4) {
            __weak AddRentCell *weakCell = cell;
            __weak AddRentViewController *weakSelf = self;
            cell.transmitNameValue = ^{
                weakSelf.selectName = weakCell.rightTextField.text;
                [weakSelf.addRenttableView reloadData];
            };
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_haveSelected) {
        if (indexPath.row == 1) {
            _pickerViewType = @"0";
            self.grayBackView.hidden = NO;
            self.addRentPickerView.hidden = NO;
            
            [self.addRentPickerView reloadAllComponents];
            //        [self.addRentPickerView selectRow: 0 inComponent: 0 animated: YES];
            [self.addRentPickerView selectRow:_selectProvinceIndex inComponent: 1 animated: YES];
            
        }
        if (indexPath.row == 2) {
            AddressViewController *addressCtrl = [[AddressViewController alloc]init];
            [self.navigationController pushViewController:addressCtrl animated:YES];
            addressCtrl.delegate = self;
            addressCtrl.monthlyRentAddress = [NSString stringWithFormat:@"%@",_selectArea];
            addressCtrl.homeOrMonthlyRent = @"monthly";
        }
        if (indexPath.row == 3) {
            ChoiceCarViewController *choiceCarCtrl = [[ChoiceCarViewController alloc] init];
            choiceCarCtrl.delegate = self;
            [self.navigationController pushViewController:choiceCarCtrl animated:YES];
        }
        if (indexPath.row == 4) {
            _pickerViewType = @"1";
            self.grayBackView.hidden = NO;
            self.addRentPickerView.hidden = NO;
            if (_selectMonth.length == 0) {
                _selectMonth = self.monthArray[0];
            }
            [self.addRenttableView reloadData];
            [self.addRentPickerView reloadAllComponents];
            [self.addRentPickerView selectRow: 0 inComponent: 0 animated: YES];
            [self.addRentPickerView selectRow: 0 inComponent: 1 animated: YES];
        }
        
    }else{
        if (indexPath.row == 0) {
            _pickerViewType = @"0";
            self.grayBackView.hidden = NO;
            self.addRentPickerView.hidden = NO;
            
            [self.addRentPickerView reloadAllComponents];
            //        [self.addRentPickerView selectRow: 0 inComponent: 0 animated: YES];
            [self.addRentPickerView selectRow:_selectProvinceIndex inComponent: 1 animated: YES];
            
        }
        if (indexPath.row == 1) {
            AddressViewController *addressCtrl = [[AddressViewController alloc]init];
            [self.navigationController pushViewController:addressCtrl animated:YES];
            addressCtrl.delegate = self;
            addressCtrl.monthlyRentAddress = [NSString stringWithFormat:@"%@",_selectArea];
            addressCtrl.homeOrMonthlyRent = @"monthly";
        }
        if (indexPath.row == 2) {
            ChoiceCarViewController *choiceCarCtrl = [[ChoiceCarViewController alloc] init];
            choiceCarCtrl.delegate = self;
            [self.navigationController pushViewController:choiceCarCtrl animated:YES];
        }
        if (indexPath.row == 3) {
            _pickerViewType = @"1";
            self.grayBackView.hidden = NO;
            self.addRentPickerView.hidden = NO;
            if (_selectMonth.length == 0) {
                _selectMonth = self.monthArray[0];
            }
            [self.addRenttableView reloadData];
            [self.addRentPickerView reloadAllComponents];
            [self.addRentPickerView selectRow: 0 inComponent: 0 animated: YES];
            [self.addRentPickerView selectRow: 0 inComponent: 1 animated: YES];
        }
    }
    
    NSNotification *notification = [[NSNotification alloc]initWithName:@"hideAddRentKeyboard" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}

#pragma mark -SelectedParking代理方法
- (void)selectedParkingAtMonthlyRent:(ParkingModel *)model
{
    _selectParkingModel = model;
    _selectParking = model.parking_Name;
    [self.addRenttableView reloadData];
    if (_selectParking.length != 0 && _selectCar.length != 0) {
        [self getRentPrice];
    }
}

#pragma mark -SelectedCar代理方法
- (void)selectedCarWithCarModel:(CarModel *)model
{
    _selectCarModel = model;
    _selectCar = model.car_Number;
    [self.addRenttableView reloadData];
    if (_selectParking.length != 0 && _selectCar.length != 0) {
        [self getRentPrice];
    }
}

//获取单价
- (void)getRentPrice
{
    BEGIN_MBPROGRESSHUD;
    //---------------------------网路
    AFHTTPRequestOperationManager *tempManager = [AFHTTPRequestOperationManager manager];
    tempManager.requestSerializer = [AFJSONRequestSerializer serializer];
    tempManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *paramDic = @{@"villageId":_selectParkingModel.parking_Id,@"carNumber":_selectCar};
    
    NSString *urlString = [GET_UNIT_PRICE stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [tempManager GET:urlString parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         if ([result isKindOfClass:[NSDictionary class]])
         {
             NSDictionary *dict = result;
             
             if ([dict[@"messageCode"] isEqualToString:@"OK"])
             {
                 _selectPrice = dict[@"result"][@"unitPrice"];
                 _selectPayType = dict[@"result"][@"unitPriceType"];
                 _haveSelected = YES;
             }else{
                 MyLog(@"%@",dict[@"message"]);
                 _selectPrice = @"";
                 _selectPayType = @"";
                 ALERT_VIEW(@"无该车牌号对应单价");
                 _alert = nil;
             }
         }
         [self.addRenttableView reloadData];
         END_MBPROGRESSHUD;
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         MyLog(@"1111111%@",error);
         END_MBPROGRESSHUD;
     }];
    //---------------------------网路请求
}

#pragma mark- Picker Data Source 代理方法

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if ([_pickerViewType isEqualToString:@"0"]) {
        return 3;
    }else{
        return 2;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([_pickerViewType isEqualToString:@"0"]) {
        if (component == 0) {
            return [self.countryArray count];
        }
        else if (component == 1) {
            return [self.provinceArray count];
        }
        else {
            return [self.cityArray count];
        }
        
    }else{
        if (component == 1) {
            return [self.monthArray count];
        }else {
            return 1;
        }
    }
}


#pragma mark- Picker Delegate 代理方法
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    myView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3, 30)];
    myView.textAlignment = NSTextAlignmentCenter;
    myView.font = [UIFont systemFontOfSize:14];
    myView.backgroundColor = [UIColor clearColor];
    
    if ([_pickerViewType isEqualToString:@"0"]) {
        if (component == 0) {
            myView.text = [self.countryArray objectAtIndex: row];
        }
        else if (component == 1) {
            myView.text = [self.provinceArray objectAtIndex: row];
        }
        else {
            myView.text = [self.cityArray objectAtIndex: row];
        }
        
    }else if ([_pickerViewType isEqualToString:@"1"]){
        if (component == 0) {
            myView.text = _nowYear;
        }else {
            myView.text = [self.monthArray objectAtIndex:row];
        }
    }
    return myView;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([_pickerViewType isEqualToString:@"0"]) {
        if (component == 1) {
            _selectedProvince = [self.provinceArray objectAtIndex: row];
            _selectProvinceIndex = row;
            
            NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [self.areaDic objectForKey: [NSString stringWithFormat:@"%ld", row]]];
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: _selectedProvince]];
            NSArray *cityArray = [dic allKeys];
            NSArray *sortedArray = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
                
                if ([obj1 integerValue] > [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedDescending;//递减
                }
                
                if ([obj1 integerValue] < [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedAscending;//上升
                }
                return (NSComparisonResult)NSOrderedSame;
            }];
            
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (int i=0; i<[sortedArray count]; i++) {
                NSString *index = [sortedArray objectAtIndex:i];
                NSArray *temp = [[dic objectForKey: index] allKeys];
                [array addObject: [temp objectAtIndex:0]];
            }
            
            [self.cityArray removeAllObjects];
            [self.cityArray addObjectsFromArray:array];
            _selectCity = self.cityArray[0];
            
            [self.addRentPickerView selectRow: 0 inComponent: 2 animated: YES];
            [self.addRentPickerView reloadComponent: 2];
            
        }
        else if (component == 2) {
            _selectCity = self.cityArray[row];
            
            if (_selectedProvince.length == 0) {
                _selectedProvince = @"北京市";
            }
        }
            
    }else if ([_pickerViewType isEqualToString:@"1"]){
        if (component == 1) {
            _selectMonth = self.monthArray[row];
        }
    }

    [self.addRenttableView reloadData];
}

- (int)getDayWithYear:(int)year month:(int)month
{
    int days = 0;
    
    if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12)
    {
        days = 31;
    }
    else if (month == 4 || month == 6 || month == 9 || month == 11)
    {
        days = 30;
    }
    else
    { // 2月份，闰年29天、平年28天
        if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0)
        {
            days = 29;
        }
        else
        {
            days = 28;
        }
    }
    
    return days;
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
@end
