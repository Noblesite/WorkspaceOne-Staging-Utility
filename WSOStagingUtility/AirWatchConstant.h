//
//  AirWatchCN223Constant.h
//  IntuneMigrationTool
//
//  Created by Jonathon Poe on 7/5/19.
//  Copyright © 2019 Noblesite. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceInformation.h"

NS_ASSUME_NONNULL_BEGIN

@interface AirWatchConstant : NSObject

@property (nonatomic, retain) NSString *apiUrl; 
@property (nonatomic, retain) NSString *tenant;
@property (nonatomic, retain) NSString *authorization;
@property (nonatomic, retain) NSDictionary *airWatchAppConfigs;
@property (nonatomic, retain) NSString *airWatchUrl;
@property (nonatomic, retain) NSString *awCertPassCode;


- (AirWatchConstant*)NewAirWatchEnv;
- (NSString*)getApiUrl;
- (NSString*)getTenant;
- (NSString*)getAuthorization;
- (NSString*)getAirWatchURL;
- (NSString*)getAirWatchCertPassCode;

@end

NS_ASSUME_NONNULL_END
