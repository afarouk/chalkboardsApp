//
//  CTActivatePromotionView.h
//  Community
//
//  Created by My Mac on 15/03/16.
//  Copyright © 2016 Community. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HVTableView.h"

@protocol CTActivatePromotionViewControllerDelegate <NSObject>
@end
@interface CTActivatePromotionView : UIViewController <HVTableViewDelegate, HVTableViewDataSource>
{
    
    IBOutlet HVTableView *tblActivate;
    NSMutableDictionary *selectedIndexes;
    
//    UILabel *MessageLabelText;
//    UILabel *MessageLabel;
//    UILabel *CampaignLabelText;
//    UILabel *CampaignLabel;
//    UILabel *UserLabelText;
//    UILabel *UserLabel;
    
    UIImageView *MainImage;
    UIImageView *ShareImage;
    UILabel *TitleLbl;
    UILabel *MsgTitleLbl;
    UILabel *MessgeLbl;
    UILabel *MsgBgLbl;
    UILabel *OffersLbl;
}

@property(nonatomic,assign) id<CTActivatePromotionViewControllerDelegate> delegate;
@property(nonatomic,strong) UIButton *hideBtn;

- (BOOL)cellIsSelected:(NSIndexPath *)indexPath;
@property (nonatomic, strong) NSMutableArray *promotionsArray;
@end
