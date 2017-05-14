//
//  CTModifyReservationView.h
//  Community
//
//  Created by dinesh on 28/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTModifyReservationView : UIView<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UILabel *cancelLbl;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIImageView *closeIcon;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;
@property (weak, nonatomic) IBOutlet UIButton *downButton;
@property (weak, nonatomic) IBOutlet UIButton *upButton;
@property (weak, nonatomic) IBOutlet UILabel *delayTimeLbl;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UILabel *sendLbl;
@property (nonatomic,retain)NSDictionary *restaurantDetail;
@property (nonatomic,retain)NSString *delayTime;
@property (nonatomic,retain)NSArray *categoryArray;

@property(nonatomic,weak) IBOutlet UILabel *timeLabel,*dateLabel;
-(IBAction)didChangeValueForSegmentedControl:(id)sender;
-(IBAction)cancelReservation:(id)sender;
@end
