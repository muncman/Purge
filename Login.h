//
//  LoginModal.h
//  Purge
//
//  Created by Ryan Nystrom on 2/18/12.
//  Copyright (c) 2012 Topic Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTabView.h"

@interface Login : UITableViewController
<UITextFieldDelegate>
{
    UITextField *_nameField;
    UITextField *_passField;
}

@property (nonatomic, retain) UITextField *nameField;
@property (nonatomic, retain) UITextField *passField;

-(void)onDone;
-(void)login;

@end