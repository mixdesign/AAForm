//
//  AAFieldIconView.m
//  AAFieldComponents
//
//  Created by Almas Adilbek on 07/26/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIImageView+WebCache.h>
#import "AAFieldIconView.h"

@implementation AAFieldIconView {
    UIImageView *iconView;
}

- (id)initWithWidth:(float)width height:(float)height
{
    self = [super initWithFrame:CGRectMake(0, 0, width, height)];
    if (self) {

        iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        iconView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:iconView];

    }
    return self;
}

-(void)setIcon:(id)icon
{
    if([icon isKindOfClass:[UIImage class]]) {
        iconView.image = icon;
    } else {
        __block UIActivityIndicatorView *iconLoader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        iconLoader.center = iconView.center;
        [self addSubview:iconLoader];
        [iconLoader startAnimating];

        [iconView setImageWithURL:icon placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            [iconLoader stopAnimating];
            [iconLoader removeFromSuperview];
        }];
    }
}

#pragma mark -

-(void)dealloc {
    iconView = nil;
}

@end
