//
//  UIImage+Resize.h
//  IRISLibrary
//
//  Created by Ricky Lee on 1/13/15.
//  Copyright (c) 2015 Ricky Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)

- (UIImage *)imageWithSize:(CGSize)newSize;
- (UIImage *)imageWithScale:(float)scale;
- (UIImage *)imageWithWidth:(float)width;
- (UIImage *)imageWithHeight:(float)height;

@end
