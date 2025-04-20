//
//  ViewController.m
//  StagingIsDone
//
//  Created by Jonathon Poe on 1/16/24.
//  Copyright © 2024 Noblesite. All rights reserved.
//

#import "ViewController.h"
#import "SimplePing.h"

@interface ViewController () <SimplePingDelegate>

@property (nonatomic, strong) SimplePing *simplePing;
@property (nonatomic, assign) bool didPingComplete;

@end

@implementation ViewController

@synthesize wifiStatus;
@synthesize wifiRemoved;
@synthesize wifiInstalled;
@synthesize wifiButton;
@synthesize lockButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.wifiRemoved = false;
    
   
}

- (IBAction)reloadR4:(UIButton *)sender {
    
    if(!self.wifiRemoved){
        
        RestHandler *restHandler = [[RestHandler alloc]newRestHandler];
        
        bool success = [restHandler starRemoveWiFiProfile];
        
        if(success){
            
          
            [sender setTitle:@"Removing WiFi Profile: Check Status" forState:UIControlStateNormal];
            sender.enabled = NO;
            [self removeWiFiRequest];
            
        }else{
            
            [self apiCallErrorAlert];
        }
        
    }else{
        
        RestHandler *restHandler = [[RestHandler alloc]newRestHandler];
        
        bool success = [restHandler starInstallWiFiProfile];
        
        if(success){
            
            [sender setTitle:@"Installing WiFi Profile: Check Status" forState:UIControlStateNormal];
            sender.enabled = NO;
            [self installWiFiRequest];
            
        }else{
            
            [self apiCallErrorAlert];
        }
        
    }
}

- (IBAction)lockDevice:(UIButton *)sender {
    
    sender.enabled = false;
    
    /* TODO: Ping a external or internal webiste to validate wifi connection*/
    
    self.didPingComplete = false;
    self.simplePing = [[SimplePing alloc]initWithHostName:@"your.website.com"];
    self.simplePing.delegate = self;
    [self startPingTimeout];
    [self.simplePing start];
    

}

- (IBAction)checkWiFiStatus:(UIButton *)sender {
    
    RestHandler *restHandler = [[RestHandler alloc]newRestHandler];
    
    [sender setTitle:@"Checking WiFi Status . . ." forState:UIControlStateDisabled];
    sender.enabled = false;
    int status = [restHandler starStatusWiFiProfile];
    switch (status) {
                case 1:
                    NSLog(@"Number is 1");
                    [self wifiStatusRequestProcessing];
                    break;
                case 2:
                    NSLog(@"Number is 2");
                    self.wifiRemoved = false;
                    [self wifiStatusRequestProcessing];
                    break;
                case 3:
                    self.wifiButton.enabled = YES;
                    [self.wifiButton setTitle:@"Remove WiFi Profile" forState:UIControlStateNormal];
                    self.wifiRemoved = false;
                    [self wifiStatusRequestInstalled];
                    break;
                case 4:
                    self.wifiRemoved = false;
                    [self wifiStatusRequestProcessing];
                    break;
                case 6:
                    self.wifiButton.enabled = YES;
                    [self.wifiButton setTitle:@"Install WiFi Profile" forState:UIControlStateNormal];
                    self.wifiRemoved = true;
                    [self wifiStatusRequestRemoved];
                    break;
                case 9:
                    NSLog(@"Number is 9");
                    [self apiCallErrorAlert];
                    break;
                default:
                    NSLog(@"Number is not between 1 and 4");
            [self wifiStatusRequestProcessing];
                    break;
            }
    
    [sender setTitle:@"Check R4 Status" forState:UIControlStateNormal];
    sender.enabled = true;
}



#pragma mark - SimplePingDelegate

- (void)simplePing:(SimplePing *)pinger didStartWithAddress:(NSData *)address {
    NSLog(@"Ping started with address: %@", address);
    [self.simplePing sendPingWithData:nil];
}

- (void)simplePing:(SimplePing *)pinger didFailWithError:(NSError *)error {
    NSLog(@"Ping failed with error: %@", error);
    [self cleanupPing];
}

- (void)simplePing:(SimplePing *)pinger didSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber {
    NSLog(@"Ping sent packet with sequence number: %u", sequenceNumber);
}

- (void)simplePing:(SimplePing *)pinger didFailToSendPacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber error:(NSError *)error {
    NSLog(@"Ping failed to send packet with sequence number: %u, error: %@", sequenceNumber, error);
    
    [self cleanupPing];
}

- (void)simplePing:(SimplePing *)pinger didReceivePingResponsePacket:(NSData *)packet sequenceNumber:(uint16_t)sequenceNumber {
    NSLog(@"Ping received response packet with sequence number: %u", sequenceNumber);
    
    [self cleanupPing];
    self.lockButton.enabled = true;
    self.didPingComplete = true;
    [self sendLockDeviceRequest];
}

- (void)simplePing:(SimplePing *)pinger didReceiveUnexpectedPacket:(NSData *)packet {
    NSLog(@"Ping received unexpected packet: %@", packet);
    
    [self cleanupPing];
}
- (void)cleanupPing{
    
    if(self.simplePing){
        
        [self.simplePing stop];
        self.simplePing = nil;
    }
}
-(void)sendLockDeviceRequest{
    
    RestHandler *restHandler = [[RestHandler alloc]newRestHandler];
    bool didComplete = restHandler.startOgMigrationProcess;
    
    if(!didComplete){
                
        [self apiCallErrorAlert];
    }
}

- (void)apiCallErrorAlert{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"AirWatch Error"
                               message:@"Error when connecting to AirWatch. Please check network connection."
                               preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {}];

    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)noNetworkConnection{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Check Network Connection"
                               message:@"iOS device is not connected to the Network. Lock Device request rejected"
                               preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {}];

    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)removeWiFiRequest{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"WiFi Profile"
                               message:@"Remove WiFi Profile request sent."
                               preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {}];

    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)installWiFiRequest{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"WiFi Profile"
                               message:@"Install WiFi Profile request sent."
                               preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {}];

    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)wifiStatusRequestInstalled{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"wifi Status"
                               message:@"WiFi Profile Installed."
                               preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {}];

    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)wifiStatusRequestRemoved{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"wifi Status"
                               message:@"WiFi Profile Removed."
                               preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {}];

    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)wifiStatusRequestProcessing{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"WiFi Status"
                               message:@"Previous request is being processed."
                               preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {}];

    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)startPingTimeout{

    [NSTimer scheduledTimerWithTimeInterval:15.0
                                     target:self
                                   selector:@selector(canclePing:)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)canclePing:(NSTimer *)timer {
    
    if(!self.didPingComplete){
        
        self.lockButton.enabled = true;
        [self cleanupPing];
        [self noNetworkConnection];
    }
}



@end
