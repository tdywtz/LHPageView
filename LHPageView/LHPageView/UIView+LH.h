//
//  UIView+LH.h
//  chezhiwang
//
//  Created by bangong on 16/11/2.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LH)


@property (nonatomic,assign) CGFloat lh_top;
@property (nonatomic,assign) CGFloat lh_left;
@property (nonatomic,assign) CGFloat lh_bottom;
@property (nonatomic,assign) CGFloat lh_right;
@property (nonatomic,assign) CGFloat lh_centerX;
@property (nonatomic,assign) CGFloat lh_centerY;
@property (nonatomic,assign) CGFloat lh_width;
@property (nonatomic,assign) CGFloat lh_height;
@property (nonatomic,assign) CGSize  lh_size;

- (UIImage *)imageWithFrame:(CGRect)frame;

- (UIImage *)getImage;

@end
