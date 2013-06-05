Purpose
--------------

FXReachability is a lightweight reachability class for Mac and iOS. It is designed to be as simple as possible, with no extraneous bells and whistles.


Supported iOS & SDK Versions
-----------------------------

* Supported build target - iOS 6.1 / Mac OS 10.8 (Xcode 4.6, Apple LLVM compiler 4.2)
* Earliest supported deployment target - iOS 5.0 / Mac OS 10.7
* Earliest compatible deployment target - iOS 4.3 / Mac OS 10.6

NOTE: 'Supported' means that the library has been tested with this version. 'Compatible' means that the library should work on this iOS version (i.e. it doesn't rely on any unavailable SDK features) but is no longer being tested for compatibility and may require tweaking or bug fixes to run correctly.


ARC Compatibility
------------------

FXReachability works both with or without ARC without modification. There is no need to exclude FXReachability files from the ARC validation process, or to convert FXReachability using the ARC conversion tool.


Installation
---------------

To use FXReachability, just drag the class files into your project and add the SystemConfiguration framework to your build phases. FXReachability is a self-instantiating singleton, so there's no need to create an instance of it.


Usage
-----------------

To use FXReachability, just add an observer for the `FXReachabilityStatusDidChangeNotification` notification, as follows:

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myUpdateMethod:) name:FXReachabilityStatusDidChangeNotification object:nil];

In your notification handler method, you can then simply use the following code to determine if the device has a network connection:

    BOOL reachable = [FXReachability isReachable];

Or to find out the exact status, use the following:
    
    FXReachabilityStatus status = [FXReachability sharedInstance].status;

You can also poll this property at any time to determine the current status.


Methods
----------------

The FXReachability class has the following methods  and properties:

    + (instancetype)sharedInstance;
    
This returns the singleton shared instance of the FXReachability class. Useful for accessing the `status` property.

    + (BOOL)isReachable;

This method returns YES if the device is reachable, and NO if it isn't. Note that reachability is inherently *optimistic* - a return value of NO means that you definitely can't make a network connection, but a value of YES only means that you *may* be able to (for example, the site you are trying to connect to may be down). For this reason, `+isReachable` will return YES if the status is currently unknown, to prevent spurious errors.

    @property (nonatomic, readonly) FXReachabilityStatus status;

This property returns the current reachabilility status. For obvious reasons, it's read-only. For a list of possible status values, see below.


FXReachabilityStatus
-------------------------

The `[FXReachability sharedInstance].status` property is a constant which can have one of the following values:

    FXReachabilityStatusUnknown
    
This means that the status is not currently known. This is usually the case prior to the first time that the `FXReachabilityStatusDidChangeNotification` has fired, but will not usually occur otherwise.
    
    FXReachabilityStatusNotReachable
    
This means that the device does not currently have access to the internet.
    
    FXReachabilityStatusReachableViaWWAN
    
This means that the device currently has a mobile data connection (e.g. 3G) and may therefore have poor bandwidth and/or metered data. You may wish to pause large downloads or reduce the quality of streaming video in this case. Note that this status is only supported on iOS devices - a Mac that is using a tethered connection or a 3G dongle will not report that this is the case.
    
    FXReachabilityStatusReachableViaWiFi
    
This means that the device has either a WiFi or ethernet broadband connection, and can be presumed to have reasonable bandwidth and/or unmetered access. Note that a Mac will report that is has this status even if it is actually sharing a mobile data connection from an iPhone or 3G dongle.
