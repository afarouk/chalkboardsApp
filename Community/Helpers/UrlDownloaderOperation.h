#import <Foundation/Foundation.h>

@protocol UrlDownloaderOperationDelegate <NSObject>
@optional
-(void)didDownloadData:(NSData*)data forObject:(id)object;
-(void)didFailWithError:(NSError*)error forObject:(id)object;
-(void)didFinishWithData:(NSData*)data forObject:(id)object;
@end
@interface UrlDownloaderOperation : NSOperation
{
    NSURL * _url;
    NSURLConnection * _connection;
    NSInteger _statusCode;
    NSMutableData * _data;
    NSError * _error;
    
    BOOL _isExecuting;
    BOOL _isFinished;
    id object;
}

@property (readonly, copy) NSURL * url;
@property (readonly) NSInteger statusCode;
@property (readonly, retain) NSData * data;
@property (readonly, retain) NSError * error;

@property (readonly) BOOL isExecuting;
@property (readonly) BOOL isFinished;
@property(nonatomic,assign) id<UrlDownloaderOperationDelegate> delegate;
+ (id)urlDownloaderWithUrlString:(NSString *)urlString object:(id)object;

- (id)initWithUrl:(NSURL *)url object:(id)object;
-(void)cancelOperation ;
@end
