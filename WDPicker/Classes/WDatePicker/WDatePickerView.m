//
//  WDatePicker.m
//  WDPicker
//
//  Created by wd on 2017/5/5.
//  Copyright © 2017年 winter. All rights reserved.
//

#import "WDatePickerView.h"

#define kPK_PickerHeight    240

#define kPK_Screen_Width    [UIScreen mainScreen].bounds.size.width
#define kPK_Screen_Height   [UIScreen mainScreen].bounds.size.height

#define kPK_KeyWindow       [UIApplication sharedApplication].keyWindow

@interface WDatePickerView ()
@property (weak, nonatomic) UIDatePicker *datePicker;

@property (nonatomic, strong) NSString *dateString;

@property (nonatomic, weak) UIView *topView;
@property (nonatomic, weak) UIView *dateView;
@property (nonatomic, weak) UIControl *coverView;

@property (nonatomic, strong) NSArray *buttons;

@property (nonatomic) UIDatePickerMode datePickerMode;
@end

@implementation WDatePickerView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"WDatePickerView dealloc");
}

+ (instancetype)datePickerView {
    return [self datePickerViewWithMode:UIDatePickerModeDate];
}

+ (instancetype)datePickerViewWithMode:(UIDatePickerMode)datePickerMode {
    CGRect frame = CGRectMake(0, 0, kPK_Screen_Width, kPK_Screen_Height);
    WDatePickerView *picker = [WDatePickerView datePickerViewWithFrame:frame];
    picker.datePickerMode = datePickerMode;
    return picker;
}

+ (instancetype)datePickerViewWithFrame:(CGRect)frame {
    WDatePickerView *datePickerView = [[WDatePickerView alloc] initWithFrame:frame];
    return datePickerView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    CGRect tempFrame = CGRectMake(0, 0, frame.size.width, kPK_Screen_Height);
    if (self = [super initWithFrame:tempFrame]) {
        self.backgroundColor = [UIColor clearColor];
        [self setupSubViews];
        
        NSDate *selectedDate = [NSDate date];
        self.dateString = [self dateString:selectedDate];
        
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
    
    UIView *dateView = [[UIView alloc] initWithFrame:CGRectMake(0, kPK_Screen_Height, CGRectGetWidth(self.bounds), kPK_PickerHeight)];
    self.dateView = dateView;
    self.dateView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.dateView];
    
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
    [self.dateView addSubview:topView];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, height, kPK_Screen_Width, kPK_PickerHeight-height)];
    [self.dateView addSubview:datePicker];
    datePicker.backgroundColor = [UIColor whiteColor];
    [datePicker setLocale:[NSLocale localeWithLocaleIdentifier:@"zh-CN"]];
    [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.datePicker = datePicker;
    
    self.buttons = @[cancelButton, finishedButton];
}

- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode {
    _datePickerMode = datePickerMode;
    [self.datePicker setDatePickerMode:datePickerMode];
}

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    UIColor *heightColor = [tintColor colorWithAlphaComponent:0.5];
    for (UIButton *button in self.buttons) {
        [button setTitleColor:tintColor forState:UIControlStateNormal];
        [button setTitleColor:heightColor forState:UIControlStateHighlighted];
    }
}

- (void)deviceOrientationDidChange {
    CGRect bounds = CGRectMake(0, 0, kPK_Screen_Width, kPK_Screen_Height);
    self.frame = bounds;
    self.coverView.frame = self.bounds;
    
    CGFloat height = 40;
    self.dateView.frame = CGRectMake(0, kPK_Screen_Height-kPK_PickerHeight, CGRectGetWidth(self.bounds), kPK_PickerHeight);
    self.topView.frame = CGRectMake(0, 0, kPK_Screen_Width, height);
    
    UIView *view1 = self.buttons[0];
    view1.frame = CGRectMake(15, 0, 50, height);
    
    UIView *view2 = self.buttons[1];
    view2.frame = CGRectMake(CGRectGetWidth(self.topView.frame)-65, 0, 50, height);
    
    self.datePicker.frame = CGRectMake(0, height, kPK_Screen_Width, kPK_PickerHeight-height);
}

#pragma mark - method

- (void)showPickerView {
    [kPK_KeyWindow endEditing:YES];
    [kPK_KeyWindow addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.dateView.frame = CGRectMake(self.dateView.frame.origin.x, kPK_Screen_Height-kPK_PickerHeight, self.dateView.frame.size.width, self.dateView.frame.size.height);
        self.coverView.alpha = 0.2;
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.25 animations:^{
        self.dateView.frame = CGRectMake(self.dateView.frame.origin.x, kPK_Screen_Height, self.dateView.frame.size.width, self.dateView.frame.size.height);
        self.coverView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (NSString *)dateString:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (self.dateFormat) {
        [dateFormatter setDateFormat:self.dateFormat];
    }
    else
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:date];
}

- (void)buttonClicked:(UIButton *)sender {
    if (100 == sender.tag) {
        // 取消
        if (self.dateResultBlock) {
            self.dateResultBlock(nil);
        }
    }
    else {
        // 确定
        if (self.dateResultBlock) {
            self.dateResultBlock(self.dateString);
        }
    }
    [self hide];
}

- (void)datePickerValueChanged:(UIDatePicker *)sender {
    NSDate *selectedDate = [sender date];
    self.dateString = [self dateString:selectedDate];
    if (self.dateChangedBlock) {
        self.dateChangedBlock(self.dateString);
    }
}

@end
