//
//  SignupModal.h
//  Purge
//
//  Created by Ryan Nystrom on 2/18/12.
//  Copyright (c) 2012 Topic Design. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ConnectSocial.h"
#import "MainTabView.h"

@interface Signup : UITableViewController
<UITextFieldDelegate>
{
    UITextField *_nameField;
    UITextField *_passField;
    UITextField *_emailField;
}

@property (nonatomic, retain) UITextField *nameField;
@property (nonatomic, retain) UITextField *passField;
@property (nonatomic, retain) UITextField *emailField;

-(void)onDone;
-(void)signup;

@end