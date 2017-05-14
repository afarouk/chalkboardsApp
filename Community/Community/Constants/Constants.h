//
//  Constants.h
//  Community
//
//  Created by dinesh on 19/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//


#define isIOS7 (floor(NSFoundationVersionNumber)>NSFoundationVersionNumber_iOS_6_1)

#define DEBUGGING YES    //or YES
#define NSLog if(DEBUGGING)NSLog

#define CT_AlertTitle @"Community"
#define CT_AlertPassTitle @"Warning!"
#define CT_DefaultAlertMessage @"Could not connect to server"
#define CT_ErrorMessage_ForGetSASLSummaryByUIDAndLocation @"Failed to get business. Please choose other server in app settings and try it again"
#define CT_LocationDisabledTitle @"Location Services Disabled"
#define CT_LocationDisbaledMessage @"Community needs to use your location information for showing you what is nearby. We do not retail your location information and use it only for filtering results. You can enter a zip code or scroll the map manually"
#define CT_ServerNotAccessibleTitle @"Unable to access server"
#define CT_ServerNotAccessibleMessage @"Unable to access server, would you like to try again?"

#define CT_LoginToAccessThisFeature_Title @"Feature requires login"
#define CT_LoginToAccessThisFeature_Message @"Please login to access this feature"

#define ShowAlertWithTitleAndMessage(title,msg) [[[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles:nil, nil] show]

#define ShowAlertWithTitle(title) [[[UIAlertView alloc] initWithTitle:title message:@"" delegate:nil cancelButtonTitle:StringAlertButtonOK otherButtonTitles:nil, nil] show]

#define StringAlertTitleWarning             @"Warning!"
#define StringAlertTitleRequestFailed       @"Request failed."
#define StringAlertMsg160CharOnly           @"You can enter only 160 characters."
#define StringAlertMsgEnterMsg              @"Please enter your message."
#define StringAlertTitleAlertCreated        @"Breaking News has been successfully created"
#define StringAlertTitleCampaignCreated     @"Campaign has been successfully created"

//#define StringAlertTitleBusiness            @"Business account created successfully"
//#define StringAlertTitleBusinessCreated     @"Please Login to create Promotions/Deals, Events, Breaking News"

#define StringAlertTitleBusiness            @"Please Login with your email/password to create"
#define StringAlertTitleBusinessCreated     @"Promotions/Deals, \nEvents, \nBreaking News"

#define StringAlertButtonCancel             @"Cancel"
#define StringAlertButtonCall               @"Call"
#define StringAlertButtonOK                 @"OK"
#define StringAlertTitleInvalidPhoneNo      @"Invalid telephone number."
#define StringAlertMsgReqValidPhoneNo       @"Please provide a valid telephone number and try again."
#define StringAlertMsgReqValidBusinessName       @"Please provide a Business name."
#define StringAlertTitleInvalidMailId       @"Invalid e-mail"
#define StringAlertMsgValidMailId           @"Please provide a valid email id and try again"
#define StringAlertTitleError               @"Error"
#define StringAlertButtonDone               @"Done"
#define StringDictionaryKeyError            @"error"
#define StringAlertTitleNoBusinessImage         @"There are no businesses to manage."
#define StringAlertTitlePleaseAddPicture        @"Please add a picture."
#define StringAlertTitlePollCreated         @"Poll created."
#define StringAlertTitlePromotionCreated         @"Promotion created."
#define StringAlertTitlePromotionActivated         @"Promotion Activated."
#define StringAlertTitlePromotionDeactivated         @"Promotion Deactivated."
#define StringAlertTitleEventActivated         @"Event Activated."
#define StringAlertTitleEventDeactivated         @"Event Deactivated."
#define StringAlertTitlePollActivated         @"Poll Activated."
#define StringAlertMsgAddPhoto              @"Please add a photo"
#define StringAlertMessageExpDateReq            @"Please select the expiration date."
#define StringAlertMessageActDateReq            @"Please select the activation date."
#define StringAlertMessageBothDateReq           @"Please select activation and expiration dates."
#define StringAlertTitleNoImage                 @"No image selected"
#define StringAlertMsgSelectImage               @"Please select an image from the library or take picture with the camera and try again."
#define StringAlertContestDate              @"Expiration date must be after activation date."
#define StringAlertButtonCreateContest          @"Create a poll without a picture."

#define StringLearnMore @"http://chalkboards.today/portalexpress"

#define CT_AlertTagServerNotAccessible 2
#define CT_AlertTagLocationServicesDisabled 3
#define CT_AlertTagDefaultLocationWillBeUsed 4
#define iPHONE_3GS @"iPhone3GS"
#define iPHONE4_4S @"iPHONE4_4S"
#define iPHONE5 @"iPhone5"

