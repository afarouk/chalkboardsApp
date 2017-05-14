//
//  CTReservationView.h
//  Community
//
//  Created by dinesh on 31/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTReservationView : UIView<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate> {
    NSString *params;
}
@property (weak, nonatomic) IBOutlet UILabel *tierNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *tableLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UITableView *timeSlotTableView;
@property (nonatomic,retain)UIActionSheet *actionSheet;
@property (nonatomic,retain)UIDatePicker *datePicker;
@property (nonatomic,retain) NSString *sa;
@property (nonatomic,retain)NSString *sl;
@property (nonatomic,retain)NSString *urlString;
@property (nonatomic,retain)NSMutableArray *timeSlotArray;
@property (nonatomic,retain)NSMutableArray *tableArray;
@property (nonatomic,retain)NSMutableArray *chosenTableArray;
@property (weak, nonatomic) IBOutlet UIButton *selectTimeBtn;
@property (nonatomic,assign)BOOL isTableNoChosen;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak,nonatomic) IBOutlet UISegmentedControl *segmentedControl;
-(IBAction)segmentedControlValueChanged:(id)sender;
-(void)showReservationViewWithMenuView:(UIView*)_menuView ;
@end
