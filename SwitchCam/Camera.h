//
//  Camera.h
//  SwitchCam
//
//  Created by Aleksandr Bydaiev on 4/19/19.
//  Copyright © 2019 ab.name. All rights reserved.
//

#import <Foundation/Foundation.h>

///TODO: available through bridging.
@interface Camera : NSObject

/**
 Static initializer.
 @result instance.
 */
+ (Camera *)createCamera;

@end
