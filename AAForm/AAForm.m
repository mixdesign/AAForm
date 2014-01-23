//
//  AAForm.m
//  Myth
//
//  Created by Almas Adilbek on 08/08/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <TPKeyboardAvoiding/TPKeyboardAvoidingScrollView.h>
#import "AAForm.h"
#import "AAFieldBase.h"
#import "AAField.h"
#import "AAFieldTextArea.h"
#import "AAFieldCombobox.h"

@interface AAForm()

@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
-(void)configFieldOnFocus:(AAFieldBase *)field;
-(void)onFieldFocus:(id)field;
@end;

@implementation AAForm {
    NSMutableArray *fields;
    NSMutableArray *views;
    UIScrollView *contentScrollView;
}

@synthesize bottomY;

- (id)initWithScrollView:(UIScrollView *)scrollView {
    self = [super init];
    if (self) {

        contentScrollView = scrollView;
        self.bottomY = 0;
        fields = [[NSMutableArray alloc] init];
        views = [[NSMutableArray alloc] init];

    }
    return self;
}

#pragma mark -
#pragma mark Methods

-(void)insertField:(AAFieldBase *)field withMarginTop:(float)marginTop
{
    field.fieldPaddingTop = marginTop;
    [self pushField:field];
}

-(void)pushField:(AAFieldBase *)field
{
    CGRect f = field.frame;
    f.origin.y = bottomY;
    field.frame = f;

    [fields addObject:field];

    [contentScrollView addSubview:field];

    [self configFieldOnFocus:field];

    self.bottomY = field.frame.origin.y + field.bounds.size.height;
    
    [self setFormScrollContentHeight:self.bottomY];
}

-(void)pushFieldAtTop:(AAFieldBase *)field {
    [self insertFieldAtTop:field withMarginBottom:0];
}

-(void)insertFieldAtTop:(AAFieldBase *)field withMarginBottom:(float)marginBottom
{
    float fieldHeight = field.bounds.size.height + marginBottom;

    for(UIView *subfield in fields) {
        CGRect f = subfield.frame;
        f.origin.y += fieldHeight;
        subfield.frame = f;
    }

    for(UIView *subview in views) {
        CGRect f = subview.frame;
        f.origin.y += fieldHeight;
        subview.frame = f;
    }

    [self defineBottomY];

    [contentScrollView addSubview:field];
    [fields insertObject:field atIndex:0];

    [self configFieldOnFocus:field];
}

#pragma mark -

-(void)pushView:(UIView *)view {
    [self insertView:view withMarginTop:0];
}

-(void)insertView:(UIView *)view withMarginTop:(float)marginTop {
    CGRect f = view.frame;
    f.origin.y = bottomY + marginTop;
    view.frame = f;
    [contentScrollView addSubview:view];

    [views addObject:view];

    self.bottomY = view.frame.origin.y + view.bounds.size.height;
    [self setFormScrollContentHeight:self.bottomY];
}

-(void)pushViewAtTop:(UIView *)view {
    [self pushViewAtTop:view withMarginBottom:0];
}

-(void)pushViewAtTop:(UIView *)view withMarginBottom:(float)marginBottom
{
    float viewHeight = view.bounds.size.height + marginBottom;

    for(UIView *subfield in fields) {
        CGRect f = subfield.frame;
        f.origin.y += viewHeight;
        subfield.frame = f;
    }

    for(UIView *subview in views) {
        CGRect f = subview.frame;
        f.origin.y += viewHeight;
        subview.frame = f;
    }

    [self defineBottomY];

    [contentScrollView addSubview:view];
    [views insertObject:view atIndex:0];
}

#pragma mark -

-(void)removeView:(id)view
{
    UIView *theView = (UIView *)view;
    float viewHeight = theView.bounds.size.height;
    float viewY = theView.frame.origin.y;

    [view removeFromSuperview];
    [views removeObject:view];
    [fields removeObject:view];

    for(UIView *subfield in fields) {
        CGRect f = subfield.frame;
        if(f.origin.y > viewY) {
            f.origin.y -= viewHeight;
            subfield.frame = f;
        }
    }

    for(UIView *subview in views) {
        CGRect f = subview.frame;
        if(f.origin.y > viewY) {
            f.origin.y -= viewHeight;
            subview.frame = f;
        }
    }

    [self defineBottomY];
}

