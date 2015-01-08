//
//  HTTPClient.m
//
//  Created by Ricky Lee on 12/22/14.
//  Copyright (c) 2014 Ricky Lee. All rights reserved.
//

#import "ServerUtils.h"
#import "Reachability.h"

#define TIME 25.0f
#define REQUEST_TIME 30.0f

// final

@interface ServerUtils() {
    NSURLConnection *connection;
    NSMutableData *receivedData;
    
    NSTimer *timer;

    Reachability *internetReachablility;
}

@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *wifiReachability;

@end

@implementation ServerUtils

@synthesize delegate;

#pragma mark - Reachability
- (BOOL)updateInterfaceWithReachability:(Reachability *)reachability
{
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    BOOL reachable = NO;
    switch (netStatus)
    {
        case NotReachable:        {
            NSLog(@"Internet NotReachable");
            reachable = NO;
            break;
        }
        case ReachableViaWWAN:        {
            NSLog(@"Internet ReachableViaWWAN");
            reachable = YES;
            break;
        }
        case ReachableViaWiFi:        {
            NSLog(@"Internet ReachableViaWiFi");
            reachable = YES;
            break;
        }
    }

    return reachable;
}

-(BOOL)internetIsAvailable {
    NSLog(@"Check Internet Connection...");
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    return [self updateInterfaceWithReachability:reachability];
}

-(BOOL)wifiIsAvailable {
    NSLog(@"Check Wifi Connection...");
    Reachability *reachability = [Reachability reachabilityForLocalWiFi];
    [reachability startNotifier];
    return [self updateInterfaceWithReachability:reachability];
}

-(BOOL)hostIsAvailable:(NSString *)host {
    NSLog(@"Check Host Connection...");
    Reachability *reachability = [Reachability reachabilityWithHostName:host];
    [reachability startNotifier];
    return [self updateInterfaceWithReachability:reachability];
}

#pragma mark - Data Convertion
+ (NSString *)dataToString:(NSData *)data {
    NSString *dataString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    return dataString;
}

+ (NSDictionary *)dataToJSON:(NSData *)data {
    NSError *e;
    NSDictionary *jsonDict =
    [NSJSONSerialization JSONObjectWithData: data
                                    options: NSJSONReadingMutableContainers
                                      error: &e];
    return jsonDict;
}

#pragma mark - Connection Timer
- (void)cancelTimer {
    if (timer.isValid) {
        [timer invalidate];
        timer = nil;
    }
}

- (void)fireTimer {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSLog(@"HTTPClient Connection timeout!");
    [self cancelConnection];
}

- (void)startTimer {
    timer = [NSTimer scheduledTimerWithTimeInterval:TIME target:self selector:@selector(fireTimer) userInfo:nil repeats:NO];
}

#pragma mark - URL request using block

/***************************************************************
 *
 *
 * ServerUtils with Blocks
 *
 *
 ***************************************************************/

- (void)get:(NSString *)urlStr completionHandler:(void(^)(BOOL successed, NSData *data))completionBlock {
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:REQUEST_TIME];
    
    [self connectWithRequest:theRequest completionHandler:^(BOOL successed, NSData *data) {
        completionBlock(successed, data);
    }];
}

- (void)post:(NSString *)urlStr withBody:(NSDictionary *)params completionHandler:(void(^)(BOOL successed, NSData *data))completionBlock {
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                        timeoutInterval:REQUEST_TIME];
    
    [theRequest setHTTPMethod:@"POST"];
    NSMutableString *httpBody = [[NSMutableString alloc] init];
    int count = (int)[[params allKeys] count];
    for(int i = 0; i < count; i++) {
        NSString *key = [[params allKeys] objectAtIndex:i];
        if (i >= count-1) {
            [httpBody appendFormat:@"%@=%@", key, [params objectForKey:key]];
        }
        else {
            [httpBody appendFormat:@"%@=%@&", key, [params objectForKey:key]];
        }
    }
    
    [theRequest setHTTPBody:[httpBody dataUsingEncoding:NSUTF8StringEncoding]];
    [httpBody release];
    
    [self connectWithRequest:theRequest completionHandler:^(BOOL successed, NSData *data) {
        completionBlock(successed, data);
    }];
    
}

- (void)uploadImage:(UIImage *)theImage withURL:(NSString *)theUrl completionHandler:(void(^)(BOOL successed, NSData *data))completionBlock {
    
    NSData *imageData = UIImageJPEGRepresentation(theImage, 1.0);
    // setting up the URL to post to
    NSString *urlString = theUrl;
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *dispositionStr = [[NSString alloc]initWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"temp.jpg\"\r\n"];
    [body appendData:[dispositionStr dataUsingEncoding:NSUTF8StringEncoding]];
    [dispositionStr release];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    [self connectWithRequest:request completionHandler:^(BOOL successed, NSData *data) {
        completionBlock(successed, data);
    }];
}

