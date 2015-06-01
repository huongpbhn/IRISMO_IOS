//
//  AsyncImageView.h
//  B88C
//
//  Created by Ricky Lee on 4/10/15.
//  Copyright (c) 2015 Ricky Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Async.h"

@interface AsyncImageView : UIImageView

- (void)downloadImageWithURL:(NSString *)imageURL;

@end
