//
//  AAFormViewController.h
//  AAFieldComponents
//
//  Created by Almas Adilbek on 07/29/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ScrollViewController.h"

@class AAFieldBase;

@interface AAFormViewController : ScrollViewController<UIScrollViewDelegate> {
    //UIScrollView *contentScrollView;
    float lastFieldY;
}

-(void)setFormScrollViewHeight:(float)height;
-(void)setFormScrollViewContentHeight:(float)height;

-(void)insertField:(AAFieldBase *)field withMarginTop:(float)marginTop;
-(void)pushField:(AAFieldBase *)field;

@end
