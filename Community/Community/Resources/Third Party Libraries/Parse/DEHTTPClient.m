//Developed by Mykola Darkngs Golyash
//2013.08.29
//http://golyash.com

#import "AFNetworking.h"
#import "DEHTTPClient.h"
#import "NSData+Base64.h"
//#import "CTCommonMethods.h"
#import "CTCommonMethods.h"

@implementation DEHTTPClient

+ (DEHTTPClient *)sharedInstance
{
   static DEHTTPClient *sharedHTTPClient=nil;
   static dispatch_once_t predicate;
   dispatch_once(&predicate, ^{
//      if([CTCommonMethods sharedInstance].serverMainUrl == nil)
//      {
         sharedHTTPClient=[[self alloc] initWithBaseURL:[NSURL URLWithString:[CTCommonMethods getChoosenServer]]];
//      }
//      else
//      {
//         sharedHTTPClient=[[self alloc] initWithBaseURL:[NSURL URLWithString:[CTCommonMethods sharedInstance].serverMainUrl]];
//      }
   });
//    if([CTCommonMethods sharedInstance].serverMainUrl != nil)
        sharedHTTPClient.baseURL = [NSURL URLWithString:[CTCommonMethods getChoosenServer]];
    NSLog(@"sharedHTTPClient = %@",sharedHTTPClient);
   return sharedHTTPClient;
}

#pragma mark -

- (id)initWithBaseURL:(NSURL *)url {
   self = [super initWithBaseURL:url];
   
   if(self) {
      [self registerHTTPOperationClass:[AFHTTPRequestOperation class]];
      [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
      [self setParameterEncoding:AFJSONParameterEncoding];
      [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
      _defaultTimeout = 10.0;
      
      self.failureBlock = ^(NSURLRequest *request, NSError *error ) {
          [[CTCommonMethods sharedInstance]hideHUD];
         if (error.localizedRecoverySuggestion) {
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:[error.localizedRecoverySuggestion dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *dictError=dict[StringDictionaryKeyError];
            
            [[[UIAlertView alloc] initWithTitle:StringAlertTitleError message:dictError[@"message"] delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles:nil] show];
         }
         else {
            [[[UIAlertView alloc] initWithTitle:StringAlertTitleError message:error.localizedDescription delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles:nil] show];
         }
      };
   }
   return self;
}

#pragma mark -

- (void)cancelAllOperations
{
   [self.operationQueue cancelAllOperations];
}

#pragma mark -

- (NSString *)authPathWithParams:(NSDictionary *)params {
   
   if (params) {
      for(NSString *key in params) {
         NSString *desc = [NSString stringWithFormat:@"%@ can't be nil", key];
         NSAssert(params[key], desc);
      }
      
      NSString *authPath = AFQueryStringFromParametersWithEncoding(params, NSUTF8StringEncoding);
      if(authPath) {
         return [@"?" stringByAppendingString:authPath];
      }
   }
   
   return nil;
}

#pragma mark - HTTPRequest
- (void)performHTTPRequestOperationWithMethod:(NSString *)method path:(NSString *)path params:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure {
   NSMutableURLRequest *request = [self requestWithMethod:method path:path parameters:params];
   request.timeoutInterval = _defaultTimeout;
   AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
   
   [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
      success(request, responseObject);
   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      failure(request, error);
   }];
   [self enqueueHTTPRequestOperation:operation];
}

#pragma mark - JSONRequest

- (void)performJSONRequestOperationWithMethod:(NSString *)method path:(NSString *)path params:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure {
   
   NSMutableURLRequest *request = [self requestWithMethod:method path:path parameters:params];
   request.timeoutInterval = _defaultTimeout;
   AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                          success(request, JSON);
                                                                                       }
                                                                                       failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                          NSLog(@"performJSONRequestOperationWithMethod %@", error.userInfo);
                                                                                          failure(request, error);
                                                                                       }];
   [self enqueueHTTPRequestOperation:operation];
}

#pragma mark - Login Request
- (void)loginWithParams:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure {
   [self performJSONRequestOperationWithMethod:@"POST" path:@"authentication/login" params:params success:success failure:failure];
}

- (void)getUserAndCommunityWithParams:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure {
   [self performJSONRequestOperationWithMethod:@"GET" path:@"usersasl/getUserAndCommunity" params:params success:success failure:failure];
}

- (void)logoutWithParams:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure {
   [self performJSONRequestOperationWithMethod:@"GET" path:@"authentication/logout" params:params success:success failure:failure];
}

- (void)pingWithParams:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure {
   [self performJSONRequestOperationWithMethod:@"GET" path:@"liveupdate/ping" params:params success:success failure:failure];
}

- (void)getAuthenticationStatusWithParams:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure {
   [self performJSONRequestOperationWithMethod:@"GET" path:@"authentication/getAuthenticationStatus" params:params success:success failure:failure];
}

- (void)retrieveCommunicationAlertsForSASLFromCommunityWithParams:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure {
    [self performJSONRequestOperationWithMethod:@"GET" path:@"communication/retrieveCommunicationAlertsForSASLFromCommunity" params:params success:success failure:failure];
}

- (void)retrieveItemsWithParams:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure {
    [self performJSONRequestOperationWithMethod:@"GET" path:@"retail/retrieveItems" params:params success:success failure:failure];
}

#pragma mark - Business Listing

- (void)getBusinessNameWithParams:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure {
    [self performJSONRequestOperationWithMethod:@"GET" path:@"sasl/getBusinessName" params:params success:success failure:failure];
}

//- (void)setBusinessNameWithParams:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure {
//    NSString *path = [@"sasl/setBusinessName" stringByAppendingString:[self authPathWithParams:params]];
//    [self performJSONRequestOperationWithMethod:@"PUT" path:path params:params success:success failure:failure];
//}


- (void)getBusinessEmailWithParams:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure {
    [self performJSONRequestOperationWithMethod:@"GET" path:@"sasl/getBusinessEmail" params:params success:success failure:failure];
}
//businessEmail
//- (void)setBusinessEmailWithParams:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure {
//    NSString *path = [@"sasl/setBusinessEmail" stringByAppendingString:[self authPathWithParams:params]];
//    [self performJSONRequestOperationWithMethod:@"PUT" path:path params:params success:success failure:failure];
//}

