//
//  MyFeedsVC.m
//  Humsafar
//
//  Created by Rahul on 11/24/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "MyFeedsVC.h"

@interface MyFeedsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *lbl_title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_subTitle1;
@property (weak, nonatomic) IBOutlet UILabel *lbl_subTitle2;
@property (weak, nonatomic) IBOutlet UILabel *lbl_date;

@end

@implementation MyFeedsTableViewCell

-(void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius = 8.0;
    self.bgView.layer.masksToBounds = YES;
    
    self.lbl_title.font = [UIFont boldSystemFontOfSize:16];
    self.lbl_subTitle1.font = [UIFont systemFontOfSize:14];
    self.lbl_subTitle2.font = [UIFont systemFontOfSize:12];
    self.lbl_date.font = [UIFont systemFontOfSize:10];
}

@end

@interface MyFeedsVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) NSArray *arrayList;
@property (weak, nonatomic) IBOutlet UITableView *tblView;

@end

@implementation MyFeedsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tblView.tableFooterView = [UIView new];
    [self fetchDataListFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Btn Action

- (IBAction)backBtnACTION:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)fetchDataListFromServer {
    
    [self showProgressHudWithMessage:@"Loading..."];
    
    [[FFWebServiceHelper sharedManager] callWebServiceWithUrl:GetDepartmentUserFeed withParameter:@{@"userMobile" : [UIViewController retrieveDataFromUserDefault:@"mobile"]} onCompletion:^(eResponseType responseType, id response) {
        
        [self hideProgressHudAfterDelay:.1];
        
        if (responseType == eResponseTypeSuccessJSON) {
            self.arrayList = [response objectForKey:kKEY_ResponseObject];
        }else{
            [self showResponseErrorWithType:eResponseTypeFailJSON responseObject:response errorMessage:nil];
        }
        
        [self.tblView reloadData];
    }];
}

#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.arrayList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyFeedsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyFeedsTableViewCell" forIndexPath:indexPath];
    
    NSDictionary *dict = self.arrayList[indexPath.row];
    
    cell.lbl_title.text = dict[@"title"];
    cell.lbl_subTitle1.text = dict[@"message"];
    cell.lbl_subTitle2.text = dict[@"from"];
    cell.lbl_date.text = [UIViewController formattedDate:dict[@"createdOn"]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict = self.arrayList[indexPath.row];
    
    CGFloat height = 0;
    
    height += 5;

    height += 10;
    
    height += [dict[@"title"] boundingRectWithSize:CGSizeMake(ScreenWidth-50, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:16]} context:nil].size.height;
    
    height += 10;
    
    height += [dict[@"message"] boundingRectWithSize:CGSizeMake(ScreenWidth-50, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
    
    height += 10;
    
    height += [dict[@"from"] boundingRectWithSize:CGSizeMake(ScreenWidth-50, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil].size.height;
    
    height += 10;// line
    height += 44;// 8+28+8 bg view
    
    height += 5;// contentView
    
    return height;
}


@end
