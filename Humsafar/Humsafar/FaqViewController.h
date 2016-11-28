//
//  BlogViewController.h
//  FabFurnish
//
//  Created by Apple on 14/10/15.
//  Copyright © 2015 Bluerock eServices Pvt Ltd. All rights reserved.
//

#include <UIKit/UIKit.h>

@interface FaqViewController : UIViewController
{
    __weak IBOutlet UIWebView *vwWeb;
}

@property (nonatomic, strong) NSString* webUrl;
@property (nonatomic, strong) NSString* headertitle;

@end
