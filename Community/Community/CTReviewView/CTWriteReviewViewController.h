//
//  CTWriteReviewViewController.h
//  Community
//
//  Created by dinesh on 23/02/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTWriteReviewViewController : UIViewController<UITextViewDelegate>
@property int  starRatingCount;
@property(nonatomic,weak) IBOutlet UIButton *sendBtn;
- (IBAction)starButtonAction:(id)sender;

@end
