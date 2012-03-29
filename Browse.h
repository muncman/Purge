//
//  Browse.h
//  Purge
//
//  Created by Ryan Nystrom on 2/18/12.
//  Copyright (c) 2012 Topic Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeDataSource.h"

@interface Browse : UITableViewController
<HomeDataSourceDelegate>
{
    HomeDataSource *_dataSource;
    UIFont *font;
    UIFont *fontBold;
    UIColor *fontColor;
}

@property (nonatomic, retain) HomeDataSource *dataSource;

-(void)loadCell:(UITableViewCell*)cell WithPurge:(PFObject*)purge WithData:(NSData*)data;

@end
