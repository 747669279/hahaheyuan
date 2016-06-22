//
//  RKCardView.h
//  RKCard
//
//  Created by Richard Kim on 11/5/14.
//  Copyright (c) 2014 Richard Kim. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol RKCardViewDelegate <NSObject>

@optional

- (void)likeTap;
- (void)nameTap;
- (void)coverPhotoTap;
- (void)profilePhotoTap;

@end


@interface ClickLibraryCardView : UIView

@property (nonatomic, weak) IBOutlet id<RKCardViewDelegate> delegate;

@property (nonatomic)UIImageView *profileImageView;
@property (nonatomic)UIImageView *coverImageView;
@property (nonatomic)UILabel *titleLabel;
@property (nonatomic)UIImageView *likeImageView;

- (void)addBlur;
- (void)removeBlur;
- (void)addShadow;
- (void)removeShadow;

@end
