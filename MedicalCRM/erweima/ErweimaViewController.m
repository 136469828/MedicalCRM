//
//  ErweimaViewController.m
//  No.1 Pharmacy
//
//  Created by JCong on 15/12/9.
//  Copyright © 2015年 梁健聪. All rights reserved.
//

#import "ErweimaViewController.h"
#import "WebModel.h"
#import "WebViewController.h"
@interface ErweimaViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@end

@implementation ErweimaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    UIButton * scanButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    scanButton.backgroundColor = [UIColor whiteColor];
    [scanButton setTitle:@"取消" forState:UIControlStateNormal];
    scanButton.frame = CGRectMake(ScreenWidth/2-60, 440, 120, 40);
    [scanButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanButton];
    
    UILabel * labIntroudction= [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2-145, 60, 290, 50)];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.numberOfLines=2;
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.text=@"将二维码图像置于矩形方框内，离手机摄像头10CM左右，系统会自动识别。";
    [self.view addSubview:labIntroudction];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2-150, 120, 300, 300)];
    imageView.image = [UIImage imageNamed:@"pick_bg"];
    [self.view addSubview:imageView];
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2-110, 130, 240, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [self.view addSubview:_line];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
}

-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(ScreenWidth/2-110, 130+2*num, 220, 2);
        if (2*num == 280) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(70, 130+2*num, 220, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
}



-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
    [timer invalidate];
    //    [self dismissViewControllerAnimated:YES completion:^{
    //        [timer invalidate];
    //    }];
}


-(void)viewWillAppear:(BOOL)animated
{
//    self.navigationController.navigationBarHidden = YES; 
    [self setupCamera];
}


- (void)setupCamera
{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
#if !TARGET_IPHONE_SIMULATOR
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
#endif
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame =CGRectMake(ScreenWidth/2-140,130,280,280);
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    // Start
    [_session startRunning];
}


#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        
        NSLog(@"%@", stringValue);
        //        UILabel *lab = [[UILabel alloc]initWithFrame:cgrect];
        if([stringValue rangeOfString:@"http://"].location !=NSNotFound)//_roaldSearchText
        {
            NSLog(@"yes");
            NSURL *url = [NSURL URLWithString:stringValue];
            [[UIApplication sharedApplication] openURL:url];
        }
        else
        {
            NSLog(@"no");
            stringValue = [NSString stringWithFormat:@"http://%@",stringValue];
            NSURL *url = [NSURL URLWithString:stringValue];
            [[UIApplication sharedApplication] openURL:url];
        }
        NSURL *url = [NSURL URLWithString:stringValue];
        [[UIApplication sharedApplication] openURL:url];
//        [self pushWebVcWithURL:stringValue];
        
    }
    [_session stopRunning];
    
    [self dismissViewControllerAnimated:YES completion:^
     {
         [timer invalidate];
     }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
