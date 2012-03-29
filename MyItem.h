//
//  MyItem.h
//  Purge
//
//  Created by Ryan Nystrom on 2/18/12.
//  Copyright (c) 2012 Topic Design. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyItemDelegate;

@interface MyItem : UIViewController
<UIScrollViewDelegate, UIAlertViewDelegate>
{
    PFObject *_purge;
    UIScrollView *_scrollView;
    id <MyItemDelegate> _delegate;
}

@property (nonatomic, retain) PFObject *purge;
@property (nonatomic, retain) id <MyItemDelegate> delegate;
@property (nonatomic, retain) UIScrollView *scrollView;

@end

@protocol MyItemDelegate

-(void)myItemWasDeleted;

@end