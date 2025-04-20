//
//  ViewController.h
//  StagingIsDone
//
//  Created by Jonathon Poe on 1/16/24.
//

#import <UIKit/UIKit.h>

#import "RestHandler.h"
#import "CacheHandler.h"
#import "AirWatchConstant.h"
#import "X509Handler.h"


@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *lockButton;

@property (strong, nonatomic) IBOutlet UIButton *wifiButton;
@property (nonatomic, assign) bool wifiInstalled;
@property (nonatomic, assign) bool wifiRemoved;
@property (nonatomic, assign) bool wifiStatus;

@end

