//
//  Home.h
//  Purge
//
//  Created by Ryan Nystrom on 2/18/12.
//  Copyright (c) 2012 Topic Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeDataSource.h"
#import "Item.h"

@interface Home : UIViewController
<HomeDataSourceDelegate>
{
    MBProgressHUD *HUD;
    HomeDataSource *_dataSource;
    UIScrollView *_scrollView;
}

@property (nonatomic, retain) HomeDataSource *dataSource;
@property (nonatomic, retain) UIScrollView *scrollView;

-(void)displayImage:(UIImage*)image WithFrame:(CGRect)frame WithTag:(int)tag;
-(void)onImageButton:(id)sender;
-(void)onSync;

@end
