//
//  SignupModal.m
//  Purge
//
//  Created by Ryan Nystrom on 2/18/12.
//  Copyright (c) 2012 Topic Design. All rights reserved.
//

#import "Signup.h"


@implementation Signup

@synthesize nameField = _nameField;
@synthesize passField = _passField;
@synthesize emailField = _emailField;

-(void)dealloc
{
    [_nameField release], _nameField = nil;
    [_passField release], _passField = nil;
    [_emailField release], _emailField = nil;
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

    [self setTitle:@"Signup"];
    
    [[self view] setBackgroundColor:[UIColor colorWithRed:0.792f green:0.874f blue:0.894f alpha:1]];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStyleDone target:self action:@selector(onDone)];
    [[self navigationItem] setRightBarButtonItem:doneButton];
    [doneButton release], doneButton = nil;
}

-(void)onDone
{
    [self signup];
    [[self nameField] resignFirstResponder];
    [[self passField] resignFirstResponder];
    [[self emailField] resignFirstResponder];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
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
                [textField setPlaceholder:@"example@email.com"];
                [textField setKeyboardType:UIKeyboardTypeEmailAddress];
                [textField setReturnKeyType:UIReturnKeyNext];
                [self setEmailField:textField];
                [[self emailField] performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.1];
                break;
            case 1:
                [textField setPlaceholder:@"Required"];
                [textField setKeyboardType:UIKeyboardTypeDefault];
                [textField setReturnKeyType:UIReturnKeyNext];
                [self setNameField:textField];
                break;
            case 2:
                [textField setPlaceholder:@"Required"];
                [textField setKeyboardType:UIKeyboardTypeDefault];
                [textField setReturnKeyType:UIReturnKeyDone];
                [textField setSecureTextEntry:YES];
                [self setPassField:textField];
                break;
        }
        
        [cell addSubview:textField];
        
        [textField release];
    }
    
    switch ([indexPath row]) {
        case 0:
            [[cell textLabel] setText:@"Email"];
            break;
        case 1:
            [[cell textLabel] setText:@"Username"];
            break;
        case 2:
            [[cell textLabel] setText:@"Password"];
            break;
    }
    
    return cell;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // email
    if ([textField isEqual:[self emailField]]) {
        [[self nameField] becomeFirstResponder];
    }
    // username
    else if ([textField isEqual:[self nameField]]) {
        [[self passField] becomeFirstResponder];
    }
    // password
    else {
        [textField resignFirstResponder];
        [self signup];
    }
    return YES;
}

-(void)signup
{    
    NSString *username = [[self nameField] text];
    NSString *email = [[self emailField] text];
    NSString *pass = [[self passField] text];
    
    if ( ! username || [username length] < 2) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Valid username required." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [av show];
        [av release], av = nil;
        return;
    }
    if ( ! email || [email length] < 2) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Valid email required." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [av show];
        [av release], av = nil;
        return;
    }
    if ( ! pass || [pass length] < 2) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Valid password required." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [av show];
        [av release], av = nil;
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:[self view] animated:YES];
    
    PFUser *user = [PFUser user];
    [user setUsername:username];
    [user setPassword:pass];
    [user setEmail:email];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [MBProgressHUD hideHUDForView:[self view] animated:YES];
        if (succeeded) {
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
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:[[error userInfo] objectForKey:@"error"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [av show];
            [av release], av = nil;
        }
    }];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    for (UIView *view in [tableViewCell subviews]) {
        if ([view isKindOfClass:[UITextField class]]) {
            [(UITextField*)view becomeFirstResponder];
        }
    }
}

@end
