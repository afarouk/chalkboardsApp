//
//  CTRestaurantHomeControllerDataModel.h
//  Community
//
//  Created by practice on 17/04/2014.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^MarkAsFavoriteBlock)(NSError *error, id JSON);
typedef void(^DeleteFavoriteBlock)(NSError *error, id JSON);
typedef void(^GetFavoritesCompletionBlock)(NSError *error, id JSON);
@interface CTFavoritesDataModel : NSObject
@property(nonatomic,strong) NSMutableArray *favoritesList;
+(CTFavoritesDataModel*)sharedInstance;
-(void)markAsFavoriteWithURLKey:(NSString*)urlKey completionBlock:(MarkAsFavoriteBlock)block;
-(void)deleteFavoriteRestaurant:(NSString *)urlKey completionBlock:(DeleteFavoriteBlock)block;
-(void)retriveFavoritesWithCompletionBlock:(GetFavoritesCompletionBlock)block;
@end