- (void)getBusinessTelephoneWithParams:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure {
    [self performJSONRequestOperationWithMethod:@"GET" path:@"sasl/getBusinessTelephone" params:params success:success failure:failure];
}
//businessTelephone
//- (void)setBusinessTelephoneWithParams:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure {
//    NSString *path = [@"sasl/setBusinessTelephone" stringByAppendingString:[self authPathWithParams:params]];
//    [self performJSONRequestOperationWithMethod:@"PUT" path:path params:params success:success failure:failure];
//}

//sasl/getBusinessAddress
- (void)getBusinessAddressWithParams:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure {
    [self performJSONRequestOperationWithMethod:@"GET" path:@"sasl/getBusinessAddress" params:params success:success failure:failure];
}
/* 
"number": "818",
"street": "Cowper Street",
"street2": "Suite A",
"state": "CA",
"zip": "14301",
"city": "Palo Alto",
"country": "USA"
*/
//- (void)setBusinessAddressWithParams:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure {
//    NSString *path = [@"sasl/setBusinessAddress" stringByAppendingString:[self authPathWithParams:params]];
//    [self performJSONRequestOperationWithMethod:@"PUT" path:path params:params success:success failure:failure];
//}
#pragma mark - Orders

/* returns current status */
- (void)retrieveOrdersBySASL:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure {
    [self performJSONRequestOperationWithMethod:@"GET" path:@"retail/retrieveOrdersBySASL" params:params success:success failure:failure];
}

- (void)retrievePoll:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure {
    [self performJSONRequestOperationWithMethod:@"GET" path:@"contests/retrievePollPortal" params:params success:success failure:failure];
}

#pragma mark - Resturant status

/* returns current status */
- (void)getStatusWithParams:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure {
   [self performJSONRequestOperationWithMethod:@"GET" path:@"liveupdate/getStatus" params:params success:success failure:failure];
}

- (void)updateServiceStatusWithParams:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure {
   NSString *path = [@"liveupdate/updateServiceStatus" stringByAppendingString:[self authPathWithParams:params]];
   [self performJSONRequestOperationWithMethod:@"PUT" path:path params:params success:success failure:failure];
}

//- (void)markAsReadSASL:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure {
//    NSString *path = [@"communication/markAsReadSASL" stringByAppendingString:[self authPathWithParams:params]];
//    [self performJSONRequestOperationWithMethod:@"PUT" path:path params:params success:success failure:failure];
//}

- (void)setVisitorPasswordWithParams:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure{
     NSString *path = [@"sasl/setVisitorPassword" stringByAppendingString:[self authPathWithParams:params]];
    [self performJSONRequestOperationWithMethod:@"PUT" path:path params:params success:success failure:failure];
}


/* This returns all options available in drop down */
- (void)getServiceStatusOptionsWithParams:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure {
   [self performJSONRequestOperationWithMethod:@"GET" path:@"liveupdate/getServiceStatusOptions" params:params success:success failure:failure];
}

#pragma mark - Get Restaurant
- (void)getRestaurantWithParams:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure
{
   [self performJSONRequestOperationWithMethod:@"GET" path:@"sasl/getSASLForPortal" params:params  success:success failure:failure];
}

#pragma mark - Get Support Email Topics

- (void)getSupportEmailTopicsWithSuccessBlock:(CMPActionSuccessBlock)success failureBlock:(CMPActionfailureBlock)failure{

    [self performJSONRequestOperationWithMethod:@"GET" path:@"html/getSupportEmailTopics" params:nil success:success failure:failure];
}

- (void)getOrderDeliveryStatusOptionsWithParams:(NSDictionary *)params SuccessBlock:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure{
    [self performJSONRequestOperationWithMethod:@"GET" path:@"retail/getOrderDeliveryStatusOptions" params:params success:success failure:failure];
}
- (void)getOrderStatusOptionsWithParams:(NSDictionary *)params SuccessBlock:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure{
    [self performJSONRequestOperationWithMethod:@"GET" path:@"retail/getOrderStatusOptions" params:params success:success failure:failure];
}
- (void)getItemStatusOptionsWithParams:(NSDictionary *)params SuccessBlock:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure{
    [self performJSONRequestOperationWithMethod:@"GET" path:@"retail/getItemStatusOptions" params:params success:success failure:failure];
}

#pragma mark - usersasl/registerAdhocMember
- (void)registerAdhocMemberWithParams:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure
{
   [self performHTTPRequestOperationWithMethod:@"POST" path:@"usersasl/registerAdhocMember" params:params success:success failure:failure];
}

#pragma mark - Promotion Services
- (void)retrievePromotionSATiersBySASLWithParams:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure {
   [self performHTTPRequestOperationWithMethod:@"GET" path:@"promotions/retrievePromotionSATiersBySASL" params:params  success:success failure:failure];
}
-(void)retrieveRetailItemsWithParams:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure {
    [self performHTTPRequestOperationWithMethod:@"GET" path:RetailItems_RetrieveItems_URL params:params  success:success failure:failure];
}
- (void)retrievePicturesBySAWithParams:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure {
   [self performHTTPRequestOperationWithMethod:@"GET" path:@"promotions/retrievePicturesBySA" params:params success:success failure:failure];
}

- (void)getPromotionTypesWithSuccess:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure {
   [self performJSONRequestOperationWithMethod:@"GET" path:@"promotions/getPromotionTypes" params:nil success:success failure:failure];
}

- (void)getSessionIDforUploadPromoWithSuccess:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure {
   [self performHTTPRequestOperationWithMethod:@"POST" path:@"promotions/getSessionIDforUpload" params:nil success:success failure:failure];
}

- (void)getPromotionTypeWithSuccess:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure {
   [self performJSONRequestOperationWithMethod:@"GET" path:@"promotions/getPromotionTypes" params:nil success:success failure:failure];
}

