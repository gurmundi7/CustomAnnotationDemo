//
//  GPCustomAnnotationView.m
//  CustomAnnotationDemo
//
//  Created by GurPreet Singh Mundi on 09/03/14.
//  Copyright (c) 2014 GurPreet. All rights reserved.
//

#import "GPCustomAnnotationView.h"
#import "GPCustomPinAnnotation.h"

#pragma mark- DefaultView
@interface DefaultView : UIView
{
    UILabel *titleLabel_;
    UIButton *button_;
    UILabel* subLitleLabel_;
}
@property (nonatomic,assign) BOOL showCalloutButton;
@property (nonatomic,retain) UILabel* titleLabel_;
@property (nonatomic,retain) UILabel* subLitleLabel_;
@property (nonatomic,retain) UIButton* button_;
@end

@implementation DefaultView
@synthesize titleLabel_,button_,subLitleLabel_;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.alpha = 0.8f;
        CGRect frame_ = frame;
        frame_.size.height /= 2;
        frame_.size.height -= 50;
        self.frame = frame_;
        
        self.layer.cornerRadius = 10;
        
        self.showCalloutButton = YES;
        
        titleLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 0.0f, CGRectGetWidth(self.frame) - 10.0f, 20.0f)];
        titleLabel_.backgroundColor = [UIColor clearColor];
        titleLabel_.textAlignment = NSTextAlignmentCenter;
        titleLabel_.textColor       = [UIColor blackColor];
        titleLabel_.font = [UIFont systemFontOfSize:15];
        
        [self addSubview:titleLabel_];
        
        subLitleLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, CGRectGetHeight(titleLabel_.frame), CGRectGetWidth(self.frame) - 10.0f - CGRectGetWidth(button_.frame), CGRectGetHeight(self.frame)-CGRectGetHeight(titleLabel_.frame) - 5)];
        subLitleLabel_.backgroundColor = [UIColor clearColor];
        subLitleLabel_.textAlignment = NSTextAlignmentLeft;
        subLitleLabel_.textColor       = [UIColor blackColor];
        subLitleLabel_.font = [UIFont systemFontOfSize:12];
        subLitleLabel_.numberOfLines = 5;
        [self addSubview:subLitleLabel_];
        
        
    }
    return self;
}
-(void)addCalloutButton
{
    button_ = [UIButton buttonWithType:UIButtonTypeInfoLight] ;
    button_.center = CGPointMake(CGRectGetWidth(self.frame)- CGRectGetWidth(button_.frame), CGRectGetMidY(self.frame));
    [self addSubview:button_];
}
-(void)layoutSubviews
{
    NSLog(@"layoutSubviews");
    
    button_.center = CGPointMake(CGRectGetWidth(self.frame)- CGRectGetWidth(button_.frame), CGRectGetMidY(self.frame));
    
    titleLabel_.frame = CGRectMake(5.0f, 0.0f, CGRectGetWidth(self.frame) - 10.0f, 20.0f);
   
    CGRect frame            = CGRectZero;
    frame.origin.x          = 5.0f;
    frame.origin.y          = CGRectGetHeight(titleLabel_.frame);
    frame.size.width        = CGRectGetWidth(self.frame) - 35.0f - CGRectGetWidth(button_.frame);
    frame.size.height       = CGRectGetHeight(self.frame)-CGRectGetHeight(titleLabel_.frame)-5;

    if(!self.showCalloutButton)
        frame.size.width += 20;

    subLitleLabel_.frame    = frame;
}
-(void)setShowCalloutButton:(BOOL)showCalloutButton
{
    if (showCalloutButton)
    {
        if(!button_)[self addCalloutButton];
    }else
    {
        if(button_)
        {
            [button_ removeFromSuperview];
            button_ = Nil;
        }
    }
}
@end

#pragma mark- Custom Anotation Callout class

@interface GPCustomAnnotationView ()
/** Default view if you did not set your Customview*/
@property (nonatomic,retain) DefaultView* Defaultview_;
@end

@implementation GPCustomAnnotationView

@synthesize delegate=delegate_;

