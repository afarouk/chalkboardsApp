//
//  CTLocationSearchPopup.h
//  Community
//
//  Created by practice on 27/05/2014.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SearchQueryCallBack)(NSString *street,NSString* city, NSString* zipCode);

@interface CTLocationSearchPopup : UIView
@property(weak,nonatomic) IBOutlet UITextField *streetTextField,*cityTextField,*zipTextField;
@property(nonatomic,copy) SearchQueryCallBack callBack;
-(IBAction)submitBtnTaped:(id)sender;
-(IBAction)closeBtnTaped:(id)sender;
@end
