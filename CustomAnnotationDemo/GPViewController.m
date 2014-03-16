//
//  GPViewController.m
//  CustomAnnotationDemo
//
//  Created by GurPreet Singh Mundi on 09/03/14.
//  Copyright (c) 2014 GurPreet. All rights reserved.
//

#import "GPViewController.h"

typedef enum _AnnotationTag
{
    AnnotationTagWhite  = 1,
    AnnotationTagBlack  = 2,
    AnnotationTagCustom = 3
}AnnotationTag;

@interface GPViewController ()

@end

@implementation GPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Pin annotation.
    NSMutableArray *locationArray = [NSMutableArray arrayWithCapacity:0];
    [locationArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                              @"Black Pin", @"title",
                              @"This is black view with small text.", @"Subtitle",
                              [NSNumber numberWithFloat:34.655146f],  @"lat",
                              [NSNumber numberWithFloat:133.919502f], @"lon", nil]];
    [locationArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                              @"White Pin", @"title",
                              @"This is white view with large text. and this label can auto resize accorinding the length of text.", @"Subtitle",
                              [NSNumber numberWithFloat:34.755146f],  @"lat",
                              [NSNumber numberWithFloat:133.819502f], @"lon", nil]];
    [locationArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                              @"Custom View Tittle", @"title",
                              @"This is Custom view Sub Tittle.", @"Subtitle",
                              [NSNumber numberWithFloat:34.755146f],  @"lat",
                              [NSNumber numberWithFloat:133.719502f], @"lon", nil]];
    
    // Add annotations on the MapView.
    
    NSDictionary *location = locationArray[0];
    [self addAnnotationWithDictionary:location tag:AnnotationTagBlack];
    
    location = locationArray[1];
    [self addAnnotationWithDictionary:location tag:AnnotationTagWhite];
    
    location = locationArray[2];
    [self addAnnotationWithDictionary:location tag:AnnotationTagCustom];

}
-(void)addAnnotationWithDictionary:(NSDictionary*)location tag:(int)tag
{
    CLLocationCoordinate2D coordinate ;
    coordinate.latitude  = [[location objectForKey:@"lat"] floatValue];
    coordinate.longitude = [[location objectForKey:@"lon"] floatValue];
    
    GPSimplePinAnnotation *pinAnnotation = [[GPSimplePinAnnotation alloc] initWithTitle:(NSString *)[location objectForKey:@"title"] subTitle:(NSString *)[location objectForKey:@"Subtitle"] cordinate:coordinate];
    pinAnnotation.tag = tag;
    [self.mapView addAnnotation:pinAnnotation];
    self.mapView.region = MKCoordinateRegionMakeWithDistance(coordinate, 100000, 100000);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - MapView delegate.
- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id<MKAnnotation>)annotation
{
    NSString *identifier;
    
    if ([annotation isKindOfClass:[GPSimplePinAnnotation class]])
    {
        // For Simple Pin annotation.
        identifier = @"Pin";
        MKAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        annotationView.annotation = annotation;
        return annotationView;
        
        
        
    } else if ([annotation isKindOfClass:[GPCustomPinAnnotation class]])
    {
        GPCustomPinAnnotation *calloutAnnotation = (GPCustomPinAnnotation *)annotation;
        // For Custom pin annotation.
        identifier = @"Callout";
        if (calloutAnnotation.tag == AnnotationTagCustom) {
            identifier = @"Custom";
        }
        GPCustomAnnotationView *annotationView = (GPCustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];

        if (annotationView == nil) {
            annotationView = [[GPCustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier andDelegate:self];
        }
        
        if (calloutAnnotation.tag == AnnotationTagBlack) {
            annotationView.backgroundColor  = [UIColor blackColor];
            annotationView.titleTextColor   = [UIColor whiteColor];
            annotationView.subTitleTextColor = [UIColor whiteColor];
        }
        if (calloutAnnotation.tag == AnnotationTagWhite) {
            annotationView.backgroundColor  = [UIColor whiteColor];
            annotationView.titleTextColor   = [UIColor blackColor];
            annotationView.subTitleTextColor = [UIColor blackColor];
        }
        
        annotationView.showCalloutButton = YES;
        
        annotationView.title    = calloutAnnotation.title;
        annotationView.subTitle = calloutAnnotation.subtitle;
        
        // Move the display position of MapView.
        [UIView animateWithDuration:0.5f
                         animations:^(void) {
                             mapView.centerCoordinate = calloutAnnotation.coordinate;
                         }];
        
        annotationView.annotation = annotation;
        
        return annotationView;
    }
    return nil;
}
-(UIView *)CustomCalloutForAnnotation:(id<MKAnnotation>)annotation
{
    GPCustomPinAnnotation* anno = (GPCustomPinAnnotation*)annotation;
    if (anno.tag == AnnotationTagCustom)
    {
        UIView* BaseView = [[UIView alloc] init];
        BaseView.backgroundColor = [UIColor redColor];
        CGRect frame = CGRectMake(0, 0, 200, 60);
        BaseView.frame = frame;
        BaseView.layer.cornerRadius = 10.0f;
        
        UILabel* label = [[UILabel alloc] initWithFrame:BaseView.bounds];
        label.text = [NSString stringWithFormat:@"%@ \n %@",anno.title,anno.subtitle];
        label.font = [UIFont systemFontOfSize:12];
        label.numberOfLines = 5;
        label.textAlignment = NSTextAlignmentCenter;
        [BaseView addSubview:label];
        
        return BaseView;
    }
    return Nil;
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[GPSimplePinAnnotation class]]) {
        // Selected the pin annotation.
        GPSimplePinAnnotation *pinAnnotation        = ((GPSimplePinAnnotation *)view.annotation);
        GPCustomPinAnnotation *calloutAnnotation    = [[GPCustomPinAnnotation alloc] initWithAnnotation:pinAnnotation];
        
        pinAnnotation.calloutAnnotation = calloutAnnotation;
        
        [mapView addAnnotation:calloutAnnotation];
    }
}

- (void)mapView:(MKMapView *)mapView
didDeselectAnnotationView:(MKAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[GPSimplePinAnnotation class]]) {
        // Deselected the pin annotation.
        GPSimplePinAnnotation *pinAnnotation = ((GPSimplePinAnnotation *)view.annotation);
        
        [mapView removeAnnotation:pinAnnotation.calloutAnnotation];
        
        pinAnnotation.calloutAnnotation = nil;
    }  
}

#pragma mark - CalloutAnnotationViewDelegate
- (void)calloutButtonClicked:(NSString *)title
{
    NSLog(@"%@", title);
}

@end