- (void)uploadAudio:(NSURL *)wavPath withURL:(NSString *)theUrl completionHandler:(void(^)(BOOL successed, NSData *data))completionBlock {
    
    NSString *urlString = theUrl;
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *dispositionStr = [[NSString alloc]initWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"temp.wav\"\r\n"];
    [body appendData:[dispositionStr dataUsingEncoding:NSUTF8StringEncoding]];
    [dispositionStr release];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *postData = [NSData dataWithContentsOfFile:wavPath.path];
    [body appendData:postData];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    [self connectWithRequest:request completionHandler:^(BOOL successed, NSData *data) {
        completionBlock(successed, data);
    }];
    
}

- (void)connectWithRequest:(NSURLRequest *)request completionHandler:(void(^)(BOOL successed, NSData *data))completionBlock {
    
    if (![self internetIsAvailable]) {
        NSLog(@"no internet connection");
        return;
    }
    
    [self startTimer];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               [self cancelTimer];
                               if ( !error )
                               {
                                   completionBlock(YES,data);
                               } else{
                                   NSLog(@"ServerUtils Connection failed! Error - %@ %@", [error localizedDescription], [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
                                   completionBlock(NO,nil);
                               }
                           }];

}

#pragma mark - URL request using delegate

/***************************************************************
 *
 *
 * ServerUtils with Delegate
 *
 *
 ***************************************************************/

- (void)get:(NSString *)urlStr {
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:REQUEST_TIME];
    
    [self connectWithRequest:theRequest];
}

- (void)post:(NSString *)urlStr withBody:(NSDictionary *)params {
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]
                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                        timeoutInterval:REQUEST_TIME];
    
    [theRequest setHTTPMethod:@"POST"];
    NSMutableString *httpBody = [[NSMutableString alloc] init];
    int count = (int)[[params allKeys] count];
    for(int i = 0; i < count; i++) {
        NSString *key = [[params allKeys] objectAtIndex:i];
        if (i >= count-1) {
            [httpBody appendFormat:@"%@=%@", key, [params objectForKey:key]];
        }
        else {
            [httpBody appendFormat:@"%@=%@&", key, [params objectForKey:key]];
        }
    }
    
    [theRequest setHTTPBody:[httpBody dataUsingEncoding:NSUTF8StringEncoding]];
    [httpBody release];
    
    [self connectWithRequest:theRequest];
}

- (void)uploadImage:(UIImage *)theImage withURL:(NSString *)theUrl {
    
    NSData *imageData = UIImageJPEGRepresentation(theImage, 1.0);
    // setting up the URL to post to
    NSString *urlString = theUrl;
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *dispositionStr = [[NSString alloc]initWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"dr.jpg\"\r\n"];
    [body appendData:[dispositionStr dataUsingEncoding:NSUTF8StringEncoding]];
    [dispositionStr release];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    [self connectWithRequest:request];
}

- (void)uploadAudio:(NSURL *)wavPath withURL:(NSString *)theUrl {
    
    NSString *urlString = theUrl;
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *dispositionStr = [[NSString alloc]initWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"temp.wav\"\r\n"];
    [body appendData:[dispositionStr dataUsingEncoding:NSUTF8StringEncoding]];
    [dispositionStr release];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *postData = [NSData dataWithContentsOfFile:wavPath.path];
    [body appendData:postData];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    [self connectWithRequest:request];
    
}

#pragma mark Create Server Connection
- (void)cancelConnection {
    if (connection) {
        [connection cancel];
        [connection release];
        connection = nil;
    }
}

- (void)connectWithRequest:(NSURLRequest *)request {
    
    if (![self internetIsAvailable]) {
        NSLog(@"no internet connection");
        return;
    }
    
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection) {
        [self startTimer];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        receivedData = [[NSMutableData data] retain];
    } else {
        // Inform the user that the connection failed.
        NSLog(@"ServerUtils Connection failed!");
    }

}

#pragma mark NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

#pragma mark Server Responds
- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
{
    [self cancelTimer];
    [self cancelConnection];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if ([delegate respondsToSelector:@selector(serverUtilsDidFailed:)]) {
        [delegate serverUtilsDidFailed:error];
    }
    
    [receivedData release];
    
    // inform the user
    NSLog(@"ServerUtils Connection failed! Error - %@ %@", [error localizedDescription], [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);

}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection
{
    NSLog(@"ServerUtils Connection URL: %@", theConnection.currentRequest.URL.absoluteString);
    [self cancelTimer];
    [self cancelConnection];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if ([delegate respondsToSelector:@selector(serverUtilsDidFinished:)]) {
        [delegate serverUtilsDidFinished:receivedData];
    }
    
    [receivedData release];
}

@end
