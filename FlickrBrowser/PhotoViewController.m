//
// Created by Jeremy Wiebe on 2013-05-23.
// Copyright (c) 2013 Jeremy Wiebe. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PhotoViewController.h"
#import "FlickrFetcher.h"

@interface PhotoViewController () <UIScrollViewDelegate>

@property(weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(strong, nonatomic) UIImageView *imageView;

@end

@implementation PhotoViewController

- (void)setPhoto:(NSDictionary *)photo
{
    _photo = photo;
    [self resetImage];
}

// add the image view to the scroll view's content area
// setup zooming by setting min and max zoom scale
//   and setting self to be the scroll view's delegate
// resets the image in case URL was set before outlets (e.g. scroll view) were set

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
    self.scrollView.minimumZoomScale = 0.2;
    self.scrollView.maximumZoomScale = 5.0;
    self.scrollView.delegate = self;
    [self resetImage];
}


// fetches the data from the URL
// turns it into an image
// adjusts the scroll view's content size to fit the image
// sets the image as the image view's image
- (void)resetImage
{
    if (self.scrollView)
    {
        self.scrollView.contentSize = CGSizeZero;
        self.imageView.image = nil;

        NSData *imageData = [[NSData alloc] initWithContentsOfURL:[FlickrFetcher urlForPhoto:self.photo
                                                                                      format:FlickrPhotoFormatLarge]];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        if (image)
        {
            self.scrollView.zoomScale = 1.0;
            self.scrollView.contentSize = image.size;
            self.imageView.image = image;
            self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        }
    }
}

- (UIImageView *)imageView
{
    if (!_imageView) _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    return _imageView;
}

// returns the view which will be zoomed when the user pinches
// in this case, it is the image view, obviously
// (there are no other subviews of the scroll view in its content area)
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

@end
