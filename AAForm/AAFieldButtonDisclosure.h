//
//  AAFieldButtonDisclosure.h
//  AAFieldComponents
//
//  Created by Almas Adilbek on 7/23/13.
//  Copyright (c) 2013 GoodApp inc. All rights reserved.
//

#import "AAField.h"

typedef void(^AAFieldButtonDisclosureOnTap)(void);

@interface AAFieldButtonDisclosure : AAField {

}

-(void)onDisclosureButtonTap:(AAFieldButtonDisclosureOnTap)block;

@end
