//
//  CacheHandler.m
//
//
//  Created by Jonathon Poe on 1/29/24.
//  Copyright © 2019 Noblesite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CacheHandler.h"

@implementation CacheHandler


- (CacheHandler*)cacheHandler{
    
    CacheHandler *cacheHandler = [CacheHandler alloc];
    [self findObjectsInCache];
    return cacheHandler;
}



- (void)findObjectsInCache{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [paths objectAtIndex:0];
    
    NSError *error;
    NSArray *directoryItems = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:cacheDirectory error:&error];
    NSLog(@"Cache Directory Items: %@", directoryItems);
    
    NSURLCache *sharedCache = [NSURLCache sharedURLCache];
    
    NSLog(@"SharedCache Disk Size: %@", [@(sharedCache.currentDiskUsage) stringValue]);
    NSLog(@"SharedCache Memory Size: %@", [@(sharedCache.currentDiskUsage) stringValue]);
    
    for(NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {

        if([[cookie domain] isEqualToString:@"http://YourWebsite.com"]) {
            
            NSLog(@"Cookies: %@", cookie);

            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
    
    [self removeAllStoredCredentials];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    NSLog(@"SharedCache Disk Size After: %@", [@(sharedCache.currentDiskUsage) stringValue]);
    NSLog(@"SharedCache Memory Size After: %@", [@(sharedCache.currentDiskUsage) stringValue]);
    
    
}

- (void)removeAllStoredCredentials{
    
    // Delete any cached URLrequests!
    NSURLCache *sharedCache = [NSURLCache sharedURLCache];
    
    [sharedCache removeAllCachedResponses];

    // Also delete all stored cookies!
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [cookieStorage cookies];
    id cookie;
    for (cookie in cookies) {
        [cookieStorage deleteCookie:cookie];
    }

    NSDictionary *credentialsDict = [[NSURLCredentialStorage sharedCredentialStorage] allCredentials];
    if ([credentialsDict count] > 0) {
        // the credentialsDict has NSURLProtectionSpace objs as keys and dicts of userName => NSURLCredential
        NSEnumerator *protectionSpaceEnumerator = [credentialsDict keyEnumerator];
        id urlProtectionSpace;
        // iterate over all NSURLProtectionSpaces
        while (urlProtectionSpace = [protectionSpaceEnumerator nextObject]) {
            NSEnumerator *userNameEnumerator = [[credentialsDict objectForKey:urlProtectionSpace] keyEnumerator];
            id userName;
            // iterate over all usernames for this protectionspace, which are the keys for the actual NSURLCredentials
            while (userName = [userNameEnumerator nextObject]) {
                NSURLCredential *cred = [[credentialsDict objectForKey:urlProtectionSpace] objectForKey:userName];
                    NSLog(@"credentials to be removed: %@", cred);
                [[NSURLCredentialStorage sharedCredentialStorage] removeCredential:cred forProtectionSpace:urlProtectionSpace];
            }
        }
    }
}

@end
