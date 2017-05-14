//
//  CTMappAnnotationCalloutView.m
//  Community
//
//  Created by dinesh on 20/01/14.
//  Copyright (c) 2014 Community. All rights reserved.
//

#import "CTMapAnnotationCalloutView.h"
@implementation CustomCallout
-(void)customCalloutTaped:(UITapGestureRecognizer*)tap {
    CTMapAnnotationCalloutView *superView = (CTMapAnnotationCalloutView*)self.superview;
    [superView.delegate didTapCalloutAccessoryView:superView];
}
-(UIView*)container {
    UIView *container = [[UIView alloc]initWithFrame:CGRectZero];
    container.backgroundColor = [UIColor whiteColor];
    container.layer.cornerRadius = 3.0f;
//    container.layer.borderWidth = 1;
//    container.layer.borderColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.06f].CGColor;
    container.layer.shadowOffset = CGSizeMake(0, 0);
    container.layer.shadowOpacity = 1.0f;
    container.layer.shadowRadius = 1.0f;
    container.layer.shadowColor = [UIColor grayColor].CGColor;
    return container;

}
-(UILabel*)label {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.userInteractionEnabled = FALSE;
    return label;
}
-(UIImageView*)arrowImageView {
    return  [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MarkerArrow.png"]];
}
-(UIButton*)disclosureBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *btnImage  = [UIImage imageNamed:@"DetailDisclosure.png"];
    [btn setImage:btnImage forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, btnImage.size.width, btnImage.size.height);
    btn.userInteractionEnabled = FALSE;
    return btn;
}
-(id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        // Drop Arrow
        dropArrowImageView = [self arrowImageView];
        [self addSubview:dropArrowImageView];
        // container.
        labelContainer  = [self container];
        self.titleLabel = [self label]; // Lable
        [labelContainer addSubview:self.titleLabel];
        self.rightCalloutButton = [self disclosureBtn]; // Disclosure button
        [labelContainer addSubview:self.rightCalloutButton];
        [self addSubview:labelContainer];
        //
        [self bringSubviewToFront:dropArrowImageView];
        // gesture.
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(customCalloutTaped:)];
        [self addGestureRecognizer:tap];
        [labelContainer addGestureRecognizer:tap];

    }
    return self;
}
-(void)adjustSubviewsToFitWithText:(NSString*)text {
    UIFont *calloutFont = [UIFont systemFontOfSize:14.0f];
    CGSize calloutLabelSize = [text sizeWithFont:calloutFont];
    self.frame = CGRectMake(0, 0, calloutLabelSize.width+30, calloutLabelSize.height+10+dropArrowImageView.frame.size.height);
    // container.
    labelContainer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-dropArrowImageView.frame.size.height);
    // title label
    self.titleLabel.frame = CGRectMake(5, 0, calloutLabelSize.width, labelContainer.frame.size.height);
    // callout button
    self.rightCalloutButton.center = CGPointMake(labelContainer.frame.size.width-(self.rightCalloutButton.frame.size.width/2), labelContainer.frame.size.height/2);
    // drop arrow
    dropArrowImageView.center = CGPointMake(labelContainer.frame.size.width/4, self.frame.size.height-(dropArrowImageView.frame.size.height/2));
}
-(void)layoutSubviews {
    [super layoutSubviews];
    // Animate drop arrow.
    CGPoint center = dropArrowImageView.center;
    dropArrowImageView.center = CGPointMake(labelContainer.frame.size.width-(dropArrowImageView.frame.size.width/2), dropArrowImageView.center.y);
    [UIView animateWithDuration:0.3f animations:^{
        dropArrowImageView.center =  center;
    }];
}

