//
//  AirWatchCN223Constant.m
//  IntuneMigrationTool
//
//  Created by Jonathon Poe on 7/5/19.
//  Copyright © 2019 Noblesite. All rights reserved.
//

#import "AirWatchConstant.h"

@implementation AirWatchConstant

@synthesize apiUrl;
@synthesize tenant;
@synthesize authorization;
@synthesize airWatchAppConfigs;
@synthesize airWatchUrl;
@synthesize awCertPassCode;

- (AirWatchConstant*)NewAirWatchEnv{
    
    AirWatchConstant *airWatch = [AirWatchConstant alloc];

    airWatch.airWatchAppConfigs = [self setAirWatchAppConfigs];
    airWatch.apiUrl = [airWatch.airWatchAppConfigs objectForKey:@"APIURL"];
    airWatch.airWatchUrl = [airWatch.airWatchAppConfigs objectForKey:@"URL"];
    airWatch.tenant = [airWatch.airWatchAppConfigs objectForKey:@"Tenant"];
    airWatch.awCertPassCode = [airWatch.airWatchAppConfigs objectForKey:@"awCertPassCode"];
    airWatch.authorization = [self unEncodeAppConfigs:[airWatch.airWatchAppConfigs objectForKey:@"Authorization"]];
    
    return airWatch;
}


-(NSDictionary*)setAirWatchAppConfigs{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
   
    if([prefs dictionaryForKey:@"com.apple.configuration.managed"]){
        
         NSDictionary *airWatchAppConfigs = [prefs dictionaryForKey:@"com.apple.configuration.managed"];
        
        return airWatchAppConfigs;
   
    }else{
        
        NSDictionary *airWatchAppConfigs = @{ @"APIURL" : @"unknown", @"Tenant" : @"unknown", @"Authorization" : @"unknown"};
        
        return airWatchAppConfigs;
    }
}

-(NSString*)unEncodeAppConfigs:(NSString*)data{
    
    NSData *encodedData = [[NSData alloc] initWithBase64EncodedString:data options:0];

    NSString *decoded = [[NSString alloc]initWithData:encodedData encoding:NSUTF8StringEncoding];
   
    return decoded;
}

- (NSString*)getApiUrl{
    
    
    return self.apiUrl;
}

- (NSString*)getTenant{
    
    
    return self.tenant;
}

- (NSString*)getAuthorization{
    
    
    return self.authorization;
}

-(NSString*)getAirWatchURL{
    
    return self.airWatchUrl;
}

- (NSString*)getAirWatchCertPassCode{
    
    return self.awCertPassCode;
}


@end
