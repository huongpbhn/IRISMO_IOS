//
//  UIImage+Resize.m
//  IRISLibrary
//
//  Created by Ricky Lee on 1/13/15.
//  Copyright (c) 2015 Ricky Lee. All rights reserved.
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)

#pragma mark global
- (UIImage *)imageWithSize:(CGSize)newSize {
    
    UIGraphicsBeginImageContext(newSize);
    
    [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)imageWithScale:(float)scale {
    
    CGSize newSize = CGSizeMake(self.size.width * scale, self.size.height * scale);
    
    return [self imageWithSize:newSize];
}

- (UIImage *)imageWithWidth:(float)width {
    
    float ratio = width/self.size.width;
    CGSize newSize = CGSizeMake(width, self.size.height * ratio);
    
    return [self imageWithSize:newSize];
}

- (UIImage *)imageWithHeight:(float)height {
    
    float ratio = height/self.size.height;
    CGSize newSize = CGSizeMake(height, self.size.height * ratio);
    
    return [self imageWithSize:newSize];
}

@end
