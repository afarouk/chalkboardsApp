//
//  MISDropdownMenuView.h
//  MISDropdownViewController
//
//  Created by Michael Schneider on 4/11/15.
//  Copyright (c) 2015 mischneider. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MISDropdownMenuView : UIControl
@property (copy, nonatomic, readonly) NSArray *items;
@property (assign, nonatomic) NSInteger selectedItemIndex;

@property (strong, nonatomic) UIColor *textLabelColor;
@property (strong, nonatomic) UIColor *selectedTextLabelColor;

- (instancetype)initWithItems:(NSArray *)items;
@end
