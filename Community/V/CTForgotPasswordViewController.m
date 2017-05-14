//
//  CTForgotPasswordViewController.m
//  Community
//
//  Created by BBITS Dev on 01/07/15.
//  Copyright (c) 2015 Community. All rights reserved.
//

#import "CTForgotPasswordViewController.h"
#import "CTWebServicesMethods.h"
#import "MBProgressHUD.h"
#import "CTCommonMethods.h"

@interface CTForgotPasswordViewController ()

@end

@implementation CTForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.view removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)closeBtnTaped:(id)sender {
    [self.view removeFromSuperview];
}

-(IBAction)okBtnTaped:(id)sender {
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDModeIndeterminate;//authentication/sendEmailForResetPassword?usernameOrEmail=member0

    NSString *url=[NSString stringWithFormat:@"%@authentication/sendEmailForResetPassword?usernameOrEmail=%@",[CTCommonMethods getChoosenServer],tfUserName.text];
    
    
    [CTWebServicesMethods sendRequestWithURL:url params:nil method:kHTTPMethod_PUT contentType:@"application/json" success:^(id JSON) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if (JSON) {
                @try {
                    //                    NSString *strMessage = [JSON valueForKeyPath:@"messageBody"];
                    [CTCommonMethods showErrorAlertMessageWithTitle:@"Work in progress" andMessage:@""];
                }
                @catch (NSException *exception) {
                    NSLog(@"exception in okBtnTaped %@",exception);
                }
            }
            NSLog(@"okBtnTaped Response JSON = %@",JSON);
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSLog(@"okBtnTaped Error %@",error);
            [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        });
    }];
}

@end
