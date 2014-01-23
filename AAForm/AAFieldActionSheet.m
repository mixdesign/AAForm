//
//  AAFieldActionSheet.m
//  AAFieldComponents
//
//  Created by Almas Adilbek on 7/23/13.
//  Copyright (c) 2013 GoodApp inc. All rights reserved.
//

#import "AAFieldActionSheet.h"
#import "AAFieldActionSheetListItem.h"

#define kPadding 13
#define kDimAlpha 0.35

@implementation AAFieldActionSheet {
    UIView *dim;
    UIView *sheetView;
    UIScrollView *sheetViewScrollView;
    
    AAFieldActionSheetValueChangedBlock onValueChangeBlock;
}

@synthesize options, visibleItems, selectedIndex;

- (id)initWithTitle:(NSString *)title
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {

        self.visibleItems = 5;

        dim = [[UIView alloc] initWithFrame:self.bounds];
        dim.backgroundColor = [UIColor blackColor];
        dim.alpha = 0;
        [self addSubview:dim];
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [dim addGestureRecognizer:ges];
        
        sheetView = [[UIView alloc] initWithFrame:CGRectMake(0, size.height, size.width, 200)];
        sheetView.backgroundColor  = [UIColor whiteColor];
        [self addSubview:sheetView];
        
        // Title
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPadding, kPadding, size.width - 2 * kPadding, 1)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = [UIColor grayColor];
        titleLabel.text = title;
        [titleLabel sizeToFit];
        [sheetView addSubview:titleLabel];
        
        sheetViewScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, titleLabel.frame.origin.y + titleLabel.bounds.size.height + kPadding, size.width, 0)];
        sheetViewScrollView.alwaysBounceVertical = options.count > visibleItems;
        [sheetView addSubview:sheetViewScrollView];
        
    }
    return self;
}

-(void)onValueChange:(AAFieldActionSheetValueChangedBlock)block {
    onValueChangeBlock = block;
}

-(void)show
{
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    float lastY = 0;
    int index = 0;
    float containerHeight = 0;

    for (NSDictionary *option in options)
    {
        AAFieldActionSheetListItem *item = [[AAFieldActionSheetListItem alloc] initWithTitle:[option objectForKey:@"title"] width:self.bounds.size.width];
        item.optionIndex = index;

        // Icon
        id icon = [option objectForKey:@"icon"];
        if(([icon isKindOfClass:[NSString class]] && [icon length] > 0) || [icon isKindOfClass:[UIImage class]]) [item setIcon:icon];

        CGRect f = item.frame;
        f.origin.y = lastY;
        item.frame = f;
        [sheetViewScrollView addSubview:item];

        // Select
        if(self.selectedIndex == index) {
            [item select];
        }

        lastY = f.origin.y + f.size.height;

        ++index;
        if(index <= visibleItems) containerHeight = lastY;

        __weak AAFieldActionSheet *wSelf = self;
        __weak NSMutableArray *weakOptions = options;
        
        [item onTap:^(int index) {
            if(onValueChangeBlock) {
                onValueChangeBlock([weakOptions objectAtIndex:index], index);
            }
            [wSelf hide];
        }];
    }

    CGRect f = sheetViewScrollView.frame;
    f.size.height = containerHeight;
    sheetViewScrollView.frame = f;
    sheetViewScrollView.contentSize = CGSizeMake(f.size.width, lastY);
    
    f = sheetView.frame;
    f.size.height = sheetViewScrollView.frame.origin.y + sheetViewScrollView.bounds.size.height + kPadding;
    f.origin.y = size.height - f.size.height;
    
    [UIView animateWithDuration:0.25 animations:^{
        dim.alpha = kDimAlpha;
        sheetView.frame = f;
    } completion:^(BOOL finished) {
        //
    }];
}

-(void)hide
{
    CGRect f = sheetView.frame;
    f.origin.y = [UIScreen mainScreen].bounds.size.height;
    [UIView animateWithDuration:0.2 animations:^{
        sheetView.frame = f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            dim.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }];
}

-(void)dealloc {
    dim = nil;
    sheetViewScrollView = nil;
    self.options = nil;
    onValueChangeBlock = nil;
}

@end
