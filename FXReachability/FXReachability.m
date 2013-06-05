//
//  FXReachability.m
//
//  Version 1.1
//
//  Created by Nick Lockwood on 13/04/2013.
//  Copyright (c) 2013 Charcoal Design
//
//  Distributed under the permissive zlib License
//  Get the latest version from here:
//
//  https://github.com/nicklockwood/FXReachability
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//

#import "FXReachability.h"
#import <Availability.h>

NSString *const FXReachabilityStatusDidChangeNotification = @"FXReachabilityStatusDidChangeNotification";
NSString *const FXReachabilityNotificationStatusKey = @"status";


@interface FXReachability ()

@property (nonatomic, assign) SCNetworkReachabilityRef reachability;
@property (nonatomic, assign) FXReachabilityStatus status;

@end


@implementation FXReachability

static void ONEReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void *info)
{
    FXReachabilityStatus status = FXReachabilityStatusUnknown;
    if ((flags & kSCNetworkReachabilityFlagsReachable) == 0 ||
        (flags & kSCNetworkReachabilityFlagsConnectionRequired) != 0)
    {
        status = FXReachabilityStatusNotReachable;
    }
    
#if	TARGET_OS_IPHONE
    
    else if ((flags & kSCNetworkReachabilityFlagsIsWWAN) != 0)
    {
        status = FXReachabilityStatusReachableViaWWAN;
    }
    
#endif
    
    else
    {
        status = FXReachabilityStatusReachableViaWiFi;
    }
    
    if (status != [FXReachability sharedInstance].status)
    {
        [FXReachability sharedInstance].status = status;
        [[NSNotificationCenter defaultCenter] postNotificationName:FXReachabilityStatusDidChangeNotification object:[FXReachability sharedInstance] userInfo:@{FXReachabilityNotificationStatusKey: @(status)}];
    }
}

+ (void)load
{
    [self performSelectorOnMainThread:@selector(sharedInstance) withObject:nil waitUntilDone:NO];
}

+ (instancetype)sharedInstance
{
    static FXReachability *instance;
    if (!instance)
    {
        instance = [[self alloc] init];
    }
    return instance;
}

+ (BOOL)isReachable
{
    return [[self sharedInstance] status] != FXReachabilityStatusNotReachable;
}

- (id)init
{
    if ((self = [super init]))
    {
        _status = FXReachabilityStatusUnknown;
        _reachability = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, "apple.com");
        SCNetworkReachabilitySetCallback(_reachability, ONEReachabilityCallback, NULL);
        SCNetworkReachabilityScheduleWithRunLoop(_reachability, CFRunLoopGetMain(), kCFRunLoopCommonModes);
    }
    return self;
}

- (void)dealloc
{

#if !__has_feature(objc_arc)
    
    [super dealloc];
    
#endif
    
    if (_reachability)
    {
        SCNetworkReachabilityUnscheduleFromRunLoop(_reachability, CFRunLoopGetMain(), kCFRunLoopCommonModes);
        CFRelease(_reachability);
    }
}

@end
