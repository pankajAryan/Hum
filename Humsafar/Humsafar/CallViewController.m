//
//  CallViewController.m
//  Humsafar
//
//  Created by B0081006 on 10/22/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "CallViewController.h"
#import "ActionSheetStringPicker.h"

@interface CallViewController ()
{
    NSArray *arrayDistrictsInfo;
    NSMutableArray *arrayDistrictsNames;
}
@end

@implementation CallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arrayDistrictsNames = [NSMutableArray new];
    arrayDistrictsInfo = [UIViewController retrieveDataFromUserDefault:@"selectedStateDistrictArray"];
    for (NSDictionary *info in arrayDistrictsInfo) {
        [arrayDistrictsNames addObject:info[@"districtName"]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)action_goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIActionSheetPicker

-(IBAction)action_selectState:(id)sender{
    [ActionSheetStringPicker showPickerWithTitle:nil rows:arrayDistrictsNames initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedValueIndex, id selectedValue) {
        self.lbl_districtName.text = selectedValue;
        NSDictionary *dict_dictrictInfo = [arrayDistrictsInfo objectAtIndex:selectedValueIndex];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DistrictSelectionNotification" object:nil userInfo:dict_dictrictInfo];
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        NSLog(@"Block Picker Canceled");
    } origin:sender];
}

@end
