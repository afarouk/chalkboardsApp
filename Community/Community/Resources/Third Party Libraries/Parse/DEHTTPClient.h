//Developed by Mykola Darkngs Golyash
//2013.08.29
//http://golyash.com

#import "AFHTTPClient.h"
//#import "DropdownController.h"

typedef void (^CPCompletion)(id response, NSError *error);
typedef void (^CMPActionSuccessBlock)(NSURLRequest *request, id response);
typedef void (^CMPActionfailureBlock)(NSURLRequest *request, NSError *error);

@interface DEHTTPClient: AFHTTPClient

@property (nonatomic, assign) float defaultTimeout;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) CMPActionfailureBlock failureBlock;
@property (readwrite,nonatomic, strong) NSURL *baseURL;
+ (DEHTTPClient *)sharedInstance;

- (void)cancelAllOperations;

#pragma mark - Login Request
- (void)loginWithParams:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;
- (void)getUserAndCommunityWithParams:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;
- (void)logoutWithParams:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;
- (void)retrieveCommunicationAlertsForSASLFromCommunityWithParams:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;
- (void)retrieveItemsWithParams:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;
//- (void)markAsReadSASL:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;
- (void)setVisitorPasswordWithParams:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;

#pragma mark - Business Listing
- (void)getBusinessNameWithParams:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;
//- (void)setBusinessNameWithParams:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;
- (void)getBusinessEmailWithParams:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;
//- (void)setBusinessEmailWithParams:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;
- (void)getBusinessTelephoneWithParams:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;
//- (void)setBusinessTelephoneWithParams:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;
- (void)getBusinessAddressWithParams:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;
//- (void)setBusinessAddressWithParams:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;

#pragma mark - Orders
- (void)retrieveOrdersBySASL:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;


#pragma mark - Resturant status
- (void)pingWithParams:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;
- (void)getAuthenticationStatusWithParams:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;
- (void)getStatusWithParams:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;
- (void)updateServiceStatusWithParams:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;
- (void)getServiceStatusOptionsWithParams:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;

#pragma mark - Get Support Email Topics

- (void)getOrderDeliveryStatusOptionsWithParams:(NSDictionary *)params SuccessBlock:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;
- (void)getOrderStatusOptionsWithParams:(NSDictionary *)params SuccessBlock:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;
- (void)getItemStatusOptionsWithParams:(NSDictionary *)params SuccessBlock:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;
- (void)getSupportEmailTopicsWithSuccessBlock:(CMPActionSuccessBlock)success failureBlock:(CMPActionfailureBlock)failure;

#pragma mark - Get Restaurant
- (void)getRestaurantWithParams:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;

#pragma mark - usersasl
- (void)registerAdhocMemberWithParams:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;

#pragma mark - Promotion Services
- (void)retrievePromotionSATiersBySASLWithParams:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;
- (void)retrievePicturesBySAWithParams:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;
- (void)getPromotionTypesWithSuccess:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;
- (void)getSessionIDforUploadPromoWithSuccess:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;
- (void)getPromotionTypeWithSuccess:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;
- (void)updateWNewPictureModifiedMetaDataWithParams:(NSDictionary *)params path:(NSString *)path imageData:(NSData *)imageData success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;
- (void)updateWRecycledPictureModifiedMetaDataWithParams:(NSDictionary *)params path:(NSString *)path success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;
- (void)updateWSamePictureModifiedMetaDataWithParams:(NSDictionary *)params path:(NSString *)path success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;
- (void)createWNewPictureNewMetaDataWithParams:(NSDictionary *)params path:(NSString *)path imageData:(NSData *)imageData  success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;
- (void)createWRecycledPictureNewMetaDataWithParams:(NSDictionary *)params path:(NSString *)path imageData:(NSData *)imageData completion:(void(^)(id response, NSError *error))completion;
- (void)getUserRoleOptionsWithParams:(NSDictionary *)params completion:(CPCompletion)completion;

- (void)uploadMultipartStreamingWithParams:(NSDictionary *)params sessionId:(NSString *)sessionId imageData:(NSData *)imageData completion:(void(^)(id response, NSError *error))completion;
- (void)createWNewPictureNewMetaDataWithParams:(NSDictionary *)params sessionId:(NSString *)sessionId imageData:(NSData *)imageData completion:(void(^)(id response, NSError *error))completion;

#pragma mark - Product Purchase

- (void) retrieveAppleStoreProductsWithPath: (NSString *)path success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;

#pragma mark - Poll Contest
- (void)retrievePoll:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;
- (void)retrievePollPortalWithPath:(NSString *)path success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;
- (void)retrievePollPortal:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;
- (void)setCorrectPollChoiceWithPath: (NSString *)path success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;
- (void)awardPollWithParams:(NSDictionary *)params path:(NSString *)path success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;

