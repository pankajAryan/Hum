//
//  PlacesSearchVC.m
//  Humsafar
//
//  Created by Rahul on 11/9/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "PlacesSearchVC.h"
#import <GooglePlaces/GooglePlaces.h>

@interface PlacesSearchVC ()<UITextFieldDelegate,GMSAutocompleteViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtAddress;
@property (nonatomic) GMSPlace *selectedPlace;

@end

@implementation PlacesSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - btn action

- (IBAction)cancelBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)goBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    
    if (self.selectedPlace == nil) {
        [self showAlert:@"Please select address!"];
        return;
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:
         [NSURL URLWithString:@"comgooglemaps://"]])
    {
        NSString *urlString=[NSString stringWithFormat:@"comgooglemaps://?daddr=%f,%f&zoom=14&directionsmode=driving",self.selectedPlace.coordinate.latitude, self.selectedPlace.coordinate.longitude];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
    else
    {
        NSString *string = [NSString stringWithFormat:@"http://maps.apple.com/?ll=%f,%f&q=%@",self.selectedPlace.coordinate.latitude, self.selectedPlace.coordinate.longitude,[self.selectedPlace.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
    }
}

- (IBAction)placeBtn:(id)sender {
    
    [GMSPlacesClient provideAPIKey:@"AIzaSyBxRgQr0Rslm3I9fEqY9LE4cXJQQ-yZFN8"];
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;
    [self presentViewController:acController animated:YES completion:nil];
}

// Handle the user's selection.
- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place {
    // Do something with the selected place.
    
    self.selectedPlace = place;
    self.txtAddress.text = place.name;
    
    NSLog(@"Place name %@", place.name);
    NSLog(@"Place address %@", place.formattedAddress);
    NSLog(@"Place attributions %@", place.attributions.string);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
    // TODO: handle the error.
    NSLog(@"error: %ld", [error code]);
    [self dismissViewControllerAnimated:YES completion:nil];
}

// User canceled the operation.
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
    NSLog(@"Autocomplete was cancelled.");
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
