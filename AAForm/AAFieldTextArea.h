//
//  AAFieldTextArea.h
//  AAFieldComponents
//
//  Created by Almas Adilbek on 7/22/13.
//  Copyright (c) 2013 GoodApp inc. All rights reserved.
//

#import "AAFieldBase.h"

@class AAFieldTextArea;

typedef void(^AAFieldTextAreaOnValueChange)(NSString *value);
typedef void(^AAFieldTextAreaOnFocus)(AAFieldTextArea *textArea);

@interface AAFieldTextArea : AAFieldBase<UITextViewDelegate>
{
    UITextView *inputTextArea;
    UILabel *placeholderLabel;
    
    // Vars
    float textAreaHeight;
    float inputTextAreaPadding;
}

-(id)initWithHeight:(float)height;

@property (nonatomic, strong) UITextView *inputTextArea;
@property (nonatomic, strong) UILabel *placeholderLabel;

// GET
-(NSString *)value;
-(BOOL)filled;

// SET
-(void)setValue:(NSString *)value;
-(void)setPlaceholder:(NSString *)placeholderText;
-(void)focus;

-(void)onValueChange:(AAFieldTextAreaOnValueChange)block;
-(void)onFocus:(AAFieldTextAreaOnFocus)block;

@end
