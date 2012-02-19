//
//  MyPurge.m
//  Purge
//
//  Created by Ryan Nystrom on 2/18/12.
//  Copyright (c) 2012 Topic Design. All rights reserved.
//

#import "MyPurge.h"

@implementation MyPurge

@synthesize dataSource = _dataSource;

-(void)dealloc
{
    [_dataSource release], _dataSource = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
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
    
    [MBProgressHUD showHUDAddedTo:[[self navigationController] view] animated:YES];
    
    MyPurgesDataSource *data = [[MyPurgesDataSource alloc] init];
    [data setDelegate:self];
    [self setDataSource:data];
    [data release], data = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:animated];
    [[self navigationController] setToolbarHidden:YES animated:animated];
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

-(void)purgesDidLoad
{    
    [MBProgressHUD hideHUDForView:[[self navigationController] view] animated:YES];
    
    int purgesCount = [[[self dataSource] purges] count];
    int viewHeight = ((purgesCount / 4) + 1) * kThumbnailHeight + ((purgesCount / 4) + 1) * kThumbnailPadding;
    UIScrollView *view = [[UIScrollView alloc] init];
    [self setView:view];
    [view setFrame:CGRectMake(0, 0, 320, 400)];
    [view setContentSize:CGSizeMake(320, viewHeight)];
    [view setScrollEnabled:YES];
    [view setShowsVerticalScrollIndicator:NO];
    [view setAlwaysBounceVertical:YES];
    
    [view release], view = nil;
    
    // 4 images wide grid
    for (int i = 0; i < purgesCount; ++i) {
        PFObject *purge = [[[self dataSource] purges] objectAtIndex:i];
        PFFile *imageFile = [purge objectForKey:@"thumbnail"];
        NSData *imageData = [imageFile getData];
        UIImage *image = [UIImage imageWithData:imageData];
        if (image) {
            int x = (i % 4) * kThumbnailWidth + ((i % 4) + 1) * kThumbnailPadding;
            int y = (i / 4) * kThumbnailHeight + ((i / 4) + 1) * kThumbnailPadding;
            CGRect frame = CGRectMake(x, y, kThumbnailWidth, kThumbnailHeight);
            [self displayImage:image WithFrame:frame];
        }
    }
}

-(void)purgesFailed
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error retreiving your purges." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [av show];
    [av release], av = nil;
}

-(void)displayImage:(UIImage*)image WithFrame:(CGRect)frame
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setFrame:frame];
    [[self view] addSubview:imageView];
    [imageView release], imageView = nil;
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    [HUD removeFromSuperview];
    [HUD release];
	HUD = nil;
}

@end
