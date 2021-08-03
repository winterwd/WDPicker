//
//  WDAreaPickerView.m
//  WDPicker
//
//  Created by wd on 2017/5/8.
//  Copyright © 2017年 winter. All rights reserved.
//

#import "WDAreaPickerView.h"

#define kPK_PickerHeight    240

#define kPK_Screen_Width    [UIScreen mainScreen].bounds.size.width
#define kPK_Screen_Height   [UIScreen mainScreen].bounds.size.height

@interface WDAreaAddressModel : NSObject
/** 省/市 */
@property (nonatomic, copy) NSString *provinceOrCity;
/** 市/区 */
@property (nonatomic, strong) NSArray *cityOrDistrictArray;

@property (nonatomic, strong) NSArray<WDAreaAddressModel *> *cityModels;
@end

@implementation WDAreaAddressModel

@end

@interface WDAreaPickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) UIPickerView *areaPickerView;
@property (nonatomic, weak) UIView *pickerView;
@property (nonatomic, weak) UIView *topView;
@property (nonatomic, weak) UIControl *coverView;
@property (nonatomic, strong) NSArray *buttons;

@property (nonatomic, assign) WDAreaPickerType pickerType;

@property (nonatomic, strong) WDAreaAddressModel *currentAreaModel;
@property (nonatomic, strong) NSArray *areaDataArray;
@property (nonatomic, strong) NSArray *cityDataArray;
@property (nonatomic, strong) NSArray *districtDataArray;

@property (nonatomic, copy) NSString *selestProvince;
@property (nonatomic, copy) NSString *selestCity;
@property (nonatomic, copy) NSString *selestDistrict;
@property (nonatomic, copy) NSString *selestReslut;
@end

@implementation WDAreaPickerView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"WDAreaPickerView dealloc");
}

+ (instancetype)areaDefaultPickerView {
    return [self areaPickerViewWithType:WDAreaPickerType_All];
}

+ (instancetype)areaPickerViewWithType:(WDAreaPickerType)pickerType {
    CGRect frame = CGRectMake(0, 0, kPK_Screen_Width, kPK_Screen_Height);
    WDAreaPickerView *picker = [[WDAreaPickerView alloc] initWithFrame:frame];
    picker.pickerType = pickerType;
    return picker;
}

- (instancetype)initWithFrame:(CGRect)frame {
    CGRect tempFrame = CGRectMake(0, 0, frame.size.width, kPK_Screen_Height);
    if (self = [super initWithFrame:tempFrame]) {
        self.backgroundColor = [UIColor clearColor];
        [self setupSubViews];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

- (void)setupSubViews {
    UIControl *coverView = [[UIControl alloc] initWithFrame:self.bounds];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0.2;
    coverView.tag = 100;
    [coverView addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.coverView = coverView;
    [self addSubview:coverView];
    
    CGFloat height = 40;
    
    UIView *pickerView = [[UIView alloc] initWithFrame:CGRectMake(0, kPK_Screen_Height, CGRectGetWidth(self.bounds), kPK_PickerHeight)];
    self.pickerView = pickerView;
    self.pickerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.pickerView];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kPK_Screen_Width, height)];
    topView.backgroundColor = [UIColor colorWithRed:238.0f/255.0f green:238.0f/255.0f blue:238.0f/255.0f alpha:1];
    self.topView = topView;
    
    UIColor *blueColor = [UIColor colorWithRed:41.0/255.0f green:128.0/255.0f blue:185.0/255.0f alpha:1.0];
    UIColor *blueHColor = [UIColor colorWithRed:41.0/255.0f green:128.0/255.0f blue:185.0/255.0f alpha:0.5];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.tag = 100;
    cancelButton.titleLabel.font  = [UIFont systemFontOfSize:14.0];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:blueColor forState:UIControlStateNormal];
    [cancelButton setTitleColor:blueHColor forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    cancelButton.frame = CGRectMake(15, 0, 50, height);
    
    UIButton *finishedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    finishedButton.tag = 101;
    finishedButton.titleLabel.font  = [UIFont systemFontOfSize:14.0];
    [finishedButton setTitle:@"完成" forState:UIControlStateNormal];
    [finishedButton setTitleColor:blueColor forState:UIControlStateNormal];
    [finishedButton setTitleColor:blueHColor forState:UIControlStateHighlighted];
    [finishedButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    finishedButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    finishedButton.frame = CGRectMake(CGRectGetWidth(topView.frame)-65, 0, 50, height);
    
    [topView addSubview:cancelButton];
    [topView addSubview:finishedButton];
    [self.pickerView addSubview:topView];
    
    UIPickerView *areaPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, height, kPK_Screen_Width, kPK_PickerHeight-height)];
    areaPickerView.showsSelectionIndicator = YES;
    areaPickerView.delegate = self;
    areaPickerView.dataSource = self;
    [self.pickerView addSubview:areaPickerView];
    areaPickerView.backgroundColor = [UIColor whiteColor];
    self.areaPickerView = areaPickerView;
    
    self.buttons = @[cancelButton, finishedButton];
}