- (void)updateWNewPictureModifiedMetaDataWithParams:(NSDictionary *)params path:(NSString *)path imageData:(NSData *)imageData success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure {
   NSMutableURLRequest *request=[self multipartFormRequestWithMethod:@"POST" path:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                 {
                                    NSData *data=[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
                                    [formData appendPartWithFormData:data name:@"promotionsaslmetadata" contentType:@"application/json"];
                                    
                                    if(imageData)
                                    {
                                       [formData appendPartWithFileData:imageData name:@"image" fileName:@"image.jpg" mimeType:@"image/jpg"];
                                    }
                                 }];
   [request setValue:@"chunked" forHTTPHeaderField:@"Content-Transfer-Encoding"];
   request.timeoutInterval = _defaultTimeout;
   AFHTTPRequestOperation *operation=[[AFHTTPRequestOperation alloc] initWithRequest:request];
   [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
       if(success)
       {
          success(request, responseObject);
       }
    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
       
       if(failure)
       {
          failure(request, error);
       }
    }];
   [self enqueueHTTPRequestOperation:operation];
}

- (void)updateWRecycledPictureModifiedMetaDataWithParams:(NSDictionary *)params path:(NSString *)path success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure
{
   [self performJSONRequestOperationWithMethod:@"POST" path:path params:params success:success failure:failure];
}

- (void)updateWSamePictureModifiedMetaDataWithParams:(NSDictionary *)params path:(NSString *)path success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure
{
   [self performJSONRequestOperationWithMethod:@"POST" path:path params:params success:success failure:failure];
}

- (void)createWNewPictureNewMetaDataWithParams:(NSDictionary *)params path:(NSString *)path imageData:(NSData *)imageData success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure
{
   NSMutableURLRequest *request=[self multipartFormRequestWithMethod:@"POST" path:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                 {
                                    NSData *data=[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
                                    [formData appendPartWithFormData:data name:@"promotionsaslmetadata" contentType:@"application/json"];
                                    
                                    if(imageData)
                                    {
                                       [formData appendPartWithFileData:imageData name:@"image" fileName:@"image.jpg" mimeType:@"image/jpeg"];
                                    }
                                 }];
   
   AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
   [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite)
    {
       float percentDone = ((float)(totalBytesWritten) / (float)(totalBytesExpectedToWrite));
       [[CTCommonMethods sharedInstance] showHUD:[NSString stringWithFormat:@"%.0f%%", (percentDone * 100)]];
    }];
   [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
      success(request, responseObject);
   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       [[CTCommonMethods sharedInstance]hideHUD];
      failure (request, error);
   }];
   
   [self enqueueHTTPRequestOperation:operation];
}

#pragma mark - Product Purchase

- (void) retrieveAppleStoreProductsWithPath: (NSString *)path success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure {
    [self performJSONRequestOperationWithMethod:@"GET" path:path params:nil success:success failure:failure];
}

#pragma mark - Poll Contest

- (void)retrievePollPortal:(NSDictionary *)params success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure {
    [self performJSONRequestOperationWithMethod:@"GET" path:@"contests/retrievePollPortal" params:params success:success failure:failure];
}

- (void)retrievePollPortalWithPath:(NSString *)path success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure {
    [self performJSONRequestOperationWithMethod:@"GET" path:path params:nil success:success failure:failure];
}

- (void)setCorrectPollChoiceWithPath: (NSString *)path success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure {
    [self performJSONRequestOperationWithMethod:@"GET" path:path params:nil success:success failure:failure];
}

- (void)awardPollWithParams:(NSDictionary *)params path:(NSString *)path success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure
{
    [self performJSONRequestOperationWithMethod:@"POST" path:path params:params success:success failure:failure];
}

- (void)addPollPrize:(NSDictionary *)params path:(NSString *)path imageData:(NSData *)imageData success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure
{
    NSMutableURLRequest *request=[self multipartFormRequestWithMethod:@"POST" path:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                  {
                                      NSData *data=[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
                                      [formData appendPartWithFormData:data name:@"pollCandidate" contentType:@"application/json"];
                                      
                                      if(imageData)
                                      {
                                          [formData appendPartWithFileData:imageData name:@"image" fileName:@"image.jpg" mimeType:@"image/jpeg"];
                                      }
                                  }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite)
     {
         float percentDone = ((float)(totalBytesWritten) / (float)(totalBytesExpectedToWrite));
         [[CTCommonMethods sharedInstance] showHUD:[NSString stringWithFormat:@"%.0f%%", (percentDone * 100)]];
     }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(request, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[CTCommonMethods sharedInstance]hideHUD];
        failure (request, error);
        NSLog(@"error=%@",error);
    }];
    
    [self enqueueHTTPRequestOperation:operation];
}

- (void)addPollChoice:(NSDictionary *)params path:(NSString *)path imageData:(NSData *)imageData success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure
{
    NSMutableURLRequest *request=[self multipartFormRequestWithMethod:@"POST" path:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                  {
                                      NSData *data=[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
                                      [formData appendPartWithFormData:data name:@"pollCandidate" contentType:@"application/json"];
                                      
                                      if(imageData)
                                      {
                                          [formData appendPartWithFileData:imageData name:@"image" fileName:@"image.jpg" mimeType:@"image/jpeg"];
                                      }
                                  }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite)
     {
         float percentDone = ((float)(totalBytesWritten) / (float)(totalBytesExpectedToWrite));
         [[CTCommonMethods sharedInstance] showHUD:[NSString stringWithFormat:@"%.0f%%", (percentDone * 100)]];
     }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(request, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[CTCommonMethods sharedInstance]hideHUD];
        failure (request, error);
        NSLog(@"error=%@",error);
    }];
    
    [self enqueueHTTPRequestOperation:operation];
}

- (void)createPoll:(NSDictionary *)params path:(NSString *)path imageData:(NSData *)imageData success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure
{
    NSMutableURLRequest *request=[self multipartFormRequestWithMethod:@"POST" path:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                  {
                                      NSData *data=[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
                                      [formData appendPartWithFormData:data name:@"pollCandidate" contentType:@"application/json"];
                                      
                                      if(imageData)
                                      {
                                          [formData appendPartWithFileData:imageData name:@"image" fileName:@"image.jpg" mimeType:@"image/jpeg"];
                                      }
                                  }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite)
     {
         float percentDone = ((float)(totalBytesWritten) / (float)(totalBytesExpectedToWrite));
         [[CTCommonMethods sharedInstance] showHUD:[NSString stringWithFormat:@"%.0f%%", (percentDone * 100)]];
     }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(request, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[CTCommonMethods sharedInstance]hideHUD];
        failure (request, error);
        NSLog(@"error=%@",error);
    }];
    
    [self enqueueHTTPRequestOperation:operation];
}

