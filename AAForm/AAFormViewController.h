//
//  AAFormViewController.h
//  AAFieldComponents
//
//  Created by Almas Adilbek on 07/29/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

//#import "ScrollViewController.h"
#import "TPKeyboardAvoidingScrollView.h"

@class AAFieldBase;

//@interface AAFormViewController : ScrollViewController<UIScrollViewDelegate> {
@interface AAFormViewController : UIViewController<UIScrollViewDelegate> {
    //UIScrollView *contentScrollView;
    float lastFieldY;
}

@property (nonatomic, strong) TPKeyboardAvoidingScrollView *contentScrollView;

-(void)setFormScrollViewHeight:(float)height;
-(void)setFormScrollViewContentHeight:(float)height;
-(void)clearContent;

-(float)contentScrollHeight;

// ---

-(void)insertField:(AAFieldBase *)field withMarginTop:(float)marginTop;
-(void)pushField:(AAFieldBase *)field;

-(void)pushViewToBottom:(UIView *)insertView;
-(void)pushViewToBottom:(UIView *)insertView paddingBottom:(int)paddingBottom;

-(void)pushButtonToBottom:(UIView *)button;
-(void)pushButtonToBottom:(UIView *)button paddingBottom:(int)paddingBottom;


@end