@end
@implementation CTMapAnnotationCalloutView
@synthesize callout;
#pragma Control Methods
-(void)didTapAtMarker:(UITapGestureRecognizer*)tap {
    [self.delegate didTapMarker:self];
    [self showLabel:YES];
}
//-(void)didTapHitDetectionArea:(UITapGestureRecognizer*)tap {
//    self.didTapHitDetectionArea = YES;
////    [self.delegate didTapOnCalloutView:self];
//}
-(void)didTapOnCallout:(UITapGestureRecognizer*)tap {
    if(tap.state == UIGestureRecognizerStateEnded) {
        [self.delegate didTapCalloutAccessoryView:self];
    }
}
-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    id view = [super hitTest:point withEvent:event];
//    NSLog(@"view %@",view);
    if([view isKindOfClass:NSClassFromString(@"_MKSmallCalloutPassthroughButton")]) {
        NSLog(@"gestures %@",[view gestureRecognizers]);
        NSPredicate *predicate =[NSPredicate predicateWithFormat:@"self isKindOfClass: %@",[UITapGestureRecognizer class]];
        if([[view gestureRecognizers] filteredArrayUsingPredicate:predicate].count == 0) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapOnCallout:)];
            [view addGestureRecognizer:tap];
            [self didTapOnCallout:tap];
        }
    }
    return [super hitTest:point withEvent:event];
}
#pragma Instance Methods

-(void)setImage:(UIImage *)image withText:(NSString*)text withFlag:(BOOL)flag {
    UIFont *labelFont = [UIFont systemFontOfSize:12.0f];
    CGSize textSize = [text sizeWithFont:labelFont];
    if(textSize.width>65)
        textSize.width = 65;
    textSize.width +=5;
    textSize.height +=5;
    [callout removeFromSuperview];
    [pinImageView removeFromSuperview];
    [label removeFromSuperview];
    //    if(!label && !pinImageView) {
    
    //        callout = [[CustomCallout alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
    //        [callout adjustSubviewsToFitWithText:text];
    //        callout.titleLabel.text = text;
    //        callout.backgroundColor = [UIColor clearColor];
    //        [self addSubview:callout];
    //        callout.center = CGPointMake((callout.frame.size.width/2), callout.center.y+10);
    
    pinImageView = [[UIImageView alloc]initWithImage:image];
    pinImageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    pinImageView.userInteractionEnabled = YES;
    [self addSubview:pinImageView];
    //    pinImageView.center = CGPointMake(callout.frame.size.width/4, callout.frame.size.height+(pinImageView.frame.size.height/2));
    label = [[UILabel alloc]init];
    [label setFont:labelFont];
    label.text = text;
    [label setTextAlignment:NSTextAlignmentCenter];
    //    label.frame = CGRectMake(pinImageView.center.x, pinImageView.frame.origin.y-(textSize.height/2), textSize.width, textSize.height);
    label.frame = CGRectMake(pinImageView.center.x-15, pinImageView.frame.origin.y+textSize.height+5, textSize.width+30, textSize.height);
    label.backgroundColor = [UIColor whiteColor];
    label.layer.borderWidth = 1;
    label.clipsToBounds = YES;
    label.layer.cornerRadius = (textSize.height/3);
    label.layer.borderColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.50f].CGColor;
    label.alpha = 0.0f;
    
    if (!flag) {
        label.backgroundColor = [UIColor colorWithWhite:1.0 alpha:.5];
        label.textColor = [UIColor colorWithWhite:.0 alpha:.5];
        label.alpha = .7;
    }
    //    label.numberOfLines = 0;
    [label sizeToFit];
    CGRect rect = label.frame;
    rect.origin.x -= 3;
    rect.size.width += 4;
    label.frame = rect;
    [self addSubview:label];
    //    [self bringSubviewToFront:callout];
    [self bringSubviewToFront:label];
    // now add callout as well
    //    self.frame = CGRectMake(0, 0, callout.frame.size.width, pinImageView.frame.origin.y+pinImageView.frame.size.height);
    self.frame = CGRectMake(0, 0, pinImageView.frame.size.width, pinImageView.frame.origin.y+pinImageView.frame.size.height);
