//
//  CreatePurge.h
//  Purge
//
//  Created by Ryan Nystrom on 2/18/12.
//  Copyright (c) 2012 Topic Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CreatePurge : UIViewController
<UITextFieldDelegate, UITextViewDelegate, UIScrollViewDelegate, UIAlertViewDelegate, MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    UIImage *_image;
    UITextField *_priceField;
    UITextView *_descriptionTextView;
    UIScrollView *_scrollView;
}

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) UITextField *priceField;
@property (nonatomic, retain) UITextView *descriptionTextView;
@property (nonatomic, retain) UIScrollView *scrollView;

- (UIImage*)imageByScalingForHeight:(CGFloat)maxHeight WithImage:(UIImage*)image;
- (void)setViewMovedUp:(BOOL)movedUp;
-(void)onDone;
- (UIImage*)imageByScalingForSize:(CGSize)size WithImage:(UIImage*)image;
- (UIImage*)convertToWeb:(UIImage*)image;
- (NSData *)convertToWebWithWidth:(float)length WithImage:(UIImage*)image;

@end
