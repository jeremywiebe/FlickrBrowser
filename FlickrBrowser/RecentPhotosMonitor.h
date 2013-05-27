//
// Created by Jeremy Wiebe on 2013-05-27.
// Copyright (c) 2013 Jeremy Wiebe. All rights reserved.
//


#import <Foundation/Foundation.h>

@protocol PhotoViewedDelegate;

@interface RecentPhotosMonitor : NSObject

@property(nonatomic, strong) id photos;

@property(nonatomic, weak) id <PhotoViewedDelegate> delegate;

@end