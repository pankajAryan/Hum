//
//  CallListVC.m
//  Humsafar
//
//  Created by B0081006 on 10/22/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "CallListVC.h"

@interface CallListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *lbl_title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_subTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbl_date;
@property (weak, nonatomic) IBOutlet UITextView *txtVw_phonenumber;

@end

@implementation CallListTableViewCell

-(void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius = 8.0;
    self.bgView.layer.masksToBounds = YES;
    
    self.lbl_title.font = [UIFont systemFontOfSize:14];
    self.lbl_subTitle.font = [UIFont systemFontOfSize:12];
    self.lbl_date.font = [UIFont systemFontOfSize:10];
}

@end

@interface CallListVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSDictionary *selectedDistrictInfo;
}
@property (nonatomic) NSArray *arrayList;
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (strong, nonatomic) NSArray *filteredresultList;

@end

@implementation CallListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tblView.tableFooterView = [UIView new];
    
    selectedDistrictInfo = [UIViewController retrieveDataFromUserDefault:@"selectedDistrictDict"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self fetchDataListFromServer];
    
    if (self.callListVCType != CallListVCTypeOther) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectDistrict:) name:@"DistrictSelectionNotification" object:nil];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if ([self.txtField_search isFirstResponder])
        [self.txtField_search resignFirstResponder];

    if (self.callListVCType != CallListVCTypeOther) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DistrictSelectionNotification" object:nil];
    }
}

-(void)selectDistrict:(NSNotification*)notification {
    selectedDistrictInfo = [notification userInfo];
    [self fetchDataListFromServer];
}


-(void)fetchDataListFromServer {
    
    NSString *strCat = @"";
    
    switch (self.callListVCType) {
        case CallListVCTypeMedical:
            strCat = @"Medical";
            break;
        case CallListVCTypePolice:
            strCat = @"Police";
            break;
        case CallListVCTypeTransport:
            strCat = @"Transport";
            break;
        case CallListVCTypeOther:
            strCat = @"Police";
            break;
            
            
        default:
            break;
    }
    
    
    if (self.callListVCType == CallListVCTypeOther) {
        //CallListVCTypeOther change it
        NSString *stateId = @"29";//selectedDistrictInfo[@"stateId"];
        NSString *districtId = @"2";//selectedDistrictInfo[@"districtId"];
        
        if (stateId == nil || districtId == nil) {
            return;
        }
        
        [[FFWebServiceHelper sharedManager] callWebServiceWithUrl:GetEmergencyServices withParameter:@{@"department" : strCat, @"stateId" : stateId, @"districtId" : districtId} onCompletion:^(eResponseType responseType, id response) {
            
            @try {
                if (responseType == eResponseTypeSuccessJSON) {
                    self.arrayList = [response objectForKey:kKEY_ResponseObject];
                    self.filteredresultList = [NSArray arrayWithArray:self.arrayList];
                }else{
                    [self showResponseErrorWithType:eResponseTypeFailJSON responseObject:response errorMessage:nil];
                }
            } @catch (NSException *exception) {
                
            }
            
            [self.tblView reloadData];
        }];
        
        return;
    }
    
    NSString *stateId = selectedDistrictInfo[@"stateId"];
    NSString *districtId = selectedDistrictInfo[@"districtId"];

    if ([[UIViewController retrieveDataFromUserDefault:@"loginType"] isEqualToString:@"department"]) {
        stateId = @"29";
        districtId = @"2";
    }
    
    if (stateId == nil || districtId == nil) {
        return;
    }
    
    [[FFWebServiceHelper sharedManager] callWebServiceWithUrl:GetEmergencyServices withParameter:@{@"department" : strCat, @"stateId" : stateId, @"districtId" : districtId} onCompletion:^(eResponseType responseType, id response) {
        
        if (responseType == eResponseTypeSuccessJSON) {
            self.arrayList = [response objectForKey:kKEY_ResponseObject];
            self.filteredresultList = [NSArray arrayWithArray:self.arrayList];
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
    return self.filteredresultList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CallListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CallListTableViewCell" forIndexPath:indexPath];
    
    NSDictionary *dict = self.filteredresultList[indexPath.row];
    
    if (self.callListVCType == CallListVCTypeOther) {
        //CallListVCTypeOther change it
        cell.lbl_title.text = dict[@"name"];
        cell.txtVw_phonenumber.text = dict[@"phoneNumbers"];
    }else{
        cell.lbl_title.text = dict[@"name"];
        cell.txtVw_phonenumber.text = dict[@"phoneNumbers"];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict = self.filteredresultList[indexPath.row];
    
    CGFloat height = 0;
    
    height += 10;
    
    if (self.callListVCType == CallListVCTypeOther) {
        //CallListVCTypeOther change it
        height += [dict[@"name"] boundingRectWithSize:CGSizeMake(ScreenWidth-50, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
        
        height += 10;
        
        height += [dict[@"phoneNumbers"] boundingRectWithSize:CGSizeMake(ScreenWidth-50, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil].size.height;
    }else{
        height += [dict[@"name"] boundingRectWithSize:CGSizeMake(ScreenWidth-50, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
        
        height += 10;
        
        height += [dict[@"phoneNumbers"] boundingRectWithSize:CGSizeMake(ScreenWidth-50, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil].size.height;
    }
    
    
    height += 10;// line
    height += 44;// bg view
    
    height += 10;// contentView
    
    return height;
}


#pragma mark - Searching Functionality

- (void)filterContentForSearchText:(NSString*)searchText
{
    if (searchText.length == 0 && [searchText isEqualToString:@""])
    {
        self.filteredresultList=nil;
        self.filteredresultList = [NSArray arrayWithArray:self.arrayList];
        [self.tblView reloadData];
    }
    else
    {
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.name CONTAINS [c] %@ ",searchText];
        self.filteredresultList =nil;
        self.filteredresultList = [self.arrayList filteredArrayUsingPredicate:resultPredicate];
        [self.tblView reloadData];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString* searchText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self filterContentForSearchText:searchText];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    self.filteredresultList = [NSArray arrayWithArray:self.arrayList];
    [self.tblView reloadData];
    return YES;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.txtField_search isFirstResponder])
        [self.txtField_search resignFirstResponder];
}


@end
