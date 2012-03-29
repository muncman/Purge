//
//  Home.m
//  Purge
//
//  Created by Ryan Nystrom on 2/18/12.
//  Copyright (c) 2012 Topic Design. All rights reserved.
//

#import "Home.h"

@implementation Home

@synthesize dataSource = _dataSource;
@synthesize scrollView = _scrollView;

-(void)dealloc
{
    [_dataSource release], _dataSource = nil;
    [_scrollView release], _scrollView = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
        
    UIScrollView *view = [[UIScrollView alloc] init];
    [self setScrollView:view];
    [[self view] setBackgroundColor:[UIColor blackColor]];
    [[self view] addSubview:view];
    [view setFrame:CGRectMake(0, 0, 320, 400)];
    [view setScrollEnabled:YES];
    [view setShowsVerticalScrollIndicator:NO];
    [view setBackgroundColor:[UIColor colorWithRed:0.792f green:0.874f blue:0.894f alpha:1]];
    
    [view release], view = nil;

    [MBProgressHUD showHUDAddedTo:[self view] animated:YES];
    
    HomeDataSource *data = [[HomeDataSource alloc] init];
    [data setDelegate:self];
    [self setDataSource:data];
    [data release], data = nil;
}

-(void)viewWillAppear:(BOOL)animated
{        
    UIBarButtonItem *syncButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(onSync)];
    [[[self tabBarController] navigationItem] setRightBarButtonItem:nil];
    [[[self tabBarController] navigationItem] setRightBarButtonItem:syncButton];
    [syncButton release], syncButton = nil;
    
    [super viewWillAppear:animated];
}

-(void)onSync
{
    if ([self dataSource]) {
        [MBProgressHUD showHUDAddedTo:[self view] animated:YES];
        [[self dataSource] refresh];
    }
}

-(void)purgesDidLoad
{    
    [MBProgressHUD hideHUDForView:[self view] animated:YES];
    
    int purgesCount = [[[self dataSource] purges] count];
    int viewHeight = ((purgesCount / 4) + 1) * kThumbnailHeight + ((purgesCount / 4) + 1) * kThumbnailPadding + 44;
    
    for (UIView *view in [[self scrollView] subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    [[self scrollView] setContentSize:CGSizeMake(320, viewHeight)];
        
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
            [self displayImage:image WithFrame:frame WithTag:i];
        }
    }
}

-(void)purgesFailed
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error retreiving your request." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [av show];
    [av release];
}

-(void)displayImage:(UIImage*)image WithFrame:(CGRect)frame WithTag:(int)tag
{
    UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [imageButton setFrame:frame];
    [imageButton setImage:image forState:UIControlStateNormal];
    [imageButton setTag:tag];
    [[imageButton layer] setBorderColor:[[UIColor colorWithRed:0.396f green:0.435f blue:0.427f alpha:1] CGColor]];
    [[imageButton layer] setBorderWidth:1.0];
    [imageButton addTarget:self action:@selector(onImageButton:) forControlEvents:UIControlEventTouchUpInside];
    [[self scrollView] addSubview:imageButton];
}

-(void)onImageButton:(id)sender
{
    UIButton *button = (UIButton*)sender;    
    PFObject *purge = [[[self dataSource] purges] objectAtIndex:[button tag]];
    Item *item = [[Item alloc] init];
    [item setPurge:purge];
    [[self navigationController] pushViewController:item animated:YES];
    [item release], item = nil;
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    [HUD removeFromSuperview];
    [HUD release];
	HUD = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
