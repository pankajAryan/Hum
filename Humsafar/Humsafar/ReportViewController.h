//
//  ReportViewController.h
//  Humsafar
//
//  Created by B0081006 on 10/22/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportViewController : UIViewController<UITextFieldDelegate>

@property (strong,nonatomic)UIImage *image;
@property (weak, nonatomic) IBOutlet UIImageView *imgVw_reportImg;
@property (weak, nonatomic) IBOutlet UIButton *button_selectIssueType;
@property (weak, nonatomic) IBOutlet UITextField *txtVw_desc;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollVw_report;
@property (strong, nonatomic) NSString *navType;
@property (weak, nonatomic) IBOutlet UILabel *label_title;
@property (weak, nonatomic) IBOutlet UIImageView *imgVw_dropdown;

- (IBAction)action_selectIssueType:(id)sender;
- (IBAction)action_goBack:(id)sender;
- (IBAction)action_done:(id)sender;
@end