- (void)deviceOrientationDidChange {
    CGRect bounds = CGRectMake(0, 0, kPK_Screen_Width, kPK_Screen_Height);
    self.frame = bounds;
    self.coverView.frame = self.bounds;
    
    CGFloat height = 40;
    self.pickerView.frame = CGRectMake(0, kPK_Screen_Height-kPK_PickerHeight, CGRectGetWidth(self.bounds), kPK_PickerHeight);
    self.topView.frame = CGRectMake(0, 0, kPK_Screen_Width, height);
    
    UIView *view1 = self.buttons[0];
    view1.frame = CGRectMake(15, 0, 50, height);
    
    UIView *view2 = self.buttons[1];
    view2.frame = CGRectMake(CGRectGetWidth(self.topView.frame)-65, 0, 50, height);
    
    self.areaPickerView.frame = CGRectMake(0, height, kPK_Screen_Width, kPK_PickerHeight-height);
}

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    UIColor *heightColor = [tintColor colorWithAlphaComponent:0.5];
    for (UIButton *button in self.buttons) {
        [button setTitleColor:tintColor forState:UIControlStateNormal];
        [button setTitleColor:heightColor forState:UIControlStateHighlighted];
    }
}

- (void)setPickerType:(WDAreaPickerType)pickerType {
    _pickerType = pickerType;
    [self configurePickerViewData];
}

- (void)configurePickerViewData {
    NSArray *addArray = [self loadAreaDataFromResourceBundle];
    NSMutableArray *addressArray = [NSMutableArray arrayWithCapacity:addArray.count];
    
    NSInteger i = 0;
    for (NSDictionary *provinceDict in addArray) {
        NSString *provinceKey = [[provinceDict allKeys] firstObject];
        WDAreaAddressModel *model = [[WDAreaAddressModel alloc] init];
        model.provinceOrCity = provinceKey;
        NSDictionary *cityDic = [[provinceDict objectForKey:provinceKey] firstObject];
        model.cityOrDistrictArray = [cityDic allKeys];
        if (i == 0) {
            self.cityDataArray = [model.cityOrDistrictArray copy];
        }
        
        if (self.pickerType == WDAreaPickerType_All) {
            NSInteger j = 0;
            NSMutableArray *cityModels = [NSMutableArray arrayWithCapacity:model.cityOrDistrictArray.count];
            for (NSString *cityKey in model.cityOrDistrictArray) {
                WDAreaAddressModel *cityModel = [[WDAreaAddressModel alloc] init];
                cityModel.provinceOrCity = cityKey;
                cityModel.cityOrDistrictArray = [cityDic objectForKey:cityKey];
                [cityModels addObject:cityModel];
                if (i == 0 && j == 0) {
                    self.districtDataArray = [cityModel.cityOrDistrictArray copy];
                }
                j++;
            }
            model.cityModels = cityModels;
        }
        [addressArray addObject:model];
        i++;
    }
    self.areaDataArray = [addressArray copy];
}

- (void)setDistrictDataArray:(NSArray *)districtDataArray {
    NSMutableArray *array = [NSMutableArray arrayWithArray:districtDataArray];
    [array addObject:@"其他"];
    _districtDataArray = [array copy];
}

#pragma mark - public method