#define CT_Observers_FilterDomain @"FilterByDomain"
#define CT_Observers_FilterCategory @"FilterByCategory"
#define CT_Observers_SearchLocation @"searchForSelectedLocation"
#define CT_Observers_LoginBackAction @"slideInMainMenu"
#define CT_Observers_SuccessfullyLogedIn @"LoggedInSuccessfully"
#define CT_Observers_SuccessfullyLogedOut @"LoggedoutSuccessfully"
#define RetailItems_RetrieveItems_URL       @"retail/retrieveItems"
#define CT_Observers_RestaurantListData @"restaurantListData"
#define CT_Observers_MarkerImageDownloaded @"MarkerIconDownloaded"
#define CT_Observers_SignupCloseAction @"signupcloseAction"
#define CT_Observer_NetworkStatus @"reachability"
#define CT_Observer_ReservationList @"reservationList"
#define CT_Observer_MessageControllerIsOpen @"messageControllerIsOpen"
#define CT_Observers_RestaurantMenu @"RestaurantMenu"
#define CT_Observers_getSASL @"getSASL"


#define CT_Server [[NSUserDefaults standardUserDefaults]objectForKey:@"server"]
//Notification
#define NotificationReloadPollContests @"reloadPollContests"

#define CT_BusinessSignup_URL @"billing/getAvailableDomains"
#define CT_Business_Post @"billing/purchaseSASLandSignupLiveOffers"

#define CT_DemoServer @"simfel.com"
#define CT_ProdServer @"communitylive.ws"
#define CT_Localhost  @"localhost:8080"
#define CT_No_Server_Choosen @"none"
//#define CT_UID @"UID"
#define CT_Latitude @"latitude"
#define CT_Longitude @"longitude"
#define CT_URLKey @"urlKey"

#define CT_DemoServer_BaseURL   @"https://simfel.com/apptsvc/rest/"
//#define CT_DemoServer_BaseURL   @"https://communitylive.ws/apptsvc/rest/"
#define CT_ProdServer_BaseURL   @"https://communitylive.ws/apptsvc/rest/"
//#define CT_ProdServer_BaseURL   @"https://simfel.com/apptsvc/rest/"
#define CT_Localhost_BaseURL    @"http://localhost:8080/apptsvc/rest/"

#define CT_WebView_ShareFacebookPicture @"https://simfel.com/apptsvc/rest/promotions/retrievePromotionPictureByPromoUUID"

#define CT_WebView_ShareEmailURL @"html/sendPromoURLToEmail"
#define CT_WebView_ShareEventEmailURL @"html/sendEventURLToEmail"
#define CT_WebVire_ShareNotificationEmailURL @"html/sendNotificationURLToEmail"
#define CT_WebVire_ShareCampaignEmailURL @"html/sendCampaignURLToEmail"

#define CT_WebVire_ShareSMSURL   @"html/sendPromoURLToMobileviaSMS"
#define CT_WebVire_ShreEventSMSURL @"html/sendEventURLToMobileviaSMS"
#define CT_WebVire_ShareNotificationSMSURL @"html/sendNotificationURLToMobileviaSMS"
#define CT_WebVire_ShareCampaignSMSURL @"html/sendCampaignURLToMobileviaSMS"

#define CT_DemoHTTPServer_BaseURL   @"https://chalkboards.today/"
#define CT_ProdHTTPServer_BaseURL   @"https://chalkboardstoday.com/"


#define CT_DemoHTMLServer @"https://appointment-service.com/?serviceAccommodatorId=%@&serviceLocationId=%@&embedded=true&demo=true"
//#define CT_ProdHTMLServer @"http://sitelette.com/?serviceAccommodatorId=%@&serviceLocationId=%@&embedded=true"
#define CT_ProdHTMLServer @"https://appointment-service.com/?serviceAccommodatorId=%@&serviceLocationId=%@&embedded=true&demo=true"
#define CT_GetUserCommunity @"usersasl/getUserAndCommunity?"
#define CT_Send_Notification       @"communication/sendNotification?UID=%@"

#define CT_CreateOwnerFromInvitation @"authentication/createOwnerFromInvitation"
//Event
#define CT_EventTypeAPI_URL @"reservations/getEventTypes"
#define CT_EventSummaryAPI_URL @"reservations/retrieveEventSummary"

#define CT_CreateEventAPI_URL @"reservations/createSASLEventNewPictureNewMetaData"
//Poll Content
#define CT_CreatePollAPI_URL @"contests/createPoll"
#define CT_CreatePollPrizeAPI_URL @"contests/addPollPrize"
#define CT_RetrivePollAPI_URL @"contests/retrievePollPortal"
#define CT_CreatePollAnswerAPI_URL @"contests/addPollChoice"
#define CT_ActivePollAPI_URL @"contests/activatePoll?serviceAccommodatorId=%@&serviceLocationId=%@&UID=%@&contestUUID=%@&activate=%@"
#define CT_RemovePollPrize_URL @"contests/deletePollContestPrize?serviceAccommodatorId=%@&serviceLocationId=%@&UID=%@&contestUUID=%@&contestPrizeId=%@"
#define CT_RemovePollAnswer_URL @"contests/removePollChoice?UID=%@&contestUUID=%@&choiceId=%@"
//Event Content
#define CT_ActivateEventAPI_URL @"reservations/activateEvent"
#define CT_DeactivateEventAPI_URL @"reservations/deactivateEvent"

