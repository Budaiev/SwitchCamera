//
//  Camera.m
//  SwitchCam
//
//  Created by Aleksandr Bydaiev on 4/19/19.
//  Copyright © 2019 ab.name. All rights reserved.
//


#import "Camera.h"

@interface Camera ()

@end

@implementation Camera

+ (Camera *)createCamera {
    
    return [[Camera alloc] initWith];
}

- (instancetype)initWith {
    
    self = [super init];
    
    return self;
}

@end

