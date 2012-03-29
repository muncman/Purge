//
//  MyItem.m
//  Purge
//
//  Created by Ryan Nystrom on 2/18/12.
//  Copyright (c) 2012 Topic Design. All rights reserved.
//

#import "MyItem.h"

@implementation MyItem

@synthesize purge = _purge;
@synthesize delegate = _delegate;
@synthesize scrollView = _scrollView;

-(void)dealloc
{
    [_scrollView release], _scrollView = nil;
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
    
    UIScrollView *view = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
    [[self view] addSubview:view];
    [self setScrollView:view];    
    [view setScrollEnabled:YES];
    [view setShowsVerticalScrollIndicator:NO];
    [view setAlwaysBounceVertical:YES];
    [view setDelegate:self];
    [view setBackgroundColor:[UIColor colorWithRed:0.792f green:0.874f blue:0.894f alpha:1]];
    [view release], view = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[[self tabBarController] navigationItem] setRightBarButtonItem:nil];
    [[self navigationController] setNavigationBarHidden:NO animated:animated];
    [MBProgressHUD showHUDAddedTo:[self view] animated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    int padding = 5;
    int runningHeight = padding;
    CGSize maxLabelSize = CGSizeMake(320 - 2 * padding, MAXFLOAT);
    UIFont *boldFont = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:17];
    UIColor *fontColor = [UIColor colorWithRed:0.301f green:0.325f blue:0.431f alpha:1];
    
    PFFile *imageFile = [[self purge] objectForKey:@"image"];
    NSData *imageData;
    if ( ! [imageFile isDataAvailable]) {
        imageData = [imageFile getData];
    }
    else {
        imageData = [[self purge] objectForKey:@"image"];
    }
    
    UIImage *image = [UIImage imageWithData:imageData];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    CGRect frame = CGRectMake(padding, padding, 320 - 2 * padding, 320 - 2 * padding);
    [imageView setFrame:frame];
    [[self scrollView] addSubview:imageView];
    [[imageView layer] setMasksToBounds:YES];
    [[imageView layer] setCornerRadius:2.0];
    [[imageView layer] setBorderColor:[[UIColor colorWithRed:0.396f green:0.435f blue:0.427f alpha:0.8] CGColor]];
    [[imageView layer] setBorderWidth:2.0];
    runningHeight += imageView.frame.size.height + padding;
    [imageView release], imageView = nil;
    
    UILabel *descriptionTitle = [[UILabel alloc] initWithFrame:CGRectMake(padding, runningHeight, 320 - 2 * padding, 20)];
    [descriptionTitle setText:@"Description"];
    [descriptionTitle setFont:boldFont];
    [[self scrollView] addSubview:descriptionTitle];
    runningHeight += descriptionTitle.frame.size.height;
    [descriptionTitle setBackgroundColor:[UIColor clearColor]];
    [descriptionTitle setTextColor:fontColor];
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
    [description setTextColor:fontColor];
    [[self scrollView] addSubview:description];
    runningHeight += description.frame.size.height + padding;
    [description setBackgroundColor:[UIColor clearColor]];
    [description release], description = nil;
    
    UILabel *priceTitle = [[UILabel alloc] initWithFrame:CGRectMake(padding, runningHeight, 320 - 2 * padding, 20)];
    [priceTitle setText:@"Price"];
    [priceTitle setFont:boldFont];
    [[self scrollView] addSubview:priceTitle];
    [priceTitle setTextColor:fontColor];
    runningHeight += priceTitle.frame.size.height;
    [priceTitle setBackgroundColor:[UIColor clearColor]];
    [priceTitle release], priceTitle = nil;
    
    UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(padding, runningHeight, 320 - 2 * padding, 20)];
    [price setNumberOfLines:0];
    [price setLineBreakMode:UILineBreakModeWordWrap];
    dText = [[self purge] objectForKey:@"price"];
    [price setText:dText];
    [[self scrollView] addSubview:price];
    [price setBackgroundColor:[UIColor clearColor]];
    [price setTextColor:fontColor];
    runningHeight += price.frame.size.height + padding;
    [price release], price = nil;
    
    CGRect buttonFrame = CGRectMake(padding, runningHeight, 320 - 2 * padding, 73);
    UIButton *delete = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *deleteImage = [UIImage imageNamed:@"product_button.png"];
    [delete setImage:deleteImage forState:UIControlStateNormal];
    [delete setTitleEdgeInsets:UIEdgeInsetsMake(10, -320, 5.0, 5.0)];
    [[delete titleLabel] setFont:boldFont];
    [delete setTitleColor:fontColor forState:UIControlStateNormal];
    [delete setTitle:@"Delete" forState:UIControlStateNormal];
    [delete addTarget:self action:@selector(onDelete) forControlEvents:UIControlEventTouchUpInside];
    [delete setFrame:buttonFrame];
    [[self scrollView] addSubview:delete];
    runningHeight += delete.frame.size.height + padding;
    
    [[self scrollView] setContentSize:CGSizeMake(320, runningHeight)];
            
    [MBProgressHUD hideHUDForView:[self view] animated:YES];
}

-(void)onDelete
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are you sure you want to purge this Purge?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    [av show];
    [av release], av = nil;
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[self purge] deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [[self navigationController] popViewControllerAnimated:YES];
                [[self delegate] myItemWasDeleted];
            }
            else {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error processing your request." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [av show];
                [av release], av = nil;
            }
        }];
    }
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
