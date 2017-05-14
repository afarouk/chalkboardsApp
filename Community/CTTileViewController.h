//
//  CTTileViewController.h
//  Community
//
//  Created by practice on 08/06/2014.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTTileViewController : UITableViewController {
    NSMutableDictionary *imageDownloadedDictionary;
    NSMutableArray * listoftile;
    NSString *helloimage;
    NSMutableArray *tilelistarr;
    NSArray *addalerttile;
}
@property(nonatomic,weak) id<CTGetRestaurantsDelegate> delegate;
@property (retain,nonatomic)UIImageView *imageview;
@property (nonatomic) int indexValue;
@end
