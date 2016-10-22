//
//  RegisterViewController.h
//  Humsafar
//
//  Created by Pankaj Yadav on 12/10/16.
//  Copyright © 2016 mobiquel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController
{
    NSArray *arrayStatesData;
    NSArray *arrayDistrictsData;
}

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSURL *imageUrl;


@end
