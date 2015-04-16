//
//  AsyncImageView.m
//  B88C
//
//  Created by Ricky Lee on 4/10/15.
//  Copyright (c) 2015 Ricky Lee. All rights reserved.
//

#import "AsyncImageView.h"

@interface AsyncImageView () {
    UIActivityIndicatorView *spinner;
}

@end

@implementation AsyncImageView

- (void)startSpinner {
    if (!spinner) {
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    spinner.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    spinner.hidesWhenStopped = YES;
    [self addSubview:spinner];
    [spinner startAnimating];
}

- (void)stopSpinner {
    [spinner stopAnimating];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)downloadImageWithURL:(NSString *)imageURL {
    [self startSpinner];
    self.image = nil;
    [UIImage downloadImageWithURL:imageURL completionHandler:^(BOOL succeeded, UIImage *image) {
        if (succeeded) {
            self.image = image;
        }
        else {
            self.backgroundColor = [UIColor lightGrayColor];
        }
        [self stopSpinner];
    }];
}

- (void)dealloc {
    [spinner release];
    [super dealloc];
}

@end
