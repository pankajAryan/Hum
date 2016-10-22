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

@end

@implementation CallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
    NSArray *arrayStates = [NSArray arrayWithObjects:@"A",@"B",@"C",@"D",nil];
    
    [ActionSheetStringPicker showPickerWithTitle:nil rows:arrayStates initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedValueIndex, id selectedValue) {
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        NSLog(@"Block Picker Canceled");
    } origin:sender];
}

@end
