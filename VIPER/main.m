//
//  main.m
//  VIPER
//
//  Created by Hugo Sousa on 22/7/14.
//  Copyright (c) 2014 muzzley. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HSAppDelegate.h"

int main(int argc, char * argv[])
{
    @autoreleasepool {
        BOOL runningTests = NSClassFromString(@"XCTestCase") != nil;
        if(!runningTests) {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([HSAppDelegate class]));
        }
        else {
            return UIApplicationMain(argc, argv, nil, @"HSTestAppDelegate");
        }
        
    }
}
