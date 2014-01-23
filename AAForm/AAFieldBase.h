//
//  AAFieldBase.h
//  AAFieldComponents
//
//  Created by Almas Adilbek on 7/22/13.
//  Copyright (c) 2013 GoodApp inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AAFieldBase : UIView
{
    UILabel *titleLabel;
    UILabel *requiredMarkLabel;
    UIView *fieldBackgroundView;
    
    //Parameters
    BOOL required;
    BOOL selectionEnabled;
    UIColor *fieldSelectionColor;
    
    // Padding
    float fieldSidePadding;
    float fieldPaddingTop;
    float titleFieldBackgroundViewSpacing;
    
    // Values
    int cornerRadius;
    float fieldBackgroundViewHeight;
    float titleLabelLeftPadding;
    float titleLabelRightPadding;
    float fieldWidth;
    int fieldTextSize;
}

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *requiredMarkLabel;
@property (nonatomic, strong) UIView *fieldBackgroundView;
@property (nonatomic, assign) BOOL required;
@property (nonatomic, assign) BOOL selectionEnabled;
@property (nonatomic, strong) UIColor *fieldSelectionColor;
@property (nonatomic, assign) float fieldPaddingTop;
@property (nonatomic, assign) float fieldSidePadding;
@property (nonatomic, assign) float fieldWidth;

// Methods
-(void)setTitle:(NSString *)text;
-(void)updateUI;

-(void)actionFieldBackgroundTapped;
-(void)actionSelectFieldBackground;
-(void)actionUnselectFieldBackground;
-(void)selectFieldBackground;
-(void)unselectFieldBackground;

// Helper
-(UIColor *)colorWithRGB:(int)rgb;
-(float)yAfter:(UIView *)view;
-(float)yAfter:(UIView *)view margin:(float)margin;
-(UIImage *)imageWithName:(NSString *)imageName;
-(void)doBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;

-(void)setFieldHeight:(float)height;
-(void)updateFieldHeight;

@end
