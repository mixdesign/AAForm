//
//  AAField.m
//  AAFieldComponents
//
//  Created by Almas Adilbek on 7/22/13.
//  Copyright (c) 2013 GoodApp inc. All rights reserved.
//

#import "AAField.h"
#import "AAFieldIconView.h"

@interface AAField()
-(void)createIconView;
@end

@implementation AAField {
    AAFieldOnTap onTapBlock;
    AAFieldOnValueChanged onValueChangedBlock;
    NSMutableArray *onFocusBlocks;

    UIActivityIndicatorView *loader;

    NSString *oldValue;
}

@synthesize inputField, keyboardType = _keyboardType, isLoading, secureTextEntry = _secureTextEntry, inputFieldEditable = _inputFieldEditable;;

- (id)init
{
    self = [super init];
    if (self) {
        
        inputFieldPaddingLeft = 15;
        inputFieldPaddingRight = 30;
        iconViewPaddingLeft = 10;
        iconViewSize = 24;
        iconViewInputFieldSpacing = 8;
        disclosurePaddingRight = 20;

        _inputFieldEditable = YES;
        
        self.inputField = [[UITextField alloc] initWithFrame:CGRectZero];
        inputField.delegate = self;
        inputField.backgroundColor = [UIColor clearColor];
        inputField.font = [UIFont systemFontOfSize:fieldTextSize];
        inputField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        inputField.autocorrectionType = UITextAutocorrectionTypeNo;
        inputField.autocapitalizationType = UITextAutocapitalizationTypeNone;

        [fieldBackgroundView addSubview:inputField];
    }
    return self;
}

#pragma mark -
#pragma mark GET