- (id)initWithAnnotation:(id<MKAnnotation>)annotation
         reuseIdentifier:(NSString *)reuseIdentifier andDelegate:(id<GPAnnotationViewDelegate>)delegate
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.delegate = delegate;
        if(self.delegate)
        {
            if ([self.delegate respondsToSelector:@selector(CustomCalloutForAnnotation:)])
            {
                self.Customview = [self.delegate CustomCalloutForAnnotation:annotation];
                self.backgroundColor = [UIColor clearColor];
                
                if (self.Customview)
                {
                    CGRect frame = self.Customview.frame;
                    frame.size.height += 50;
                    frame.size.height *= 2;
                    self.frame = frame;
                    self.backgroundColor = [UIColor blueColor];
                    [self addSubview: self.Customview];
                }

            }
        }
        if (!self.Customview) {
            self.Defaultview_ = [self defaultView];
            [self addSubview: self.Defaultview_];
        }
    }
    
    return self;
}
-(DefaultView*)defaultView
{
    self.frame = CGRectMake(0.0f, 0.0f,  (self.showCalloutButton)?250.0f:200.0f,300.0f);
    
    DefaultView* BaseView = [[DefaultView alloc] initWithFrame:self.frame];
    [BaseView.button_ addTarget:self action:@selector(calloutButtonClicked) forControlEvents:UIControlEventTouchDown];

    return BaseView;
}

-(void)setTitle:(NSString *)title
{
    _title = title;
    if(self.Defaultview_) self.Defaultview_.titleLabel_.text = title;
}
-(void)setSubTitle:(NSString *)subTitle
{
    _subTitle = subTitle;
    if(self.Defaultview_) {
     self.Defaultview_.subLitleLabel_.text = subTitle;
        
        CGRect oldframe = self.Defaultview_.subLitleLabel_.frame;
        CGRect newFrame = [self frameWithDynamicheightForText:subTitle label:self.Defaultview_.subLitleLabel_];
        CGFloat heightDiff = oldframe.size.height - newFrame.size.height;
        
        CGRect newViewFrame = self.frame;
        newViewFrame.size.height -= (heightDiff*2);
        self.frame = newViewFrame;
    }
    
}
-(void)layoutSubviews
{
    if (self.Defaultview_)
    {
        CGRect frame_ = self.Defaultview_.frame;
        frame_.size = self.frame.size;
        frame_.size.height /= 2;
        frame_.size.height -= 50;
        self.Defaultview_.frame = frame_;
    }
}
/** This will return dynamic frame according to text.*/
-(CGRect)frameWithDynamicheightForText:(NSString*)text label:(UILabel*)label_
{
    //Calculate the expected size based on the font and linebreak mode of your label
    // FLT_MAX here simply means no constraint in height
    CGSize maximumLabelSize = CGSizeMake(label_.frame.size.width, FLT_MAX);
    
    CGSize expectedLabelSize = [text sizeWithFont:label_.font constrainedToSize:maximumLabelSize lineBreakMode:label_.lineBreakMode];
    
    CGRect newFrame = label_.frame;
    newFrame.size.height = expectedLabelSize.height;
    return newFrame;
}
#pragma mark - Button clicked
- (void)calloutButtonClicked
{
    GPCustomPinAnnotation *annotation = self.annotation;
    [delegate_ calloutButtonClicked:(NSString *)annotation.title];
}
-(void)setBackgroundColor:(UIColor *)backgroundColor
{
    self.Defaultview_.backgroundColor = backgroundColor;
}
-(void)setShowCalloutButton:(BOOL)showCalloutButton
{
    self.Defaultview_.showCalloutButton = showCalloutButton;
}
-(void)setTitleTextColor:(UIColor *)titleTextColor
{
    if(self.Defaultview_)self.Defaultview_.titleLabel_.textColor = titleTextColor;
}
-(void)setSubTitleTextColor:(UIColor *)subTitleTextColor
{
    if(self.Defaultview_)self.Defaultview_.subLitleLabel_.textColor = subTitleTextColor;
}
@end
