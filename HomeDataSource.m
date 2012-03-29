//
//  HomeDataSource.m
//  Purge
//
//  Created by Ryan Nystrom on 2/18/12.
//  Copyright (c) 2012 Topic Design. All rights reserved.
//

#import "HomeDataSource.h"

@implementation HomeDataSource

@synthesize purges = _purges;
@synthesize delegate = _delegate;

-(void)dealloc
{
    [_purges release], _purges = nil;
    [super dealloc];
}

-(void)getPurgesWithLimit:(int)limit cache:(PFCachePolicy)cachePolicy
{
    PFQuery *query = [PFQuery queryWithClassName:@"Purges"];
    [query orderByDescending:@"createdAt"];
    [query setLimit:[NSNumber numberWithInt:limit]];
    [query setCachePolicy:cachePolicy];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ( ! error) {
            [self setPurges:nil];
            [self setPurges:objects];
            [[self delegate] purgesDidLoad];
        }
        else {
            [[self delegate] purgesFailed];
        }
    }];
}

-(id)init
{
    if (self = [super init]) {
        [self getPurgesWithLimit:80 cache:kPFCachePolicyCacheElseNetwork];
    }
    return self;
}

-(id)initWithLimit
{
    if (self = [super init]) {
        [self getPurgesWithLimit:10 cache:kPFCachePolicyCacheElseNetwork];        
    }
    return self;
}

-(void)refresh
{
    [self getPurgesWithLimit:80 cache:kPFCachePolicyNetworkOnly];
}

-(void)refreshWithLimit
{
    [self getPurgesWithLimit:10 cache:kPFCachePolicyNetworkOnly];
}

@end
