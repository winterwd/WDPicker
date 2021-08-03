//
//  WDatePickerView.h
//  WDPicker
//
//  Created by wd on 2017/5/5.
//  Copyright © 2017年 winter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDatePickerView : UIView

@property (nonatomic, strong) UIColor *tintColor;

/**
 返回结果日期格式 默认@"yyyy-MM-dd"
 */
@property (nonatomic, copy) NSString *dateFormat;

/**
 选择日期结果 格式dateFormat 默认@"yyyy-MM-dd"
 */
@property (nonatomic, copy) void(^dateResultBlock)(NSString *dateString);

/**
 选择日期 改变 格式dateFormat 默认@"yyyy-MM-dd"
 */
@property (nonatomic, copy) void(^dateChangedBlock)(NSString *dateString);


/**
 默认 UIDatePickerModeDate
 */
+ (instancetype)datePickerView;
+ (instancetype)datePickerViewWithMode:(UIDatePickerMode)datePickerMode;
- (void)showPickerView;
@end
