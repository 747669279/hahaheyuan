//
//  PeopleView.m
//  XinMinClub
//
//  Created by 杨科军 on 16/6/24.
//  Copyright © 2016年 yangkejun. All rights reserved.
//

#import "PeopleView.h"
#import "ZXMovieBrowser.h"
#import "NineGridView.h"

@interface PeopleView()<ZXMovieBrowserDelegate>

@property (nonatomic, strong, readwrite) ZXMovieBrowser *movieBrowser;
//@property (nonatomic, strong, readwrite) UILabel *titileLabel;
@property (nonatomic, strong, readwrite) NSMutableArray *movies;
@property (nonatomic, strong, readwrite) NSArray *name;

@end

@implementation PeopleView

-(id)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        NSMutableArray *movies = [NSMutableArray array];
        UIImage *i1=[UIImage imageNamed:@"xiao1"];
        UIImage *i2=[UIImage imageNamed:@"xiao3"];
        UIImage *i3=[UIImage imageNamed:@"xiao2"];
        [movies addObject:i1];
        [movies addObject:i2];
        [movies addObject:i3];
        self.movies = movies;
        self.name=@[@"儒",@"释",@"道"];
        
        [self addSubview:self.movieBrowser];
        
//        UILabel *titileLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, movieBrowser.frame.size.height-50, SCREEN_WIDTH, 50)];
//        titileLabel.textAlignment = NSTextAlignmentCenter;
//        titileLabel.textColor = [UIColor blackColor];
//        titileLabel.font = [UIFont systemFontOfSize:15];
//        [movieBrowser addSubview:titileLabel];
//        self.titileLabel = titileLabel;
    }
    return self;
}

- (ZXMovieBrowser*)movieBrowser{
    if (!_movieBrowser) {
        _movieBrowser = [[ZXMovieBrowser alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.bounds.size.height) movies:self.movies currentIndex:1];
        _movieBrowser.delegate = self;
    }
    return _movieBrowser;
}

#pragma mark - ZXMovieBrowserDelegate
- (void)movieBrowser:(ZXMovieBrowser *)movieBrowser didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"跳转到九宫格!!!");
    [self.movieBrowser removeFromSuperview];
    NineGridView *nv = [[NineGridView alloc]initWithFrame:self.bounds];
    nv.backgroundColor=[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.95];
    nv.isPeople=index;
    [self addSubview:nv];
}
- (void)movieBrowser:(ZXMovieBrowser *)movieBrowser didChangeItemAtIndex:(NSInteger)index{
    NSLog(@"index: %ld", (long)index);
//    self.titileLabel.text=self.name[index];
}

static NSInteger _lastIndex = -1;
- (void)movieBrowser:(ZXMovieBrowser *)movieBrowser didEndScrollingAtIndex:(NSInteger)index{
    if (_lastIndex != index) {
        //        NSLog(@"刷新---%@", ((ZXMovie *)self.movies[index]).name);
        NSLog(@"刷新---%@", self.name[index]);
    }
    _lastIndex = index;
}


@end
