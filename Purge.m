//
//  Purge.m
//  Purge
//
//  Created by Ryan Nystrom on 2/18/12.
//  Copyright (c) 2012 Topic Design. All rights reserved.
//

#import "Purge.h"

@implementation Purge

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect frame = [[self view] frame];
    CGRect buttonFrame = CGRectMake(15, frame.size.width / 3 * 2, frame.size.width - 2*15, 40);
    
    UIButton *choose = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [choose setTitle:@"Choose Existing" forState:UIControlStateNormal];
    [choose addTarget:self action:@selector(onChooseExisting) forControlEvents:UIControlEventTouchUpInside];
    [choose setFrame:buttonFrame];
    
    buttonFrame.origin.y += frame.size.width / 5;
    UIButton *take = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [take setTitle:@"Take Photo" forState:UIControlStateNormal];
    [take addTarget:self action:@selector(onTakePhoto) forControlEvents:UIControlEventTouchUpInside];
    [take setFrame:buttonFrame];
    
    
    
    [[self view] addSubview:choose];
    [[self view] addSubview:take];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:animated];
    [[self navigationController] setToolbarHidden:YES animated:animated];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [picker dismissModalViewControllerAnimated:YES];
    
    CreatePurge *createPurge = [[CreatePurge alloc] init];
    [createPurge setImage:image];
    [[self navigationController] pushViewController:createPurge animated:NO];
    
    [createPurge release], createPurge = nil;
    [picker release], picker = nil;
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
    
    [picker release], picker = nil;
}

-(void)onChooseExisting
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [picker setDelegate:self];
    [picker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    [self presentModalViewController:picker animated:YES];
}

-(void)onTakePhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [picker setDelegate:self];
    [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [self presentModalViewController:picker animated:YES];
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