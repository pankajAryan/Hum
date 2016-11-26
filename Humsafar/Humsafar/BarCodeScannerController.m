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
    
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {

            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self stopReading];

                if (audioPlayer) {
                    [audioPlayer play];
                }

/*
                public static final String SERVER_URL = "http://128.199.129.241:8080/QRAppServer/rest/service/";
                public static final String QRCODESCAN_SUB_URL = "qrScanContent";
                http://itwplus.niitnguru.com:8080/QRAppServer/rest/service/qrScanContent
                
                KEY
                params.put("qrCode",qrCode); (Sample values: 12345678 & ABCDEFGH)
 
 */
                NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
                
                NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
                
                NSURLComponents *components = [[NSURLComponents alloc]init];
                components.scheme = @"http";
                components.host = @"itwplus.niitnguru.com";
                components.port = [NSNumber numberWithInteger:8080];
                components.path = @"/QRAppServer/rest/service/qrScanContent";
                
                NSURLQueryItem *item1 = [NSURLQueryItem
                                         queryItemWithName:@"qrCode" value:[metadataObj stringValue]];
                components.queryItems = @[item1];
                
                NSURL *url = components.URL;
                
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                                       cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                   timeoutInterval:10.0];
                
                [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
                [request setHTTPMethod:@"POST"];
                
                NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    
                    if (!error) {
                        NSError *localError = nil;
                        
                        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                        NSDictionary *scannedRecordDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&localError];
                        
                        if (localError == nil) {
                            
                            NSLog(@"Response = %@",scannedRecordDict);
                            
                            if ([[scannedRecordDict objectForKey:@"errorMessage"] isEqualToString:@"Success"]) {
                                
                                self.metadataCallback([scannedRecordDict objectForKey:@"responseObject"]);
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self Back:nil];
                                });
                            }
                        }
                    }
                }];
                
                [postDataTask resume];
            });
        }
    }
}


/*
- (void)playMovie:(NSURL*)videoUrl
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        MPMoviePlayerController *moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:videoUrl];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlaybackComplete:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:moviePlayerController];
        
        [self.view addSubview:moviePlayerController.view];
        moviePlayerController.fullscreen = YES;
        moviePlayerController.movieSourceType = MPMovieSourceTypeStreaming;

        [moviePlayerController play];
    });
}

- (void)moviePlaybackComplete:(NSNotification *)notification
{
    MPMoviePlayerController *moviePlayerController = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:moviePlayerController];
    
    [moviePlayerController.view removeFromSuperview];
}
*/

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
