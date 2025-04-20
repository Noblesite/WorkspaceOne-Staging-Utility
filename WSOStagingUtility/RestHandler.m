
//
//  RestHandler.m
//  IntuneMigrationTool
//
//  Created by Jonathon Poe on 7/5/19.
//  Copyright © 2019 Noblesite. All rights reserved.
//

#import "RestHandler.h"

@interface RestHandler () <NSURLConnectionDelegate>

@property (nonatomic, assign) NSNumber* wifiStatus;
@property (nonatomic, assign,readwrite) bool webCallSucsses;
@property (nonatomic, assign) NSNumber* neoOgId;


@end


@implementation RestHandler

@synthesize airWatchEnv;
@synthesize deviceInformation;

- (RestHandler*)newRestHandler{
    
    RestHandler *restHandler = [RestHandler alloc];
    restHandler.airWatchEnv  = [[AirWatchConstant alloc]NewAirWatchEnv];
    restHandler.deviceInformation =[[DeviceInformation alloc]NewDeviceInfo];
    
    return restHandler;
}

- (bool)startOgMigrationProcess{
    
    [self getDeviceInfoAirWatch];
    [self searchForDeviceOrgGroup];
    [self changeDeviceOrgGroup];
    
    return self.webCallSucsses;
}
- (bool)starRemoveWiFiProfile{
    
    [self getDeviceInfoAirWatch];
    [self removeWiFiProfile];
    
    return self.webCallSucsses;
}
- (int)starStatusWiFiProfile{
    
    [self getDeviceInfoAirWatch];
    [self getDeviceProfiles];
    [self deviceQuery];
    
    if(!self.webCallSucsses){
        
        return 9;
    }
    
    return self.wifiStatus.intValue;
}
- (bool)starInstallWiFiProfile{
    
    [self getDeviceInfoAirWatch];
    [self installWiFiProfile];
    
    return self.webCallSucsses;
}

    
- (void)getDeviceInfoAirWatch{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/mdm/devices?searchby=Serialnumber&id=%@", self.airWatchEnv.getApiUrl, self.deviceInformation.getDeviceSerialNumber];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // Create a semaphore
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [request setHTTPMethod:@"GET"];
    [request setValue:self.airWatchEnv.getAuthorization forHTTPHeaderField:@"Authorization"];
    [request setValue:self.airWatchEnv.getTenant forHTTPHeaderField:@"aw-tenant-code"];
    [request setValue:@"no-cache" forHTTPHeaderField:@"cache-control"];
    [request setValue:@"0" forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data,
                                                                    NSURLResponse *response,
                                                                    NSError *error) {
    if(error){
        NSLog(@"Error: %@", error.localizedDescription);
        self.webCallSucsses = false;
        return;
    }
            
    NSError *jsonError;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:0
                                                                   error:&jsonError];
    if(jsonError){
        
        NSLog(@"JSON Error: %@", jsonError.localizedDescription);
        
    }else{
        
        NSLog(@"Response: %@", json);
        
        [self parseAirWatchDeviceInfoReturn:json];
        self.webCallSucsses = true;
        
        }
        dispatch_semaphore_signal(semaphore);
    }];
        
    [task resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
       
}


-(void)getDeviceProfiles{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/mdm/devices/%@/profiles", self.airWatchEnv.getApiUrl, self.deviceInformation.getAirWatchDeviceId];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // Create a semaphore
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [request setHTTPMethod:@"GET"];
    [request setValue:self.airWatchEnv.getAuthorization forHTTPHeaderField:@"Authorization"];
    [request setValue:self.airWatchEnv.getTenant forHTTPHeaderField:@"aw-tenant-code"];
    [request setValue:@"no-cache" forHTTPHeaderField:@"cache-control"];
    [request setValue:@"0" forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data,
                                                                    NSURLResponse *response,
                                                                    NSError *error) {
    if(error){
        NSLog(@"Error: %@", error.localizedDescription);
        self.webCallSucsses = false;
        return;
    }
            
    NSError *jsonError;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:0
                                                                   error:&jsonError];
    if(jsonError){
        
        NSLog(@"JSON Error: %@", jsonError.localizedDescription);
        
    }else{
        
        NSLog(@"Response: %@", json);
        
        [self parseDeviceProfilesReturn:json];
        self.webCallSucsses = true;
        
        }
        dispatch_semaphore_signal(semaphore);
    }];
        
    [task resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}