- (void)addPollPrize:(NSDictionary *)params path:(NSString *)path imageData:(NSData *)imageData success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;

- (void)addPollChoice:(NSDictionary *)params path:(NSString *)path imageData:(NSData *)imageData success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;

- (void)createPoll:(NSDictionary *)params path:(NSString *)path imageData:(NSData *)imageData success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;

- (void)createPoll:(NSDictionary *)params path:(NSString *)path imageData:(NSData *)imageData completion:(void(^)(id response, NSError *error))completion;

- (void)deletePollPrizeWithParams:(NSDictionary *)params Path:(NSString *)path completion:(CPCompletion)completion;

#pragma mark - Photo Contest
- (void)createPhotoContest:(NSDictionary *)params path:(NSString *)path imageData:(NSData *)imageData success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;
- (void)deletephotoPrize:(NSDictionary *)params Path:(NSString *)path completion:(CPCompletion)completion;

#pragma mark - CheckIn Contest
- (void)createCheckContest:(NSDictionary *)params path:(NSString *)path imageData:(NSData *)imageData success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;

#pragma mark - Retail Item
- (void)createWNewPictureURLNewMetaData:(NSDictionary *)params path:(NSString *)path imageData:(NSData *)imageData success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;

- (void)addMediaToItem:(NSDictionary *)params path:(NSString *)path imageData:(NSData *)imageData success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;

#pragma mark - Event Screen
- (void)createNewEvent:(NSDictionary *)params path:(NSString *)path imageData:(NSData *)imageData success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;


#pragma Mark - Create Post With image
- (void)CreateWallPostWithImage:(NSDictionary *)params path:(NSString *)path imageData:(NSData *)imageData success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;

#pragma mark - Appointment
- (void)retrieveStdSvcsBySASLWithParams:(NSDictionary *)params completion:(CPCompletion)completion;
- (void)retrieveStdSvcPicturesForSASLWithParams:(NSDictionary *)params completion:(CPCompletion)completion;
- (void)retrieveStdSvcsForSvcProviderSASLWithParams:(NSDictionary *)params completion:(CPCompletion)completion;
- (void)addStdSvcsToServiceProviderSASLWithParams:(NSDictionary *)params path:(NSString *)path completion:(CPCompletion)completion;
- (void)removeStdSvcsFromServiceProviderSASLWithParams:(NSDictionary *)params path:(NSString *)path completion:(CPCompletion)completion;
- (void)createStdSvcForSASLWithParams:(NSDictionary *)params path:(NSString *)path imageData:(NSData *)imageData completion:(CPCompletion)completion;
- (void)updateStdSvcWNewPictureNewMetaDataWithParams:(NSDictionary *)params path:(NSString *)path imageData:(NSData *)imageData completion:(CPCompletion)completion;
- (void)updateStdSvcWRecycledPictureNewMetaDataWithParams:(NSDictionary *)params path:(NSString *)path completion:(CPCompletion)completion;
- (void)deleteStdSvcForSASLWithParams:(NSDictionary *)params completion:(CPCompletion)completion;
- (void)deleteServiceProviderWithParams:(NSDictionary *)params completion:(CPCompletion)completion;
- (void)retrieveSvcProvidersForSASLWithParams:(NSDictionary *)params completion:(CPCompletion)completion;
- (void)createServiceProviderWNewPictureNewMetaDataWithParams:(NSDictionary *)params path:(NSString *)path imageData:(NSData *)imageData completion:(CPCompletion)completion;
- (void)retrieveServiceProvidersForStdSvcBySASLWithParams:(NSDictionary *)params completion:(CPCompletion)completion;

- (void)retrieveSASLMetaDataPortalWithParams:(NSDictionary *)params completion:(CPCompletion)completion;
- (void)updateSASLMetaDataWithParams:(NSDictionary *)params path:(NSString *)path completion:(CPCompletion)completion;
- (void)getDomainOptionsWithCompletion:(CPCompletion)completion;
- (void)getSASLSummaryByZipCodeWithParams:(NSDictionary *)params completion:(CPCompletion)completion;
- (void)isFriendlyURLAvailableWithParams:(NSDictionary *)params completion:(CPCompletion)completion;
- (void)createAndClaimOwnershipWithParams:(NSDictionary *)params path:(NSString *)path completion:(CPCompletion)completion;
- (void)cloneAndClaimOwnershipWithParams:(NSDictionary *)params path:(NSString *)path completion:(CPCompletion)completion;
- (void)retrieveSASLInfoWithParams:(NSDictionary *)params completion:(CPCompletion)completion;
- (void)updateSASLInfoWithParams:(NSDictionary *)params path:(NSString *)path completion:(CPCompletion)completion;
// Retail Items
-(void)retrieveRetailItemsWithParams:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure;
@end