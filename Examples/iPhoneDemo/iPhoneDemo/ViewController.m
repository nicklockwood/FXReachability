//
//  ViewController.m
//  iPhoneDemo
//
//  Created by Nick Lockwood on 29/05/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import "ViewController.h"
#import "FXReachability.h"


@interface ViewController ()

@property (nonatomic, strong) IBOutlet UILabel *currentStatusLabel;
@property (nonatomic, strong) IBOutlet UITextView *historicStatusView;

@end

@implementation ViewController

- (NSString *)statusText
{
    switch ([FXReachability sharedInstance].status)
    {
        case FXReachabilityStatusUnknown:
        {
            return @"Status Unknown";
        }
        case FXReachabilityStatusNotReachable:
        {
            return @"Not reachable";
        }
        case FXReachabilityStatusReachableViaWWAN:
        {
            return @"Reachable via WWAN";
        }
        case FXReachabilityStatusReachableViaWiFi:
        {
            return @"Reachable via WiFi";
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateStatus) name:FXReachabilityStatusDidChangeNotification object:nil];
    
    [self updateStatus];
}

- (void)updateStatus
{
    self.currentStatusLabel.text = [self statusText];
    
    static NSDateFormatter *formatter = nil;
    if (!formatter)
    {
        formatter = [[NSDateFormatter alloc] init];
        formatter.timeStyle = NSDateFormatterMediumStyle;
    }
    
    NSMutableString *consoleText = [NSMutableString stringWithString:self.historicStatusView.text];
    NSString *timeStamp = [formatter stringFromDate:[NSDate date]];
    [consoleText appendFormat:@"%@  %@\n", timeStamp, [self statusText]];
    self.historicStatusView.text = consoleText;
}

@end
