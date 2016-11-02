//
//  HomeListVC2.m
//  Humsafar
//
//  Created by Rahul on 10/26/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "HomeListVC2.h"
#import "UIImageView+AFNetworking.h"

@interface HomeList2TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *lbl_title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_subTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbl_date;
@property (weak, nonatomic) IBOutlet UILabel *lbl_name;

@end

@implementation HomeList2TableViewCell

-(void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius = 8.0;
    self.bgView.layer.masksToBounds = YES;
    
    self.lbl_title.font = [UIFont systemFontOfSize:14];
    self.lbl_subTitle.font = [UIFont systemFontOfSize:12];
    self.lbl_date.font = [UIFont systemFontOfSize:10];
    self.lbl_name.font = [UIFont systemFontOfSize:12];

}

@end


@interface HomeListVC2 ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) NSArray *arrayList;
@property (weak, nonatomic) IBOutlet UITableView *tblView;

@end

@implementation HomeListVC2

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
    
    NSString *strURL = @"";
    
    switch (self.homeListVC2Type) {
        case HomeListVC2TypeEmergencie:
            strURL = GetListOfReportedEmergencies;
            break;
        case HomeListVC2TypeIssue:
            strURL = GetListOfReportedIssues;
            break;
        default:
            break;
    }
    
    [self showProgressHudWithMessage:@"Loading..."];
    
    [[FFWebServiceHelper sharedManager] callWebServiceWithUrl:strURL withParameter:@{@"stateId" :  [UIViewController retrieveDataFromUserDefault:@"selectedStateDict"][@"stateId"]} onCompletion:^(eResponseType responseType, id response) {
        
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
    
    HomeList2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeList2TableViewCell" forIndexPath:indexPath];
    
    NSDictionary *dict = self.arrayList[indexPath.row];
    
    cell.lbl_title.text = dict[@"description"];
    cell.lbl_subTitle.text = [NSString stringWithFormat:@"lat : %@, log : %@",dict[@"lat"],dict[@"lon"]];
    cell.lbl_date.text = dict[@"postedOn"];
    cell.lbl_name.text = dict[@"postedBy"];
    
    [cell.imgView setImageWithURL:[NSURL URLWithString:dict[@"uploadedImageURL"]] placeholderImage:nil];

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict = self.arrayList[indexPath.row];
    
    CGFloat height = 5;
    
    height += 10;//space
    
    height += ScreenWidth-50;// imgView

    height += 10;//space

    height += [dict[@"description"] boundingRectWithSize:CGSizeMake(ScreenWidth-50, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
    
    height += 10;//space
    
    height += [[NSString stringWithFormat:@"lat : %@, log : %@",dict[@"lat"],dict[@"lon"]] boundingRectWithSize:CGSizeMake(ScreenWidth-50, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil].size.height;
    
    height += 10;// space
    height += 1;// line height
    height += 5;// space
    height += 30;// name/img/date height
    height += 5;// space
    height += 5;// contentView
    
    return height;
}



@end
