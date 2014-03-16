//
//  GPViewController.h
//  CustomAnnotationDemo
//
//  Created by GurPreet Singh Mundi on 09/03/14.
//  Copyright (c) 2014 GurPreet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPSimplePinAnnotation.h"
#import "GPCustomPinAnnotation.h"
#import "GPCustomAnnotationView.h"

@interface GPViewController : UIViewController<MKMapViewDelegate,GPAnnotationViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