- (void)createPoll:(NSDictionary *)params path:(NSString *)path imageData:(NSData *)imageData completion:(void(^)(id response, NSError *error))completion{
    NSMutableURLRequest *request=[self multipartFormRequestWithMethod:@"POST" path:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                  {
                                      NSData *data=[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
                                      [formData appendPartWithFormData:data name:@"pollCandidate" contentType:@"application/json"];
                                      
                                      if(imageData)
                                      {
                                          [formData appendPartWithFileData:imageData name:@"image" fileName:@"image.jpg" mimeType:@"image/jpeg"];
                                      }
                                  }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite)
     {
         float percentDone = ((float)(totalBytesWritten) / (float)(totalBytesExpectedToWrite));
         [[CTCommonMethods sharedInstance] showHUD:[NSString stringWithFormat:@"%.0f%%", (percentDone * 100)]];
     }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion) {
            completion(responseObject,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[CTCommonMethods sharedInstance]hideHUD];
        if (completion) {
            completion(nil,error);
        }
        NSLog(@"error=%@",error);
    }];
    
    [self enqueueHTTPRequestOperation:operation];
}

- (void)deletePollPrizeWithParams:(NSDictionary *)params Path:(NSString *)path completion:(CPCompletion)completion
{
    NSMutableURLRequest *request=[self requestWithMethod:@"POST" path:path parameters:params];
    request.timeoutInterval=_defaultTimeout;
    AFJSONRequestOperation *operation=[[AFJSONRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if(completion)
         {
             completion(responseObject, nil);
         }
     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error occurred in attempt to deletePollPrizeWithParams %@", error);
         if(completion)
         {
             completion(nil, error);
         }
     }];
    [self enqueueHTTPRequestOperation:operation];
}
#pragma mark - Photo Contest

- (void)createPhotoContest:(NSDictionary *)params path:(NSString *)path imageData:(NSData *)imageData success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure
{
    NSMutableURLRequest *request=[self multipartFormRequestWithMethod:@"POST" path:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                  {
                                      NSData *data=[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
                                      [formData appendPartWithFormData:data name:@"photoCandidate" contentType:@"application/json"];
                                      
                                      if(imageData)
                                      {
                                          [formData appendPartWithFileData:imageData name:@"image" fileName:@"image.jpg" mimeType:@"image/jpeg"];
                                      }
                                  }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite)
     {
         float percentDone = ((float)(totalBytesWritten) / (float)(totalBytesExpectedToWrite));
         [[CTCommonMethods sharedInstance] showHUD:[NSString stringWithFormat:@"%.0f%%", (percentDone * 100)]];
     }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(request, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[CTCommonMethods sharedInstance]hideHUD];
        failure (request, error);
       
    }];
    
    [self enqueueHTTPRequestOperation:operation];
}
- (void)deletephotoPrize:(NSDictionary *)params Path:(NSString *)path completion:(CPCompletion)completion
{
    NSMutableURLRequest *request=[self requestWithMethod:@"POST" path:path parameters:params];
    request.timeoutInterval=_defaultTimeout;
    AFJSONRequestOperation *operation=[[AFJSONRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if(completion)
         {
             completion(responseObject, nil);
         }
     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Error occurred in attempt to deletephotoPrize %@", error);
         if(completion)
         {
             completion(nil, error);
         }
     }];
    [self enqueueHTTPRequestOperation:operation];
}
#pragma mark - Check Contest
- (void)createCheckContest:(NSDictionary *)params path:(NSString *)path imageData:(NSData *)imageData success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure
{
    NSMutableURLRequest *request=[self multipartFormRequestWithMethod:@"POST" path:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                  {
                                      NSData *data=[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
                                      [formData appendPartWithFormData:data name:@"CheckInCandidate" contentType:@"application/json"];
                                      
                                      if(imageData)
                                      {
                                          [formData appendPartWithFileData:imageData name:@"image" fileName:@"image.jpg" mimeType:@"image/jpeg"];
                                      }
                                  }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite)
     {
         float percentDone = ((float)(totalBytesWritten) / (float)(totalBytesExpectedToWrite));
         [[CTCommonMethods sharedInstance] showHUD:[NSString stringWithFormat:@"%.0f%%", (percentDone * 100)]];
     }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(request, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[CTCommonMethods sharedInstance]hideHUD];
        failure (request, error);
        
    }];
    
    [self enqueueHTTPRequestOperation:operation];
}

#pragma mark - Retail Item
- (void)createWNewPictureURLNewMetaData:(NSDictionary *)params path:(NSString *)path imageData:(NSData *)imageData success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure
{
    NSMutableURLRequest *request=[self multipartFormRequestWithMethod:@"POST" path:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                  {
                                      NSData *data=[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
                                      [formData appendPartWithFormData:data name:@"retailItemCandidate" contentType:@"application/json"];
                                      
                                      if(imageData)
                                      {
                                          [formData appendPartWithFileData:imageData name:@"image" fileName:@"image.jpg" mimeType:@"image/jpeg"];
                                      }
                                  }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite)
     {
         float percentDone = ((float)(totalBytesWritten) / (float)(totalBytesExpectedToWrite));
         [[CTCommonMethods sharedInstance] showHUD:[NSString stringWithFormat:@"%.0f%%", (percentDone * 100)]];
     }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(request, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[CTCommonMethods sharedInstance]hideHUD];
        failure (request, error);
        NSLog(@"error=%@",error);
    }];
    
    [self enqueueHTTPRequestOperation:operation];
}
- (void)addMediaToItem:(NSDictionary *)params path:(NSString *)path imageData:(NSData *)imageData success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure
{
    NSMutableURLRequest *request=[self multipartFormRequestWithMethod:@"POST" path:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                  {
                                      NSData *data=[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
                                      [formData appendPartWithFormData:data name:@"retailItemCandidate" contentType:@"application/json"];
                                      
                                      if(imageData)
                                      {
                                          [formData appendPartWithFileData:imageData name:@"image" fileName:@"image.jpg" mimeType:@"image/jpeg"];
                                      }
                                  }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite)
     {
         float percentDone = ((float)(totalBytesWritten) / (float)(totalBytesExpectedToWrite));
         [[CTCommonMethods sharedInstance] showHUD:[NSString stringWithFormat:@"%.0f%%", (percentDone * 100)]];
     }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(request, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[CTCommonMethods sharedInstance]hideHUD];
        failure (request, error);
        NSLog(@"errorin Update=%@",error);
    }];
    
    [self enqueueHTTPRequestOperation:operation];
}

