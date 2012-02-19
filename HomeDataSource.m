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

-(id)init
{
    if (self = [super init]) {
        PFQuery *query = [PFQuery queryWithClassName:@"Purges"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if ( ! error) {
                [self setPurges:objects];
                [[self delegate] purgesDidLoad];
            }
            else {
                [[self delegate] purgesFailed];
            }
        }];

    }
    return self;
}

-(void)refresh
{
    PFQuery *query = [PFQuery queryWithClassName:@"Purges"];
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

@end
