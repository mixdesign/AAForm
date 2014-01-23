//
//  AAField.h
//  AAFieldComponents
//
//  Created by Almas Adilbek on 7/22/13.
//  Copyright (c) 2013 GoodApp inc. All rights reserved.
//

#import "AAFieldBase.h"

@class AAFieldIconView;
@class AAField;

typedef void(^AAFieldOnTap)(void);
typedef void(^AAFieldOnValueChanged)(NSString *value);
typedef void(^AAFieldOnFocus)(AAField *_field);

@interface AAField : AAFieldBase<UITextFieldDelegate>
{
    UITextField *inputField;
    AAFieldIconView *iconView;
    UIButton *triggerButton;

    // Params
    UIKeyboardType keyboardType;
    BOOL isLoading;
    BOOL secureTextEntry;
    BOOL inputFieldEditable;
    
    // Vars
    float inputFieldPaddingLeft;
    float inputFieldPaddingRight;
    float iconViewPaddingLeft;
    float iconViewSize;
    float iconViewInputFieldSpacing;
    float disclosurePaddingRight;
}

@property (nonatomic, strong) UITextField *inputField;
@property (nonatomic, assign) UIKeyboardType keyboardType;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL secureTextEntry;
@property (nonatomic, assign) BOOL inputFieldEditable;

// GET
-(NSString *)value;
-(BOOL)filled;
-(BOOL)requiredFilled;

// SET
-(void)setIcon:(UIImage *)iconImage;
-(void)setIconWithURL:(NSURL *)url;
-(void)setValue:(NSString *)inputFieldValue;
-(void)setPlaceholder:(NSString *)placeholderText;
-(void)clear;
-(void)focus;

-(void)startLoading;
-(void)stopLoading;

-(void)updateInputFieldUI;
-(void)enableFieldBackgroundViewTrigger;

// Blocks
-(void)onTap:(AAFieldOnTap)block;
-(void)onValueChanged:(AAFieldOnValueChanged)block;
-(void)onFocus:(AAFieldOnFocus)block;

@end
