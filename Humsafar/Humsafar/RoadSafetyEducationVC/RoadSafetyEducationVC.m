//
//  RoadSafetyEducationVC.m
//  Humsafar
//
//  Created by Rahul on 10/22/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "RoadSafetyEducationVC.h"
#import "WebViewController.h"

#import "UIImageView+AFNetworking.h"

@interface RoadSafetyEducationListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *lbl_title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_date;
@property (weak, nonatomic) IBOutlet UILabel *lbl_subTitle;

@end

@implementation RoadSafetyEducationListTableViewCell

-(void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius = 8.0;
    self.bgView.layer.masksToBounds = YES;
    
    self.lbl_title.font = [UIFont boldSystemFontOfSize:16];
    self.lbl_date.font = [UIFont systemFontOfSize:12];
    self.lbl_subTitle.font = [UIFont systemFontOfSize:12];
}

@end


@interface RoadSafetyEducationVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *lat;
    NSString *lon;
}
@property (nonatomic, strong) CLLocationManager *manager;

@property (nonatomic) NSArray *arrayList;
@property (weak, nonatomic) IBOutlet UITableView *tblView;

@end

@implementation RoadSafetyEducationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tblView.tableFooterView = [UIView new];
    self.manager = [CLLocationManager updateManagerWithAccuracy:100.0 locationAge:15.0 authorizationDesciption:CLLocationUpdateAuthorizationDescriptionWhenInUse];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self fetchDataListFromServer];
}

#pragma mark -

-(void)fetchDataListFromServer {
    
    NSString *strCat = @"";
    
    switch (self.roadSafetyEducationVCType) {
        case RoadSafetyEducationVCTypeVideos:
            strCat = @"video";
            break;
        case RoadSafetyEducationVCTypePDFs:
            strCat = @"pdf";
            break;
        default:
            break;
    }
    
    [[FFWebServiceHelper sharedManager] callWebServiceWithUrl:GetEducationContentForType withParameter:@{@"type" : strCat} onCompletion:^(eResponseType responseType, id response) {
        
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
    
    RoadSafetyEducationListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoadSafetyEducationListTableViewCell" forIndexPath:indexPath];
    
    NSDictionary *dict = self.arrayList[indexPath.row];
    
    cell.lbl_title.text = dict[@"title"];
    cell.lbl_date.text = dict[@"postedOn"];
    cell.lbl_subTitle.text = dict[@"description"];
    
    switch (self.roadSafetyEducationVCType) {
        case RoadSafetyEducationVCTypeVideos:
            [cell.imgView setImageWithURL:[NSURL URLWithString:dict[@"thumbnailURL"]] placeholderImage:[UIImage imageNamed:@"call"]];
            break;
        case RoadSafetyEducationVCTypePDFs:
            cell.imgView.image = [UIImage imageNamed:@"call"];
            break;
        default:
            break;
    }

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict = self.arrayList[indexPath.row];

    WebViewController *webVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    webVC.urlString = dict[@"mediaURL"];
    
    [self.navigationController presentViewController:webVC animated:YES completion:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict = self.arrayList[indexPath.row];
    
    CGFloat height = 0;
    
    height += 10;
    
    height += [dict[@"title"] boundingRectWithSize:CGSizeMake(ScreenWidth-130, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:16]} context:nil].size.height;
    
    height += 10;
    
    height += [dict[@"postedOn"] boundingRectWithSize:CGSizeMake(ScreenWidth-130, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil].size.height;

    height += 10;
    
    height += [dict[@"description"] boundingRectWithSize:CGSizeMake(ScreenWidth-130, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil].size.height;
    
    height += 10;// bgview
    height += 10;// contentView
    
    return height > 110 ? height : 110;
}

@end
