//
//  CTPromotionViewController.h
//  Community
//
//  Created by ADMIN on 2/25/16.
//  Copyright (c) 2016 Community. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"
#import "CTImageAddViewController.h"

@protocol CTPromotionViewControllerDelegate <NSObject>
@end

@interface CTPromotionViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UITextViewDelegate,NIDropDownDelegate,UIGestureRecognizerDelegate,CTImageAddDelegate>
{
    int movementDistance ;
    CGFloat animatedDistance;
    id rootNavController;
    
    NSMutableArray * listofpromotionName;
    NSMutableArray * listofpromotionColor;
    NIDropDown *dropDown;
    
    int selectnumber;
    
    BOOL Flag;
    
    NSString * getPromoCode;
}

@property (nonatomic, strong) NSMutableArray *promotionPictureList;
@property (nonatomic, assign) NSInteger currentImage;
@property(nonatomic,assign) id<CTPromotionViewControllerDelegate> delegate;
@property(nonatomic,strong) UIButton *hideBtn;

@property (weak, nonatomic) IBOutlet UITextField *txt_title;
@property (weak, nonatomic) IBOutlet UIImageView *img_new;
@property (weak, nonatomic) IBOutlet UITextView *txt_discription;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextView *txt_FinePrint;

@property (strong, nonatomic) IBOutlet UIScrollView *Scroll_Vw;


- (IBAction)btnTypePressed:(id)sender;
- (IBAction)btnCreatePressed:(id)sender;
- (IBAction)btnCancelPressed:(id)sender;
- (IBAction)btnAddNewPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *lbl_type;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_select_picture;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Discription;

@property (weak, nonatomic) IBOutlet UIButton *btn_items;
@property (weak, nonatomic) IBOutlet UIButton *btn_addnew;
@property (weak, nonatomic) IBOutlet UIButton *btn_create;
@property (weak, nonatomic) IBOutlet UIButton *btn_cancel;


@end
