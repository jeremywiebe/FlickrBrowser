//
//  FlickrBrowserAppDelegate.h
//  FlickrBrowser
//
//  Created by Jeremy Wiebe on 2013-05-21.
//  Copyright (c) 2013 Jeremy Wiebe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RecentPhotosMonitor;

@interface FlickrBrowserAppDelegate : UIResponder <UIApplicationDelegate>

@property(strong, nonatomic) UIWindow *window;

@property(nonatomic, strong) RecentPhotosMonitor *monitor;

@end
