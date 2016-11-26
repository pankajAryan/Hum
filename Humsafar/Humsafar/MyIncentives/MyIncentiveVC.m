//
//  MyIncentiveVC.m
//  Humsafar
//
//  Created by Rahul on 11/24/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "MyIncentiveVC.h"

@interface MyIncentiveTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *lbl_title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_subTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbl_date;

@end

@implementation MyIncentiveTableViewCell

-(void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius = 8.0;
    self.bgView.layer.masksToBounds = YES;
    
    self.lbl_title.font = [UIFont boldSystemFontOfSize:14];
    self.lbl_subTitle.font = [UIFont systemFontOfSize:12];
    self.lbl_date.font = [UIFont systemFontOfSize:10];
}

@end

@interface MyIncentiveVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) NSArray *arrayList;
@property (weak, nonatomic) IBOutlet UITableView *tblView;

@property (weak, nonatomic) IBOutlet UILabel *lbl_noDataToShow;
@end

@implementation MyIncentiveVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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

#pragma mark -

-(void)fetchDataListFromServer {
    
    [self showProgressHudWithMessage:@"Loading..."];
    
    [[FFWebServiceHelper sharedManager] callWebServiceWithUrl:GetIncentivesForUser withParameter:@{@"userMobile" : [UIViewController retrieveDataFromUserDefault:@"mobile"]} onCompletion:^(eResponseType responseType, id response) {
        
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
    
    if ([self.arrayList count] == 0) {
        self.lbl_noDataToShow.hidden = NO;
        tableView.hidden = YES;
    }else{
        self.lbl_noDataToShow.hidden = YES;
        tableView.hidden = NO;
    }
    return [self.arrayList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyIncentiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIncentiveTableViewCell" forIndexPath:indexPath];
    
    NSDictionary *dict = self.arrayList[indexPath.row];
    
    cell.lbl_title.text = [NSString stringWithFormat:@"%@ points",dict[@"amount"]];
    cell.lbl_subTitle.text = dict[@"reason"];
    cell.lbl_date.text = [UIViewController formattedDate:dict[@"createdOn"]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict = self.arrayList[indexPath.row];
    
    CGFloat height = 0;
    
    height += 10;
    
    height += [[NSString stringWithFormat:@"%@ points",dict[@"amount"]] boundingRectWithSize:CGSizeMake(ScreenWidth-50, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:14]} context:nil].size.height;
    
    height += 10;
    
    height += [dict[@"reason"] boundingRectWithSize:CGSizeMake(ScreenWidth-50, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil].size.height;
    
    height += 10;// line
    height += 44;// bg view
    
    height += 10;// contentView
    
    return height;
}

@end