#pragma mark - Event Screen
- (void)createNewEvent:(NSDictionary *)params path:(NSString *)path imageData:(NSData *)imageData success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure
{
    NSMutableURLRequest *request=[self multipartFormRequestWithMethod:@"POST" path:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                  {
                                      NSData *data=[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
                                      [formData appendPartWithFormData:data name:@"photoCandidate" contentType:@"application/json"];
                                      
                                      if(imageData)
                                      {
                                          [formData appendPartWithFileData:imageData name:@"image" fileName:@"image.jpg" mimeType:@"image/jpeg"];
                                      }
                                  }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite)
     {
         float percentDone = ((float)(totalBytesWritten) / (float)(totalBytesExpectedToWrite));
         [[CTCommonMethods sharedInstance] showHUD:[NSString stringWithFormat:@"%.0f%%", (percentDone * 100)]];
     }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(request, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[CTCommonMethods sharedInstance]hideHUD];
        failure (request, error);
        
    }];
    
    [self enqueueHTTPRequestOperation:operation];
}

#pragma mark - WallPost
- (void)CreateWallPostWithImage:(NSDictionary *)params path:(NSString *)path imageData:(NSData *)imageData success:(CMPActionSuccessBlock)success failure:(CMPActionfailureBlock)failure
{
    NSMutableURLRequest *request=[self multipartFormRequestWithMethod:@"POST" path:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                  {
                                      NSData *data=[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
                                      [formData appendPartWithFormData:data name:@"postFromSASL" contentType:@"application/json"];
                                      
                                      if(imageData)
                                      {
                                          [formData appendPartWithFileData:imageData name:@"image" fileName:@"image.jpg" mimeType:@"image/jpeg"];
                                      }
                                  }];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite)
     {
         float percentDone = ((float)(totalBytesWritten) / (float)(totalBytesExpectedToWrite));
         [[CTCommonMethods sharedInstance] showHUD:[NSString stringWithFormat:@"%.0f%%", (percentDone * 100)]];
     }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(request, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[CTCommonMethods sharedInstance]hideHUD];
        failure (request, error);
        NSLog(@"error=%@",error);
    }];
    
    [self enqueueHTTPRequestOperation:operation];
}
//---------End Wall Post
#pragma mark -
- (void)createWRecycledPictureNewMetaDataWithParams:(NSDictionary *)params path:(NSString *)path imageData:(NSData *)imageData completion:(void (^)(id, NSError *))completion
{
   NSMutableURLRequest *request=[self requestWithMethod:@"POST" path:path parameters:params];
   request.timeoutInterval=_defaultTimeout;
   AFJSONRequestOperation *operation=[[AFJSONRequestOperation alloc] initWithRequest:request];
   [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
       if(completion)
       {
          completion(responseObject, nil);
       }
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
       NSLog(@"Error occurred in attempt to promotions/createWRecycledPictureNewMetaData. %@", error);
       if(completion)
       {
          completion(nil, error);
       }
    }];
   [self enqueueHTTPRequestOperation:operation];
}

- (void)getUserRoleOptionsWithParams:(NSDictionary *)params completion:(CPCompletion)completion
{
   NSMutableURLRequest *request=[self requestWithMethod:@"GET" path:@"usersasl/getUserRoleOptions" parameters:params];
   request.timeoutInterval=_defaultTimeout;
   AFJSONRequestOperation *operation=[[AFJSONRequestOperation alloc] initWithRequest:request];
   [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
       if(completion)
       {
          completion(responseObject, nil);
       }
    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
       NSLog(@"Error occurred in attempt to usersasl/getUserRoleOptions. %@", error);
       if(completion)
       {
          completion(nil, error);
       }
    }];
   [self enqueueHTTPRequestOperation:operation];
}

- (void)uploadMultipartStreamingWithParams:(NSDictionary *)params sessionId:(NSString *)sessionId imageData:(NSData *)imageData completion:(void (^)(id, NSError *))completion
{
   NSMutableURLRequest *request=[self multipartFormRequestWithMethod:@"POST" path:[NSString stringWithFormat:@"media/uploadMultipartStreaming?sessionId=%@", sessionId] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                 {
                                    NSData *data=[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
                                    [formData appendPartWithFormData:data name:@"mediametadata" contentType:@"application/json"];
                                    
                                    if(imageData)
                                    {
                                       [formData appendPartWithFileData:imageData name:@"image" fileName:@"image.jpg" mimeType:@"image/jpg"];
                                    }
                                 }];
   AFHTTPRequestOperation *operation=[[AFHTTPRequestOperation alloc] initWithRequest:request];
   [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
       if(completion)
       {
          completion(responseObject, nil);
       }
    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
       NSLog(@"Error occurred in attempt to media/uploadMultipartStreaming. %@", error);
       if(completion)
       {
          completion(nil, error);
       }
    }];
   [self enqueueHTTPRequestOperation:operation];
}

- (void)createWNewPictureNewMetaDataWithParams:(NSDictionary *)params sessionId:(NSString *)sessionId imageData:(NSData *)imageData completion:(void (^)(id, NSError *))completion
{
   NSMutableURLRequest *request=[self multipartFormRequestWithMethod:@"POST" path:[NSString stringWithFormat:@"media/createWNewPictureNewMetaData?sessionId=%@&UID=%@", sessionId, _uid] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                 {
                                    NSData *data=[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
                                    [formData appendPartWithFormData:data name:@"mediametadata" contentType:@"application/json"];
                                    
                                    if(imageData)
                                    {
                                       [formData appendPartWithFileData:imageData name:@"image" fileName:@"image.jpg" mimeType:@"image/jpg"];
                                    }
                                 }];
   AFHTTPRequestOperation *operation=[[AFHTTPRequestOperation alloc] initWithRequest:request];
   
   [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite)
   {
      float percentDone = ((float)(totalBytesWritten) / (float)(totalBytesExpectedToWrite));
      [[CTCommonMethods sharedInstance] showHUD:[NSString stringWithFormat:@"%.0f%%", (percentDone * 100)]];
   }];
   
   [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
       if(completion)
       {
          completion(responseObject, nil);
       }
    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
       NSLog(@"Error occurred in attempt to media/createWNewPictureNewMetaData. %@", error);
       if(completion)
       {
          completion(nil, error);
       }
    }];
   [self enqueueHTTPRequestOperation:operation];
}

