//
//  DeviceInformation.h
//
//  Created by Jonathon Poe on 7/5/19.
//  Copyright © 2019 Noblesite. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceInformation : NSObject

@property (nonatomic, retain) NSString *deviceSerialNumber;
@property (nonatomic, retain) NSString *airWatchDeviceId;
@property (nonatomic, assign) NSNumber *neoGroupId;
@property (nonatomic, retain) NSString *enrollmentUser;
@property (nonatomic, retain) NSString *airWatchUUID;
@property (nonatomic, retain) NSString *OgName;
@property (nonatomic, retain) NSDictionary *airWatchAppConfigs;
@property (nonatomic, retain) NSString *wifiProifleId;
@property (nonatomic, retain) NSString *wifiProifleName;
@property (nonatomic, retain) NSString *ogPrefix;
@property (nonatomic, retain) NSString *ogSuffex;

- (DeviceInformation*)NewDeviceInfo;
- (NSString*)getAirWatchDeviceId;
- (NSString*)getDeviceSerialNumber;
- (NSString*)getEnrollmentUser;
- (NSString*)getAirWatchUUID;
- (void)setNeoGroupId:(NSNumber*)groupId;
- (void)setDeviceId:(NSString*)deviceId;
- (NSString*)getOgName;
- (NSString*)getNeoGroupId;
- (NSString*)getWifiProfileId;
- (NSString*)getWifiProfileName;


@end

NS_ASSUME_NONNULL_END
