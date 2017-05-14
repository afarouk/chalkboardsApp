//
//  CTReviewView.h
//  Community
//
//  Created by dinesh on 16/02/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTReviewView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *reviewTableView;
@property (nonatomic,retain) NSString *sa;
@property (nonatomic,retain)NSString *sl;
@property (nonatomic,retain)NSArray *reviewArray;
@property (nonatomic,retain)NSMutableArray *ratingImageUrlArray;
@property (nonatomic,retain)UIViewController *viewController;
@property (nonatomic,retain)UINavigationController *navigationController;


@end
