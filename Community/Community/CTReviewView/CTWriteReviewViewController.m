//
//  CTWriteReviewViewController.m
//  Community
//
//  Created by dinesh on 23/02/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTWriteReviewViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "NSDictionary+GetRestaurantDetails.h"
#import "MBProgressHUD.h"


@interface CTWriteReviewViewController ()

@property (weak, nonatomic) IBOutlet UITextView *reviewTextView;
@property (weak, nonatomic) IBOutlet UIButton *starBtn1;
@property (weak, nonatomic) IBOutlet UIButton *starBtn2;
@property (weak, nonatomic) IBOutlet UIButton *starBtn3;
@property (weak, nonatomic) IBOutlet UIButton *starBtn4;
@property (weak, nonatomic) IBOutlet UIButton *starBtn5;

@end

@implementation CTWriteReviewViewController
@synthesize starRatingCount;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.reviewTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sendButton:(id)sender {
    
   //
    if(self.reviewTextView.text.length!=0){
    [self addReview];
    }
    else{
        [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:@"Please write your review"];
    }
}

- (IBAction)starButtonAction:(id)sender {
    
    UIButton *button=sender;
    NSLog(@"buuton tag %d",button.tag);
    if(button.tag==1){
        
//        if(button.imageView.image==[UIImage imageNamed:@"gold_star.png"]){
//        starRatingCount=0;
//        [_starBtn1 setImage:[UIImage imageNamed:@"white_star.png"] forState:UIControlStateNormal];
//        [_starBtn2 setImage:[UIImage imageNamed:@"white_star.png"] forState:UIControlStateNormal];
//        [_starBtn3 setImage:[UIImage imageNamed:@"white_star.png"] forState:UIControlStateNormal];
//        [_starBtn4 setImage:[UIImage imageNamed:@"white_star.png"] forState:UIControlStateNormal];
//        [_starBtn5 setImage:[UIImage imageNamed:@"white_star.png"] forState:UIControlStateNormal];
//        }else{
             [_starBtn1 setImage:[UIImage imageNamed:@"gold_star.png"] forState:UIControlStateNormal];
        [_starBtn2 setImage:[UIImage imageNamed:@"white_star.png"] forState:UIControlStateNormal];
        [_starBtn3 setImage:[UIImage imageNamed:@"white_star.png"] forState:UIControlStateNormal];
        [_starBtn4 setImage:[UIImage imageNamed:@"white_star.png"] forState:UIControlStateNormal];
        [_starBtn5 setImage:[UIImage imageNamed:@"white_star.png"] forState:UIControlStateNormal];

              starRatingCount=1;
//        }
    }
    else if (button.tag==2){
//       if(button.imageView.image==[UIImage imageNamed:@"gold_star.png"]){
//            starRatingCount=1;
//            [_starBtn1 setImage:[UIImage imageNamed:@"gold_star.png"] forState:UIControlStateNormal];
//            [_starBtn2 setImage:[UIImage imageNamed:@"white_star.png"] forState:UIControlStateNormal];
//            [_starBtn3 setImage:[UIImage imageNamed:@"white_star.png"] forState:UIControlStateNormal];
//            [_starBtn4 setImage:[UIImage imageNamed:@"white_star.png"] forState:UIControlStateNormal];
//            [_starBtn5 setImage:[UIImage imageNamed:@"white_star.png"] forState:UIControlStateNormal];
//        }else{
            starRatingCount=2;
             [_starBtn1 setImage:[UIImage imageNamed:@"gold_star.png"] forState:UIControlStateNormal];
            [_starBtn2 setImage:[UIImage imageNamed:@"gold_star.png"] forState:UIControlStateNormal];
        [_starBtn3 setImage:[UIImage imageNamed:@"white_star.png"] forState:UIControlStateNormal];
        [_starBtn4 setImage:[UIImage imageNamed:@"white_star.png"] forState:UIControlStateNormal];
        [_starBtn5 setImage:[UIImage imageNamed:@"white_star.png"] forState:UIControlStateNormal];
//        }
    }
    else if (button.tag==3){
//        if(button.imageView.image==[UIImage imageNamed:@"gold_star.png"]){
//            starRatingCount=2;
//            [_starBtn1 setImage:[UIImage imageNamed:@"gold_star.png"] forState:UIControlStateNormal];
//            [_starBtn2 setImage:[UIImage imageNamed:@"gold_star.png"] forState:UIControlStateNormal];
//            [_starBtn3 setImage:[UIImage imageNamed:@"white_star.png"] forState:UIControlStateNormal];
//            [_starBtn4 setImage:[UIImage imageNamed:@"white_star.png"] forState:UIControlStateNormal];
//            [_starBtn5 setImage:[UIImage imageNamed:@"white_star.png"] forState:UIControlStateNormal];
//        }else{
            starRatingCount=3;
            [_starBtn1 setImage:[UIImage imageNamed:@"gold_star.png"] forState:UIControlStateNormal];
            [_starBtn2 setImage:[UIImage imageNamed:@"gold_star.png"] forState:UIControlStateNormal];
            [_starBtn3 setImage:[UIImage imageNamed:@"gold_star.png"] forState:UIControlStateNormal];
        [_starBtn4 setImage:[UIImage imageNamed:@"white_star.png"] forState:UIControlStateNormal];
        [_starBtn5 setImage:[UIImage imageNamed:@"white_star.png"] forState:UIControlStateNormal];
//        }
    }
    else if (button.tag==4){
//        if(button.imageView.image==[UIImage imageNamed:@"gold_star.png"]){
//            starRatingCount=3;
//            [_starBtn1 setImage:[UIImage imageNamed:@"gold_star.png"] forState:UIControlStateNormal];
//            [_starBtn2 setImage:[UIImage imageNamed:@"gold_star.png"] forState:UIControlStateNormal];
//            [_starBtn3 setImage:[UIImage imageNamed:@"gold_star.png"] forState:UIControlStateNormal];
//            [_starBtn4 setImage:[UIImage imageNamed:@"white_star.png"] forState:UIControlStateNormal];
//            [_starBtn5 setImage:[UIImage imageNamed:@"white_star.png"] forState:UIControlStateNormal];
//        }else{
            starRatingCount=4;
            [_starBtn1 setImage:[UIImage imageNamed:@"gold_star.png"] forState:UIControlStateNormal];
            [_starBtn2 setImage:[UIImage imageNamed:@"gold_star.png"] forState:UIControlStateNormal];
            [_starBtn3 setImage:[UIImage imageNamed:@"gold_star.png"] forState:UIControlStateNormal];
            [_starBtn4 setImage:[UIImage imageNamed:@"gold_star.png"] forState:UIControlStateNormal];
        [_starBtn5 setImage:[UIImage imageNamed:@"white_star.png"] forState:UIControlStateNormal];
//        }

    }
    else if (button.tag==5){
//       if(button.imageView.image==[UIImage imageNamed:@"gold_star.png"]){
//           starRatingCount=4;
//            [_starBtn1 setImage:[UIImage imageNamed:@"gold_star.png"] forState:UIControlStateNormal];
//            [_starBtn2 setImage:[UIImage imageNamed:@"gold_star.png"] forState:UIControlStateNormal];
//            [_starBtn3 setImage:[UIImage imageNamed:@"gold_star.png"] forState:UIControlStateNormal];
//            [_starBtn4 setImage:[UIImage imageNamed:@"gold_star.png"] forState:UIControlStateNormal];
//            [_starBtn5 setImage:[UIImage imageNamed:@"white_star.png"] forState:UIControlStateNormal];
//        }else{
            starRatingCount=5;
            [_starBtn1 setImage:[UIImage imageNamed:@"gold_star.png"] forState:UIControlStateNormal];
            [_starBtn2 setImage:[UIImage imageNamed:@"gold_star.png"] forState:UIControlStateNormal];
            [_starBtn3 setImage:[UIImage imageNamed:@"gold_star.png"] forState:UIControlStateNormal];
            [_starBtn4 setImage:[UIImage imageNamed:@"gold_star.png"] forState:UIControlStateNormal];
            [_starBtn5 setImage:[UIImage imageNamed:@"gold_star.png"] forState:UIControlStateNormal];
//        }
    }
}

