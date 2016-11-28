//
//  HomeListVC.m
//  Humsafar
//
//  Created by Rahul on 10/22/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "HomeListVC.h"

@interface HomeListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *lbl_title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_subTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbl_date;

@end

@implementation HomeListTableViewCell

-(void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius = 8.0;
    self.bgView.layer.masksToBounds = YES;
    
    self.lbl_title.font = [UIFont boldSystemFontOfSize:16];
    self.lbl_subTitle.font = [UIFont systemFontOfSize:14];
    self.lbl_date.font = [UIFont systemFontOfSize:12];
}

@end


@interface HomeListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) NSArray *arrayList;
@property (weak, nonatomic) IBOutlet UITableView *tblView;

@end

@implementation HomeListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tblView.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self fetchDataListFromServer];
}

-(void)fetchDataListFromServer {
    
    NSString *strCat = @"";
    
    switch (self.homeListVCType) {
        case HomeListVCTypeJams:
            strCat = @"Jams";
            break;
        case HomeListVCTypeDiversions:
            strCat = @"Diversions";
            break;
        case HomeListVCTypeVIPMovements:
            strCat = @"VIP Movements";
            break;
        case HomeListVCTypeSuggestions:
            strCat = @"Suggestions";
            break;
        default:
            break;
    }
    
    [self showProgressHudWithMessage:@"Loading..."];

    [[FFWebServiceHelper sharedManager] callWebServiceWithUrl:GetAlertsForCategory withParameter:@{@"category" : strCat, @"stateId" : [UIViewController retrieveDataFromUserDefault:@"selectedStateDict"][@"stateId"], @"districtId" : [UIViewController retrieveDataFromUserDefault:@"selectedDistrictDict"][@"districtId"]} onCompletion:^(eResponseType responseType, id response) {
        
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
    
    HomeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeListTableViewCell" forIndexPath:indexPath];
    
    NSDictionary *dict = self.arrayList[indexPath.row];
    
    cell.lbl_title.text = dict[@"title"];
    cell.lbl_subTitle.text = dict[@"message"];
    cell.lbl_date.text = [UIViewController formattedDate:dict[@"date"]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict = self.arrayList[indexPath.row];
    
    CGFloat height = 0;
    
    height += 10;
    
    height += [dict[@"title"] boundingRectWithSize:CGSizeMake(ScreenWidth-50, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:16]} context:nil].size.height;
    
    height += 10;

    height += [dict[@"message"] boundingRectWithSize:CGSizeMake(ScreenWidth-50, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;

    height += 10;// line
    height += 44;// bg view

    height += 10;// contentView

    return height;
}


@end
