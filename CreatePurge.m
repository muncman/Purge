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
@synthesize scrollView = _scrollView;

#define kOFFSET_FOR_KEYBOARD 216.0

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [_image release], _image = nil;
    [_descriptionTextView release], _descriptionTextView = nil;
    [_priceField release], _priceField = nil;
    [_scrollView release], _scrollView = nil;

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
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Purge" style:UIBarButtonItemStyleDone target:self action:@selector(onDone)];
    [[self navigationItem] setRightBarButtonItem:doneButton];
    [doneButton release], doneButton = nil;
    
    int xPosition = 15;
    int padding = 15;
    UIFont *boldFont = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:17];
    UIColor *fontColor = [UIColor colorWithRed:0.301f green:0.325f blue:0.431f alpha:1];
    
    UIScrollView *view = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
    [self setScrollView:view];
    [[self view] addSubview:view];
    [view setScrollEnabled:YES];
    [view setShowsVerticalScrollIndicator:NO];
    [view setAlwaysBounceVertical:YES];
    [view setDelegate:self];
    [view setBackgroundColor:[UIColor colorWithRed:0.792f green:0.874f blue:0.894f alpha:1]];
    [view setUserInteractionEnabled:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillShow:) 
												 name:UIKeyboardWillShowNotification 
                                               object:[[self view] window]]; 
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillShow:) 
												 name:UIKeyboardWillHideNotification 
                                               object:[[self view] window]]; 
    
    UIImage *newImage = [UIImage imageWithData:[self convertToWebWithWidth:kWebImageWidth WithImage:[self image]]];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:newImage];
    CGRect frame = CGRectMake(padding, padding, 320 - 2 * padding, 320 - 2 * padding);
    [imageView setFrame:frame];
    [[self scrollView] addSubview:imageView];
    [[imageView layer] setBorderColor:[[UIColor colorWithRed:0.396f green:0.435f blue:0.427f alpha:0.8] CGColor]];
    [[imageView layer] setBorderWidth:1.0];
    [[imageView layer] setCornerRadius:1.0];
    
    xPosition += imageView.frame.size.height;
    UILabel *description = [[UILabel alloc] initWithFrame:CGRectMake(padding, xPosition, 320 - padding * 2, 30)];
    [description setBackgroundColor:[UIColor clearColor]];
    [description setText:@"Description"];
    [description setFont:boldFont];
    [description setTextColor:fontColor];
    [[self scrollView] addSubview:description];
    
    xPosition += description.frame.size.height;
    UITextView *descriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(padding, xPosition, 320 - padding * 2, 80)];
    [descriptionTextView setDelegate:self];
    [[descriptionTextView layer] setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [[descriptionTextView layer] setBorderWidth:2.0f];
    [[descriptionTextView layer] setCornerRadius:5];
    [descriptionTextView setClipsToBounds:YES];
    [descriptionTextView setFont:font];
    [descriptionTextView setTextColor:fontColor];
    [descriptionTextView setBackgroundColor:[UIColor clearColor]];
    [[self scrollView] addSubview:descriptionTextView];
    [self setDescriptionTextView:descriptionTextView];
    
    xPosition += descriptionTextView.frame.size.height;    
    UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(padding, xPosition, 320 - padding * 2, 30)];
    [price setBackgroundColor:[UIColor clearColor]];
    [price setText:@"Price:"];
    [price setFont:boldFont];
    [price setTextColor:fontColor];
    [[self scrollView] addSubview:price];
    
    xPosition += price.frame.size.height;
    UITextField *priceField = [[UITextField alloc] initWithFrame:CGRectMake(padding, xPosition, 320 - padding * 2, 50)];
    [priceField setReturnKeyType:UIReturnKeyDefault];
    [priceField setDelegate:self];
    [priceField setBorderStyle:UITextBorderStyleNone];
    [[priceField layer] setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [[priceField layer] setBorderWidth:2.0f];
    [[priceField layer] setCornerRadius:5];
    [priceField setFont:font];
    [priceField setTextColor:fontColor];
    [priceField setBackgroundColor:[UIColor clearColor]];
    [[self scrollView] addSubview:priceField];
    [self setPriceField:priceField];
    
    xPosition += priceField.frame.size.height;
    [view setContentSize:CGSizeMake(320, xPosition + 2 * padding)];
    
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
            NSData *thumbnailData = [self convertToWebWithWidth:kThumbnailWidth WithImage:[self image]];
;
                        
            PFFile *thumbFile = [PFFile fileWithName:@"thumbnail.png" data:thumbnailData];
            PFObject *purge = [PFObject objectWithClassName:@"Purges"];
            
            [MBProgressHUD showHUDAddedTo:[[self navigationController] view] animated:YES];
            
            [purge setObject:[[self priceField] text] forKey:@"price"];
            [purge setObject:[[self descriptionTextView] text] forKey:@"description"];
            
            // save thumbnail
            [thumbFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    //relate
                    [purge setObject:thumbFile forKey:@"thumbnail"];
                    
                    NSData *imageData = [self convertToWebWithWidth:kWebImageWidth WithImage:[self image]];
                    PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
                    
                    [MBProgressHUD hideHUDForView:[[self navigationController] view] animated:YES];
                    
                    HUD = [[MBProgressHUD alloc] initWithView:[[self navigationController] view]];
                    [[[self navigationController] view] addSubview:HUD];
                    [HUD setMode:MBProgressHUDModeDeterminate];
                    [HUD setDelegate:self];
                    [HUD show:YES];
                    
                    // save image
                    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            //relate
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
//        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
	else
	{
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
//        rect.size.height -= kOFFSET_FOR_KEYBOARD;
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

- (void)hudWasHidden:(MBProgressHUD *)hud 
{
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    [HUD release];
	HUD = nil;
}

- (UIImage*)convertToWeb:(UIImage*)image 
{
	CGSize imgSize = [image size];
	UIGraphicsBeginImageContext(imgSize);
	[image drawInRect:CGRectMake(0, 0, imgSize.width, imgSize.height)];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

- (NSData *)convertToWebWithWidth:(float)length WithImage:(UIImage*)image 
{
    UIImage *newImage;

    UIImage *mainImage = image;
    UIImageView *mainImageView = [[UIImageView alloc] initWithImage:mainImage];
    BOOL widthGreaterThanHeight = (mainImage.size.width > mainImage.size.height);
    float sideFull = (widthGreaterThanHeight) ? mainImage.size.height : mainImage.size.width;
    CGRect clippedRect = CGRectMake(0, 0, sideFull, sideFull);
    //creating a square context the size of the final image which we will then
    // manipulate and transform before drawing in the original image
    UIGraphicsBeginImageContext(CGSizeMake(length, length));
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextClipToRect( currentContext, clippedRect);
    CGFloat scaleFactor = length/sideFull;
    if (widthGreaterThanHeight) {
        //a landscape image – make context shift the original image to the left when drawn into the context
        CGContextTranslateCTM(currentContext, -((mainImage.size.width - sideFull) / 2) * scaleFactor, 0);
    }
    else {
        //a portfolio image – make context shift the original image upwards when drawn into the context
        CGContextTranslateCTM(currentContext, 0, -((mainImage.size.height - sideFull) / 2) * scaleFactor);
    }
    //this will automatically scale any CGImage down/up to the required thumbnail side (length) when the CGImage gets drawn into the context on the next line of code
    CGContextScaleCTM(currentContext, scaleFactor, scaleFactor);
    [mainImageView.layer renderInContext:currentContext];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImagePNGRepresentation(newImage);
    [mainImageView release], mainImageView = nil;

    return imageData;
}

@end
