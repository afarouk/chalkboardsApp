//
//  CTCommonBarButtons.m
//  Community
//
//  Created by practice on 15/04/2014.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTCommonBarButtons.h"
#import "ImageNamesFile.h"
@implementation CTCommonBarButtons
+(UIBarButtonItem*)listMenuBtn {
    UIButton *menuButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setFrame:CGRectMake(0, 0, 25, 25)];
    [menuButton setImage:[UIImage imageNamed:CT_MenuIcon] forState:UIControlStateNormal];
    UIBarButtonItem *rightBarButton=[[UIBarButtonItem alloc]initWithCustomView:menuButton];
    return  rightBarButton;
}
@end
