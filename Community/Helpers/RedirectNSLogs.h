//
//  RedirectNSLogs.h
//  CommunityPortal
//
//  Created by Ihtesham Khan on 24/11/2014.
//  Copyright (c) 2014 apploom.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RedirectNSLogs : NSObject
+(instancetype)sharedInstance;
- (void)redirectNSLogToDocuments;
-(NSString*)filePathForNSLogsFile;
@end
