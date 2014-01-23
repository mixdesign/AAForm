//
//  AAFormViewController.m
//  AAFieldComponents
//
//  Created by Almas Adilbek on 07/29/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "AAFormViewController.h"
#import "AAFieldBase.h"

@interface AAFormViewController ()
-(void)formScrollViewTapped:(UITapGestureRecognizer *)ges;
@end

@implementation AAFormViewController {

}

-(void)loadView
{
    [super loadView];

    // Init vars
    lastFieldY = 0;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(formScrollViewTapped:)];
    [contentScrollView addGestureRecognizer:tap];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark Methods

-(void)setFormScrollViewHeight:(float)height
{
    CGRect f = contentScrollView.frame;
    f.size.height = height;
    contentScrollView.frame = f;
}

-(void)setFormScrollViewContentHeight:(float)height {
    CGSize size = contentScrollView.contentSize;
    size.height = height;
    contentScrollView.contentSize = size;
}

-(void)insertField:(AAFieldBase *)field withMarginTop:(float)marginTop
{
    field.fieldPaddingTop = marginTop;
    [self pushField:field];
}

-(void)pushField:(AAFieldBase *)field
{
    CGRect f = field.frame;
    f.origin.y = lastFieldY;
    field.frame = f;

    lastFieldY = f.origin.y + f.size.height;

    [contentScrollView addSubview:field];
}

#pragma mark Actions

-(void)formScrollViewTapped:(UITapGestureRecognizer *)ges {
    [self.view endEditing:YES];
}

#pragma mark UIScrollView

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {
    contentScrollView = nil;
}

@end
