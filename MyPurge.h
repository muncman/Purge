//
//  MyPurge.h
//  Purge
//
//  Created by Ryan Nystrom on 2/18/12.
//  Copyright (c) 2012 Topic Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPurgesDataSource.h"
#import "MyItem.h"

@interface MyPurge : UIViewController
<MyPurgesDataSourceDelegate, MBProgressHUDDelegate, MyItemDelegate>
{
    MBProgressHUD *HUD;
    MyPurgesDataSource *_dataSource;
    UIScrollView *_scrollView;
}

@property (nonatomic, retain) MyPurgesDataSource *dataSource;
@property (nonatomic, retain) UIScrollView *scrollView;

-(void)displayImage:(UIImage*)image WithFrame:(CGRect)frame WithTag:(int)tag;
-(void)onSync;
-(void)onImageButton:(id)sender;

@end
