//
//  ViewController.m
//  BaseProject
//
//  Created by jiyingxin on 15/10/22.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "ViewController.h"
#import "NSString+QRCode.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController () <AVCaptureMetadataOutputObjectsDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

//输入输出桥
@property (nonatomic, strong)  AVCaptureSession  *session;
//展示界面
@property (nonatomic, strong)  AVCaptureVideoPreviewLayer  *layer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)scanQRCode:(id)sender {
//获取摄像头
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//创建输入流,
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
//创建输出流
    AVCaptureMetadataOutput *output = [AVCaptureMetadataOutput new];
//设置代理,在主线程中刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
//initialize session object
    _session = [AVCaptureSession new];
//高质量传输
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
//输入输出流
    [_session addInput:input];
    [_session addOutput:output];

//设置扫描支持的格式
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeCode128Code];
//把session中的画面读出来
    self.layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
//铺满全屏
    self.layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//设置 layer 的大小
    self.layer.frame = self.view.bounds;
    [self.view.layer addSublayer:_layer];
//启动扫描
    [_session startRunning];
    
}
- (IBAction)createQRCode:(id)sender {
    
    _imageView.image = [@"hehehehehehehehehe" imageForQRCode:_imageView.frame.size.width];
}

#pragma  mark - delegate 
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
//扫描结束,处理
        [_session stopRunning];
        [self.layer removeFromSuperlayer];
        
        [self showSuccessMsg:obj.stringValue];
        
        NSLog(@"扫描结果 %@", obj.stringValue);
    }
}

@end
