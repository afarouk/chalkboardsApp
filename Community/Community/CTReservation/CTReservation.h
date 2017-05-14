//
//  CTReservation.h
//  Community
//
//  Created by dinesh on 28/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTModifyReservationView.h"

@interface CTReservation : UIView<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *reservationTableView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIImageView *backIcon;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (nonatomic,retain)NSArray *reservationListArray;
@property (nonatomic,strong)CTModifyReservationView *modifyReservationView;

@end
