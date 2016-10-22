//
//  HomeViewController.m
//  Humsafar
//
//  Created by Pankaj Yadav on 12/10/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "HomeViewController.h"
#import "UIViewController+RESideMenu.h"
#import "ReportViewController.h"

@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btn_menu;
@property (strong, nonatomic) NSString *navType;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [_btn_menu addTarget:self action:@selector(presentLeftMenuViewController:) forControlEvents:UIControlEventTouchUpInside];
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


#pragma mark- ImagePickerControllerDelegate

-(IBAction)action_openCamera:(id)sender{
    if ([sender tag] == 1) {
        self.navType = @"emergency";
        UIImagePickerController *imagePicker= [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing = YES;
        [imagePicker setNavigationBarHidden:YES];
        [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
    }else if ([sender tag] == 2){
        self.navType = @"report";
        UIImagePickerController *imagePicker= [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing = YES;
        [imagePicker setNavigationBarHidden:YES];
        [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    [self dismissViewControllerAnimated:YES completion:^{
        UIStoryboard *homeStory = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
        ReportViewController *vcReport = [homeStory instantiateViewControllerWithIdentifier:@"ReportViewController"];
        vcReport.image = image;
        vcReport.navType = self.navType;
        [self.navigationController pushViewController:vcReport animated:NO];
    }];
}

@end
