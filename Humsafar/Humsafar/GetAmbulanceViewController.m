//
//  GetAmbulanceViewController.m
//  Humsafar
//
//  Created by Pankaj Yadav on 22/10/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "GetAmbulanceViewController.h"

@interface GetAmbulanceViewController () {
    
    NSString *lat;
    NSString *lon;
}

@property (nonatomic, strong) CLLocationManager *manager;
@property (nonatomic) NSArray *arrayList;

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

@end

@implementation GetAmbulanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.manager = [CLLocationManager updateManagerWithAccuracy:100.0 locationAge:15.0 authorizationDesciption:CLLocationUpdateAuthorizationDescriptionWhenInUse];
    
    if (CLLocationManager.authorizationStatus != kCLAuthorizationStatusNotDetermined) {
        [self showProgressHudWithMessage:@"Please wait..."];
    }
    else {
        [self.manager didChangeAuthorizationStatusWithBlock:^(CLLocationManager *manager, CLAuthorizationStatus status)
         {
             if (CLLocationManager.authorizationStatus != kCLAuthorizationStatusNotDetermined)
                 [self showProgressHudWithMessage:@"Please wait..."];
         }];
    }

    [self fetchLocation];
}

-(void)fetchLocation {
    
    NSLog(@"entered into fetch location");
    
    if ([CLLocationManager isLocationUpdatesAvailable]) {
        
        [self.manager startUpdatingLocationWithUpdateBlock:^(CLLocationManager *manager, CLLocation *location, NSError *error, BOOL *stopUpdating) {
            
            *stopUpdating = YES;
            
            if (location)
            {
                lat = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
                lon = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setupMapView];
                });
                
                [self fetchAmbulanceData];
                
                return;
            }
            else
                [self showAlert:@"Could not determine your location. Please check location settings."];
        }];
    }
    else {
        [self showAlert:@"Please enable location services from settings."];
    }
    
    [self hideProgressHudAfterDelay:0.0];
}

-(void)fetchAmbulanceData {
    
    [[FFWebServiceHelper sharedManager] callWebServiceWithUrl:GetAmbulanceList withParameter:nil onCompletion:^(eResponseType responseType, id response) {
        
        if (responseType == eResponseTypeSuccessJSON) {
            self.arrayList = [response objectForKey:kKEY_ResponseObject];
            [self drawAmbulancesAtMap];
        }
        else {
            [self showResponseErrorWithType:eResponseTypeFailJSON responseObject:response errorMessage:nil];
            // [self showAlert:[response objectForKey:kKEY_ErrorMessage]];
        }
        
        [self hideProgressHudAfterDelay:0.0];
    }];
}

- (void)setupMapView {
    // Map Setup
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[lat floatValue]
                                                            longitude:[lon floatValue]
                                                                 zoom:4];
    
    // _mapView = [GMSMapView mapWithFrame:_mapView.bounds camera:camera]; Use if mapView is not created in xib
    _mapView.camera = camera;
    _mapView.delegate = self;
    _mapView.myLocationEnabled = YES;
    _mapView.indoorEnabled = YES;
    _mapView.accessibilityElementsHidden = NO;
    _mapView.settings.scrollGestures = YES;
    _mapView.settings.zoomGestures = YES;
    _mapView.settings.compassButton = YES;
    _mapView.settings.myLocationButton = NO;
    
    _mapView.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawAmbulancesAtMap {
    
    for (NSDictionary *dict in self.arrayList) {
        
        // Creates a marker in the center of the map.
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake([dict[@"lat"] doubleValue], [dict[@"lon"] doubleValue]);

        marker.title = [dict objectForKey:@"driverName"];
        marker.snippet = [dict objectForKey:@"driverNumber"];
        marker.icon = [UIImage imageNamed:@"ic_ambulance"];
        marker.appearAnimation = kGMSMarkerAnimationPop;
        marker.map = _mapView;
    }
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
