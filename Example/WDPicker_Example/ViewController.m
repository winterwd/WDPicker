//
//  ViewController.m
//  WDPicker
//
//  Created by wd on 05/05/2017.
//  Copyright (c) 2017 winter. All rights reserved.
//

#import "ViewController.h"
#import "WDatePickerView.h"
#import "WDAreaPickerView.h"
#import "WDCustomPickerView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)datePicker:(id)sender {
    WDatePickerView *datePicker = [WDatePickerView datePickerViewWithMode:UIDatePickerModeDate];
    datePicker.dateFormat = @"yyyy-MM-dd-HH-mm-ss";
    [datePicker setTintColor:[UIColor redColor]];
    [datePicker showPickerView];
    
    __weak typeof(self) weakSelf = self;
    datePicker.dateResultBlock = ^(NSString *dateString) {
        if (dateString == nil) {
            dateString = @"取消操作";
        }
        weakSelf.resultLabel.text = dateString;
    };
    
    datePicker.dateChangedBlock = ^(NSString *dateString) {
        weakSelf.resultLabel.text = dateString;
    };
}

- (IBAction)arerPicker:(id)sender {
    WDAreaPickerView *areaPicker = [WDAreaPickerView areaPickerViewWithType:WDAreaPickerType_City];
    [areaPicker setTintColor:[UIColor redColor]];
    [areaPicker showPickerView];
    
    __weak typeof(self) weakSelf = self;
    areaPicker.areaResultBlock = ^(NSString *dateString) {
        if (dateString == nil) {
            dateString = @"取消操作";
        }
        weakSelf.resultLabel.text = dateString;
    };
    
    areaPicker.areaChangedBlock = ^(NSString *dateString) {
        weakSelf.resultLabel.text = dateString;
    };
}

- (IBAction)customPicker:(id)sender {
    WDCustomPickerView *customPicker = [WDCustomPickerView customPickerViewWithItem:^id {
//        return @[@"1", @"2", @"3"];
//        return @[@[@"1", @"2", @"3"]];
        return @[@[@"1", @"2", @"3"], @[@"0"], @[@"4", @"5", @"6"], @[@"1"]];
    }];
    [customPicker setTintColor:[UIColor redColor]];
    [customPicker showPickerView];
    
    __weak typeof(self) weakSelf = self;
    customPicker.customResultBlock = ^(NSString *dateString) {
        if (dateString == nil) {
            dateString = @"取消操作";
        }
        weakSelf.resultLabel.text = dateString;
    };
    
    customPicker.customChangedBlock =  ^(NSString *dateString) {
        weakSelf.resultLabel.text = dateString;
    };
}
@end
