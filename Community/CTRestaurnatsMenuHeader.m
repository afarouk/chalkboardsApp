//
//  CTRestaurnatsMenuHeader.m
//  Community
//
//  Created by practice on 29/05/2014.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTRestaurnatsMenuHeader.h"

@implementation CTRestaurnatsMenuHeader

@synthesize btnName, btnDistance;

- (id)init
{
    self = [[[NSBundle mainBundle]loadNibNamed:@"RestaurnatsMenuHeader" owner:self options:nil] objectAtIndex:0];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
