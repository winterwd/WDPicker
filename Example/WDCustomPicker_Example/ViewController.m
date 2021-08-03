//
//  ViewController.m
//  WDCustomPicker_Example
//
//  Created by wd on 2017/5/15.
//  Copyright © 2017年 winter. All rights reserved.
//

#import "ViewController.h"
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

- (IBAction)arerPicker:(id)sender {
    WDCustomPickerView *customPicker = [WDCustomPickerView customPickerViewWithItem:^id _Nonnull{
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