-(void)addReview{
    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:CT_Observers_getSASL];
    NSDictionary *restaurantDetails=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSString *UID=[CTCommonMethods UID];
    NSString *sa=[NSString stringWithFormat:@"%@",[restaurantDetails objectForKey:@"serviceAccommodatorId"]];
    NSString *sl=[NSString stringWithFormat:@"%@",[restaurantDetails objectForKey:@"serviceLocationId"]];
    NSString *urlParams=[NSString stringWithFormat:@"UID=%@&serviceAccommodatorId=%@&serviceLocationId=%@",UID,sa,sl];
    NSString *urlString=[NSString stringWithFormat:@"%@%@%@",[CTCommonMethods getChoosenServer],CT_AddReview,urlParams];
    NSLog(@"URL %@",urlString);
    NSURL *url=[NSURL URLWithString:urlString];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    NSString *msgTxt=[NSString stringWithFormat:@"{\"text_excerpt\":\"%@\",\"rating\":%d}",self.reviewTextView.text,starRatingCount];
    NSLog(@"MSG TEXT %@",msgTxt);
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[NSData dataWithBytes:[msgTxt UTF8String] length:strlen([msgTxt UTF8String])]];
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDModeIndeterminate;
    hud.labelText=@"Please wait...";
    AFJSONRequestOperation *operation=[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"SUCEESS");
        NSDictionary *dict=(NSDictionary *)JSON;
        if([[dict objectForKey:@"explanation"] isEqualToString:@"OK"]){
            [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:@"Thanks for your review"];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomTop];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if(error) {
            [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:error.localizedRecoverySuggestion];
        }else {
            NSLog(@"FAILED");
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSError *jsonError = [CTCommonMethods validateJSON:JSON];
            //        NSDictionary *errorDict=(NSDictionary *)JSON;
            //        NSDictionary *errorMsgDict=[errorDict objectForKey:@"error"];
            //        NSString *errorMsgStr=[errorMsgDict objectForKey:@"message"];
            if(jsonError)
                [CTCommonMethods showErrorAlertMessageWithTitle:jsonError.localizedFailureReason andMessage:jsonError.localizedDescription];
            else
                [CTCommonMethods showErrorAlertMessageWithTitle:CT_AlertTitle andMessage:CT_DefaultAlertMessage];
        }
       
    }];
    
    [operation start];
    
}
@end
