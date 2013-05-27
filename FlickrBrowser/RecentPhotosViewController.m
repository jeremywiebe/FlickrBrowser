//
//  RecentPhotosViewController.m
//  FlickrBrowser
//
//  Created by Jeremy Wiebe on 2013-05-22.
//  Copyright (c) 2013 Jeremy Wiebe. All rights reserved.
//

#import "RecentPhotosViewController.h"
#import "FlickrFetcher.h"

@interface RecentPhotosViewController ()

@end

@implementation RecentPhotosViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Load up recent photos viewed from isolated storage
    [self loadRecentPhotos];

    // Register to be notified when a photo is viewed
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(photoViewed:)
                                                 name:@"Photo Viewed"
                                               object:nil];
}

- (void)sortPhotos
{
    self.photos = [self.photos sortedArrayUsingComparator:^(id objA, id objB)
    {
        if ([objA isKindOfClass:[NSDictionary class]] && [objB isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *a = (NSDictionary *) objA;
            NSDictionary *b = (NSDictionary *) objB;

            return [(NSString *) a[FLICKR_PHOTO_TITLE] compare:(NSString *) b[FLICKR_PHOTO_TITLE]];
        }

        return (NSComparisonResult) NSOrderedSame;
    }];

    [self.tableView reloadData];
}

- (void)photoViewed:(NSNotification *)notification
{
    NSDictionary *viewedPhoto = (NSDictionary *)notification.userInfo[@"Photo"];
    NSUInteger photoIndex = [self.photos indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop)
    {
        NSDictionary *existingPhoto = (NSDictionary *)obj;
        return existingPhoto[FLICKR_PHOTO_ID] == viewedPhoto[FLICKR_PHOTO_ID];
    }];

    if (photoIndex == NSNotFound)
    {
        NSDictionary *newPhoto = [[NSDictionary alloc] initWithDictionary:viewedPhoto];
        self.photos = [self.photos arrayByAddingObject:newPhoto];
    }
    else
    {
        NSDictionary *existingPhoto = self.photos[photoIndex];
        [existingPhoto setValue:[NSDate date]
                         forKey:FLICKR_LAST_VIEWED];
    }

    [self saveRecentPhotos];

    [self sortPhotos];
}

- (NSString *)subtitleForRow:(NSInteger)row
{
    return self.photos[row][FLICKR_LAST_VIEWED];
}

- (void)loadRecentPhotos
{
    self.photos = [[NSUserDefaults standardUserDefaults] arrayForKey:RecentPhotosUserDefaultsKey];
    [self sortPhotos];
}

- (void)saveRecentPhotos
{
    [[NSUserDefaults standardUserDefaults] setObject:self.photos
                                              forKey:RecentPhotosUserDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
