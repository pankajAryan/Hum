//
//  ShowroomsViewController.h
//  FabFurnish
//
//  Created by Pankaj Yadav on 19/05/15.
//  Copyright (c) 2015 Bluerock eServices Pvt Ltd. All rights reserved.
//

#include <UIKit/UIKit.h>

@interface BarCodeScannerController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *viewPreview;

@property (nonatomic, copy)  void (^metadataCallback)(NSDictionary* infoDict);


@end
