//
//  AAFieldDatePicker.m
//  Myth
//
//  Created by Almas Adilbek on 08/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "AAFieldDatePicker.h"

@interface AAFieldDatePicker()
-(void)showDatePicker;
@end

@implementation AAFieldDatePicker {
    UIView *datePickerView;
    UIView *dim;
}

@synthesize dateFormatter, date;

- (id)init
{
    self = [super init];
    if (self)
    {
        __weak AAFieldDatePicker *wSelf = self;

        self.date = nil;
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd.MM.yyyy"];

        [self setIcon:[self imageWithName:@"AAFieldCalendarIcon"]];
        [self enableFieldBackgroundViewTrigger];

        [self onTap:^{
            [wSelf showDatePicker];
        }];
    }
    return self;
}

-(void)showDatePicker
{
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];

    dim = [[UIView alloc] initWithFrame:screenRect];
    dim.backgroundColor = [UIColor blackColor];
    dim.alpha = 0.0;
    [window addSubview:dim];

    if(!datePickerView)
    {
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        [datePicker setDatePickerMode:UIDatePickerModeDate];
        [datePicker addTarget:self action:@selector(datePickerDateChanged:) forControlEvents:UIControlEventValueChanged];
        datePicker.backgroundColor = [UIColor whiteColor];
//        if(field.optionValue) [datePicker setDate:(NSDate *)field.optionValue];

        CGSize pickerSize = [datePicker sizeThatFits:CGSizeZero];
        CGRect f = datePicker.frame;
        f.origin.y = 44;
        datePicker.frame = f;

        datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, pickerSize.height + 44)];
        datePickerView.backgroundColor = [UIColor clearColor];
        [datePickerView addSubview:datePicker];

        //Toolbar
        UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, 44)];
        pickerToolbar.barStyle=UIBarStyleBlackTranslucent;
        [pickerToolbar sizeToFit];

        NSMutableArray *barItems = [NSMutableArray array];
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [barItems addObject:flexSpace];

        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(datePickerDoneClicked)];
        [barItems addObject:doneButton];

        [pickerToolbar setItems:barItems animated:NO];
        [datePickerView addSubview:pickerToolbar];

        [window addSubview:datePickerView];
    }

    CGSize pickerViewSize = datePickerView.frame.size;
    CGRect startRect = CGRectMake(0.0, screenRect.origin.y + screenRect.size.height, pickerViewSize.width, pickerViewSize.height);
    datePickerView.frame = startRect;

    CGRect pickerRect = CGRectMake(0.0, screenRect.origin.y + screenRect.size.height - pickerViewSize.height, pickerViewSize.width, pickerViewSize.height);

    [UIView animateWithDuration:0.25 animations:^{
        dim.alpha = 0.2;
        datePickerView.frame = pickerRect;
    }];

}

#pragma mark -
#pragma mark Overrides

-(void)focus {
    [self showDatePicker];
}


#pragma mark Actions

- (void)datePickerDoneClicked
{
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    CGSize pickerViewSize = datePickerView.frame.size;
    CGRect startRect = CGRectMake(0.0, screenRect.origin.y + screenRect.size.height, pickerViewSize.width, pickerViewSize.height);
    [UIView animateWithDuration:0.25 animations:^{
        datePickerView.frame = startRect;
        dim.alpha = 0;
    } completion:^(BOOL finished) {
        [dim removeFromSuperview];
        [datePickerView removeFromSuperview];
        datePickerView = nil;
    }];
}

- (void)datePickerDateChanged:(UIDatePicker *)datePicker
{
    self.date = [datePicker date];
    [self setValue:[dateFormatter stringFromDate:[datePicker date]]];
}

#pragma mark -

-(void)dealloc {
    datePickerView = nil;
    self.dateFormatter = nil;
    self.date = nil;
}

@end
