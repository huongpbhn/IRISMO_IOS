//
//  UIImage+Async.h
//  IRISLibrary
//
//  Created by Ricky Lee on 12/26/14.
//  Copyright (c) 2014 Ricky Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 *Async download image with NSCache
 */

@interface UIImage (Async)

+ (void)downloadImageWithURL:(NSString *)url completionHandler:(void (^)(BOOL succeeded, UIImage *image))completionBlock;

@end
