//
//  CTPhotoUploadViewController.h
//  Community
//
//  Created by practice on 03/04/2014.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTPhotoUploadViewController : UIViewController
@property(nonatomic,strong) NSDictionary *restaurantDictionary;
@property(nonatomic,weak) IBOutlet UIImageView *imageView;
-(IBAction)pickPhoto:(id)sender;
-(IBAction)takePhoto:(id)sender;
-(IBAction)closeBtnTaped:(id)sender;
-(IBAction)uploadBtnTaped:(id)sender;
@end
