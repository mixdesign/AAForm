//
//  AAFieldDatePicker.h
//  Myth
//
//  Created by Almas Adilbek on 08/01/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//



#import "AAField.h"

@interface AAFieldDatePicker : AAField {
    NSDateFormatter *dateFormatter;
    NSDate *date;
}

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDate *date;

@end