//    NSLog(@"FRAME %@",NSStringFromCGRect(self.frame));
    // gesture.
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapAtMarker:)];
    //    [pinImageView addGestureRecognizer:tap];
    //    }
    
    
    //    pinImageView.superview.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    //    [pinImageView setFrame:CGRectMake(0, 0,image.size.width,image.size.height)];
    //    [pinImageView setImage:image];
    // label frame
    //    label.frame = CGRectMake(pinImageView.center.x, -(textSize.height/2), textSize.width, textSize.height);
    //    [label setText:text];
    // annotation view frame
    //    self.frame = CGRectMake(0, 0, pinImageView.frame.size.width, pinImageView.frame.origin.y+pinImageView.frame.size.height);
//    NSLog(@"FRAME %@",NSStringFromCGRect(self.frame));
    
}

-(void)setImage:(UIImage *)image withText:(NSString*)text {
    UIFont *labelFont = [UIFont systemFontOfSize:12.0f];
    CGSize textSize = [text sizeWithFont:labelFont];
    if(textSize.width>65)
        textSize.width = 65;
    textSize.width +=5;
    textSize.height +=5;
    [callout removeFromSuperview];
    [pinImageView removeFromSuperview];
    [label removeFromSuperview];
    //    if(!label && !pinImageView) {
    
    //        callout = [[CustomCallout alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
    //        [callout adjustSubviewsToFitWithText:text];
    //        callout.titleLabel.text = text;
    //        callout.backgroundColor = [UIColor clearColor];
    //        [self addSubview:callout];
    //        callout.center = CGPointMake((callout.frame.size.width/2), callout.center.y+10);
    
    pinImageView = [[UIImageView alloc]initWithImage:image];
    pinImageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    pinImageView.userInteractionEnabled = YES;
    [self addSubview:pinImageView];
//    pinImageView.center = CGPointMake(callout.frame.size.width/4, callout.frame.size.height+(pinImageView.frame.size.height/2));
    label = [[UILabel alloc]init];
    [label setFont:labelFont];
    label.text = text;
    [label setTextAlignment:NSTextAlignmentCenter];
//    label.frame = CGRectMake(pinImageView.center.x, pinImageView.frame.origin.y-(textSize.height/2), textSize.width, textSize.height);
    label.frame = CGRectMake(pinImageView.center.x, pinImageView.frame.origin.y+textSize.height+5, textSize.width, textSize.height);
    label.backgroundColor = [UIColor whiteColor];
    label.layer.borderWidth = 1;
    label.layer.borderColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.50f].CGColor;
    label.alpha = 0.0f;
//    label.numberOfLines = 0;
    [label sizeToFit];
    [self addSubview:label];
    //    [self bringSubviewToFront:callout];
    [self bringSubviewToFront:label];
    // now add callout as well
//    self.frame = CGRectMake(0, 0, callout.frame.size.width, pinImageView.frame.origin.y+pinImageView.frame.size.height);
    self.frame = CGRectMake(0, 0, pinImageView.frame.size.width, pinImageView.frame.origin.y+pinImageView.frame.size.height);
//    NSLog(@"FRAME %@",NSStringFromCGRect(self.frame));
    // gesture.
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapAtMarker:)];
    //    [pinImageView addGestureRecognizer:tap];
    //    }
    
    
    //    pinImageView.superview.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    //    [pinImageView setFrame:CGRectMake(0, 0,image.size.width,image.size.height)];
    //    [pinImageView setImage:image];
    // label frame
    //    label.frame = CGRectMake(pinImageView.center.x, -(textSize.height/2), textSize.width, textSize.height);
    //    [label setText:text];
    // annotation view frame
    //    self.frame = CGRectMake(0, 0, pinImageView.frame.size.width, pinImageView.frame.origin.y+pinImageView.frame.size.height);
//    NSLog(@"FRAME %@",NSStringFromCGRect(self.frame));

}
-(void)showLabel:(BOOL)animated {
    if(animated) {
    [UIView animateWithDuration:0.3f animations:^{
        label.alpha = 1.0f;
    }];
    }else {
        label.alpha = 1.0f;
    }
}
-(void)hideLabel:(BOOL)animated {
    if(animated) {
    [UIView animateWithDuration:0.3f animations:^{
        label.alpha = 0.0f;
    }];
    }else
        label.alpha = 0.0f;
}
-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
