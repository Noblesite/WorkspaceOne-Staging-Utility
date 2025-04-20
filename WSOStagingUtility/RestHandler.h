//
//  RestHandler.h
//  IntuneMigrationTool
//
//  Created by Jonathon Poe on 7/5/19.
//  Copyright © 2019 Noblesite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AirWatchConstant.h"
#import "DeviceInformation.h"
#import <SystemConfiguration/SystemConfiguration.h>



NS_ASSUME_NONNULL_BEGIN

@interface RestHandler : NSURLConnection <NSURLConnectionDelegate>

@property (nonatomic, retain)  AirWatchConstant *airWatchEnv;
@property (nonatomic, retain) DeviceInformation *deviceInformation;


- (RestHandler*)newRestHandler;

- (bool)startOgMigrationProcess;
- (bool)starRemoveWiFiProfile;
- (int)starStatusWiFiProfile;
- (bool)starInstallWiFiProfile;

@end

NS_ASSUME_NONNULL_END