- (void)showPickerView {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow endEditing:YES];
    [keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.pickerView.frame = CGRectMake(self.pickerView.frame.origin.x, kPK_Screen_Height-kPK_PickerHeight, self.pickerView.frame.size.width, self.pickerView.frame.size.height);
        self.coverView.alpha = 0.2;
    }];
    // 切换数据源 恢复默认
    [self.areaPickerView selectRow:0 inComponent:0 animated:NO];
    // 调用delegate
    [self pickerView:self.areaPickerView didSelectRow:0 inComponent:0];
}

- (void)hidePickerView {
    [UIView animateWithDuration:0.25 animations:^{
        self.pickerView.frame = CGRectMake(self.pickerView.frame.origin.x, kPK_Screen_Height, self.pickerView.frame.size.width, self.pickerView.frame.size.height);
        self.coverView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)buttonClicked:(UIButton *)sender {
    [self pickerViewWithResult:101 == sender.tag];
}

- (void)pickerViewWithResult:(BOOL)confirm {
    if (self.areaResultBlock) {
        self.areaResultBlock(confirm?self.selestReslut:nil);
    }
    [self hidePickerView];
}

#pragma mark - pickerView deleagte & dataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (self.pickerType == WDAreaPickerType_All) {
        return 3;
    }
    else
        return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (0 == component) {
        return self.areaDataArray.count;
    }
    else if (1 == component) {
        return self.cityDataArray.count;
    }
    else {
        return self.districtDataArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (0 == component) {
        WDAreaAddressModel *model = self.areaDataArray[row];
        return model.provinceOrCity;
    }
    else if (1 == component) {
        return self.cityDataArray[row];
    }
    else {
        return self.districtDataArray[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (0 == component) {
        WDAreaAddressModel *provinceModel = self.areaDataArray[row];
        self.cityDataArray = provinceModel.cityOrDistrictArray;
        self.currentAreaModel = provinceModel;
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        
        self.selestProvince = provinceModel.provinceOrCity;
        
        if (self.pickerType == WDAreaPickerType_All) {
            WDAreaAddressModel *cityModel = self.currentAreaModel.cityModels[0];
            self.districtDataArray = cityModel.cityOrDistrictArray;
            self.selestCity = cityModel.provinceOrCity;
            self.selestDistrict = self.districtDataArray[0];
            
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:2 animated:YES];
        }
        else
            self.selestCity = provinceModel.cityOrDistrictArray[0];
    }
    else if (1 == component) {
        if (self.pickerType == WDAreaPickerType_All) {
            WDAreaAddressModel *cityModel = self.currentAreaModel.cityModels[row];
            self.districtDataArray = cityModel.cityOrDistrictArray;
            self.selestCity = cityModel.provinceOrCity;
            self.selestDistrict = self.districtDataArray[0];
            
            [pickerView selectRow:0 inComponent:2 animated:YES];
            [pickerView reloadComponent:2];
        }
        else
            self.selestCity = self.cityDataArray[row];
    }
    else {
        self.selestDistrict = self.districtDataArray[row];
    }
    
    if (self.pickerType == WDAreaPickerType_All) {
        self.selestReslut = [NSString stringWithFormat:@"%@-%@-%@",self.selestProvince,self.selestCity,self.selestDistrict];
    }
    else
        self.selestReslut = [NSString stringWithFormat:@"%@-%@",self.selestProvince,self.selestCity];
    
    if (self.areaChangedBlock) {
        self.areaChangedBlock(self.selestReslut);
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:15]];
    }
    
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

#pragma mark - Getting Resources from Bundle

+ (NSBundle *)getResourcesBundle {
    NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(@"WDAreaPickerView")];
    NSURL *bundleURL = [bundle URLForResource:@"WDAreaPicker" withExtension:@"bundle"];
    return [NSBundle bundleWithURL:bundleURL];
}

- (NSArray *)loadAreaDataFromResourceBundle {
    NSString *addressFilePath = [[WDAreaPickerView getResourcesBundle] pathForResource:@"address" ofType:@"plist"];
    NSArray *address = [NSArray arrayWithContentsOfFile:addressFilePath];
    return address;
}

@end
