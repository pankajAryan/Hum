//
//  HighwayServicesVC.m
//  Humsafar
//
//  Created by Rahul on 10/22/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "HighwayServicesVC.h"

@interface HighwayServicesListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *lbl_title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_subTitle;
@property (weak, nonatomic) IBOutlet UIButton *btn_direction;

@end

@implementation HighwayServicesListTableViewCell

-(void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius = 8.0;
    self.bgView.layer.masksToBounds = YES;
    
    self.lbl_title.font = [UIFont boldSystemFontOfSize:16];
    self.lbl_subTitle.font = [UIFont systemFontOfSize:14];
}

@end

@interface HighwayServicesVC () <UITableViewDelegate,UITableViewDataSource>
{
    NSString *lat;
    NSString *lon;
}
@property (nonatomic, strong) CLLocationManager *manager;

@property (nonatomic) NSArray *arrayList;
@property (weak, nonatomic) IBOutlet UITableView *tblView;

@end

@implementation HighwayServicesVC

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
    
    [self fetchLocation];
}

-(void)fetchLocation {
    
    if ([CLLocationManager isLocationUpdatesAvailable]) {
        
        [self.manager startUpdatingLocationWithUpdateBlock:^(CLLocationManager *manager, CLLocation *location, NSError *error, BOOL *stopUpdating) {
            
            *stopUpdating = YES;
            
            if (location)
            {
                lat = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
                lon = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
                
                // Fetch latest data
                [self fetchDataListFromServer];
            }
            else
                [self showAlert:@"Could not determine your location. Please check location settings."];
        }];
    }
    else {
        [self showAlert:@"Please enable location services from settings."];
    }

}
-(void)fetchDataListFromServer {
    
//    public ResponseVO<List<HighwayFacilityVO>> getHighwayFacilityListByType(@FormParam("type")String type,@FormParam("stateId")String stateId,@FormParam("highwayId")String highwayId,@FormParam("lat")String lat,@FormParam("lon")String lon)

    NSString *strCat = @"";

    switch (self.highwayServicesVCType) {
        case HighwayServicesVCTypeCAR:
            strCat = @"car_repair";
            break;
        case HighwayServicesVCTypeHOSPITAL:
            strCat = @"hospital";
            break;
        case HighwayServicesVCTypeRESTAURANT:
            strCat = @"restaurant";
            break;
        case HighwayServicesVCTypeGAS:
            strCat = @"gas_station";
            break;
        case HighwayServicesVCTypePHARMACY:
            strCat = @"pharmacy";
            break;
        default:
            break;
    }
    
    [[FFWebServiceHelper sharedManager] callWebServiceWithUrl:GetHighwayServices withParameter:@{@"type" : strCat, @"stateId" : [UIViewController retrieveDataFromUserDefault:@"selectedStateDict"][@"stateId"], @"highwayId" : @"1", @"lat" : lat , @"lon" :lon} onCompletion:^(eResponseType responseType, id response) {
        
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
    
    HighwayServicesListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HighwayServicesListTableViewCell" forIndexPath:indexPath];
    
    NSDictionary *dict = self.arrayList[indexPath.row];
    
    cell.lbl_title.text = dict[@"name"];
    cell.lbl_subTitle.text = dict[@"address"];
    [cell.btn_direction addTarget:self action:@selector(openDirectionsInExternalMap:) forControlEvents:UIControlEventTouchUpInside];
    cell.btn_direction.tag = indexPath.row;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict = self.arrayList[indexPath.row];
    
    CGFloat height = 0;
    
    height += 10;
    
    height += [dict[@"name"] boundingRectWithSize:CGSizeMake(ScreenWidth-85, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:16]} context:nil].size.height;
    
    height += 10;
    
    height += [dict[@"address"] boundingRectWithSize:CGSizeMake(ScreenWidth-85, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
    
    height += 10;// line
    height += 10;// contentView
    
    return height;
}

#pragma mark - btn Action


- (IBAction)openDirectionsInExternalMap:(UIButton*)sender {
    
    NSDictionary *dict = self.arrayList[sender.tag];

    if ([[UIApplication sharedApplication] canOpenURL:
         [NSURL URLWithString:@"comgooglemaps://"]])
    {
        NSString *urlString=[NSString stringWithFormat:@"comgooglemaps://?daddr=%@,%@&zoom=14&directionsmode=driving",dict[@"lat"], dict[@"lon"]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
    else
    {
        NSString *string = [NSString stringWithFormat:@"http://maps.apple.com/?ll=%@,%@&q=%@",dict[@"lat"], dict[@"lon"],[dict[@"name"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
    }
}

@end
