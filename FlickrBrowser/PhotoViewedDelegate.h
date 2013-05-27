//
// Created by Jeremy Wiebe on 2013-05-27.
// Copyright (c) 2013 Jeremy Wiebe. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class RecentPhotosMonitor;

@protocol PhotoViewedDelegate <NSObject>

@required
- (void)recentPhotoListDidChange:(RecentPhotosMonitor *)monitor;

@end