-(void)deviceQuery{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/mdm/devices/%@/commands?command=DeviceQuery", self.airWatchEnv.getApiUrl, self.deviceInformation.getAirWatchDeviceId];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // Create a semaphore
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    request.HTTPMethod = @"POST";

    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:self.airWatchEnv.getAuthorization forHTTPHeaderField:@"Authorization"];
    [request setValue:self.airWatchEnv.getTenant forHTTPHeaderField:@"aw-tenant-code"];
    [request setValue:@"no-cache" forHTTPHeaderField:@"cache-control"];
    [request setValue:@"0" forHTTPHeaderField:@"Content-Length"];
        
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data,
                                                                    NSURLResponse *response,
                                                                    NSError *error) {
        if(error){
                
            NSLog(@"Error: %@", error.localizedDescription);
            self.webCallSucsses = false;
            return;
        }
            
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:0
                                                                   error:&jsonError];
        if(jsonError){
                
                NSLog(@"JSON Error: %@", jsonError.localizedDescription);
                
        }else{
                
            NSLog(@"Response: %@", json);
            self.webCallSucsses = true;
        }
            
            // Signal the semaphore to indicate that the request has completed
            dispatch_semaphore_signal(semaphore);
        }];
        
        [task resume];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
}

- (void)searchForDeviceOrgGroup{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/system/groups/search?name=%@", self.airWatchEnv.getApiUrl, self.deviceInformation.getOgName];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // Create a semaphore
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [request setHTTPMethod:@"GET"];
    [request setValue:self.airWatchEnv.getAuthorization forHTTPHeaderField:@"Authorization"];
    [request setValue:self.airWatchEnv.getTenant forHTTPHeaderField:@"aw-tenant-code"];
    [request setValue:@"no-cache" forHTTPHeaderField:@"cache-control"];
    [request setValue:@"0" forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data,
                                                                    NSURLResponse *response,
                                                                    NSError *error) {
    if(error){
        NSLog(@"Error: %@", error.localizedDescription);
        self.webCallSucsses = false;
        return;
    }
            
    NSError *jsonError;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:0
                                                                   error:&jsonError];
    if(jsonError){
        
        NSLog(@"JSON Error: %@", jsonError.localizedDescription);
        
    }else{
        
        NSLog(@"Response: %@", json);
        self.webCallSucsses = true;
        [self parseOrgSearchReturn:json];
        
        }
        dispatch_semaphore_signal(semaphore);
    }];
        
    [task resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
       
}


-(void)changeDeviceOrgGroup{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/mdm/devices/%@/commands/changeorganizationgroup/%@", self.airWatchEnv.getApiUrl, self.deviceInformation.getAirWatchDeviceId, self.neoOgId];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // Create a semaphore
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [request setHTTPMethod:@"PUT"];
    [request setValue:self.airWatchEnv.getAuthorization forHTTPHeaderField:@"Authorization"];
    [request setValue:self.airWatchEnv.getTenant forHTTPHeaderField:@"aw-tenant-code"];
    [request setValue:@"no-cache" forHTTPHeaderField:@"cache-control"];
    [request setValue:@"0" forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data,
                                                                    NSURLResponse *response,
                                                                    NSError *error) {
    if(error){
        NSLog(@"Error: %@", error.localizedDescription);
        self.webCallSucsses = false;
        return;
    }
            
    NSError *jsonError;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:0
                                                                   error:&jsonError];
    if(jsonError){
        
        NSLog(@"JSON Error: %@", jsonError.localizedDescription);
        
    }else{
        
        NSLog(@"Response: %@", json);
        self.webCallSucsses = true;
        
        }
        dispatch_semaphore_signal(semaphore);
    }];
        
    [task resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}


-(void)installWiFiProfile{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/mdm/profiles/%@/install", self.airWatchEnv.getApiUrl, self.deviceInformation.getWifiProfileId];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // Create a semaphore
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    request.HTTPMethod = @"POST";

    NSDictionary *bodyData =  @{@"DeviceId": self.deviceInformation.getAirWatchDeviceId};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:bodyData options:0 error:&error];

    if(!error){
        request.HTTPBody = jsonData;
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:self.airWatchEnv.getAuthorization forHTTPHeaderField:@"Authorization"];
        [request setValue:self.airWatchEnv.getTenant forHTTPHeaderField:@"aw-tenant-code"];
        [request setValue:@"no-cache" forHTTPHeaderField:@"cache-control"];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data,
                                                                    NSURLResponse *response,
                                                                    NSError *error) {
            if(error){
                
                NSLog(@"Error: %@", error.localizedDescription);
                self.webCallSucsses = false;
                return;
            }
            
            NSError *jsonError;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:0
                                                                   error:&jsonError];
            if(jsonError){
                
                NSLog(@"JSON Error: %@", jsonError.localizedDescription);
                
            }else{
                
                NSLog(@"Response: %@", json);
                self.webCallSucsses = true;
            }
            
            // Signal the semaphore to indicate that the request has completed
            dispatch_semaphore_signal(semaphore);
        }];
        
        [task resume];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
    }else{
        
        NSLog(@"JSON Serialization Error: %@", error.localizedDescription);
    }
}

