//
//  ConnectSocial.m
//  Purge
//
//  Created by Ryan Nystrom on 2/18/12.
//  Copyright (c) 2012 Topic Design. All rights reserved.
//

#import "ConnectSocial.h"


@implementation ConnectSocial

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(onDone)];
    [[self navigationItem] setRightBarButtonItem:doneButton];
    [doneButton release], doneButton = nil;
}

-(void)onDone
{
    MainTabView *appView = [[MainTabView alloc] init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    [[[[self navigationController] view] layer] addAnimation:transition forKey:nil];
    
    [[self navigationController] pushViewController:appView animated:NO];
    [appView release], appView = nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[[self navigationController] navigationItem] setHidesBackButton:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 1;
            break;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if ([indexPath section] == 0) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        switch ([indexPath row]) {
            case 0:
                [[cell textLabel] setText:@"Facebook"];
                break;
            case 1:
                [[cell textLabel] setText:@"Twitter"];
                break;
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([indexPath section] == 0) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        switch ([indexPath row]) {
            case 0:
//                [[PFUser currentUser] linkToFacebook:nil block:^(BOOL succeeded, NSError *error){
//                    if (error) {
//                        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:[[error userInfo] objectForKey:@"error"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//                        [av show];
//                        [av release], av = nil;
//                    }
//                    else if (succeeded){
//                        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
//                    }
//                }];
                break;
            case 1:
                break;
        }
    }
}

@end
