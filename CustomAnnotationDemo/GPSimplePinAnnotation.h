//
//  GPSimplePinAnnotation.h
//  CustomAnnotationDemo
//
//  Created by GurPreet Singh Mundi on 09/03/14.
//  Copyright (c) 2014 GurPreet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPSimplePinAnnotation : NSObject <MKAnnotation>
{
@private
    NSString *title_;
    NSString *subtitle_;
    CLLocationCoordinate2D coordinate_;
    id calloutAnnotation_;
}
// Title and subtitle for use by selection UI.
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (assign) int tag;

@property (nonatomic, retain) id calloutAnnotation;

-(id)initWithTitle:(NSString*)title subTitle:(NSString*)subTitle cordinate:(CLLocationCoordinate2D)cordinate;
@end
