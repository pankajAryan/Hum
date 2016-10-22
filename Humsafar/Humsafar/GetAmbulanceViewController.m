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

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

@end

@implementation GetAmbulanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.manager = [CLLocationManager updateManagerWithAccuracy:100.0 locationAge:15.0 authorizationDesciption:CLLocationUpdateAuthorizationDescriptionWhenInUse];
    
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
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setupMapView];
                });
                
                //TODO: Fetch ambulance list
            }
            else
                [self showAlert:@"Could not determine your location. Please check location settings."];
        }];
    }
    else {
        [self showAlert:@"Please enable location services from settings."];
    }
}

- (void)setupMapView {
    // Map Setup
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[lat floatValue]
                                                            longitude:[lon floatValue]
                                                                 zoom:8];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)drawAmbulancesAtMap {
    
//    for (HomeMapStoreModelResponseObject *fuelStationPin in fuelStationBase.responseObject) {
        
        // Creates a marker in the center of the map.
        GMSMarker *marker = [[GMSMarker alloc] init];
/*        marker.position = CLLocationCoordinate2DMake([fuelStationPin.lat doubleValue], [fuelStationPin.lon doubleValue]);
        
 
  */
        marker.title = @"Ambulance";
        marker.icon = nil;//[UIImage imageNamed:@""]; // ambulance image
        marker.snippet = nil;//[NSString stringWithFormat:@"%@",]; // ambulance text details as per android
        marker.appearAnimation = kGMSMarkerAnimationPop;
//        marker.userData = fuelStationPin;
        marker.map = _mapView;
//    }
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
