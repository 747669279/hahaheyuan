//
//  RKCardView.m
//  RKCard
//
//  Created by Richard Kim on 11/5/14.
//  Copyright (c) 2014 Richard Kim. All rights reserved.
//

#import "ClickLibraryCardView.h"

// Responsive view ratio values
#define CORNER_RATIO 0.015
#define CP_RATIO 0.3
#define PP_RATIO 0.147
#define PP_X_RATIO 0.01
#define PP_Y_RATIO 0.213
#define PP_BUFF 3
#define LABEL_Y_RATIO .012

@implementation ClickLibraryCardView {
    UIVisualEffectView *visualEffectView;
}
@synthesize delegate;
@synthesize profileImageView;
@synthesize coverImageView;
@synthesize titleLabel;
@synthesize likeImageView;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self setupView];
    }
    return self;
}

- (void)addShadow{
    self.layer.shadowOpacity = 0.15;
}

- (void)removeShadow{
    self.layer.shadowOpacity = 0;
}

-(void)setupView{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = self.frame.size.width * CORNER_RATIO;
    self.layer.shadowRadius = 3;
    self.layer.shadowOpacity = 0;
    self.layer.shadowOffset = CGSizeMake(1, 1);
    [self setupPhotos];
}

-(void)setupPhotos{
    CGFloat height = self.frame.size.height;
    CGFloat width = self.frame.size.width;
    UIView *cp_mask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height * CP_RATIO)];
    UIView *pp_mask = [[UIView alloc]initWithFrame:CGRectMake(width * PP_X_RATIO, height * PP_Y_RATIO, height * PP_RATIO, height *PP_RATIO)];
    UIView *pp_circle = [[UIView alloc]initWithFrame:CGRectMake(pp_mask.frame.origin.x - PP_BUFF, pp_mask.frame.origin.y - PP_BUFF, pp_mask.frame.size.width + 2* PP_BUFF, pp_mask.frame.size.height + 2*PP_BUFF)];
    pp_circle.backgroundColor = [UIColor whiteColor];
    pp_circle.layer.cornerRadius = pp_circle.frame.size.height/2;
    pp_mask.layer.cornerRadius = pp_mask.frame.size.height/2;
    cp_mask.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1];
    
//    CGFloat cornerRadius = self.layer.cornerRadius;
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cp_mask.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
//    CAShapeLayer *maskLayer = [CAShapeLayer layer];
//    maskLayer.frame = cp_mask.bounds;
//    maskLayer.path = maskPath.CGPath;
//    cp_mask.layer.mask = maskLayer;
    
    UIBlurEffect* blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    visualEffectView.frame = cp_mask.frame;
    visualEffectView.alpha = 0;
    
    profileImageView = [[UIImageView alloc]init];
    profileImageView.frame = CGRectMake(0, 0, pp_mask.frame.size.width, pp_mask.frame.size.height);
    coverImageView = [[UIImageView alloc]init];
    coverImageView.frame = cp_mask.frame;
    [coverImageView setContentMode:UIViewContentModeScaleAspectFill];
    
    [cp_mask addSubview:coverImageView];
    [pp_mask addSubview:profileImageView];
    cp_mask.clipsToBounds = YES;
    pp_mask.clipsToBounds = YES;
    
    // Setup the label
    CGFloat titleLabelX = pp_circle.frame.origin.x+pp_circle.frame.size.width;
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabelX, cp_mask.frame.size.height, self.frame.size.width - titleLabelX-80, 26)];
    titleLabel.adjustsFontSizeToFitWidth = NO;
    titleLabel.lineBreakMode = NSLineBreakByClipping;
//    [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16]];
    [titleLabel setTextColor:[UIColor colorWithWhite:0.373 alpha:1.000]];
    titleLabel.text = @"Title Label";

    likeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - 60, cp_mask.frame.size.height + 4, 30, 30)];
    
    // Register touch events on the likeImageView
    likeImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureLike =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeImageTop)];
    [likeImageView addGestureRecognizer:tapGestureLike];
    
    // Register touch events on the label
    titleLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelTap)];
    [titleLabel addGestureRecognizer:tapGesture];
    
    // Register touch events on the cover image
    coverImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureCover =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverPhotoTap)];
    [coverImageView addGestureRecognizer:tapGestureCover];

    // Register touch events on the profile imate
    profileImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureProfile =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profilePhotoTap)];
    [profileImageView addGestureRecognizer:tapGestureProfile];
    
    // building upp the views
    [self addSubview:titleLabel];
    [self addSubview:likeImageView];
    [self addSubview:cp_mask];
    [self addSubview:pp_circle];
    [self addSubview:pp_mask];
    [coverImageView addSubview:visualEffectView];
}

-(void)likeImageTop{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(likeTap)]) {
        [self.delegate likeTap];
    }
}

-(void)titleLabelTap{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(nameTap)]) {
        [self.delegate nameTap];
    }
}

-(void)coverPhotoTap{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(coverPhotoTap)]) {
        [self.delegate coverPhotoTap];
    }
}

-(void)profilePhotoTap{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(profilePhotoTap)]) {
        [self.delegate profilePhotoTap];
    }
}

-(void)addBlur{
    visualEffectView.alpha = 1;
}

-(void)removeBlur{
    visualEffectView.alpha = 0;
}

@end
