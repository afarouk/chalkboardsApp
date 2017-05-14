//
//  CTFilterView.h
//  Community
//
//  Created by dinesh on 19/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CTFilterViewDelegate <NSObject>
-(void)didTapOnFilterView;
@end
@interface CTFilterView : UIView<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource> {
    UIView *container;
    UIView *gestureView;
}
@property(nonatomic,assign) id<CTFilterViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *domainFilterButton;
@property (weak, nonatomic) IBOutlet UIButton *categoryFilterButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (retain,nonatomic)UIView *dropdownView;
@property (retain,nonatomic)UITableView *selectorTableView;
@property (nonatomic,assign)BOOL isDomain;
@property (nonatomic,assign)BOOL isCategory;
@property (nonatomic,retain)NSMutableArray *domainList;
@property (weak, nonatomic) IBOutlet UILabel *domainLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (nonatomic,retain)NSString *selectedCategory;
@property (nonatomic,retain)NSString *selectedDomain;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (nonatomic,retain)NSMutableArray *categoryList;
-(void)enableHitDetectionArea;
-(void)disableHitDetectionArea;
@end
