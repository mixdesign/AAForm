//
//  AAFieldBase.m
//  AAFieldComponents
//
//  Created by Almas Adilbek on 7/22/13.
//  Copyright (c) 2013 GoodApp inc. All rights reserved.
//

#import "AAFieldBase.h"
#import <QuartzCore/QuartzCore.h>
#import "AAForm.h"

@interface AAFieldBase()
-(void)updateIsRequiredLabelUI;
@end

@implementation AAFieldBase

@synthesize titleLabel, requiredMarkLabel, fieldBackgroundView, required = _required, selectionEnabled, fieldSelectionColor, fieldPaddingTop = _fieldPaddingTop, fieldSidePadding, fieldWidth;

- (id)init
{
    CGSize size = [[UIScreen mainScreen] bounds].size;
    self = [super initWithFrame:CGRectMake(0, 0, size.width, 0)];
    if (self)
    {    
        // Parameters
        self.required = NO;
        self.selectionEnabled = YES;
        self.fieldSelectionColor = [self colorWithRGB:0x2dadff];
        
        // Padding
        _fieldPaddingTop = 8;
        self.fieldSidePadding = kFormSidePadding;
        titleFieldBackgroundViewSpacing = 2;
        
        // Values
        cornerRadius = 5;
        fieldBackgroundViewHeight = 42;
        titleLabelLeftPadding = 3;
        titleLabelRightPadding = 13;
        fieldWidth = size.width - 2 * fieldSidePadding;
        fieldTextSize = 16;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont ptSansNarrowBold:18];
        titleLabel.textColor = [self colorWithRGB:0x333333];
        titleLabel.shadowColor = [UIColor whiteColor];
        titleLabel.shadowOffset = CGSizeMake(0, 0.5);
        titleLabel.numberOfLines = 0;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:titleLabel];
        
        self.fieldBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        fieldBackgroundView.backgroundColor = [UIColor whiteColor];
//        fieldBackgroundView.layer.cornerRadius = cornerRadius;
//        fieldBackgroundView.layer.masksToBounds = YES;
        [self addSubview:fieldBackgroundView];
    }
    return self;
}

#pragma mark -
#pragma mark Parameters

-(void)setRequired:(BOOL)aRequired {
    _required = aRequired;

    if(_required) {
        if(!requiredMarkLabel) {
            self.requiredMarkLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            requiredMarkLabel.backgroundColor = [UIColor clearColor];
            requiredMarkLabel.textColor = [self colorWithRGB:0xff7800];
            requiredMarkLabel.font = [UIFont boldSystemFontOfSize:22];
            requiredMarkLabel.shadowColor = [UIColor whiteColor];
            requiredMarkLabel.shadowOffset = CGSizeMake(0, 1);
            requiredMarkLabel.text = @"*";
            [requiredMarkLabel sizeToFit];
            [self addSubview:requiredMarkLabel];
            [self updateIsRequiredLabelUI];
        }
    } else {
        if(requiredMarkLabel) {
            [requiredMarkLabel removeFromSuperview];
            requiredMarkLabel = nil;
        }
    }
}

-(void)setFieldPaddingTop:(float)aFieldPaddingTop
{
    _fieldPaddingTop = aFieldPaddingTop;
    [self updateUI];
}

#pragma mark -
#pragma mark Methods

-(void)setTitle:(NSString *)text
{
    titleLabel.text = text;
    [self updateUI];
}

-(void)updateUI
{
    // Title Label
    CGRect f = titleLabel.frame;
    f.origin.y = self.fieldPaddingTop;
    f.origin.x = fieldSidePadding + titleLabelLeftPadding;
    f.size.width = fieldWidth - titleLabelLeftPadding - titleLabelRightPadding;
    titleLabel.frame = f;
    [titleLabel sizeToFit];
    
    // Update isRequired Label
    [self updateIsRequiredLabelUI];
    
    // Update field background view
    f = fieldBackgroundView.frame;
    f.origin.y = self.fieldPaddingTop + titleLabel.bounds.size.height + titleFieldBackgroundViewSpacing;
    f.origin.x = fieldSidePadding;
    f.size.width = fieldWidth;
    f.size.height = fieldBackgroundViewHeight;
    fieldBackgroundView.frame = f;
    
    [self updateFieldHeight];
}

-(void)actionFieldBackgroundTapped {
    [self actionUnselectFieldBackground];
}

-(void)actionSelectFieldBackground {
    if(self.selectionEnabled) [self selectFieldBackground];
}

-(void)actionUnselectFieldBackground {
    [self unselectFieldBackground];
}

-(void)selectFieldBackground {
    self.fieldBackgroundView.layer.borderColor = self.fieldSelectionColor.CGColor;
    self.fieldBackgroundView.layer.borderWidth = 1;
}

-(void)unselectFieldBackground {
    self.fieldBackgroundView.layer.borderColor = [UIColor clearColor].CGColor;
    self.fieldBackgroundView.layer.borderWidth = 0;
}

#pragma mark -
#pragma mark Actions

-(void)fieldBackgroundViewTapped:(UITapGestureRecognizer *)tapges {
    //[self selectFieldBackground];
}

#pragma mark -
#pragma mark Helper

-(UIColor *)colorWithRGB:(int)rgb {
    return [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0 green:((float)((rgb & 0xFF00) >> 8))/255.0 blue:((float)(rgb & 0xFF))/255.0 alpha:1.0];
}

-(float)yAfter:(UIView *)view {
    return [self yAfter:view margin:0];
}
-(float)yAfter:(UIView *)view margin:(float)margin {
    CGRect f = view.frame;
    return f.origin.y + f.size.height + margin;
}
-(UIImage *)imageWithName:(NSString *)imageName {
    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:@"png"]];
}
-(void)doBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay {
    int64_t delta = (int64_t)(1.0e9 * delay);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delta), dispatch_get_main_queue(), block);
}

-(void)setFieldHeight:(float)height {
    CGRect f = self.frame;
    f.size.height = height;
    self.frame = f;
}
-(void)updateFieldHeight {
    [self setFieldHeight:[self yAfter:fieldBackgroundView]];
}

#pragma mark -
#pragma mark Local Helper

-(void)updateIsRequiredLabelUI
{
    if(self.required) {
        CGRect f = requiredMarkLabel.frame;
        f.origin.x = titleLabel.frame.origin.x + titleLabel.bounds.size.width + 5;
        f.origin.y = titleLabel.frame.origin.y + titleLabel.bounds.size.height - 22;
        requiredMarkLabel.frame = f;
    }
}

#pragma mark -

-(void)dealloc {
    self.titleLabel = nil;
    self.fieldBackgroundView = nil;
    self.requiredMarkLabel = nil;
    self.fieldSelectionColor = nil;
}

@end
