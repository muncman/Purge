//
//  LoginModal.m
//  Purge
//
//  Created by Ryan Nystrom on 2/18/12.
//  Copyright (c) 2012 Topic Design. All rights reserved.
//

#import "Login.h"


@implementation Login

@synthesize nameField = _nameField;
@synthesize passField = _passField;

-(void)dealloc
{
    [_nameField release], _nameField = nil;
    [_passField release], _passField = nil;
    [super dealloc];
}

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
    
    [self setTitle:@"Login"];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(onDone)];
    [[self navigationItem] setRightBarButtonItem:doneButton];
    [doneButton release], doneButton = nil;
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
    [[self navigationController] setNavigationBarHidden:NO animated:animated];
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
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 1;
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
        
        if ([indexPath section] == 0) {
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
            [textField setAdjustsFontSizeToFitWidth:YES];
            [textField setTextColor:[UIColor blackColor]];
            [textField setDelegate:self];
            [textField setBackgroundColor:[UIColor whiteColor]];
            [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
            [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            [textField setTextAlignment:UITextAlignmentLeft];
            [textField setBackgroundColor:[UIColor clearColor]];
            switch ([indexPath row]) {
                case 0:
                    [textField setKeyboardType:UIKeyboardTypeEmailAddress];
                    [textField setReturnKeyType:UIReturnKeyNext];
                    [self setNameField:textField];
                    break;
                case 1:
                    [textField setKeyboardType:UIKeyboardTypeDefault];
                    [textField setReturnKeyType:UIReturnKeyDone];
                    [textField setSecureTextEntry:YES];
                    [self setPassField:textField];
                    break;
            }
            
            [cell addSubview:textField];
            
            [textField release];
        }
    }
    
    if ([indexPath section] == 0) {
        switch ([indexPath row]) {
            case 0:
                [[cell textLabel] setText:@"Username"];
                break;
            case 1:
                [[cell textLabel] setText:@"Password"];
                break;
        }
    }
    else if ([indexPath section] == 1 && [indexPath row] == 0) {
        [[cell textLabel] setText:@"Forgot Password"];
        [[cell textLabel] setTextAlignment:UITextAlignmentCenter];
    }
    
    return cell;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // username
    if ([textField isEqual:[self nameField]]) {
        [[self passField] becomeFirstResponder];
    }
    // password
    else {
        [textField resignFirstResponder];
        [self login];
    }
    return YES;
}

-(void)onDone
{
    [self login];
    [[self nameField] resignFirstResponder];
    [[self passField] resignFirstResponder];
}

-(void)login
{
    NSString *username = [[self nameField] text];
    NSString *password = [[self passField] text];

    if ( ! username || [username length] == 0) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Valid username required." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [av show];
        [av release], av = nil;
        return;
    }
    if ( ! password || [password length] == 0) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Valid password required." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [av show];
        [av release], av = nil;
        return;
    }

    [MBProgressHUD showHUDAddedTo:[self view] animated:YES];

    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
        [MBProgressHUD hideHUDForView:[self view] animated:YES];
        
        if ( ! error && user) {
            MainTabView *appView = [[MainTabView alloc] init];
            CATransition *transition = [CATransition animation];
            transition.duration = 0.3f;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionFade;
            [[[[self navigationController] view] layer] addAnimation:transition forKey:nil];
            
            [[self navigationController] pushViewController:appView animated:NO];
            [appView release], appView = nil;
        }
        else {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Username or password incorrect." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [av show];
            [av release], av = nil;
        }
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 1) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        for (UIView *view in [cell subviews]) {
            if ([view isKindOfClass:[UITextField class]]) {
                [(UITextField*)view becomeFirstResponder];
            }
        }
    }
}

@end
