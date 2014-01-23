//
//  AAFieldCombobox.m
//  AAFieldComponents
//
//  Created by Almas Adilbek on 7/23/13.
//  Copyright (c) 2013 GoodApp inc. All rights reserved.
//

#import "AAFieldCombobox.h"
#import "AAFieldActionSheet.h"

@implementation AAFieldCombobox {
    UIImageView *listIcon;
    NSMutableArray *options;
    AAFieldComboboxOnValueChangeBlock onValueChangeBlock;
}

@synthesize selectedIndex, visibleItems;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.selectedIndex = -1;
        self.visibleItems = 5;
        self.inputField.userInteractionEnabled = NO;

        listIcon = [[UIImageView alloc] initWithImage:[self imageWithName:@"AAFieldListIcon"]];
        listIcon.userInteractionEnabled = NO;
        [fieldBackgroundView addSubview:listIcon];
        
        [self enableFieldBackgroundViewTrigger];
    }
    return self;
}

#pragma mark -
#pragma mark Methods

-(NSString *)optionValue {
    if(self.selectedIndex == -1) return nil;
    return [[options objectAtIndex:self.selectedIndex] objectForKey:@"id"];
}

-(void)onValueChange:(AAFieldComboboxOnValueChangeBlock)block {
    onValueChangeBlock = block;
}

-(void)addOptionWithID:(NSString *)optionID title:(NSString *)optionTitle icon:(id)icon {
    if(!options) options = [[NSMutableArray alloc] init];
    if(!icon) icon = @"";
    [options addObject:@{@"id":optionID, @"title":optionTitle, @"icon":icon}];
}

-(void)selectItemAtIndex:(int)index
{
    if(index >= 0 && index < options.count) {
        self.selectedIndex = index;
        [self setValue:[[options objectAtIndex:index] objectForKey:@"title"]];
    }
}

-(void)removeAllOptions
{
    self.selectedIndex = -1;
    [options removeAllObjects];
    options = nil;
    [self setValue:@""];
    [self setIcon:nil];
}

-(int)countOptions {
    return options?options.count:0;
}

#pragma mark -
#pragma mark Overrides

-(void)focus {
    [self actionFieldBackgroundTapped];
}

-(void)actionFieldBackgroundTapped
{
    [super actionFieldBackgroundTapped];
    [self.superview endEditing:YES];
    
    AAFieldActionSheet *actionSheet = [[AAFieldActionSheet alloc] initWithTitle:self.titleLabel.text];
    actionSheet.visibleItems = self.visibleItems;
    actionSheet.options = options;
    actionSheet.selectedIndex = self.selectedIndex;
    [actionSheet show];
    
    __weak AAFieldComboboxOnValueChangeBlock weakOnValueChangeBlock = onValueChangeBlock;
    __weak AAFieldCombobox *wSelf = self;
    [actionSheet onValueChange:^(NSDictionary *option, int index) {
        wSelf.selectedIndex = index;
        [wSelf setValue:[option objectForKey:@"title"]];

        id icon = [option objectForKey:@"icon"];
        if(([icon isKindOfClass:[NSString class]] && [icon length] > 0) || [icon isKindOfClass:[UIImage class]]) [wSelf setIcon:[option objectForKey:@"icon"]];
        if(weakOnValueChangeBlock) weakOnValueChangeBlock(option);
    }];
}

-(void)updateUI {
    [super updateUI];
    
    CGRect f = listIcon.frame;
    f.origin.x = fieldWidth - disclosurePaddingRight - f.size.width * 0.5;
    f.origin.y = (fieldBackgroundViewHeight - f.size.height) * 0.5;
    listIcon.frame = f;
}

#pragma mark -

- (void)dealloc
{
    listIcon = nil;
    options = nil;
    onValueChangeBlock = nil;
}

@end
