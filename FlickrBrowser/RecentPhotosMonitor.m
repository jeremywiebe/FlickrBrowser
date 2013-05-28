//
// Created by Jeremy Wiebe on 2013-05-27.
// Copyright (c) 2013 Jeremy Wiebe. All rights reserved.
//

#import "RecentPhotosMonitor.h"
#import "FlickrFetcher.h"
#import "RecentPhotosViewController.h"

#define MAX_RECENT_PHOTOS 20

@implementation RecentPhotosMonitor

- (id)photos
{
    if (!_photos) _photos = [[NSArray alloc] init];
    return _photos;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self loadRecentPhotos];

        // Register to be notified when a photo is viewed
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(photoViewed:)
                                                     name:@"Photo Viewed"
                                                   object:nil];
    }

    return self;
}

- (void)loadRecentPhotos
{
    self.photos = [[NSUserDefaults standardUserDefaults] arrayForKey:RecentPhotosUserDefaultsKey];
}

- (void)photoViewed:(NSNotification *)notification
{
    NSDictionary *viewedPhoto = (NSDictionary *) notification.userInfo[@"Photo"];
    NSUInteger photoIndex = [self.photos indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop)
    {
        NSDictionary *existingPhoto = (NSDictionary *) obj;
        return existingPhoto[FLICKR_PHOTO_ID] == viewedPhoto[FLICKR_PHOTO_ID];
    }];

    NSMutableDictionary *historyEntry;
    if (photoIndex == NSNotFound)
    {
        historyEntry = [[NSMutableDictionary alloc] initWithDictionary:viewedPhoto];
        self.photos = [self.photos arrayByAddingObject:historyEntry];
    }
    else
    {
        // Because this list is loaded from disk, the items in it may be
        // NSDictionary's, so we have to convert it to an NSMutableDictionary
        // so that we can update the Last Viewed timestamp.
        historyEntry = self.photos[photoIndex];
        if (![historyEntry isKindOfClass:[NSMutableDictionary class]])
        {
            historyEntry = [NSMutableDictionary dictionaryWithDictionary:historyEntry];
            self.photos[photoIndex] = historyEntry;
        }
    }

    [historyEntry setObject:[NSDate date]
                     forKey:FLICKR_LAST_VIEWED];

    [self trimRecentPhotos];
    [self saveRecentPhotos];

    [self.delegate recentPhotoListDidChange:self];
}

- (void)trimRecentPhotos
{
    if ([self.photos count] > MAX_RECENT_PHOTOS)
    {
        self.photos = [self.photos sortedArrayUsingComparator:^(id a, id b)
        {
            // Sort descending.
            return [b[FLICKR_LAST_VIEWED] compare:a[FLICKR_LAST_VIEWED]];
        }];
        self.photos = [self.photos subarrayWithRange:NSMakeRange(0, MAX_RECENT_PHOTOS)];
    }
}

- (void)saveRecentPhotos
{
    [[NSUserDefaults standardUserDefaults] setObject:self.photos
                                              forKey:RecentPhotosUserDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end