- (void)retrieveStdSvcsBySASLWithParams:(NSDictionary *)params completion:(CPCompletion)completion
{
   NSMutableURLRequest *request=[self requestWithMethod:@"GET" path:@"appointments/retrieveStdSvcsBySASL" parameters:params];
   request.timeoutInterval=_defaultTimeout;
   AFHTTPRequestOperation *operation=[[AFHTTPRequestOperation alloc] initWithRequest:request];
   [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
       if(completion)
       {
          completion(responseObject, nil);
       }
    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
       NSLog(@"Error occurred in attempt to appointments/retrieveStdSvcsBySASL. %@", error);
       if(completion)
       {
          completion(nil, error);
       }
    }];
   [self enqueueHTTPRequestOperation:operation];
}

- (void)retrieveStdSvcPicturesForSASLWithParams:(NSDictionary *)params completion:(CPCompletion)completion
{
   NSMutableURLRequest *request=[self requestWithMethod:@"GET" path:@"appointments/retrieveStdSvcPicturesForSASL" parameters:params];
   request.timeoutInterval=_defaultTimeout;
   AFHTTPRequestOperation *operation=[[AFHTTPRequestOperation alloc] initWithRequest:request];
   [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
       if(completion)
       {
          completion(responseObject, nil);
       }
    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
       NSLog(@"Error occurred in attempt to appointments/retrieveStdSvcPicturesForSASL. %@", error);
       if(completion)
       {
          completion(nil, error);
       }
    }];
   [self enqueueHTTPRequestOperation:operation];
}

- (void)retrieveStdSvcsForSvcProviderSASLWithParams:(NSDictionary *)params completion:(CPCompletion)completion
{
   NSMutableURLRequest *request=[self requestWithMethod:@"GET" path:@"appointments/retrieveStdSvcsForSvcProviderSASL" parameters:params];
   request.timeoutInterval=_defaultTimeout;
   AFHTTPRequestOperation *operation=[[AFHTTPRequestOperation alloc] initWithRequest:request];
   [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
       if(completion)
       {
          completion(responseObject, nil);
       }
    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
       NSLog(@"Error occurred in attempt to appointments/retrieveStdSvcsForSvcProviderSASL. %@", error);
       if(completion)
       {
          completion(nil, error);
       }
    }];
   [self enqueueHTTPRequestOperation:operation];
}

- (void)addStdSvcsToServiceProviderSASLWithParams:(NSDictionary *)params path:(NSString *)path completion:(CPCompletion)completion
{
   NSMutableURLRequest *request=[self requestWithMethod:@"POST" path:path parameters:params];
   request.timeoutInterval=_defaultTimeout;
   AFHTTPRequestOperation *operation=[[AFHTTPRequestOperation alloc] initWithRequest:request];
   [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
       if(completion)
       {
          completion(responseObject, nil);
       }
    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
       NSLog(@"Error occurred in attempt to appointments/addStdSvcsToServiceProviderSASL. %@", error);
       if(completion)
       {
          completion(nil, error);
       }
    }];
   [self enqueueHTTPRequestOperation:operation];
}

- (void)removeStdSvcsFromServiceProviderSASLWithParams:(NSDictionary *)params path:(NSString *)path completion:(CPCompletion)completion
{
   NSMutableURLRequest *request=[self requestWithMethod:@"PUT" path:path parameters:params];
   request.timeoutInterval=_defaultTimeout;
   AFHTTPRequestOperation *operation=[[AFHTTPRequestOperation alloc] initWithRequest:request];
   [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
       if(completion)
       {
          completion(responseObject, nil);
       }
    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
       NSLog(@"Error occurred in attempt to appointments/removeStdSvcsFromServiceProviderSASL. %@", error);
       if(completion)
       {
          completion(nil, error);
       }
    }];
   [self enqueueHTTPRequestOperation:operation];
}

- (void)createStdSvcForSASLWithParams:(NSDictionary *)params path:(NSString *)path imageData:(NSData *)imageData completion:(CPCompletion)completion
{
   NSMutableURLRequest *request=[self multipartFormRequestWithMethod:@"POST" path:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                 {
                                    NSData *data=[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
                                    [formData appendPartWithFormData:data name:@"servicemetadata" contentType:@"application/json"];
                                    
                                    if(imageData)
                                    {
                                       [formData appendPartWithFileData:imageData name:@"image" fileName:@"image.jpg" mimeType:@"image/jpg"];
                                    }
                                 }];
   request.timeoutInterval=_defaultTimeout;
   [request setValue:@"chunked" forHTTPHeaderField:@"Content-Transfer-Encoding"];
   AFHTTPRequestOperation *operation=[[AFHTTPRequestOperation alloc] initWithRequest:request];
   [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite)
    {
       CGFloat percentDone=((CGFloat)(totalBytesWritten)/(CGFloat)(totalBytesExpectedToWrite));
       [[CTCommonMethods sharedInstance] showHUD:[NSString stringWithFormat:@"%.0f%%", (percentDone*100)]];
    }];
   [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
       if(completion)
       {
          completion(responseObject, nil);
       }
    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
       NSLog(@"Error occurred in attempt to appointments/createStdSvcForSASL. %@", error);
       if(completion)
       {
          completion(nil, error);
       }
    }];
   
   [self enqueueHTTPRequestOperation:operation];
}

