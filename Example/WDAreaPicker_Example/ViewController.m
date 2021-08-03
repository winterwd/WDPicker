//
//  ViewController.m
//  WDAreaPicker_Example
//
//  Created by wd on 05/05/2017.
//  Copyright (c) 2017 winter. All rights reserved.
//

#import "ViewController.h"
#import "WDAreaPickerView.h"

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
@end
