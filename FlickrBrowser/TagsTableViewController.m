//
// Created by Jeremy Wiebe on 2013-05-22.
// Copyright (c) 2013 Jeremy Wiebe. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TagsTableViewController.h"
#import "FlickrFetcher.h"


@interface TagsTableViewController ()

@property(strong, nonatomic) NSArray *tags; // of NSString
@property(strong, nonatomic) NSArray *photos; // of NSDictionary
@end

@implementation TagsTableViewController

- (NSArray *)tags
{
    if (!_tags) _tags = [[NSArray alloc] init];
    return _tags;
}

- (NSArray *)photos
{
    if (!_photos) _photos = [[NSArray alloc] init];
    return _photos;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Fetch data and parse out tags
    self.photos = [FlickrFetcher stanfordPhotos];
    NSMutableArray *newTags = [[NSMutableArray alloc] init];

    for (NSDictionary *item in self.photos)
    {
        NSString *tagString = item[FLICKR_TAGS];
        NSArray *splitTags = [tagString componentsSeparatedByString:@" "];

        for (NSString *tag in splitTags)
        {
            if (![newTags containsObject:tag])
            {
                [newTags addObject:tag];
            }
        }
    }

    self.tags = newTags;
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath)
        {
            if ([segue.identifier isEqualToString:@"Show Photos"])
            {
                NSString *tag = self.tags[indexPath.row];
                NSArray *taggedPhotos = [self.photos filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings)
                {
                    NSDictionary *properties = (NSDictionary *) evaluatedObject;
                    NSString *tagsAsString = properties[FLICKR_TAGS];
                    NSArray *tags = [tagsAsString componentsSeparatedByString:@" "];
                    return ([tags containsObject:tag]);
                }]];

                if ([segue.destinationViewController respondsToSelector:@selector(setPhotos:)])
                {
                    [segue.destinationViewController performSelector:@selector(setPhotos:) withObject:taggedPhotos];
                    [segue.destinationViewController setTitle:[self titleForRow:indexPath.row]];
                }
            }
        }
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tags count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Flickr Tag";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                            forIndexPath:indexPath];

    cell.textLabel.text = [self titleForRow:indexPath.row];

    return cell;
}

- (NSString *)titleForRow:(NSInteger)row
{
    return self.tags[row];
}

@end