- (void)updateStdSvcWNewPictureNewMetaDataWithParams:(NSDictionary *)params path:(NSString *)path imageData:(NSData *)imageData completion:(CPCompletion)completion
{
   NSMutableURLRequest *request=[self multipartFormRequestWithMethod:@"POST" path:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                 {
                                    NSData *data=[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
                                    [formData appendPartWithFormData:data name:@"servicemetadata" contentType:@"application/json"];
                                    
                                    if(imageData)
                                    {
                                       [formData appendPartWithFileData:imageData name:@"image" fileName:@"image.jpg" mimeType:@"image/jpg"];
                                    }
                                 }];
   request.timeoutInterval=_defaultTimeout;
   [request setValue:@"chunked" forHTTPHeaderField:@"Content-Transfer-Encoding"];
   AFHTTPRequestOperation *operation=[[AFHTTPRequestOperation alloc] initWithRequest:request];
   [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite)
    {
       CGFloat percentDone=((CGFloat)(totalBytesWritten)/(CGFloat)(totalBytesExpectedToWrite));
       [[CTCommonMethods sharedInstance] showHUD:[NSString stringWithFormat:@"%.0f%%", (percentDone*100)]];
    }];
   [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
       if(completion)
       {
          completion(responseObject, nil);
       }
    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
       NSLog(@"Error occurred in attempt to appointments/updateStdSvcWNewPictureNewMetaData. %@", error);
       if(completion)
       {
          completion(nil, error);
       }
    }];
   
   [self enqueueHTTPRequestOperation:operation];
}

- (void)updateStdSvcWRecycledPictureNewMetaDataWithParams:(NSDictionary *)params path:(NSString *)path completion:(CPCompletion)completion
{
   NSMutableURLRequest *request=[self requestWithMethod:@"POST" path:path parameters:params];
   request.timeoutInterval=_defaultTimeout;
   AFJSONRequestOperation *operation=[[AFJSONRequestOperation alloc] initWithRequest:request];
   [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
       if(completion)
       {
          completion(responseObject, nil);
       }
    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
       NSLog(@"Error occurred in attempt to appointments/updateStdSvcWRecycledPictureNewMetaData. %@", error);
       if(completion)
       {
          completion(nil, error);
       }
    }];
   [self enqueueHTTPRequestOperation:operation];
}

- (void)deleteStdSvcForSASLWithParams:(NSDictionary *)params completion:(CPCompletion)completion
{
   NSMutableURLRequest *request=[self requestWithMethod:@"GET" path:@"appointments/deleteStdSvcForSASL" parameters:params];
   request.timeoutInterval=_defaultTimeout;
   AFJSONRequestOperation *operation=[[AFJSONRequestOperation alloc] initWithRequest:request];
   [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
       if(completion)
       {
          completion(responseObject, nil);
       }
    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
       NSLog(@"Error occurred in attempt to appointments/deleteStdSvcForSASL. %@", error);
       if(completion)
       {
          completion(nil, error);
       }
    }];
   [self enqueueHTTPRequestOperation:operation];
}

- (void)deleteServiceProviderWithParams:(NSDictionary *)params completion:(CPCompletion)completion
{
   NSMutableURLRequest *request=[self requestWithMethod:@"GET" path:@"appointments/deleteServiceProvider" parameters:params];
   request.timeoutInterval=_defaultTimeout;
   AFJSONRequestOperation *operation=[[AFJSONRequestOperation alloc] initWithRequest:request];
   [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
       if(completion)
       {
          completion(responseObject, nil);
       }
    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
       NSLog(@"Error occurred in attempt to appointments/deleteServiceProvider. %@", error);
       if(completion)
       {
          completion(nil, error);
       }
    }];
   [self enqueueHTTPRequestOperation:operation];
}

- (void)retrieveSvcProvidersForSASLWithParams:(NSDictionary *)params completion:(CPCompletion)completion
{
   NSMutableURLRequest *request=[self requestWithMethod:@"GET" path:@"appointments/retrieveSvcProvidersForSASL" parameters:params];
   request.timeoutInterval=_defaultTimeout;
   AFHTTPRequestOperation *operation=[[AFHTTPRequestOperation alloc] initWithRequest:request];
   [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
       if(completion)
       {
          completion(responseObject, nil);
       }
    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
       NSLog(@"Error occurred in attempt to appointments/retrieveSvcProvidersForSASL. %@", error);
       if(completion)
       {
          completion(nil, error);
       }
    }];
   [self enqueueHTTPRequestOperation:operation];
}

- (void)createServiceProviderWNewPictureNewMetaDataWithParams:(NSDictionary *)params path:(NSString *)path imageData:(NSData *)imageData completion:(CPCompletion)completion
{
   NSMutableURLRequest *request=[self multipartFormRequestWithMethod:@"POST" path:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                 {
                                    NSData *data=[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
                                    [formData appendPartWithFormData:data name:@"serviceprovidermetadata" contentType:@"application/json"];
                                    
                                    if(imageData)
                                    {
                                       [formData appendPartWithFileData:imageData name:@"image" fileName:@"image.jpg" mimeType:@"image/jpg"];
                                    }
                                 }];
   request.timeoutInterval=_defaultTimeout;
   [request setValue:@"chunked" forHTTPHeaderField:@"Content-Transfer-Encoding"];
   AFHTTPRequestOperation *operation=[[AFHTTPRequestOperation alloc] initWithRequest:request];
   [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite)
    {
       CGFloat percentDone=((CGFloat)(totalBytesWritten)/(CGFloat)(totalBytesExpectedToWrite));
       [[CTCommonMethods sharedInstance] showHUD:[NSString stringWithFormat:@"%.0f%%", (percentDone*100)]];
    }];
   [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
       if(completion)
       {
          completion(responseObject, nil);
       }
    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
       NSLog(@"Error occurred in attempt to appointments/createServiceProviderWNewPictureNewMetaData. %@", error);
       if(completion)
       {
          completion(nil, error);
       }
    }];
   
   [self enqueueHTTPRequestOperation:operation];
}

- (void)retrieveServiceProvidersForStdSvcBySASLWithParams:(NSDictionary *)params completion:(CPCompletion)completion
{
   NSMutableURLRequest *request=[self requestWithMethod:@"GET" path:@"appointments/retrieveServiceProvidersForStdSvcBySASL" parameters:params];
   request.timeoutInterval=_defaultTimeout;
   AFHTTPRequestOperation *operation=[[AFHTTPRequestOperation alloc] initWithRequest:request];
   [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
       if(completion)
       {
          completion(responseObject, nil);
       }
    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
       NSLog(@"Error occurred in attempt to appointments/retrieveServiceProvidersForStdSvcBySASL. %@", error);
       if(completion)
       {
          completion(nil, error);
       }
    }];
   [self enqueueHTTPRequestOperation:operation];
}

