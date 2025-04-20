//
//  DeviceInformation.m
//
//  Created by Jonathon Poe on 7/5/19.
//  Copyright © 2019 Noblesite. All rights reserved.
//

#import "DeviceInformation.h"

@implementation DeviceInformation

@synthesize airWatchDeviceId;
@synthesize neoGroupId;
@synthesize OgName;
@synthesize deviceSerialNumber;
@synthesize enrollmentUser;
@synthesize airWatchUUID;
@synthesize airWatchAppConfigs;
@synthesize wifiProifleId;
@synthesize wifiProifleName;
@synthesize ogPrefix;
@synthesize ogSuffex;

- (DeviceInformation*)NewDeviceInfo{
    
    DeviceInformation *newDevice = [DeviceInformation alloc];
    newDevice.airWatchAppConfigs = [self setAirWatchAppConfigs];
    newDevice.deviceSerialNumber = [newDevice.airWatchAppConfigs objectForKey:@"serialNumber"];
    newDevice.airWatchUUID = [newDevice.airWatchAppConfigs objectForKey:@"UUID"];
    newDevice.enrollmentUser = [newDevice.airWatchAppConfigs objectForKey:@"enrollmentUser"];
    newDevice.wifiProifleId = [newDevice.airWatchAppConfigs objectForKey:@"wifiProfileId"];
    newDevice.wifiProifleName = [newDevice.airWatchAppConfigs objectForKey:@"wifiProfileName"];
    newDevice.ogPrefix = [newDevice.airWatchAppConfigs objectForKey:@"ogPrefix"];
    newDevice.ogSuffex = [newDevice.airWatchAppConfigs objectForKey:@"ogSuffex"];
    newDevice.OgName = [self extractNumberFromText:newDevice.enrollmentUser];
 
    return newDevice;
}

-(NSDictionary*)setAirWatchAppConfigs{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
   
    if([prefs dictionaryForKey:@"com.apple.configuration.managed"]){
        
         NSDictionary *airWatchAppConfigs = [prefs dictionaryForKey:@"com.apple.configuration.managed"];
        
        return airWatchAppConfigs;
   
    }else{
        NSDictionary *airWatchAppConfigs = @{ @"serialNumber" : @"uknown", @"UUID" : @"unknown", @"DeviceId" : @"unknown", @"enrollmentUser" : @"uknown", @"wifiProfileId" : @"uknown", @"wifiProfileName" : @"uknown"};
        
        return airWatchAppConfigs;
    }
}


- (NSString*)getDeviceSerialNumber{
    
    return self.deviceSerialNumber;
}

- (NSString*)getAirWatchUUID{
    
    return self.airWatchUUID;
}

- (NSNumber*)getNeoGroupId{
    
    return self.neoGroupId;
}

- (NSString*)getAirWatchDeviceId{
    
    return self.airWatchDeviceId;
}

- (NSString*)getEnrollmentUser{
    
    return self.enrollmentUser;
}

- (NSString*)getOgName{
    
    /*TODO: Update Below logic for your uses case
     getOgName is used to return the OG name of the OG
     that you would like the device moved to after
     staging has completed. The name is used to search
     for the OG via AirWatch REST API's and return the OG
     ID for that specific OG. 
     
    */
    
    return [NSString stringWithFormat:@"%@ %@", self.ogPrefix, self.OgName];
}

- (NSString*)getWifiProfileId{
    
    return self.wifiProifleId;
}

- (NSString*)getWifiProfileName{
    
    return self.wifiProifleName;
}

- (NSString *)extractNumberFromText:(NSString *)text{
    
  NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    
    return [[text componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""];
}

- (void)setNeoGroupId:(NSNumber*)groupId{
    
    self.neoGroupId = groupId;
}

- (void)setDeviceId:(NSString*)deviceId{
    
    self.airWatchDeviceId = deviceId;
}


@end
