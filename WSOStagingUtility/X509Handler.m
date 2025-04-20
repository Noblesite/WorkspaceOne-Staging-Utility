//
//  X509Handler.m
//  StagingIsDone
//
//  Created by Jonathon Poe on 5/14/24.
//

#import <Foundation/Foundation.h>
#import "X509Handler.h"


@implementation X509Handler

@synthesize url;
@synthesize response;
@synthesize status;
@synthesize airWatchEnv;
@synthesize deviceInformation;


- (X509Handler*)NewX509Handler{
    
    X509Handler *x509Handler = [X509Handler alloc];
    
    return x509Handler;
}



- (void)retrieveResponseAsync:(NSString *)url :(NSDate *)body :(NSString *)verb{
    
    status = @"Retrieving response async";
    response = @"";
    
    NSURL *requestUrl = [[NSURL alloc] initWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    
    
    [request setHTTPMethod:verb];
    [request setValue:self.airWatchEnv.getTenant forHTTPHeaderField:@"aw-tenant-code"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody:body];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

- (void)retrieveResponseAsync:(NSString *)url :(NSString *)verb{
    
    status = @"Retrieving response async";
    response = @"";
    
    NSURL *requestUrl = [[NSURL alloc] initWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    
    [request setHTTPMethod:verb];
    [request setValue:self.airWatchEnv.getTenant forHTTPHeaderField:@"aw-tenant-code"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:@"0" forHTTPHeaderField:@"Content-Length"];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    
}

- (void)connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse*)response{
    
    NSLog(@"Response recieved");
}

- (void)connection:(NSURLConnection*) connection didReceiveData:(NSData *)data{
    NSLog(@"Data recieved");
    
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    response = responseString;
    
    status = @"Response retrieved async";
    
    NSLog(@"%@", response);
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
   
    
    NSLog(@"Authentication challenge");
    
    /* TODO: Update with your p12 path */
    NSString *path = [[NSBundle mainBundle] pathForResource:@"yourCertPath" ofType:@"p12"];
    NSData *p12data = [NSData dataWithContentsOfFile:path];
    CFDataRef inP12data = (__bridge CFDataRef)p12data;
    
    NSLog(@"p12data: %@", p12data);
    
    SecIdentityRef myIdentity;
    SecTrustRef myTrust;
    OSStatus ossstatus = extractIdentityAndTrust(inP12data, &myIdentity, &myTrust);
    
    SecCertificateRef myCertificate;
    SecIdentityCopyCertificate(myIdentity, &myCertificate);
    const void *certs[] = { myCertificate };
    CFArrayRef certsArray = CFArrayCreate(NULL, certs, 1, NULL);
    
    NSURLCredential *credential = [NSURLCredential credentialWithIdentity:myIdentity certificates:(__bridge NSArray*)certsArray persistence:NSURLCredentialPersistencePermanent];
    
    [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection*) connection didFailWithError:(NSError *)error{
    
    NSLog(@"%@", [NSString stringWithFormat:@"Did recieve error: %@", [error localizedDescription]]);
    NSLog(@"%@", [NSString stringWithFormat:@"%@", [error userInfo]]);
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace{
    
    return YES;
}

OSStatus extractIdentityAndTrust(CFDataRef inP12data, SecIdentityRef *identity, SecTrustRef *trust){
    OSStatus securityError = errSecSuccess;
    
    
    CFStringRef password = CFSTR("TODO");
    const void *keys[] = { kSecImportExportPassphrase };
    const void *values[] = { password };
    
    CFDictionaryRef options = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
    
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    securityError = SecPKCS12Import(inP12data, options, &items);
    
    if (securityError == 0) {
        CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex(items, 0);
        const void *tempIdentity = NULL;
        tempIdentity = CFDictionaryGetValue(myIdentityAndTrust, kSecImportItemIdentity);
        *identity = (SecIdentityRef)tempIdentity;
        const void *tempTrust = NULL;
        tempTrust = CFDictionaryGetValue(myIdentityAndTrust, kSecImportItemTrust);
        *trust = (SecTrustRef)tempTrust;
    }
    
    if (options) {
        CFRelease(options);
    }
    
    return securityError;
}


@end
