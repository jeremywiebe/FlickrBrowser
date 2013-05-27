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

        return (NSComparisonResult) NSOrderedSame;;
    }];

    [self.tableView reloadData];
}

- (void)photoViewed:(NSNotification *)notification
{
    if ([notification.object isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *photo = (NSDictionary *)notification.object;
        self.photos = [self.photos arrayByAddingObject:photo];

        [self saveRecentPhotos];

        [self.tableView reloadData];
    }
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
