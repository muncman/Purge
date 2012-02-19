//
//  HomeDataSource.h
//  Purge
//
//  Created by Ryan Nystrom on 2/18/12.
//  Copyright (c) 2012 Topic Design. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HomeDataSourceDelegate;

@interface HomeDataSource : NSObject
{
    NSArray *_purges;
    id <HomeDataSourceDelegate> _delegate;
}

@property (nonatomic, retain) NSArray *purges;
@property (nonatomic, retain) id <HomeDataSourceDelegate> delegate;

-(void)refresh;

@end

@protocol HomeDataSourceDelegate

-(void)purgesDidLoad;
-(void)purgesFailed;

@end