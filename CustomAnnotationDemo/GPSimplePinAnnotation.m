//
//  GPSimplePinAnnotation.m
//  CustomAnnotationDemo
//
//  Created by GurPreet Singh Mundi on 09/03/14.
//  Copyright (c) 2014 GurPreet. All rights reserved.
//

#import "GPSimplePinAnnotation.h"

@implementation GPSimplePinAnnotation
-(id)initWithTitle:(NSString*)title subTitle:(NSString*)subTitle cordinate:(CLLocationCoordinate2D)cordinate
{
    self = [super init];
    if (self)
    {
        title_      = title;
        subtitle_   = subTitle;
        coordinate_ = cordinate;
    }
    return self;
}
-(NSString *)title
{
    return title_;
}
-(NSString *)subtitle
{
    return subtitle_;
}
-(CLLocationCoordinate2D)coordinate
{
    return coordinate_;
}
@end
