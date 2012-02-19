//
//  AppView2.m
//  Purge
//
//  Created by Ryan Nystrom on 2/18/12.
//  Copyright (c) 2012 Topic Design. All rights reserved.
//

#import "MainTabView.h"

@implementation MainTabView

-(void)dealloc
{
    [super dealloc];
}

-(id)init
{
    if (self = [super init]) {
        Home *home = [[Home alloc] init];
        [[home tabBarItem] setTitle:@"Home"];
        About *about = [[About alloc] initWithStyle:UITableViewStyleGrouped];
        [[about tabBarItem] setTitle:@"About Me"];
        MyPurge *myPurge = [[MyPurge alloc] init];
        [[myPurge tabBarItem] setTitle:@"My Purges"];
        Browse *browse = [[Browse alloc] initWithStyle:UITableViewStylePlain];
        [[browse tabBarItem] setTitle:@"Browse"];
        Purge *purge = [[Purge alloc] init];
        [[purge tabBarItem] setTitle:@"Purge"];
        
        [self setViewControllers:[NSArray arrayWithObjects:home, myPurge, purge, browse, about, nil] animated:NO];
                
        [home release], home = nil;
        [purge release], purge = nil;
        [about release], about = nil;
        [myPurge release], myPurge = nil;
        [browse release], browse = nil;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
