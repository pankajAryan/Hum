//
//  ShowroomsViewController.m
//  FabFurnish
//
//  Created by Pankaj Yadav on 19/05/15.
//  Copyright (c) 2015 Bluerock eServices Pvt Ltd. All rights reserved.
//

#import "BarCodeScannerController.h"

#import <AVFoundation/AVFoundation.h>
//#import <MediaPlayer/MediaPlayer.h>


@interface BarCodeScannerController () <AVCaptureMetadataOutputObjectsDelegate> {
    
    AVAudioPlayer *audioPlayer;
    AVCaptureSession* captureSession;
    AVCaptureVideoPreviewLayer *videoPreviewLayer;
}

//@property (nonatomic, strong) MPMoviePlayerViewController *moviePlayerController;

@end

@implementation BarCodeScannerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadBeepSound];
    
    [self startReading];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:YES];
    
    [videoPreviewLayer removeFromSuperlayer];
}

- (void)viewDidLayoutSubviews {
    
    [videoPreviewLayer setFrame:_viewPreview.layer.bounds];
}

- (BOOL)startReading {
    NSError *error;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        //DDLogDebug(@"%@", [error localizedDescription]);
        return NO;
    }
    captureSession = [[AVCaptureSession alloc] init];
    [captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
    [videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_viewPreview.layer addSublayer:videoPreviewLayer];
    
    [captureSession startRunning];
    
    return YES;
}

-(void)stopReading {
    
    [captureSession stopRunning];
    captureSession = nil;
}


-(void)loadBeepSound{
    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:@"beep1" ofType:@"mp3"];
    NSURL *beepURL = [NSURL URLWithString:beepFilePath];
    NSError *error;
    
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepURL error:&error];
    if (error) {
       // DDLogDebug(@"Could not play beep file.");
       // DDLogDebug(@"%@", [error localizedDescription]);
    }
    else{
        [audioPlayer prepareToPlay];
    }
}


#pragma mark- AVCaptureMetadataOutputObjects Delegate

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    if (metadataObjects != nil && [metadataObjects count] > 0)
    {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self stopReading];
                
                if (audioPlayer) {
                    [audioPlayer play];
                }
                
                NSString *qrMobileString = [metadataObj stringValue];
                
                if ((qrMobileString != nil) && (qrMobileString.length == 10)) { // correct mobile number
                    
                    [self showProgressHudWithMessage:@"Loading..."];
                    
                    [[FFWebServiceHelper sharedManager] callWebServiceWithUrl:GetVehicleDigitalIdentityApprovalStatus
                                    withParameter:@{@"userMobile" : qrMobileString}
                                     onCompletion:^(eResponseType responseType, id response) {
                                         
                                         [self hideProgressHudAfterDelay:.1];
                                         
                                         if (responseType == eResponseTypeSuccessJSON) {
                                             [self showAlert:@"User's vehicle identity is successfully authenticated."];
                                         }
                                         else{
                                             [self showResponseErrorWithType:eResponseTypeFailJSON responseObject:response errorMessage:nil];
                                         }
                                         
                                         [self Back:nil];
                                     }];
                }
                else {
                    [UIViewController showAlert:@"QR code data is wrong."];
                    [self Back:nil];
                }
            });
        }
        else {
            [UIViewController showAlert:@"QR code data is wrong."];
            [self Back:nil];
        }
    }
    else {
        [UIViewController showAlert:@"QR code data is wrong."];
        [self Back:nil];
    }
}


-(void)Back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - MEMORY MANAGEMENT
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

@end
