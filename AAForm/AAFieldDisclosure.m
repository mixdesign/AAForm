//
//  AAFieldDisclosure.m
//  AAFieldComponents
//
//  Created by Almas Adilbek on 7/23/13.
//  Copyright (c) 2013 GoodApp inc. All rights reserved.
//

#import "AAFieldDisclosure.h"

@interface AAFieldDisclosure()

@end

@implementation AAFieldDisclosure {
    UIImageView *disclosureIconView;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.inputField.userInteractionEnabled = NO;
        
        disclosureIconView = [[UIImageView alloc] initWithImage:[self imageWithName:@"AAFieldDisclosureIcon"]];
        disclosureIconView.userInteractionEnabled = NO;
        [fieldBackgroundView addSubview:disclosureIconView];
        
        [self enableFieldBackgroundViewTrigger];
    }
    return self;
}

#pragma mark -
#pragma mark Methods

-(void)updateUI {
    [super updateUI];
    
    CGRect f = disclosureIconView.frame;
    f.origin.x = fieldWidth - disclosurePaddingRight - f.size.width * 0.5;
    f.origin.y = (fieldBackgroundViewHeight - f.size.height) * 0.5;
    disclosureIconView.frame = f;
}

#pragma mark -
#pragma mark Overrides

-(void)dealloc {
    disclosureIconView = nil;
}

@end
