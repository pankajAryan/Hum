//
//  CallViewController.m
//  Humsafar
//
//  Created by B0081006 on 10/22/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import "CallViewController.h"
#import "ActionSheetStringPicker.h"

@interface CallViewController ()
{
    NSArray *arrayDistrictsInfo;
    NSMutableArray *arrayDistrictsNames;
}
@end

@implementation CallViewController

- (void)viewDidLoad {
    // Do any additional setup after loading the view.
    arrayDistrictsNames = [NSMutableArray new];
    
    if ([[UIViewController retrieveDataFromUserDefault:@"loginType"] isEqualToString:@"department"]) {
        NSArray *arrayDistricts = [UIViewController retrieveDataFromUserDefault:@"districts"];
        if (arrayDistricts == nil) {
            [self fetchDistrictListForStateId:@"29"];//Hardcode
        }else{
            arrayDistrictsInfo = arrayDistricts;
            for (NSDictionary *info in arrayDistrictsInfo) {
                [arrayDistrictsNames addObject:info[@"districtName"]];
            }
        }
        
        [UIViewController saveDatatoUserDefault:@{
                                                  @"districtId" : @"10",
                                                  @"districtName" : @"Chittorgarh",
                                                  @"stateId" : @"29"
                                                  } forKey:@"selectedDictrictInfoForEmergencyDirectory"];
        self.lbl_districtName.text = @"Chittorgarh";

    }else{
        arrayDistrictsInfo = [UIViewController retrieveDataFromUserDefault:@"selectedStateDistrictArray"];
        for (NSDictionary *info in arrayDistrictsInfo) {
            [arrayDistrictsNames addObject:info[@"districtName"]];
        }
        
       NSDictionary *selectedDistrictInfo = [UIViewController retrieveDataFromUserDefault:@"selectedDistrictDict"];
        self.lbl_districtName.text = selectedDistrictInfo[@"districtName"];
        
    }
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)fetchDistrictListForStateId:(NSString*)stateId {
    [[FFWebServiceHelper sharedManager] callWebServiceWithUrl:GetDistricts withParameter:@{@"stateId" : stateId} onCompletion:^(eResponseType responseType, id response) {
        
        @try {
            if (responseType == eResponseTypeSuccessJSON) {
                NSArray *arrayDistricts = [response objectForKey:kKEY_ResponseObject];
                if (arrayDistricts != nil) {
                    [UIViewController saveDatatoUserDefault:arrayDistricts forKey:@"districts"];
                }
            }else{
                
            }
        } @catch (NSException *exception) {
            
        }
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)action_goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIActionSheetPicker

-(IBAction)action_selectState:(id)sender{//select district
    [ActionSheetStringPicker showPickerWithTitle:nil rows:arrayDistrictsNames initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedValueIndex, id selectedValue) {
        self.lbl_districtName.text = selectedValue;
        NSDictionary *dict_dictrictInfo = [arrayDistrictsInfo objectAtIndex:selectedValueIndex];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DistrictSelectionNotification" object:nil userInfo:dict_dictrictInfo];
        [UIViewController saveDatatoUserDefault:dict_dictrictInfo forKey:@"selectedDictrictInfoForEmergencyDirectory"];
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        NSLog(@"Block Picker Canceled");
    } origin:sender];
}

@end