- (void)retrieveSASLMetaDataPortalWithParams:(NSDictionary *)params completion:(CPCompletion)completion
{
   NSMutableURLRequest *request=[self requestWithMethod:@"GET" path:@"sasl/retrieveSASLMetaDataPortal" parameters:params];
   request.timeoutInterval=_defaultTimeout;
   AFJSONRequestOperation *operation=[[AFJSONRequestOperation alloc] initWithRequest:request];
   [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
       if(completion)
       {
          completion(responseObject, nil);
       }
    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
       NSLog(@"Error occurred in attempt to sasl/retrieveSASLMetaDataPortal. %@", error);
       if(completion)
       {
          completion(nil, error);
       }
    }];
   [self enqueueHTTPRequestOperation:operation];
}

- (void)updateSASLMetaDataWithParams:(NSDictionary *)params path:(NSString *)path completion:(CPCompletion)completion
{
   NSMutableURLRequest *request=[self requestWithMethod:@"PUT" path:path parameters:params];
   request.timeoutInterval=_defaultTimeout;
   AFJSONRequestOperation *operation=[[AFJSONRequestOperation alloc] initWithRequest:request];
   [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
       if(completion)
       {
          completion(responseObject, nil);
       }
    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
       NSLog(@"Error occurred in attempt to sasl/updateSASLMetaData. %@", error);
       if(completion)
       {
          completion(nil, error);
       }
    }];
   [self enqueueHTTPRequestOperation:operation];
}

- (void)getDomainOptionsWithCompletion:(CPCompletion)completion
{
   NSMutableURLRequest *request=[self requestWithMethod:@"GET" path:@"billing/getAvailableDomains" parameters:nil];
   request.timeoutInterval=_defaultTimeout;
   AFJSONRequestOperation *operation=[[AFJSONRequestOperation alloc] initWithRequest:request];
   [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
       if(completion)
       {
          completion(responseObject, nil);
       }
    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
       NSLog(@"Error occurred in attempt to sasl/getDomainOptions. %@", error);
       if(completion)
       {
          completion(nil, error);
       }
    }];
   [self enqueueHTTPRequestOperation:operation];
}

- (void)getSASLSummaryByZipCodeWithParams:(NSDictionary *)params completion:(CPCompletion)completion
{
   NSMutableURLRequest *request=[self requestWithMethod:@"GET" path:@"sasl/getSASLSummaryByZipCode" parameters:params];
   request.timeoutInterval=_defaultTimeout;
   AFJSONRequestOperation *operation=[[AFJSONRequestOperation alloc] initWithRequest:request];
   [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
       if(completion)
       {
          completion(responseObject, nil);
       }
    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
       NSLog(@"Error occurred in attempt to sasl/getSASLSummaryByZipCode. %@", error);
       if(completion)
       {
          completion(nil, error);
       }
    }];
   [self enqueueHTTPRequestOperation:operation];
}

- (void)isFriendlyURLAvailableWithParams:(NSDictionary *)params completion:(CPCompletion)completion
{
   NSMutableURLRequest *request=[self requestWithMethod:@"GET" path:@"sasl/isFriendlyURLAvailable" parameters:params];
   request.timeoutInterval=_defaultTimeout;
   AFJSONRequestOperation *operation=[[AFJSONRequestOperation alloc] initWithRequest:request];
   [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
       if(completion)
       {
          completion(responseObject, nil);
       }
    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
       NSLog(@"Error occurred in attempt to sasl/isFriendlyURLAvailable. %@", error);
       if(completion)
       {
          completion(nil, error);
       }
    }];
   [self enqueueHTTPRequestOperation:operation];
}

- (void)createAndClaimOwnershipWithParams:(NSDictionary *)params path:(NSString *)path completion:(CPCompletion)completion
{
   NSMutableURLRequest *request=[self requestWithMethod:@"POST" path:path parameters:params];
   request.timeoutInterval=_defaultTimeout;
   AFJSONRequestOperation *operation=[[AFJSONRequestOperation alloc] initWithRequest:request];
   [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
       if(completion)
       {
          completion(responseObject, nil);
       }
    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
       NSLog(@"Error occurred in attempt to sasl/createAndClaimOwnership. %@", error);
       if(completion)
       {
          completion(nil, error);
       }
    }];
   [self enqueueHTTPRequestOperation:operation];
}

- (void)cloneAndClaimOwnershipWithParams:(NSDictionary *)params path:(NSString *)path completion:(CPCompletion)completion
{
   NSMutableURLRequest *request=[self requestWithMethod:@"POST" path:path parameters:params];
   request.timeoutInterval=_defaultTimeout;
   AFJSONRequestOperation *operation=[[AFJSONRequestOperation alloc] initWithRequest:request];
   [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
       if(completion)
       {
          completion(responseObject, nil);
       }
    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
       NSLog(@"Error occurred in attempt to sasl/cloneAndClaimOwnership. %@", error);
       if(completion)
       {
          completion(nil, error);
       }
    }];
   [self enqueueHTTPRequestOperation:operation];
}

- (void)retrieveSASLInfoWithParams:(NSDictionary *)params completion:(CPCompletion)completion
{
   NSMutableURLRequest *request=[self requestWithMethod:@"GET" path:@"sasl/retrieveSASLInfo" parameters:params];
   request.timeoutInterval=_defaultTimeout;
   AFJSONRequestOperation *operation=[[AFJSONRequestOperation alloc] initWithRequest:request];
   [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
       if(completion)
       {
          completion(responseObject, nil);
       }
    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
       NSLog(@"Error occurred in attempt to sasl/retrieveSASLInfo. %@", error);
       if(completion)
       {
          completion(nil, error);
       }
    }];
   [self enqueueHTTPRequestOperation:operation];
}

- (void)updateSASLInfoWithParams:(NSDictionary *)params path:(NSString *)path completion:(CPCompletion)completion
{
   NSMutableURLRequest *request=[self requestWithMethod:@"POST" path:path parameters:params];
   request.timeoutInterval=_defaultTimeout;
   AFJSONRequestOperation *operation=[[AFJSONRequestOperation alloc] initWithRequest:request];
   [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
       if(completion)
       {
          completion(responseObject, nil);
       }
    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
       NSLog(@"Error occurred in attempt to sasl/updateSASLInfo. %@", error);
       if(completion)
       {
          completion(nil, error);
       }
    }];
   [self enqueueHTTPRequestOperation:operation];
}

@end