//
//  UIImage+Async.m
//
//  Created by Ricky Lee on 12/26/14.
//  Copyright (c) 2014 Ricky Lee. All rights reserved.
//

#import "UIImage+Async.h"

@implementation UIImage (Async)

static NSCache *cache = nil;

+ (void)downloadImageWithURL:(NSString *)url completionHandler:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    if (!cache) {
        cache = [[NSCache alloc] init];
    }
//    NSLog(@"url: %@", url);
    UIImage *image = [cache objectForKey:url];
    
    if (image) {
        completionBlock(YES, image);
    }
    else {
        NSURL *dlURL = [NSURL URLWithString:url];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:dlURL];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   UIImage *image = [UIImage imageWithData:data];
                                   if ( !error && [image isKindOfClass:[UIImage class]])
                                   {
                                       [cache setObject:image forKey:url];
                                       completionBlock(YES,image);
                                   } else{
                                       NSLog(@"Error getting image: %@", url);
                                       completionBlock(NO,nil);
                                   }
                               }];
    }
}

@end
