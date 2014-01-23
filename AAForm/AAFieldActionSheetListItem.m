//
//  AAFieldActionSheetListItem.m
//  AAFieldComponents
//
//  Created by Almas Adilbek on 7/24/13.
//  Copyright (c) 2013 GoodApp inc. All rights reserved.
//

#import "AAFieldActionSheetListItem.h"
#import "AAFieldIconView.h"
#import <QuartzCore/QuartzCore.h>

#define kVerticalPadding 10
#define kHorPadding 15

@interface AAFieldActionSheetListItem()
-(void)tapped;
@end

@implementation AAFieldActionSheetListItem
{
    float itemWidth;

    AAFieldActionSheetListItemOnTap onTapBlock;

    AAFieldIconView *iconView;
    UILabel *titleLabel;
}

@synthesize optionIndex;

- (id)initWithTitle:(NSString *)title width:(float)width
{
    self = [super initWithFrame:CGRectMake(0, 0, width, 1)];
    if (self)
    {
        itemWidth = width;
        self.backgroundColor = [UIColor clearColor];
        iconViewSize = 24;

        CGRect f;

        // Trigger button
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(tapped) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:(237 / 255.0) green:(237 / 255.0) blue:(237 / 255.0) alpha:1]] forState:UIControlStateHighlighted];
        [self addSubview:button];
        
        //float labelX = iconImage?(kHorPadding + iconViewSize + 10):kHorPadding;
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kHorPadding, 0, width - kHorPadding - 25 - kHorPadding, 1)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.userInteractionEnabled = NO;
        titleLabel.font = [UIFont boldSystemFontOfSize:16];
        titleLabel.textColor = [UIColor colorWithRed:(52 / 255.0) green:(52 / 255.0) blue:(52 / 255.0) alpha:1];
        titleLabel.numberOfLines = 0;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.shadowColor = [UIColor whiteColor];
        titleLabel.shadowOffset = CGSizeMake(0, 1);
        [self addSubview:titleLabel];
        
        titleLabel.text = title;
        [titleLabel sizeToFit];
        
        f = self.frame;
        f.size.height = 2 * kVerticalPadding + titleLabel.bounds.size.height;
        self.frame = f;

        // Button
        f = button.frame;
        f.size.width = self.bounds.size.width;
        f.size.height = self.bounds.size.height;
        button.frame = f;
        
        f = titleLabel.frame;
        f.origin.y = kVerticalPadding;
        titleLabel.frame = f;

        // Separator
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 1, width , 0.5)];
        line.backgroundColor = [UIColor colorWithRed:(220 / 255.0) green:(220 / 255.0) blue:(220 / 255.0) alpha:1];
        [self addSubview:line];
    }
    return self;
}

#pragma mark Actions

-(void)tapped {
    if(onTapBlock) onTapBlock(optionIndex);
}

#pragma mark Methods

-(void)setIcon:(id)icon
{
    if(icon == nil) {
        if(iconView) {
            [iconView removeFromSuperview];
            iconView = nil;
        }
        return;
    }

    [self createIconView];

    [iconView setIcon:icon];

    [self updateInputFieldUI];
}

-(void)select
{
    UIImageView *checkmark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AAFieldCheckmark.png"]];
    CGRect f = checkmark.frame;
    f.origin.x = self.bounds.size.width - f.size.width - kHorPadding;
    f.origin.y = (self.bounds.size.height - f.size.height) * 0.5;
    checkmark.frame = f;
    [self addSubview:checkmark];
}

-(void)onTap:(AAFieldActionSheetListItemOnTap)block {
    onTapBlock = block;
}

#pragma mark Helper


-(void)updateInputFieldUI
{
    CGRect f1 = titleLabel.frame;
    if(iconView)
    {
        CGRect f = iconView.frame;
        f.origin.x = kHorPadding;
        iconView.frame = f;

        f1.origin.x = f.origin.x + iconViewSize + 10;
        f1.size.width = itemWidth - f1.origin.x - kHorPadding;
    }
    else
    {
        f1.origin.x = kHorPadding;
    }

    titleLabel.frame = f1;
}

-(UIImage *)imageWithColor:(UIColor *)color
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    view.backgroundColor = color;
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

-(void)createIconView {
    if(!iconView) {
        iconView = [[AAFieldIconView alloc] initWithWidth:iconViewSize height:iconViewSize];
        iconView.userInteractionEnabled = NO;
        CGRect f = iconView.frame;
        f.origin.x = kHorPadding;
        f.origin.y = 9;
        iconView.frame = f;
        [self addSubview:iconView];
    }
}

#pragma mark -

-(void)dealloc {
    onTapBlock = nil;
}

@end
