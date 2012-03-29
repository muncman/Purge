//
//  Item.h
//  Purge
//
//  Created by Ryan Nystrom on 2/18/12.
//  Copyright (c) 2012 Topic Design. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Item : UIViewController
<UIScrollViewDelegate, UIAlertViewDelegate>
{
    PFObject *_purge;
    UIScrollView *_scrollView;
}

@property (nonatomic, retain) PFObject *purge;
@property (nonatomic, retain) UIScrollView *scrollView;

-(void)onBuy;

@end
