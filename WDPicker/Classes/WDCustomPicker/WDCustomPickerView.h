//
//  WDCustomPickerView.h
//  WDPicker
//
//  Created by wd on 2017/5/15.
//  Copyright © 2017年 winter. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 自定义picker 目前只支持单一列表
 */
@interface WDCustomPickerView : UIView
@property (nonatomic, strong) UIColor *tintColor;

/**
 选择地址 结果
 */
@property (nonatomic, copy) void(^customResultBlock)(NSString *customString);

/**
 选择地址 改变
 */
@property (nonatomic, copy) void(^customChangedBlock)(NSString *customString);

/**
 实例化CustomPickerView

 @param block id: [string] or [[string], [string]]
 @return CustomPickerView对象
 */
+ (instancetype)customPickerViewWithItem:(nullable id (^)(void))block;
- (void)showPickerView;
- (void)hidePickerView;
@end

NS_ASSUME_NONNULL_END
