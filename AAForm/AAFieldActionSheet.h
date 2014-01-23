//
//  AAFieldActionSheet.h
//  AAFieldComponents
//
//  Created by Almas Adilbek on 7/23/13.
//  Copyright (c) 2013 GoodApp inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AAFieldActionSheetValueChangedBlock)(NSDictionary *option, int index);

@interface AAFieldActionSheet : UIView {
    NSMutableArray *options;
    int selectedIndex;
    int visibleItems;
}

@property (nonatomic, strong) NSMutableArray *options;
@property (nonatomic, assign) int visibleItems;
@property (nonatomic, assign) int selectedIndex;

- (id)initWithTitle:(NSString *)title;
-(void)show;
-(void)hide;

-(void)onValueChange:(AAFieldActionSheetValueChangedBlock)block;

@end
