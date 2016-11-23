//
//  MyIncentiveVC.m
//  Humsafar
//
//  Created by Rahul on 11/24/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "MyIncentiveVC.h"

@interface MyIncentiveVC ()

@end

@implementation MyIncentiveVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Btn Action

- (IBAction)backBtnACTION:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
