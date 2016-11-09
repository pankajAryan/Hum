//
//  PlacesSearchVC.m
//  Humsafar
//
//  Created by Rahul on 11/9/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "PlacesSearchVC.h"

@interface PlacesSearchVC ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtAddress;

@end

@implementation PlacesSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - btn action

- (IBAction)cancelBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)goBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
