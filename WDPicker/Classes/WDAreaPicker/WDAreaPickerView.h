//
//  WDAreaPickerView.h
//  WDPicker
//
//  Created by wd on 2017/5/8.
//  Copyright © 2017年 winter. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WDAreaPickerType) {
    WDAreaPickerType_All = 0, // 默认省市区
    WDAreaPickerType_City // 省市
};


@interface WDAreaPickerView : UIView

@property (nonatomic, strong) UIColor *tintColor;

/**
 选择地址 结果 格式：@"省-市-区"
 */
@property (nonatomic, copy) void(^areaResultBlock)(NSString *dateString);

/**
 选择地址 改变 格式：@"省-市-区"
 */
@property (nonatomic, copy) void(^areaChangedBlock)(NSString *dateString);


/**
 pickerType is WDAreaPickerType_All
 */
+ (instancetype)areaDefaultPickerView;
+ (instancetype)areaPickerViewWithType:(WDAreaPickerType)pickerType;
- (void)showPickerView;
- (void)hidePickerView;
@end
