//
//  Camera.m
//  SwitchCam
//
//  Created by Aleksandr Bydaiev on 4/19/19.
//  Copyright © 2019 ab.name. All rights reserved.
//


#import "Camera.h"

@import AVFoundation;

//=============================================================================

@interface Camera ()
///<AVCapturePhotoCaptureDelegate>

@property AVCaptureSession * captureSession;
@property AVCapturePhotoOutput * stillImageOutput;
@property AVCaptureVideoPreviewLayer * videoPreviewLayer;


@end

//=============================================================================

@implementation Camera

+ (Camera *)createCamera {
    
    return [[Camera alloc] initWith];
}

- (instancetype)initWith {
    
    self = [super init];
    [self setupSession];
    return self;
}

- (void)setupSession {
    
    self.captureSession = AVCaptureSession.new;
    self.captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
}

- (void)setupCameraWithType:(NSInteger)type castToView:(UIView *)clientView {
    
    AVCaptureDevice * camera = [self selectCamera:type];
    
    NSError * error = nil;
    AVCaptureDeviceInput * input;
    
    @try {
        
        input = [AVCaptureDeviceInput deviceInputWithDevice:camera
                                                      error:&error];
        
    } @catch (NSError * error) {
        
        input = nil;
        
        NSLog(@"Camera error: %@",error.localizedDescription);
    }
    
    if (!error && [self.captureSession canAddInput:input]) {
        
        self.stillImageOutput = [[AVCapturePhotoOutput alloc] init];
        
        if ([self.captureSession canAddInput:input] &&
            [self.captureSession canAddOutput:self.stillImageOutput]) {
        
            [self.captureSession addInput:input];
            [self.captureSession addOutput:self.stillImageOutput];
            
            self.videoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
            self.videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
            self.videoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
            self.videoPreviewLayer.frame = clientView.bounds;
            [clientView.layer addSublayer:self.videoPreviewLayer];
                                               
            [self.captureSession startRunning];
        }
        
    } else {
        
        NSLog(@"Unable to AddInput!");
    }
    
}

- (void)stopRun {
    
    [self.captureSession stopRunning];
}

- (AVCaptureDevice *)selectCamera:(AVCaptureDevicePosition)position {
    
    return [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:position].devices.firstObject;
}

@end

