//
//  Camera.h
//  SwitchCam
//
//  Created by Aleksandr Bydaiev on 4/19/19.
//  Copyright © 2019 ab.name. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class AVCapturePhotoOutput;

///TODO: available through bridging.
@interface Camera : NSObject

@property (readonly) AVCapturePhotoOutput * stillImageOutput;

/**
 Static initializer.
 @result instance.
 */
+ (Camera *)createCamera;

- (void)setupSession;

- (void)setupCameraWithType:(NSInteger)type castToView:(UIView *)clientView;

- (void)stopRun;

@end
