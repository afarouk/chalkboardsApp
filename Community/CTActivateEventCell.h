//
//  CTActivateEventCell.h
//  Community
//
//  Created by My Mac on 16/03/16.
//  Copyright © 2016 Community. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTActivateEventCell : UITableViewCell
{
    
}

@property (nonatomic,retain) IBOutlet UILabel * lblEventName;
@property (nonatomic,retain) IBOutlet UILabel * lblEventDate;
@property (nonatomic,retain) IBOutlet UILabel * lblStatus;
@property (nonatomic,retain) IBOutlet UIButton * btnActivate;
@end
