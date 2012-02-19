//
//  Item.m
//  Purge
//
//  Created by Ryan Nystrom on 2/18/12.
//  Copyright (c) 2012 Topic Design. All rights reserved.
//

#import "Item.h"

@implementation Item

@synthesize purge = _purge;

-(void)dealloc
{
    [_purge release], _purge = nil;
    [super dealloc];
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
    [[self navigationController] setNavigationBarHidden:NO animated:animated];
    [MBProgressHUD showHUDAddedTo:[[self navigationController] view] animated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
        
    UIScrollView *view = [[UIScrollView alloc] initWithFrame:[[self view] frame]];
    [self setView:view];
    [view setScrollEnabled:YES];
    [view setShowsVerticalScrollIndicator:NO];
    [view setAlwaysBounceVertical:YES];
    [view setDelegate:self];
    
    int padding = 15;
    int runningHeight = padding;
    CGSize maxLabelSize = CGSizeMake(320 - 2 * padding, MAXFLOAT);
    UIFont *boldFont = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:17];
    
    PFFile *imageFile = [[self purge] objectForKey:@"image"];
    NSData *imageData;
    if ( ! [imageFile isDataAvailable]) {
        imageData = [imageFile getData];
    }
    else {
        imageData = [[self purge] objectForKey:@"image"];
    }
    
    UIImage *image = [UIImage imageWithData:imageData];
    UIImage *resizedImage = [self imageByScalingForHeight:200.0f WithImage:image];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:resizedImage];
    CGRect frame = [imageView frame];
    frame.origin.x = 320 - 320/2 - frame.size.width/2;
    frame.origin.y = padding;
    [imageView setFrame:frame];
    [[self view] addSubview:imageView];
    runningHeight += imageView.frame.size.height + padding;
        
    UILabel *descriptionTitle = [[UILabel alloc] initWithFrame:CGRectMake(padding, runningHeight, 320 - 2 * padding, 20)];
    [descriptionTitle setText:@"Description"];
    [descriptionTitle setFont:boldFont];
    [view addSubview:descriptionTitle];
    runningHeight += descriptionTitle.frame.size.height;
    [descriptionTitle release], descriptionTitle = nil;
    
    UILabel *description = [[UILabel alloc] initWithFrame:CGRectMake(padding, runningHeight, 320 - 2 * padding, 40)];
    [description setNumberOfLines:0];
    [description setLineBreakMode:UILineBreakModeWordWrap];
    NSString *dText = [[self purge] objectForKey:@"description"];
    CGSize expected = [dText sizeWithFont:font constrainedToSize:maxLabelSize lineBreakMode:UILineBreakModeWordWrap];
    frame = [description frame];
    frame.size.height = expected.height;
    [description setText:dText];
    [description setFrame:frame];
    [view addSubview:description];
    runningHeight += description.frame.size.height + padding;
    [description release], description = nil;
    
    UILabel *priceTitle = [[UILabel alloc] initWithFrame:CGRectMake(padding, runningHeight, 320 - 2 * padding, 20)];
    [priceTitle setText:@"Price"];
    [priceTitle setFont:boldFont];
    [view addSubview:priceTitle];
    runningHeight += priceTitle.frame.size.height;
    [priceTitle release], priceTitle = nil;
    
    UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(padding, runningHeight, 320 - 2 * padding, 20)];
    [price setNumberOfLines:0];
    [price setLineBreakMode:UILineBreakModeWordWrap];
    dText = [[self purge] objectForKey:@"price"];
    [price setText:dText];
    [view addSubview:price];
    runningHeight += price.frame.size.height + padding;
    [price release], price = nil;
    
    CGRect buttonFrame = CGRectMake(padding, runningHeight, 320 - 2 * padding, 40);
    UIButton *buy = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buy setTitle:@"Buy" forState:UIControlStateNormal];
    [buy setFrame:buttonFrame];
    [view addSubview:buy];
        
    [view setContentSize:CGSizeMake(320, runningHeight)];
    
    [[self view] addSubview:buy];
    
    [view release], view = nil;
    
    [MBProgressHUD hideHUDForView:[[self navigationController] view] animated:YES];
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

- (UIImage*)imageByScalingForHeight:(CGFloat)maxHeight WithImage:(UIImage*)image
{
    CGFloat oldWidth = image.size.width;
    CGFloat oldHeight = image.size.height;
    CGFloat newWidth = (oldWidth / oldHeight) * maxHeight;
    CGSize newSize = CGSizeMake(newWidth, maxHeight);
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


@end
