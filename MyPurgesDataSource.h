//
//  MyPurgesDataSource.h
//  Purge
//
//  Created by Ryan Nystrom on 2/18/12.
//  Copyright (c) 2012 Topic Design. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MyPurgesDataSourceDelegate;

@interface MyPurgesDataSource : NSObject
{
    NSArray *_purges;
    id <MyPurgesDataSourceDelegate> _delegate;
}

@property (nonatomic, retain) NSArray *purges;
@property (nonatomic, retain) id <MyPurgesDataSourceDelegate> delegate;

-(void)refresh;

@end

@protocol MyPurgesDataSourceDelegate

-(void)purgesDidLoad;
-(void)purgesFailed;

@end