//
//  AAFieldTextArea.m
//  AAFieldComponents
//
//  Created by Almas Adilbek on 7/22/13.
//  Copyright (c) 2013 GoodApp inc. All rights reserved.
//

#import "AAFieldTextArea.h"

@implementation AAFieldTextArea {
    AAFieldTextAreaOnValueChange onValueChangeBlock;
    NSString *oldValue;

    NSMutableArray *onFocusBlocks;
}

@synthesize inputTextArea, placeholderLabel;

- (id)initWithHeight:(float)height
{
    self = [super init];
    if (self)
    {
        // Vars
        textAreaHeight = height;
        inputTextAreaPadding = 8;
        
        self.inputTextArea = [[UITextView alloc] initWithFrame:CGRectZero];
        inputTextArea.delegate = self;
        inputTextArea.backgroundColor = [UIColor clearColor];
        inputTextArea.font = [UIFont systemFontOfSize:fieldTextSize];
        inputTextArea.autocorrectionType = UITextAutocorrectionTypeNo;
        inputTextArea.autocapitalizationType = UITextAutocapitalizationTypeNone;
        //inputTextArea.contentInset = UIEdgeInsetsMake(-8,-8,-8,-8);
        [fieldBackgroundView addSubview:inputTextArea];
        
        // Placeholder
        self.placeholderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        placeholderLabel.backgroundColor = [UIColor clearColor];
        placeholderLabel.font = [UIFont systemFontOfSize:fieldTextSize];
        placeholderLabel.textColor = [self colorWithRGB:0xb6b6b6];
        placeholderLabel.userInteractionEnabled = NO;
        [fieldBackgroundView addSubview:placeholderLabel];
        
    }
    return self;
}

#pragma mark -
#pragma mark GET

-(NSString *)value {
    return [inputTextArea.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

-(BOOL)filled {
    return [[self value] length] > 0;
}

#pragma mark -
#pragma mark SET

-(void)setValue:(NSString *)value {
    inputTextArea.text = value;

    if(value.length > 0) placeholderLabel.hidden = YES;

    if(onValueChangeBlock && ![oldValue isEqual:value]) {
        onValueChangeBlock(value);
    }
}

-(void)setPlaceholder:(NSString *)placeholderText {
    placeholderLabel.text = placeholderText;
    [placeholderLabel sizeToFit];
}

-(void)onValueChange:(AAFieldTextAreaOnValueChange)block {
    onValueChangeBlock = block;
}

-(void)onFocus:(AAFieldTextAreaOnFocus)block {
    if(!onFocusBlocks) {
        onFocusBlocks = [[NSMutableArray alloc] init];
    }
    [onFocusBlocks addObject:block];
}

-(void)focus {
    [inputTextArea becomeFirstResponder];
}

-(void)updateUI
{
    [super updateUI];
    
    CGRect f = fieldBackgroundView.frame;
    f.size.height = textAreaHeight;
    fieldBackgroundView.frame = f;
    fieldBackgroundView.userInteractionEnabled = YES;
    
    f = inputTextArea.frame;
    f.origin.x = inputTextAreaPadding;
    f.origin.y = inputTextAreaPadding;
    f.size.width = fieldWidth - 2 * inputTextAreaPadding;
    f.size.height = textAreaHeight - 2 * inputTextAreaPadding;
    inputTextArea.frame = f;
    
    f = placeholderLabel.frame;
    f.origin.x = inputTextAreaPadding+ 5;
    f.origin.y = inputTextAreaPadding + 7;
    placeholderLabel.frame = f;
    
    [self updateFieldHeight];
}

#pragma mark -
#pragma mark UITextView

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if(onFocusBlocks) {
        for(AAFieldTextAreaOnFocus block in onFocusBlocks) {
            block(self);
        }
    }

    if(!placeholderLabel.isHidden) {
        [UIView animateWithDuration:0.2 animations:^{
            placeholderLabel.alpha = 0;
        } completion:^(BOOL finished) {
            placeholderLabel.hidden = YES;
        }];
    }
    if(self.selectionEnabled) [self selectFieldBackground];

    oldValue = textView.text;
}
-(void)textViewDidEndEditing:(UITextView *)textView {
    NSString *text = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(text.length == 0) {
        placeholderLabel.alpha = 0;
        placeholderLabel.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{
            placeholderLabel.alpha = 1;
        }];
    }
    [self unselectFieldBackground];

    if(onValueChangeBlock && ![oldValue isEqual:text]) {
        onValueChangeBlock(text);
    }
}

#pragma mark -

- (void)dealloc {
    self.inputTextArea = nil;
    self.placeholderLabel = nil;
    onValueChangeBlock = nil;
    oldValue = nil;
    onFocusBlocks = nil;
}

@end
