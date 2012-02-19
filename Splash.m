//
//  Signup.m
//  Purge
//
//  Created by Ryan Nystrom on 2/18/12.
//  Copyright (c) 2012 Topic Design. All rights reserved.
//

#import "Splash.h"

@implementation Splash

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

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self navigationController] setToolbarHidden:YES];
    [[self navigationController] setNavigationBarHidden:YES];
    
    // Create buttons
    CGRect buttonFrame = CGRectMake(110, 150, 100, 60);
    UIButton *signupButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [signupButton setFrame:buttonFrame];
    [signupButton setTitle:@"Sign up" forState:UIControlStateNormal];
    [signupButton addTarget:self action:@selector(onSignup) forControlEvents:UIControlEventTouchUpInside];
    
    buttonFrame.origin.y += 2 * buttonFrame.size.height;
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginButton setFrame:buttonFrame];
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(onLogin) forControlEvents:UIControlEventTouchUpInside];
    
    [[self view] addSubview:signupButton];
    [[self view] addSubview:loginButton];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:animated];
}

-(void)onSignup
{
    Signup *signup = [[Signup alloc] initWithStyle:UITableViewStyleGrouped];
    [[self navigationController] pushViewController:signup animated:YES];
    [signup release], signup = nil;
}

-(void)onLogin
{
    Login *login = [[Login alloc] initWithStyle:UITableViewStyleGrouped];
    [[self navigationController] pushViewController:login animated:YES];
    [login release], login = nil;
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
