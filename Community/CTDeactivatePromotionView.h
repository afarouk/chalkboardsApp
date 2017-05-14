//
//  CTDeactivatePromotionView.h
//  Community
//
//  Created by My Mac on 15/03/16.
//  Copyright © 2016 Community. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HVTableView.h"

@protocol CTDeactivatePromotionViewControllerDelegate <NSObject>
@end

@interface CTDeactivatePromotionView : UIViewController<HVTableViewDelegate, HVTableViewDataSource>
{
    //IBOutlet UITableView * tblActivate;
    IBOutlet HVTableView *tblActivate;
    
    UIImageView *MainImage;
    UIImageView *ShareImage;
    UILabel *TitleLbl;
    UILabel *MsgTitleLbl;
    UILabel *MessgeLbl;
    UILabel *MsgBgLbl;
    UILabel *OffersLbl;
}

@property(nonatomic,assign) id<CTDeactivatePromotionViewControllerDelegate> delegate;
@property(nonatomic,strong) UIButton *hideBtn;

@property (nonatomic, strong) NSMutableArray *promotionsArray;

@end
