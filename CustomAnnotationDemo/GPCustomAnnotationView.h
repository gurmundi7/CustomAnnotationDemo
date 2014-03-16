//
//  GPCustomAnnotationView.h
//  CustomAnnotationDemo
//
//  Created by GurPreet Singh Mundi on 09/03/14.
//  Copyright (c) 2014 GurPreet. All rights reserved.
//

#import <MapKit/MapKit.h>

#pragma mark- custom annotation
@protocol GPAnnotationViewDelegate ;
@interface GPCustomAnnotationView : MKAnnotationView
{
@private
    NSString *title_;
}
/** Use this Method to init Custom annotation*/
- (id)initWithAnnotation:(id<MKAnnotation>)annotation
         reuseIdentifier:(NSString *)reuseIdentifier andDelegate:(id<GPAnnotationViewDelegate>)delegate;
/** Title of Default view*/
@property (nonatomic, retain) NSString *title;
/** Title text color of Default view*/
@property (nonatomic, retain) UIColor *titleTextColor;
/** subTittle text color of Default view*/
@property (nonatomic, retain) UIColor *subTitleTextColor;
/** SubTitle of Default view*/
@property (nonatomic, retain) NSString *subTitle;
/** Custom view that is returned by CustomCalloutForAnnotation: */
@property (nonatomic,retain) UIView* Customview;
/** Set this bool to show and hide callout button. Default value is YES. */
@property (nonatomic, assign) BOOL showCalloutButton;
/** Delegate of Custom callout*/
@property (nonatomic, assign) id<GPAnnotationViewDelegate> delegate;

@end

#pragma mark- custom annotation delegate
@protocol GPAnnotationViewDelegate <NSObject>
@required
/** Use this method to know when callout button clicked*/
- (void)calloutButtonClicked:(NSString *)title;

@optional
/** Use this method to know use your own custom view for callout*/
-(UIView*)CustomCalloutForAnnotation:(id<MKAnnotation>)annotation;


@end
