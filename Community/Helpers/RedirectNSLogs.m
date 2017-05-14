//
//  RedirectNSLogs.m
//  CommunityPortal
//
//  Created by Ihtesham Khan on 24/11/2014.
//  Copyright (c) 2014 apploom.com. All rights reserved.
//

#import "RedirectNSLogs.h"

@implementation RedirectNSLogs
+(instancetype)sharedInstance {
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[RedirectNSLogs alloc]init];
    });
    return sharedInstance;
}
- (void)redirectNSLogToDocuments
{
    NSArray *allPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [allPaths objectAtIndex:0];
    NSString *pathForLog = [documentsDirectory stringByAppendingPathComponent:@"logs.txt"];
    NSMutableData *data = [NSMutableData dataWithContentsOfFile:pathForLog];
    [data appendData:[[NSString stringWithFormat:@"\n################################ New\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //    [data setLength:0];
    [data writeToFile:pathForLog atomically:NO];
    freopen([pathForLog cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
}
-(NSString*)filePathForNSLogsFile {
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/logs.txt"];
    return filePath;
}
@end
