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

@interface ServerUtils : NSObject<NSURLConnectionDataDelegate> {
}

@property (nonatomic, assign)id delegate;

#pragma mark - Reachability
-(BOOL)internetIsAvailable;

-(BOOL)wifiIsAvailable;

-(BOOL)hostIsAvailable:(NSString *)host;

#pragma mark - Convert NSData to String/JSON
+ (NSString *)dataToString:(NSData *)data;

+ (NSDictionary *)dataToJSON:(NSData *)data;

#pragma mark - ServerUtils using blocks
- (void)get:(NSString *)urlStr completionHandler:(void(^)(BOOL successed, NSData *data))completionBlock;
- (void)get:(NSString *)urlStr withHeader:(NSDictionary *)headerParams completionHandler:(void(^)(BOOL successed, NSData *data))completionBlock;

- (void)post:(NSString *)urlStr withHeader:(NSDictionary *)headerParams withBody:(NSDictionary *)bodyParams completionHandler:(void(^)(BOOL successed, NSData *data))completionBlock;

- (void)uploadImage:(UIImage *)theImage withURL:(NSString *)theUrl completionHandler:(void(^)(BOOL successed, NSData *data))completionBlock;

- (void)uploadAudio:(NSURL *)wavPath withURL:(NSString *)theUrl completionHandler:(void(^)(BOOL successed, NSData *data))completionBlock;

#pragma mark - ServerUtils
- (void)get:(NSString *)urlStr;

- (void)post:(NSString *)urlStr withBody:(NSDictionary *)params;

- (void)uploadImage:(UIImage *)theImage withURL:(NSString *)theUrl;

- (void)uploadAudio:(NSURL *)wavPath withURL:(NSString *)theUrl;

@end
