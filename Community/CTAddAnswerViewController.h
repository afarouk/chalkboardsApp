//
//  CTAddAnswerViewController.h
//  Community
//
//  Created by My Mac on 02/03/16.
//  Copyright © 2016 Community. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTImageAddViewController.h"

@interface CTAddAnswerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,CTImageAddDelegate>
{
    NSMutableArray * Answer;
    NSMutableArray * Image;
    NSMutableArray *arrQuestionAnswers;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *img_addimage;
@property (weak, nonatomic) IBOutlet UITextField *txt_answer;
@property(nonatomic,retain) NSString * UUIDpoll;
@property(nonatomic,strong) id listofAnswer;
- (IBAction)AddImageButtonPressed:(id)sender;
- (IBAction)AddButtonPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tbl_answer;
@property (weak, nonatomic) IBOutlet UIButton *btn_addimage;
@property (weak, nonatomic) IBOutlet UIButton *btn_add;

@end
