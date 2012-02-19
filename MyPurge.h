//
//  MyPurge.h
//  Purge
//
//  Created by Ryan Nystrom on 2/18/12.
//  Copyright (c) 2012 Topic Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPurgesDataSource.h"

@interface MyPurge : UIViewController
<MyPurgesDataSourceDelegate, MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    MyPurgesDataSource *_dataSource;
}

@property (nonatomic, retain) MyPurgesDataSource *dataSource;

-(void)displayImage:(UIImage*)image WithFrame:(CGRect)frame;

@end
