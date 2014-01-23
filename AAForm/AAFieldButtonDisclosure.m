//
//  AAFieldButtonDisclosure.m
//  AAFieldComponents
//
//  Created by Almas Adilbek on 7/23/13.
//  Copyright (c) 2013 GoodApp inc. All rights reserved.
//

#import "AAFieldButtonDisclosure.h"

@interface AAFieldButtonDisclosure()
-(void)disclosureButtonTapped;
@end

@implementation AAFieldButtonDisclosure {
    UIButton *disclosureButton;
    AAFieldButtonDisclosureOnTap onDisclosureButtonTap;
}

- (id)init
{
    self = [super init];
    if (self) {

        disclosureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [disclosureButton addTarget:self action:@selector(disclosureButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        disclosureButton.showsTouchWhenHighlighted = YES;
        UIImageView *disclosureImageView = [[UIImageView alloc] initWithImage:[self imageWithName:@"AAFieldDisclosureButtonIcon"]];
        disclosureButton.frame = disclosureImageView.bounds;
        [disclosureButton setImage:[self imageWithName:@"AAFieldDisclosureButtonIcon"] forState:UIControlStateNormal];
        [fieldBackgroundView addSubview:disclosureButton];
        
    }
    return self;
}

#pragma mark -
#pragma mark Actions

-(void)disclosureButtonTapped {
    if(onDisclosureButtonTap) onDisclosureButtonTap();
}

#pragma mark -
#pragma mark Overrides

-(void)onDisclosureButtonTap:(AAFieldButtonDisclosureOnTap)block {
    onDisclosureButtonTap = block;
}

-(void)updateUI {
    [super updateUI];
    
    CGRect f = disclosureButton.frame;
    f.origin.x = fieldWidth - disclosurePaddingRight - f.size.width * 0.5;
    f.origin.y = (fieldBackgroundViewHeight - f.size.height) * 0.5;
    disclosureButton.frame = f;
}

#pragma mark -

- (void)dealloc
{
    disclosureButton = nil;
    onDisclosureButtonTap = nil;
}

@end
