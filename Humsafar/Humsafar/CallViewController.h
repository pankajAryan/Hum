//
//  CallViewController.h
//  Humsafar
//
//  Created by B0081006 on 10/22/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CallViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lbl_districtName;
- (IBAction)action_goBack:(id)sender;
- (IBAction)action_selectState:(id)sender;

@end
