//
//  Browse.m
//  Purge
//
//  Created by Ryan Nystrom on 2/18/12.
//  Copyright (c) 2012 Topic Design. All rights reserved.
//

#import "Browse.h"


@implementation Browse

@synthesize dataSource = _dataSource;

-(void)dealloc
{
    [_dataSource release], _dataSource = nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        fontBold = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        font = [UIFont fontWithName:@"Helvetica" size:17];
        fontColor = [UIColor colorWithRed:0.301f green:0.325f blue:0.431f alpha:1];    }
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
    [[self tableView] setBackgroundColor:[UIColor colorWithRed:0.792f green:0.874f blue:0.894f alpha:1]];
    
    [MBProgressHUD showHUDAddedTo:[[self navigationController] view] animated:YES];
    
    HomeDataSource *data = [[HomeDataSource alloc] initWithLimit];
    [data setDelegate:self];
    [self setDataSource:data];
    [data release], data = nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self tabBarController] setTitle:@"Browse"];
    [[self navigationController] setNavigationBarHidden:NO animated:animated];
    [[self navigationController] setToolbarHidden:YES animated:animated];
    
    UIBarButtonItem *syncButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(onSync)];
    [[[self tabBarController] navigationItem] setRightBarButtonItem:nil];
    [[[self tabBarController] navigationItem] setRightBarButtonItem:syncButton];
    [syncButton release], syncButton = nil;
}

-(void)onSync
{
    if ([self dataSource]) {
        [MBProgressHUD showHUDAddedTo:[[self navigationController] view] animated:YES];
        [[self dataSource] refreshWithLimit];
    }
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

-(void)purgesDidLoad
{    
    [MBProgressHUD hideHUDForView:[[self navigationController] view] animated:YES];
    
    [[self tableView] reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self dataSource] && [[self dataSource] purges]) {
        return [[[self dataSource] purges] count];
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 360.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    NSLog(@"%i", [indexPath row]);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    else{
//        PFFile *imageFile = [[[[self dataSource] purges] objectAtIndex:[indexPath row]] objectForKey:@"image"];
//        NSData *imageData;
//        if ( imageFile && ! [imageFile isDataAvailable]) {
//            [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
//                if ( ! error) {
//                    NSLog(@"data loaded without error");
//                    [self loadCell:cell WithPurge:[[[self dataSource] purges] objectAtIndex:[indexPath row]] WithData:data];
//                }
//            }];
//        }
//        else {
//            imageData = [[[[self dataSource] purges] objectAtIndex:[indexPath row]] objectForKey:@"image"];
//            [self loadCell:cell WithPurge:[[[self dataSource] purges] objectAtIndex:[indexPath row]] WithData:imageData];
//            NSLog(@"data already loaded");
//        }
    }
    
    return cell;
}

-(void)loadCell:(UITableViewCell*)cell WithPurge:(PFObject*)purge WithData:(NSData*)data
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 310, 350)];
    [view setBackgroundColor:[UIColor blackColor]];
    [[cell contentView] addSubview:view];
    
    if (data) {
        UIImage *image = [UIImage imageWithData:data];
        if (image) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            CGRect frame = CGRectMake(0, 0, 310, 310);
            [imageView setFrame:frame];
            [[imageView layer] setMasksToBounds:YES];
            [[imageView layer] setCornerRadius:2.0];
            [[imageView layer] setBorderColor:[[UIColor colorWithRed:0.396f green:0.435f blue:0.427f alpha:0.8] CGColor]];
            [[imageView layer] setBorderWidth:2.0];
            [view addSubview:imageView];
            [imageView release], imageView = nil;
        }
    }
    
    [view release], view = nil;
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
