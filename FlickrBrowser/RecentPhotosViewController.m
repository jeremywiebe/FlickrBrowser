//
//  RecentPhotosViewController.m
//  FlickrBrowser
//
//  Created by Jeremy Wiebe on 2013-05-22.
//  Copyright (c) 2013 Jeremy Wiebe. All rights reserved.
//

#import "RecentPhotosViewController.h"
#import "FlickrFetcher.h"
#import "RecentPhotosMonitor.h"
#import "FlickrBrowserAppDelegate.h"

@interface RecentPhotosViewController ()

@property(strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation RecentPhotosViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Register with monitor to receive calls when recent list changes
    FlickrBrowserAppDelegate *appDelegate = (FlickrBrowserAppDelegate *) [[UIApplication sharedApplication] delegate];
    appDelegate.monitor.delegate = self;

    // Load up recent photos viewed from isolated storage
    [self updateRecentPhotos];
}

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter)
    {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"MMM dd, yyyy 'at' HH:mm a"];
    }
    return _dateFormatter;
}

- (void)updateRecentPhotos
{
    // Talk to monitor to get the list of photos.
    FlickrBrowserAppDelegate *appDelegate = (FlickrBrowserAppDelegate *) [[UIApplication sharedApplication] delegate];

    self.photos = appDelegate.monitor.photos;
    [self sortPhotos];
}

- (void)sortPhotos
{
    self.photos = [self.photos sortedArrayUsingComparator:^(id objA, id objB)
    {
        if ([objA isKindOfClass:[NSDictionary class]] && [objB isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *a = (NSDictionary *) objA;
            NSDictionary *b = (NSDictionary *) objB;

            NSComparisonResult result = [(NSDate *) a[FLICKR_LAST_VIEWED] compare:(NSDate *) b[FLICKR_LAST_VIEWED]];
            if (result == NSOrderedAscending)
            {
                return NSOrderedDescending;
            }
            else if (result == NSOrderedDescending)
            {
                return NSOrderedAscending;
            }
            else
            {
                return result;
            }
        }

        return (NSComparisonResult) NSOrderedSame;
    }];

    [self.tableView reloadData];
}

- (NSString *)subtitleForRow:(NSInteger)row
{
    NSDate *lastViewed = self.photos[row][FLICKR_LAST_VIEWED];
    return [self.dateFormatter stringFromDate:lastViewed];
}

- (void)recentPhotoListDidChange:(RecentPhotosMonitor *)monitor
{
    [self updateRecentPhotos];
}

@end
