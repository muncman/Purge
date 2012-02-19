//
//  CreatePurge.m
//  Purge
//
//  Created by Ryan Nystrom on 2/18/12.
//  Copyright (c) 2012 Topic Design. All rights reserved.
//

#import "CreatePurge.h"

@implementation CreatePurge

@synthesize image = _image;
@synthesize descriptionTextView = _descriptionTextView;
@synthesize priceField = _priceField;

#define kOFFSET_FOR_KEYBOARD 216.0

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [_image release], _image = nil;
    [_descriptionTextView release], _descriptionTextView = nil;
    [_priceField release], _priceField = nil;
    
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
    
    // keyboard animations
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillShow:) 
												 name:UIKeyboardWillShowNotification 
                                               object:[[self view] window]]; 
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillShow:) 
												 name:UIKeyboardWillHideNotification 
                                               object:[[self view] window]]; 
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(onDone)];
    [[self navigationItem] setRightBarButtonItem:doneButton];
    [doneButton release], doneButton = nil;
    
    int xPosition = 15;
    int padding = 15;
    CGFloat maxHeight = 200.0f;
    
    UIScrollView *view = [[UIScrollView alloc] initWithFrame:[[self view] frame]];
    [self setView:view];
    [view setScrollEnabled:YES];
    [view setShowsVerticalScrollIndicator:NO];
    [view setAlwaysBounceVertical:YES];
    [view setDelegate:self];
    
    UIImage *newImage = [self imageByScalingForHeight:maxHeight WithImage:[self image]];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:newImage];
    CGRect frame = [imageView frame];
    frame.origin.x = 320 - 320/2 - frame.size.width/2;
    frame.origin.y = padding;
    [imageView setFrame:frame];
    [[self view] addSubview:imageView];
    
    xPosition += imageView.frame.size.height;
    UILabel *description = [[UILabel alloc] initWithFrame:CGRectMake(padding, xPosition, 320 - padding * 2, 30)];
    [description setText:@"Description"];
    [[self view] addSubview:description];
    
    xPosition += description.frame.size.height;
    UITextView *descriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(padding, xPosition, 320 - padding * 2, 80)];
    [descriptionTextView setDelegate:self];
    [[descriptionTextView layer] setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [[descriptionTextView layer] setBorderWidth:2.0f];
    [[descriptionTextView layer] setCornerRadius:5];
    [descriptionTextView setClipsToBounds:YES];
    [[self view] addSubview:descriptionTextView];
    [self setDescriptionTextView:descriptionTextView];
    
    xPosition += descriptionTextView.frame.size.height;    
    UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(padding, xPosition, 320 - padding * 2, 30)];
    [price setText:@"Price:"];
    [[self view] addSubview:price];
    
    xPosition += price.frame.size.height;
    UITextField *priceField = [[UITextField alloc] initWithFrame:CGRectMake(padding, xPosition, 320 - padding * 2, 50)];
    [priceField setReturnKeyType:UIReturnKeyDefault];
    [priceField setDelegate:self];
    [priceField setBorderStyle:UITextBorderStyleRoundedRect];
    [[self view] addSubview:priceField];
    [self setPriceField:priceField];
    
    xPosition += priceField.frame.size.height;
    [view setContentSize:CGSizeMake(320, xPosition)];
    
    [view release], view = nil;
    [imageView release], imageView = nil;
    [price release], price = nil;
    [priceField release], priceField = nil;
    [description release], description = nil;
    [descriptionTextView release], descriptionTextView = nil;
}

-(void)onDone
{
    [[self priceField] resignFirstResponder];
    [[self descriptionTextView] resignFirstResponder];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"By listing your item you are agreeing to do something that we will put here." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Agree", nil];
    [av show];
    [av release];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *description = [[self descriptionTextView] text];
        NSString *price = [[self priceField] text];
        
        if (price && [price length] > 0 && description && [description length] > 0) {
            UIImage *thumbnail = [self imageByScalingForSize:CGSizeMake(kThumbnailWidth, kThumbnailHeight) WithImage:[self image]];
            NSData *thumbnailData = UIImagePNGRepresentation(thumbnail);
            
            HUD = [[MBProgressHUD alloc] initWithView:[[self navigationController] view]];
            [[[self navigationController] view] addSubview:HUD];
            [HUD setMode:MBProgressHUDModeDeterminate];
            [HUD setDelegate:self];
            [HUD show:YES];
            
            PFFile *thumbFile = [PFFile fileWithName:@"thumbnail.png" data:thumbnailData];
            PFObject *purge = [PFObject objectWithClassName:@"Purges"];
            
            [purge setObject:[[self priceField] text] forKey:@"price"];
            [purge setObject:[[self descriptionTextView] text] forKey:@"description"];
            
            // save thumbnail
            [thumbFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [purge setObject:thumbFile forKey:@"thumbnail"];
                    UIImage *properImage = [self orientImage:[self image]];
                    NSData *imageData = UIImagePNGRepresentation(properImage);
                    PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
                    // save image
                    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            [purge setObject:imageFile forKey:@"image"];
                            [purge setObject:[PFUser currentUser] forKey:@"user"];
                            // save data and link w/ user
                            [purge saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                if (succeeded) {
                                    [HUD hide:YES];
                                    
                                    [[self navigationController] popViewControllerAnimated:YES];
                                }
                                else {
                                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error processing your request." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                    [av show];
                                    [av release];
                                }
                            }];
                        }
                        else {
                            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error processing your request." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                            [av show];
                            [av release];
                        }
                    } progressBlock:^(int percentDone) {
                        [HUD setProgress:(percentDone / 100.0f)];
                    }];
                }
                else {
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error processing your request." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [av show];
                    [av release];
                }
            }];
        }
        else {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Must fill in description and price." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [av show];
            [av release];
        }
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[self navigationController] setToolbarHidden:YES animated:NO];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[self descriptionTextView] resignFirstResponder];
    [[self priceField] resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == [self priceField]) {
        [[self priceField] resignFirstResponder];
    }
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)notif {
    if ([self view].frame.origin.y >= 0) {
        [self setViewMovedUp:YES];
    }
    else {
        [self setViewMovedUp:NO];
    }
}

- (void)setViewMovedUp:(BOOL)movedUp {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];

    CGRect rect = [self view].frame;
    if (movedUp)
	{
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
	else
	{
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    [self view].frame = rect;
    
    [UIView commitAnimations];
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

- (UIImage*)imageByScalingForSize:(CGSize)size WithImage:(UIImage*)image
{
    UIGraphicsBeginImageContext( size );
    [image drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    [HUD release];
	HUD = nil;
}

- (UIImage*)orientImage:(UIImage*)image {
	CGSize imgSize = [image size];
	UIGraphicsBeginImageContext(imgSize);
//	CGContextRef context = UIGraphicsGetCurrentContext();
//	CGContextRotateCTM(context, -M_PI);
//	CGContextTranslateCTM(context, -imgSize.width, -imgSize.height);
	[image drawInRect:CGRectMake(0, 0, imgSize.width, imgSize.height)];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

@end