-(void)removeWiFiProfile{
    
    NSString *urlString = [NSString stringWithFormat:@"%@/mdm/profiles/%@/remove", self.airWatchEnv.getApiUrl, self.deviceInformation.getWifiProfileId];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // Create a semaphore
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    request.HTTPMethod = @"POST";

    NSDictionary *bodyData =  @{@"DeviceId": self.deviceInformation.getAirWatchDeviceId};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:bodyData options:0 error:&error];

    if(!error){
        request.HTTPBody = jsonData;
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:self.airWatchEnv.getAuthorization forHTTPHeaderField:@"Authorization"];
        [request setValue:self.airWatchEnv.getTenant forHTTPHeaderField:@"aw-tenant-code"];
        [request setValue:@"no-cache" forHTTPHeaderField:@"cache-control"];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data,
                                                                    NSURLResponse *response,
                                                                    NSError *error) {
            if(error){
                NSLog(@"Error: %@", error.localizedDescription);
                self.webCallSucsses = false;
                return;
            }
            
            NSError *jsonError;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:0
                                                                   error:&jsonError];
            if(jsonError){
                NSLog(@"JSON Error: %@", jsonError.localizedDescription);
            } else {
                NSLog(@"Response: %@", json);
                self.webCallSucsses = true;
            }
            
            // Signal the semaphore to indicate that the request has completed
            dispatch_semaphore_signal(semaphore);
        }];
        
        [task resume];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
    }else{
        
        NSLog(@"JSON Serialization Error: %@", error.localizedDescription);
    }
}


- (NSDictionary*)parseJsonResponse:(NSData*)response{
    
    NSDictionary *results;
    
    if(NSClassFromString(@"NSJSONSerialization")){
        NSError *error = nil;
        id object = [NSJSONSerialization
                     JSONObjectWithData:response
                     options:0
                     error:&error];
       
        results = object;
       
        if(error) {
            
            NSLog(@"Error From Json parsing: %@", error);
        }
    }
    
    return results;
}

- (void)parseAirWatchDeviceInfoReturn:(NSDictionary*)deviceInfo{
    
    for (id key in deviceInfo) {
        
        if([key isEqualToString:@"Id"]){
            
            NSDictionary *idValue = [deviceInfo objectForKey:key];
            
            for(id key in idValue){
                
                if([key isEqualToString:@"Value"]){
                    
                    NSString *deviceId = [idValue objectForKey:key];
                    
                    NSLog(@"DeviceID: %@", deviceId);
                    
                    [self.deviceInformation setDeviceId:deviceId];
                   
                }
            }
        }
    }
}

- (void)parseDeviceProfilesReturn:(NSDictionary*)deviceInfo{
    
    for(id key in deviceInfo){
        
        if([key isEqualToString:@"DeviceProfiles"]){
            
            NSArray *profiles = [deviceInfo objectForKey:@"DeviceProfiles"];
            
            NSLog(@"Dictionary: %@", profiles);
            
            for(id object in profiles){
                
                NSDictionary *profile = object;
                
                NSString *name = profile[@"Name"];
                NSNumber *status = profile[@"Status"];
                // Update Code to get the profile name from app configs
                if([name isEqual:self.deviceInformation.getWifiProfileName]){
                    
                    self.wifiStatus = status;
                }
            }
        }
    }
}

- (void)parseOrgSearchReturn:(NSDictionary*)orgInfo{
    
    
    NSArray *orgGroup = [orgInfo objectForKey:@"LocationGroups"];
            
    NSLog(@"Dictionary: %@", orgGroup);
            
    for(id object in orgGroup){
        
        NSDictionary *org = object;
        
        NSLog(@"Dictionary: %@", org);
        
        for(id key in org){
            
            if([key isEqual:@"Id"]){
                
                NSDictionary *dictId = org[key];
                NSNumber *orgGroupId = dictId[@"Value"];
                NSLog(@"OrgID: %@", orgGroupId);
                self.neoOgId = orgGroupId;
                return;
            }
        }
    }
}

@end
