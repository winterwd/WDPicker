//
//  WDCustomPickerView.m
//  WDPicker
//
//  Created by wd on 2017/5/15.
//  Copyright © 2017年 winter. All rights reserved.
//

#import "WDCustomPickerView.h"

#define kPK_PickerHeight    200

#define kPK_Screen_Width    [UIScreen mainScreen].bounds.size.width
#define kPK_Screen_Height   [UIScreen mainScreen].bounds.size.height

@interface WDCustomPickerView  ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *areaPickerView;
@property (nonatomic, weak) UIView *pickerView;
@property (nonatomic, weak) UIView *topView;
@property (nonatomic, weak) UIControl *coverView;
@property (nonatomic, strong) NSArray *buttons;

@property (nonatomic, copy) id (^itemBlock)(void);
@property (nonatomic, strong) NSArray<NSArray<NSString *> *> *itemArray;
@property (nonatomic, copy) NSString *selestReslut;

@property (nonatomic, assign) NSInteger components;
@property (nonatomic, strong) NSArray<NSNumber *> *rows;
@property (nonatomic, strong) NSMutableArray<NSString *> *results;
@end

@implementation WDCustomPickerView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"WDCustomPickerView dealloc");
}

+ (instancetype)customPickerViewWithItem:(nullable id (^)(void))block {
    if (block) {
        CGRect frame = CGRectMake(0, 0, kPK_Screen_Width, kPK_Screen_Height);
        WDCustomPickerView *picker = [[WDCustomPickerView alloc] initWithFrame:frame];
        picker.itemBlock = block;
        return picker;
    }
    else {
        NSLog(@"【WDCustomPickerView】‘block’ must not be nil!");
        return nil;
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    CGRect tempFrame = CGRectMake(0, 0, frame.size.width, kPK_Screen_Height);
    if (self = [super initWithFrame:tempFrame]) {
        self.backgroundColor = [UIColor clearColor];
        [self setupSubViews];
        _components = 0;
        _results = [NSMutableArray array];
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

- (void)setItemBlock:(id (^)(void))itemBlock {
    _itemBlock = itemBlock;
    id obj = _itemBlock();
    if ([obj isKindOfClass:[NSArray class]]) {
        Class objCls = NULL;
        NSArray *objs = (NSArray *)obj;
        NSInteger count = objs.count;
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < count; i++) {
            id string = objs[i];
            if (objCls == NULL) {
                // 第一次识别数组内容类型
                if ([string isKindOfClass:[NSString class]]) {
                    objCls = [NSString class];
                    [array addObject:string];
                }
                else if ([string isKindOfClass:[NSArray class]]) {
                    objCls = [NSArray class];
                    NSArray *strArray = (NSArray *)string;
                    NSMutableArray *objArray = [NSMutableArray arrayWithCapacity:strArray.count];
                    for (id str in strArray) {
                        if ([str isKindOfClass:[NSString class]]) {
                            [objArray addObject:str];
                        }
                    }
                    [array addObject:objArray];
                }
            }
            else if ([objCls isSubclassOfClass:[NSString class]]) {
                if ([string isKindOfClass:[NSString class]]) {
                    [array addObject:string];
                }
            }
            else if ([objCls isSubclassOfClass:[NSArray class]]) {
                if ([string isKindOfClass:[NSArray class]]) {
                    NSArray *strArray = (NSArray *)string;
                    NSMutableArray *objArray = [NSMutableArray arrayWithCapacity:strArray.count];
                    for (id str in strArray) {
                        if ([str isKindOfClass:[NSString class]]) {
                            [objArray addObject:str];
                        }
                    }
                    [array addObject:objArray];
                }
            }
        }
        if ([objCls isSubclassOfClass:[NSArray class]]) {
            self.itemArray = [array copy];
        }
        else
            self.itemArray = @[[array copy]];
        
        self.components = self.itemArray.count;
        NSMutableArray *counts = [NSMutableArray arrayWithCapacity:_components];
        for (int i = 0; i < _components; i++) {
            NSArray *objs = self.itemArray[i];
            [_results addObject:[objs firstObject]];
            [counts addObject:[NSNumber numberWithInteger:objs.count]];
        }
        self.rows = [counts copy];
    }
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
    if (self.customResultBlock) {
        self.customResultBlock(confirm?self.selestReslut:nil);
    }
    [self hidePickerView];
}

#pragma mark - pickerView deleagte & dataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.components;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.rows[component] integerValue];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.itemArray[component][row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *result = self.itemArray[component][row];
    
    if (self.components == 1) {
        self.selestReslut = result;
    }
    else {
        [self.results replaceObjectAtIndex:component withObject:result];
        NSString *string = self.results.firstObject;
        for (int i = 1; i < self.components; i++) {
            NSString *obj = self.results[i];
            string = [string stringByAppendingString:[NSString stringWithFormat:@"-%@",obj]];
        }
        self.selestReslut = string;
    }
    
    if (self.customChangedBlock) {
        self.customChangedBlock(self.selestReslut);
    }
}

//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
//    UILabel* pickerLabel = (UILabel*)view;
//    if (!pickerLabel){
//        pickerLabel = [[UILabel alloc] init];
//        pickerLabel.adjustsFontSizeToFitWidth = YES;
//        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
//        [pickerLabel setBackgroundColor:[UIColor clearColor]];
//        [pickerLabel setFont:[UIFont systemFontOfSize:15]];
//    }
//    
//    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
//    return pickerLabel;
//}

@end
