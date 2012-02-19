//
//  Item.h
//  Purge
//
//  Created by Ryan Nystrom on 2/18/12.
//  Copyright (c) 2012 Topic Design. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Item : UIViewController
<UIScrollViewDelegate>
{
    PFObject *_purge;
}

@property (nonatomic, retain) PFObject *purge;

- (UIImage*)imageByScalingForHeight:(CGFloat)maxHeight WithImage:(UIImage*)image;

@end
