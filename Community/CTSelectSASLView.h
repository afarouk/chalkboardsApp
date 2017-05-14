//
//  CTSelectSASLView.h
//  Community
//
//  Created by My Mac on 23/02/16.
//  Copyright © 2016 Community. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTSelectSASLView : UIView <UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView * tblDisplayData;
    
    IBOutlet UILabel *Lbl_Bussiness;
}
- (IBAction)BackButtonPressed:(id)sender;



@end