-(NSString *)value {
    return [inputField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

-(BOOL)filled {
    return [[self value] length] > 0;
}

-(BOOL)requiredFilled {
    if(!self.required) return YES;
    return [[self value] length] > 0;
}

#pragma mark -
#pragma mark SET

-(void)onTap:(AAFieldOnTap)block {
    onTapBlock = block;
}

-(void)onValueChanged:(AAFieldOnValueChanged)block {
    onValueChangedBlock = block;
}

-(void)onFocus:(AAFieldOnFocus)block {
    if(!onFocusBlocks) {
        onFocusBlocks = [[NSMutableArray alloc] init];
    }
    [onFocusBlocks addObject:block];
}

-(void)setIcon:(UIImage *)iconImage
{
    if(iconImage == nil) {
        if(iconView) {
            [iconView removeFromSuperview];
            iconView = nil;
        }
        return;
    }
    
    [self createIconView];
    [iconView setIcon:iconImage];
    
    [self updateInputFieldUI];
}

-(void)setIconWithURL:(NSURL *)url
{
    [self createIconView];
    [self updateInputFieldUI];

    [iconView setIcon:url];
}

-(void)setValue:(NSString *)inputFieldValue
{
    oldValue = inputField.text;
    inputField.text = inputFieldValue;

    if(onValueChangedBlock && ![oldValue isEqual:inputFieldValue]) {
        onValueChangedBlock(inputFieldValue);
    }
}

-(void)setPlaceholder:(NSString *)placeholderText {
    inputField.placeholder = placeholderText;
}

-(void)setKeyboardType:(UIKeyboardType)aKeyboardType {
    _keyboardType = aKeyboardType;
    inputField.keyboardType = _keyboardType;
}

-(void)clear {
    inputField.text = @"";
}

-(void)focus {
    if(self.inputFieldEditable && !self.isLoading) [inputField becomeFirstResponder];
}

-(void)setSecureTextEntry:(BOOL)aSecureTextEntry {
    _secureTextEntry = aSecureTextEntry;
    inputField.secureTextEntry = _secureTextEntry;
}

-(void)setInputFieldEditable:(BOOL)anInputFieldEditable {
    _inputFieldEditable = anInputFieldEditable;
    inputField.userInteractionEnabled = _inputFieldEditable;
}

// Loader

-(void)startLoading
{
    self.isLoading = YES;
    self.userInteractionEnabled = NO;
    if(inputField) inputField.hidden = YES;
    if(iconView) iconView.hidden = YES;

    loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGRect f = loader.frame;
    f.origin.x = (fieldWidth - f.size.width) * 0.5;
    f.origin.y = (fieldBackgroundViewHeight - f.size.height) * 0.5;
    loader.frame = f;
    [fieldBackgroundView addSubview:loader];
    [loader startAnimating];
}

-(void)stopLoading
{
    self.isLoading = NO;
    self.userInteractionEnabled = YES;

    if(loader) {
        [loader removeFromSuperview];
        loader = nil;
    }

    if(inputField) inputField.hidden = NO;
    if(iconView) iconView.hidden = NO;
}

// Other

-(void)updateInputFieldUI
{
    CGRect f1 = inputField.frame;
    if(iconView)
    {
        CGRect f = iconView.frame;
        f.origin.x = iconViewPaddingLeft;
        f.origin.y = (fieldBackgroundViewHeight - f.size.height) * 0.5;
        iconView.frame = f;
        
        f1.origin.x = f.origin.x + iconViewSize + iconViewInputFieldSpacing;
        f1.size.width = fieldWidth - f1.origin.x - inputFieldPaddingRight;
    }
    else
    {
        f1.origin.x = inputFieldPaddingLeft;
    }
    
    inputField.frame = f1;
}

-(void)enableFieldBackgroundViewTrigger
{
//    NSLog(@"enableFieldBackgroundViewTrigger %@ %@", NSStringFromClass([self class]), triggerButton?@"true":@"false");
    if(!triggerButton) {
        triggerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        triggerButton.frame = fieldBackgroundView.frame;
        [triggerButton addTarget:self action:@selector(actionSelectFieldBackground) forControlEvents:UIControlEventTouchDown];
        [triggerButton addTarget:self action:@selector(actionFieldBackgroundTapped) forControlEvents:UIControlEventTouchUpInside];
        [triggerButton addTarget:self action:@selector(actionUnselectFieldBackground) forControlEvents:UIControlEventTouchUpOutside];
        [triggerButton addTarget:self action:@selector(actionUnselectFieldBackground) forControlEvents:UIControlEventTouchCancel];
        [self addSubview:triggerButton];
    }
}

#pragma mark -
#pragma mark Overrides

-(void)actionFieldBackgroundTapped {
    [super actionFieldBackgroundTapped];
    
    if(onTapBlock) onTapBlock();
}

-(void)updateUI
{
    [super updateUI];
    
    CGRect f;
    
    if(triggerButton) triggerButton.frame = fieldBackgroundView.frame;
    
    f = inputField.frame;
    f.origin.x = inputFieldPaddingLeft;
    f.size.width = fieldWidth - inputFieldPaddingLeft - inputFieldPaddingRight;
    f.size.height = fieldBackgroundViewHeight;
    inputField.frame = f;
    
    [self updateInputFieldUI];
}

#pragma mark -
#pragma mark UITextField

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(onFocusBlocks) {
        for(AAFieldOnFocus block in onFocusBlocks) {
            block(self);
        }
    }

    [self actionSelectFieldBackground];
    oldValue = textField.text;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [self actionUnselectFieldBackground];

    if(onValueChangedBlock && ![oldValue isEqual:textField.text]) {
        onValueChangedBlock(textField.text);
    }
}

#pragma mark -

-(void)createIconView {
    if(!iconView) {
        iconView = [[AAFieldIconView alloc] initWithWidth:iconViewSize height:iconViewSize];
        [fieldBackgroundView addSubview:iconView];
    }
    if(self.isLoading) iconView.hidden = YES;
}

#pragma mark -

- (void)dealloc {
    self.inputField = nil;
    iconView = nil;
    triggerButton = nil;
    onTapBlock = nil;
    onFocusBlocks = nil;
}

@end
