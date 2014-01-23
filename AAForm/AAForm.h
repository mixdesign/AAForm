//
//  AAForm.h
//  Myth
//
//  Created by Almas Adilbek on 08/08/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "BSKeyboardControls.h"

#define kFormSidePadding 12

@class AAFieldBase;

@interface AAForm : NSObject<BSKeyboardControlsDelegate> {
    float bottomY;
}

@property (nonatomic, assign) float bottomY;

- (id)initWithScrollView:(UIScrollView *)scrollView;

-(void)pushField:(AAFieldBase *)field;
-(void)insertField:(AAFieldBase *)field withMarginTop:(float)marginTop;
-(void)pushFieldAtTop:(AAFieldBase *)field;
-(void)insertFieldAtTop:(AAFieldBase *)field withMarginBottom:(float)marginBottom;

-(void)pushView:(UIView *)view;
-(void)insertView:(UIView *)view withMarginTop:(float)marginTop;
-(void)pushViewAtTop:(UIView *)view;
-(void)pushViewAtTop:(UIView *)view withMarginBottom:(float)marginBottom;

-(void)removeView:(id)view;
-(void)clear;

-(BOOL)isRequiredFieldsFilled;
-(void)initKeyboardControls;

-(void)setScrollContentHeight:(CGFloat)height;

@end
