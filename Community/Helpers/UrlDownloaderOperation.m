#import "UrlDownloaderOperation.h"

@interface UrlDownloaderOperation ()

- (void)finish;

@end

@implementation UrlDownloaderOperation

@synthesize url = _url;
@synthesize statusCode = _statusCode;
@synthesize data = _data;
@synthesize error = _error;
@synthesize isExecuting = _isExecuting;
@synthesize isFinished = _isFinished;

+ (id)urlDownloaderWithUrlString:(NSString *)urlString object:(id)object
{
    NSURL * url = [NSURL URLWithString:urlString];
    UrlDownloaderOperation * operation = [[self alloc] initWithUrl:url object:object];
    return [operation autorelease];
}

- (id)initWithUrl:(NSURL *)url object:(id)_object
{
    self = [super init];
    if (self == nil)
        return nil;
    object = _object;
    _url = [url copy];
    _isExecuting = NO;
    _isFinished = NO;
    
    return self;
}

- (void)dealloc
{
    [_url release];
    [_connection release];
    [_data release];
    [_error release];
    [super dealloc];
}

- (BOOL)isConcurrent
{
    return YES;
}

- (void)start
{
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
        return;
    }
    
    NSLog(@"opeartion for <%@> started.", _url);
    
    [self willChangeValueForKey:@"isExecuting"];
    _isExecuting = YES;
    [self didChangeValueForKey:@"isExecuting"];

    NSURLRequest * request = [NSURLRequest requestWithURL:_url];
    _connection = [[NSURLConnection alloc] initWithRequest:request
                                                  delegate:self];
    
    if (_connection == nil)
        [self finish];
}
-(void)cancelOperation {
    [_connection performSelectorOnMainThread:@selector(cancel) withObject:nil waitUntilDone:FALSE];
}
- (void)finish
{
    NSLog(@"operation for <%@> finished. "
          @"status code: %d, error: %@, data size: %u",
          _url, _statusCode, _error, [_data length]);
    
    [_connection release];
    _connection = nil;
    
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];

    _isExecuting = NO;
    _isFinished = YES;

    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
//    compBlock(object,_data,_error);
    @try {
        if([self.delegate respondsToSelector:@selector(didFinishWithData:forObject:)] && [self.delegate respondsToSelector:@selector(didFailWithError:forObject:)]) {
            if([self.delegate respondsToSelector:@selector(didFinishWithData:forObject:)] && !_error)
                [self.delegate didFinishWithData:_data forObject:object];
            else
                [self.delegate didFailWithError:_error forObject:object];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"COULD NOT CALL DELEGATE %@",exception);
    }
}

#pragma mark -
#pragma mark NSURLConnection delegate

- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response
{
    [_data release];
    _data = [[NSMutableData alloc] init];

    NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
    _statusCode = [httpResponse statusCode];
}

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data
{
    @try {
        [_data appendData:data];
        if([self.delegate respondsToSelector:@selector(didDownloadData:forObject:)])
            [self.delegate didDownloadData:_data forObject:object];
    }
    @catch (NSException *exception) {
        NSLog(@"COULD NOT CALL DELEGATE %@",exception);
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self finish];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    _error = [error copy];
    [self finish];
}

@end
