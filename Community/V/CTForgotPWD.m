//
//  CTForgotPWD.m
//  Community
//
//  Created by BBITS Dev on 01/07/15.
//  Copyright (c) 2015 Community. All rights reserved.
//

#import "CTForgotPWD.h"
#import "CTWebServicesMethods.h"
#import "MBProgressHUD.h"
#import "CTCommonMethods.h"
@implementation CTForgotPWD

- (id)init
{
    self = [[[NSBundle mainBundle]loadNibNamed:@"CTForgotPWD" owner:self options:nil] objectAtIndex:0];
    if (self) {
        // Initialization code
    }
    return self;
}

-(IBAction)closeBtnTaped:(id)sender {
    [self removeFromSuperview];
}

-(IBAction)okBtnTaped:(id)sender {
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode=MBProgressHUDModeIndeterminate;//authentication/sendEmailForResetPassword?usernameOrEmail=member0
    
    NSString *url=[NSString stringWithFormat:@"%@authentication/sendEmailForResetPassword?usernameOrEmail=%@",[CTCommonMethods getChoosenServer],tfUserName.text];
    
    
    [CTWebServicesMethods sendRequestWithURL:url params:nil method:kHTTPMethod_PUT contentType:@"application/json" success:^(id JSON) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self animated:YES];
            
            if (JSON) {
                @try {
                    //                    NSString *strMessage = [JSON valueForKeyPath:@"messageBody"];
                    if ([JSON valueForKeyPath:@"explanation"]) {
                        [CTCommonMethods showErrorAlertMessageWithTitle:[JSON valueForKeyPath:@"explanation"] andMessage:@""];
                    }
                }
                @catch (NSException *exception) {
                    NSLog(@"exception in okBtnTaped %@",exception);
                }
            }
            NSLog(@"okBtnTaped Response JSON = %@",JSON);
        });
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self animated:YES];
            
            NSLog(@"okBtnTaped Error %@",error);
            [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        });
    }];
}

@end
