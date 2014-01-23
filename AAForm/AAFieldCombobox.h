//
//  AAFieldCombobox.h
//  AAFieldComponents
//
//  Created by Almas Adilbek on 7/23/13.
//  Copyright (c) 2013 GoodApp inc. All rights reserved.
//

#import "AAField.h"

typedef void(^AAFieldComboboxOnValueChangeBlock)(NSDictionary *option);

@interface AAFieldCombobox : AAField {
    int selectedIndex;
    int visibleItems;
}

@property (nonatomic, assign) int selectedIndex;
@property (nonatomic, assign) int visibleItems;

-(NSString *)optionValue;

-(void)addOptionWithID:(NSString *)optionID title:(NSString *)optionTitle icon:(id)icon; // Icon may be URL or UIImage object
-(void)selectItemAtIndex:(int)index;
-(void)removeAllOptions;

-(int)countOptions;

-(void)onValueChange:(AAFieldComboboxOnValueChangeBlock)block;

@end
