//
//  CTLoadCityList.h
//  Community
//
//  Created by ADMIN on 01/06/16.
//  Copyright © 2016 Community. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTLoadCityList : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *CityArray;
}
@property (nonatomic, retain) id CityResult;
@property (strong, nonatomic) IBOutlet UITableView *CityTable;

@end
