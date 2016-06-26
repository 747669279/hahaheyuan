//
//  ZXMovieBrowser.h
//  ZXMovieBrowser
//
//  Created by Shawn on 16/6/21.
//  Copyright © 2016年 Shawn. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ZXMovie.h"

#define kMovieBrowserHeight 300

@class ZXMovieBrowser;

@protocol ZXMovieBrowserDelegate <NSObject>

@optional

// 选中图片之后的操作
- (void)movieBrowser:(ZXMovieBrowser *)movieBrowser didSelectItemAtIndex:(NSInteger)index;
// 滚动结束的操作
- (void)movieBrowser:(ZXMovieBrowser *)movieBrowser didEndScrollingAtIndex:(NSInteger)index;
// 完成改变之后的选择和操作
- (void)movieBrowser:(ZXMovieBrowser *)movieBrowser didChangeItemAtIndex:(NSInteger)index;

@end

@interface ZXMovieBrowser : UIView

@property (nonatomic, assign, readwrite) id<ZXMovieBrowserDelegate> delegate;
@property (nonatomic, assign, readonly)  NSInteger currentIndex;

// 初始化方法
- (instancetype)initWithFrame:(CGRect)frame movies:(NSArray *)movies;
- (instancetype)initWithFrame:(CGRect)frame movies:(NSArray *)movies currentIndex:(NSInteger)index;
- (void)setCurrentMovieIndex:(NSInteger)index;

@end
