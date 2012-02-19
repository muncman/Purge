//
//  Purge.h
//  Purge
//
//  Created by Ryan Nystrom on 2/18/12.
//  Copyright (c) 2012 Topic Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreatePurge.h"

@interface Purge : UIViewController
<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

-(void)onChooseExisting;
-(void)onTakePhoto;
-(void)onCancelPhoto;

@end
