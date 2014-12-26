//
//  HTTPClient.h
//
//  Created by Ricky Lee on 12/22/14.
//  Copyright (c) 2014 Ricky Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ServerUtilsDelegate <NSObject>

- (void)serverUtilsDidFinished:(NSData *)data;
- (void)serverUtilsDidFailed:(NSError *)error;

@end

@interface ServerUtils : NSObject<NSURLConnectionDataDelegate>

@property (nonatomic, assign)id delegate;

- (void)get:(NSString *)urlStr;
- (void)post:(NSString *)urlStr withBody:(NSDictionary *)params;
- (void)uploadImage:(UIImage *)theImage withURL:(NSString *)theUrl;
- (void)uploadAudio:(NSURL *)wavPath withURL:(NSString *)theUrl;

@end
