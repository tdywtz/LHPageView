//
//  LHPageView.h
//  LHLabel
//
//  Created by bangong on 16/6/30.
//  Copyright © 2016年 auto. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,LHPageViewDirection) {
    LHPageViewDirectionForward,//左侧
    LHPageViewDirectionReverse//右侧
};

@protocol LHPageViewDelegate,LHPageViewDataSource;

@interface LHPageView : UIView

@property (nonatomic,weak) id <LHPageViewDelegate> delegate;
@property (nonatomic,weak) id <LHPageViewDataSource> dataSource;
@property (nonatomic,strong,readonly) UIView *currentView;//当前显示view
@property (nonatomic,assign)          NSInteger numberOfPages;
@property (nonatomic,assign)          NSInteger currentPage;

- (instancetype)initWithFrame:(CGRect)frame space:(CGFloat)space;
- (void)setView:(UIView *)view direction:(LHPageViewDirection)direction anime:(BOOL)anime;

@end


@protocol LHPageViewDelegate <NSObject>
@optional
- (void)pageView:(LHPageView *)pageView willTransitionToView:(UIView *)pendingView;
- (void)pageView:(LHPageView *)pageView didFinishAnimating:(BOOL)finished previousView:(UIView *)previousView transitionCompleted:(BOOL)completed;

@end

@protocol LHPageViewDataSource <NSObject>
@required
- (UIView *)pageView:(LHPageView *)pageView viewBeforeView:(UIView *)view;
- (UIView *)pageView:(LHPageView *)pageViewController viewAfterView:(UIView *)view;

@optional
- (NSInteger)presentationCountForPageView:(LHPageView *)pageView; // The number of items reflected in the page indicator.
- (NSInteger)presentationIndexForPageView:(LHPageView *)pageView; // The selected item reflected in the page indicator.

@end