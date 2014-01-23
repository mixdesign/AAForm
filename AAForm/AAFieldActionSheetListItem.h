//
//  AAFieldActionSheetListItem.h
//  AAFieldComponents
//
//  Created by Almas Adilbek on 7/24/13.
//  Copyright (c) 2013 GoodApp inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AAFieldActionSheetListItemOnTap)(int index);

@interface AAFieldActionSheetListItem : UIView {
    int optionIndex;
    float iconViewSize;
}

@property (nonatomic, assign) int optionIndex;

- (id)initWithTitle:(NSString *)title width:(float)width;
-(void)setIcon:(id)icon;
-(void)select;

-(void)onTap:(AAFieldActionSheetListItemOnTap)block;

@end
