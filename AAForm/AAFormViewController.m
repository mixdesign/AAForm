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

@end

@implementation AAFormViewController {
    float bottomTopY;
}

-(id)init {
    self = [super initWithNibName:@"AAFormViewController" bundle:nil];
    if(self) {
    }
    return self;
}

-(void)loadView
{
    [super loadView];

    // Init vars
    lastFieldY = 0;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(formScrollViewTapped:)];
    [_contentScrollView addGestureRecognizer:tap];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    int navHeight = [self.navigationController isNavigationBarHidden]?0:44;
    
    self.contentScrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 0, [Vars screenWidth], [Vars screenHeightWithoutStatusBar] - navHeight)];
    _contentScrollView.delegate = self;
    _contentScrollView.alwaysBounceVertical = YES;
    _contentScrollView.alwaysBounceHorizontal = NO;
    _contentScrollView.showsVerticalScrollIndicator = NO;
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_contentScrollView];
    
    [self initVars];
}

-(void)initVars {
    bottomTopY = _contentScrollView.bounds.size.height - 15;
}

#pragma mark -
#pragma mark ScrollView

-(void)setFormScrollViewHeight:(float)height
{
    CGRect f = _contentScrollView.frame;
    f.size.height = height;
    _contentScrollView.frame = f;
}

-(void)setFormScrollViewContentHeight:(float)height {
    CGSize size = _contentScrollView.contentSize;
    size.height = height;
    _contentScrollView.contentSize = size;
}

-(void)clearContent
{
    if(_contentScrollView) {
        for (id subview in _contentScrollView.subviews) {
            [subview removeFromSuperview];
        }
    }
    [self initVars];
}

-(float)contentScrollHeight {
    return _contentScrollView.frame.size.height;
}

#pragma mark Methods

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

    [_contentScrollView addSubview:field];
}

-(void)pushViewToBottom:(UIView *)insertView
{
    [self pushViewToBottom:insertView paddingBottom:10];
}

-(void)pushViewToBottom:(UIView *)insertView paddingBottom:(int)paddingBottom
{
    CGRect f = insertView.frame;
    f.origin.y = bottomTopY - f.size.height - paddingBottom;
    insertView.frame = f;
    [_contentScrollView addSubview:insertView];
    
    bottomTopY = f.origin.y;
}

-(void)pushButtonToBottom:(UIView *)button {
    [self pushButtonToBottom:button paddingBottom:10];
}

-(void)pushButtonToBottom:(UIView *)button paddingBottom:(int)paddingBottom {
    [self pushViewToBottom:button paddingBottom:paddingBottom];
    
    CGRect f = button.frame;
    f.origin.x = (_contentScrollView.bounds.size.width - f.size.width) * 0.5;
    button.frame = f;
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
    _contentScrollView = nil;
}

@end
