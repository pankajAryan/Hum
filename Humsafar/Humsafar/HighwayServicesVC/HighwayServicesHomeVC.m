//
//  HighwayServicesHomeVC.m
//  Humsafar
//
//  Created by Rahul on 10/22/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "HighwayServicesHomeVC.h"

@interface HighwayServicesHomeVC ()

@end

@implementation HighwayServicesHomeVC

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
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