//Promotion
#define CT_ACTIVATE_PROMOTION_URL      @"promotions/activatePromotionSATier?promoUUID=%@&serviceAccommodatorId=%@&serviceLocationId=%@&UID=%@"
#define CT_PromotionTypeApi_URL @"promotions/getPromotionTypes"
#define CT_PromotionRetrive_URL @"promotions/retrievePicturesBySA"
#define CT_PromotionActivate_URL      @"promotions/activatePromotionSATier?promoUUID=%@&serviceAccommodatorId=%@&serviceLocationId=%@&UID=%@"
#define CT_PromotionDeactivate_URL    @"promotions/deActivatePromotionSATier?promoUUID=%@&serviceAccommodatorId=%@&serviceLocationId=%@&UID=%@"

#define CT_getSASLTilesByUIDAndLocation @"sasl/getSASLTilesByUIDAndLocation?"
#define CT_getSASLSummaryLightByUIDAndLocation @"sasl/getSASLSummaryLightByUIDAndLocation?"
#define CT_getSASLSummaryByUIDAndLocation @"sasl/getPromotionsSummaryByUIDAndLocation?"
#define CT_getSASLSummaryByUIDAndAddress @"sasl/getSASLSummaryByUIDAndAddress?"
#define CT_getDomainOptions @"sasl/getDomainOptions"
#define CT_getSASLFilterOptions @"sasl/getSASLFilterOptions"
#define CT_getRegisterNewMember @"authentication/registerNewMember/?"
#define CT_loginUser @"authentication/login/?"
#define CT_logoutUser @"authentication/logout/?"
#define CT_getRestaurant @"sasl/sasl?"
#define CT_getMediaMetaDatabySASL @"media/retrieveAugmentedMediaMetaDataBySASL?"
#define CT_createWNewPictureNewMetaData @"usersasl/createWNewPictureNewMetaData?"
#define CT_getAvailablePseudoTimeSlots @"reservations/getAvailablePseudoTimeSlots?"
#define CT_createPseduoReservation @"reservations/createPseudoReservation?"
#define CT_getPseudoReservation @"reservations/retrievePseudoReservationsForUser?"
#define CT_getReservationModificationOptions @"reservations/getReservationModificationRequestOptions?"
#define CT_modifyReservation @"reservations/requestSASLReservationModification?"
#define CT_specialOffer @"promotions/retrievePromotionSATiersBySASL?"
#define CT_retreivePromotionsUUIDs @"promotions/retrievePromotionSATierPromoUUIDs?"
#define CT_retreiveImageForPromoUUID @"promotions/retrievePictureJPGByPromoUUID?"
#define CT_retreiveMetaDataForPromoUUID @"promotions/getPromotionMetaDataClientByPromoUUID?"
#define CT_getLegendInfo @"sasl/getLegendInfo"

#define CT_FavoriteByURL @"community/addURLToFavorites?"
#define CT_RetriveFavorite @"usersasl/getFavoriteSASLSummaryByUID?"

#define CT_getSupportEmailTopics @"html/getSupportEmailTopics"
#define CT_sendCustomerSupportEmail @"html/sendSupportEmail?"
#define CT_getDurationTimesForAdAlert_URL @"communication/getDurationTimesForAdAlert?"
// V:
#define CT_RetriveFavoriteArray @"usersasl/retrieveFavoriteSASLs?"
// V: 20-05-2015 change domain "community" --> "usersasl"
//#define CT_DeleteFavorite @"community/deleteURLFromFavorites?"
#define CT_DeleteFavorite @"usersasl/deleteURLFromFavorites?"
#define CT_RetriveReview @"communication/retrieveReviews?"
#define CT_AddReview @"communication/addReview?"
#define CT_GetConversationBetweenUserSASL @"communication/getConversationBetweenUserSASL?"
#define CT_GetMessageForUser @"communication/getMessagesForUser?"
#define CT_SendMessageToSASL @"communication/sendMessageToSASL?"

#define CT_GetAuthenticationStatus  @"authentication/getAuthenticationStatus?"

#define CT_ZoomThreshold     @"zoomThreshold"
#define CT_DistanceThreshold @"distanceThreshold"
#define CT_Simulate          @"simulate"

#define UIDInDefaults @"strUID"
#define UserNameInDefaults @"strUserName"

#define CT_MapPinImage_Default @"mapmarker0_0.png"
#define kMap_ZoomLevel_To_Hide_Details 13.0f
#define kMap_ScrollL_Update_Distance_KM 2
#define kMap_ZoomDifference_To_Show_Details 14

typedef enum {
    iPhone4,
    iPhone5,
    iPhone6,
    iPhone6Plus
} iPhoneDeviceVersion;

typedef enum {
    kHTTPMethod_GET,
    kHTTPMethod_POST,
    kHTTPMethod_PUT,
    kHTTPMethod_DELETE
}HTTPMethod;
