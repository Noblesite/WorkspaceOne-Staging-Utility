//
//  X509Handler.h
//  StagingIsDone
//
//  Created by Jonathon Poe on 5/14/24.
//

#import <Security/Security.h>
#import <CoreFoundation/CoreFoundation.h>
#import "AirWatchConstant.h"
#import "DeviceInformation.h"

NS_ASSUME_NONNULL_BEGIN

@interface X509Handler : NSObject

@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *response;
@property (nonatomic, retain) NSString *status;



@property (nonatomic, retain)  AirWatchConstant *airWatchEnv;
@property (nonatomic, retain) DeviceInformation *deviceInformation;

- (X509Handler*)NewX509Handler;
- (void)retrieveResponseAsync:(NSString *)url :(NSString *)verb;
- (void)retrieveResponseAsync:(NSString *)url :(NSDate *)body :(NSString *)verb;
- (void)connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *) connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *) connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
- (void)connection:(NSURLConnection *) connection didFailWithError:(NSError *)error;
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace;

OSStatus extractIdentityAndTrust(CFDataRef inP12data, SecIdentityRef *identity, SecTrustRef *trust);

@end



NS_ASSUME_NONNULL_END
