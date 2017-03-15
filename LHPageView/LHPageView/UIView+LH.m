//
//  UIView+LH.m
//  chezhiwang
//
//  Created by bangong on 16/11/2.
//  Copyright © 2016年 车质网. All rights reserved.
//

#import "UIView+LH.h"

@implementation UIView (LH)

#pragma mark - sets
- (void)setLh_top:(CGFloat)lh_top{
    CGRect frame = self.frame;
    frame.origin.y = lh_top;
    self.frame = frame;
}

- (void)setLh_left:(CGFloat)lh_left{
    CGRect frame = self.frame;
    frame.origin.x = lh_left;
    self.frame = frame;
}

- (void)setLh_bottom:(CGFloat)lh_bottom{
    CGRect frame = self.frame;
    frame.origin.y = lh_bottom - CGRectGetHeight(frame);
    self.frame = frame;
}

- (void)setLh_right:(CGFloat)lh_right{
    CGRect frame = self.frame;
    frame.origin.x = lh_right - CGRectGetWidth(frame);
    self.frame = frame;
}

- (void)setLh_centerX:(CGFloat)lh_centerX{
    CGPoint center = self.center;
    center.x = lh_centerX;
    self.center = center;
}

- (void)setLh_centerY:(CGFloat)lh_centerY{
    CGPoint center = self.center;
    center.y = lh_centerY;
    self.center = center;
}

- (void)setLh_width:(CGFloat)lh_width{
    CGRect frame = self.frame;
    frame.size.width = lh_width;
    self.frame = frame;
}

- (void)setLh_height:(CGFloat)lh_height{
    CGRect frame = self.frame;
    frame.size.height = lh_height;
    self.frame = frame;
}

- (void)setLh_size:(CGSize)lh_size{
    CGRect frame = self.frame;
    frame.size = lh_size;
    self.frame = frame;
}

#pragma mark - gets
- (CGFloat)lh_top{
    return self.frame.origin.y;
}

- (CGFloat)lh_left{
 return self.frame.origin.x;
}

- (CGFloat)lh_bottom{
    return self.frame.origin.y + CGRectGetHeight(self.frame);
}

- (CGFloat)lh_right{
    return self.frame.origin.x + CGRectGetWidth(self.frame);
}

- (CGFloat)lh_centerX{
    return self.center.x;
}

- (CGFloat)lh_centerY{
    return self.center.y;
}


- (CGFloat)lh_width{
    return CGRectGetWidth(self.frame);
}

- (CGFloat)lh_height{
    return CGRectGetHeight(self.frame);
}

- (CGSize)lh_size{
    return self.frame.size;
}



- (UIImage *)imageWithFrame:(CGRect)frame{
    UIImage *viewImage = [self getImage];
    CGImageRef resultRef = CGImageCreateWithImageInRect(viewImage.CGImage, frame);
    UIImage *result = [UIImage imageWithCGImage:resultRef];
    return result;
}

- (UIImage *)getImage{
    UIGraphicsBeginImageContextWithOptions(self.frame.size, self.opaque, 0.0);
    //设置截屏大小
    [[self layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return viewImage;
}
@end
