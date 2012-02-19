//
//  main.m
//  Purge
//
//  Created by Ryan Nystrom on 2/18/12.
//  Copyright (c) 2012 Topic Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

#import "AppDelegate.h"

int main(int argc, char *argv[])
{
    [Parse setApplicationId:@"P3sGyZ4VjjRX5SSlh4zVKp8V4j5XdYhd59Kl8q5a" 
                  clientKey:@"BO0Qmdl9T2gVYLvuk7l4QGiMomVvgxrzmqQCmXdd"];

    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
