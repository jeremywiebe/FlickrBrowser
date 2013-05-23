//
// Created by Jeremy Wiebe on 2013-05-22.
// Copyright (c) 2013 Jeremy Wiebe. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PhotosTableViewController.h"
#import "FlickrFetcher.h"

@interface PhotosTableViewController ()

@end

@implementation PhotosTableViewController

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath)
        {
            if ([segue.identifier isEqualToString:@"Show Photo"])
            {
                NSDictionary *photo = self.photos[indexPath.row];
                if ([segue.destinationViewController respondsToSelector:@selector(setPhoto:)])
                {
                    [segue.destinationViewController performSelector:@selector(setPhoto:)
                                                          withObject:photo];
                }
            }
        }
    }
}

- (NSURL *)getPhotoUrl:(NSInteger)row format:(FlickrPhotoFormat)format
{
    return [FlickrFetcher urlForPhoto:self.photos[row] format:format];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Flickr Photo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                            forIndexPath:indexPath];

    cell.textLabel.text = [self titleForRow:indexPath.row];
    cell.detailTextLabel.text = [self subtitleForRow:indexPath.row];
    cell.imageView.image = [self imageForRow:indexPath.row format:FlickrPhotoFormatSquare];

    return cell;
}

- (NSString *)titleForRow:(NSInteger)row
{
    return self.photos[row][FLICKR_PHOTO_TITLE];
}

- (NSString *)subtitleForRow:(NSInteger)row
{
    return self.photos[row][FLICKR_PHOTO_DESCRIPTION];
}

- (UIImage *)imageForRow:(NSInteger)row format:(FlickrPhotoFormat)format
{
    NSURL *photoUrl = [self getPhotoUrl:row format:format];
    return [UIImage imageWithData:[NSData dataWithContentsOfURL:photoUrl]];
}

@end