-(void)clear
{
    for (id field in fields) {
        [field removeFromSuperview];
    }
    for (id view in views) {
        [view removeFromSuperview];
    }
    [fields removeAllObjects];
    [views removeAllObjects];
    self.bottomY = 0;
    
    [self setFormScrollContentHeight:0];
}

#pragma mark -

-(BOOL)isRequiredFieldsFilled
{
    for (id field in fields) {
        if(![field filled]) return NO;
    }
    return YES;
}

-(void)initKeyboardControls
{
    NSMutableArray *textFields = [NSMutableArray array];
    for (id field in fields) {
        if([field isKindOfClass:[AAField class]]) {
            AAField *fieldField = (AAField *)field;
            [textFields addObject:fieldField.inputField];
        } else if([field isKindOfClass:[AAFieldTextArea class]]) {
            AAFieldTextArea *areaField = (AAFieldTextArea *)field;
            [textFields addObject:areaField.inputTextArea];
        }
    }
    self.keyboardControls = [[BSKeyboardControls alloc] initWithFields:textFields];
    self.keyboardControls.delegate = self;
}

-(void)setScrollContentHeight:(CGFloat)height
{
    CGSize contentSize = contentScrollView.contentSize;
    contentSize.height = height;
    contentScrollView.contentSize = contentSize;
}

#pragma mark -
#pragma mark Keyboard Controls Delegate

- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction
{
    [(TPKeyboardAvoidingScrollView *)contentScrollView scrollToActiveTextField];

    for (id _field in fields)
    {
        if([_field isKindOfClass:[AAField class]])
        {
            AAField *fieldField = (AAField *)_field;
            if([fieldField.inputField isEqual:field])
            {
                [fieldField focus];
                if(![fieldField inputFieldEditable] || [fieldField isLoading]) {
                    [contentScrollView endEditing:YES];
                }
                break;
            }
        }
        else if([_field isKindOfClass:[AAFieldTextArea class]])
        {
            AAFieldTextArea *areaField = (AAFieldTextArea *)_field;
            if([areaField.inputTextArea isEqual:field]) {
                [areaField focus];
                break;
            }
        }
    }
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls {
    [keyboardControls.activeField resignFirstResponder];
}

#pragma mark -

-(void)configFieldOnFocus:(AAFieldBase *)field
{
    if([field isKindOfClass:[AAField class]])
    {
        AAField *fieldField = (AAField *)field;
        __weak AAForm *wSelf = self;
        [fieldField onFocus:^(AAField *_field) {
            [wSelf onFieldFocus:_field.inputField];
        }];
    }
    else if([field isKindOfClass:[AAFieldTextArea class]])
    {
        AAFieldTextArea *areaField = (AAFieldTextArea *)field;
        __weak AAForm *wSelf = self;
        [areaField onFocus:^(AAFieldTextArea *_field) {
            [wSelf onFieldFocus:_field.inputTextArea];
        }];
    }
}

-(void)onFieldFocus:(id)field {
    [self.keyboardControls setActiveField:field];
}

#pragma mark -

-(void)defineBottomY {
    UIView *lastField = (UIView *)[fields lastObject];
    UIView *lastView = (UIView *)[views lastObject];

    float y = 0;
    if(lastField.frame.origin.y >= lastView.frame.origin.y) {
        y = lastField.frame.origin.y + lastField.bounds.size.height;
    } else {
        y = lastView.frame.origin.y + lastView.bounds.size.height;
    }

    self.bottomY = y;
    [self setFormScrollContentHeight:y];
}

-(void)setFormScrollContentHeight:(CGFloat)height {
    [self setScrollContentHeight:(height + 20)]; // 20 Padding
}

#pragma mark -

-(void)dealloc {
    [ALog traceDealloc:self];
    fields = nil;
    views = nil;
    contentScrollView = nil;
    self.keyboardControls = nil;
}

@end
