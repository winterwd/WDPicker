//
//  ViewController.m
//  WDatePicker
//
//  Created by wd on 05/05/2017.
//  Copyright (c) 2017 winter. All rights reserved.
//

#import "ViewController.h"
#import "WDatePickerView.h"

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
    WDatePickerView *datePicker = [WDatePickerView datePickerViewWithMode:UIDatePickerModeDateAndTime];
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

@end
