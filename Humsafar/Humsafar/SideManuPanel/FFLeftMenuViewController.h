//
//  FFLeftMenuViewController.h
//  FabFurnish
//
//  Created by Amit Kumar on 08/05/15.
//  Copyright (c) 2015 Bluerock eServices Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFLeftMenuViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

    
@property (nonatomic, weak) IBOutlet UITableView *menuTableView;

@property (nonatomic, assign) BOOL isRoot;
@property (nonatomic, strong ) NSString *menuTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbl_name;
@property (weak, nonatomic) IBOutlet UIImageView *imgVw_userImg;

@end
