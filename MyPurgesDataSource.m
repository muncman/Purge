//
//  MyPurgesDataSource.m
//  Purge
//
//  Created by Ryan Nystrom on 2/18/12.
//  Copyright (c) 2012 Topic Design. All rights reserved.
//

#import "MyPurgesDataSource.h"

@implementation MyPurgesDataSource

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
        PFUser *user = [PFUser currentUser];
        PFQuery *query = [PFQuery queryWithClassName:@"Purges"];
        [query whereKey:@"user" equalTo:user];
        [query orderByDescending:@"createdAt"];
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
    PFUser *user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Purges"];
    [query whereKey:@"user" equalTo:user];
    [query orderByDescending:@"createdAt"];
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

@end