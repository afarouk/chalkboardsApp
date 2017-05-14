//
//  CTFilterViewController.h
//  Community
//
//  Created by practice on 14/04/2014.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTFilterViewController : UIViewController <UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate>{
    IBOutlet UIBarButtonItem *item;
    IBOutlet UIButton *btnCancel;
    
    IBOutlet UIBarButtonItem *goButton;
    
    IBOutlet UIButton *SelectButton;
}
@property(nonatomic,retain) IBOutlet UIPickerView *pickerView;
@property(nonatomic,strong)  UIView *tapableView;

@property (nonatomic, retain) id searchResult;

-(void)showFilterPicker:(BOOL)animated;
-(void)hideFilterPicker:(BOOL)animated;
-(BOOL)isVisible;
-(IBAction)didTapCancelBtn:(id)sender;
-(IBAction)didTapSubmitBtn:(id)sender;
@end
