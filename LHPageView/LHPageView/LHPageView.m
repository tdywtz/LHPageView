
//
//  LHPageView.m
//  LHLabel
//
//  Created by bangong on 16/6/30.
//  Copyright © 2016年 auto. All rights reserved.
//

#import "LHPageView.h"

@interface LHPageScollView : UIScrollView

@end

@implementation LHPageScollView

#pragma makr - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;{

    return NO;
}

@end

@interface LHPageView ()
{
    UIView * leftView;
    UIView * mainView;
    UIView * rightView;
    
    CGFloat pageWidth;
    
    BOOL _obtainView;//是否获取view
    CGFloat elasticity;//弹性
}
@property (nonatomic,strong) UIView *currentView;//当前显示view
@property (nonatomic,strong) UIView *toView;//将要显示view
@property (nonatomic,strong) LHPageScollView *scrollView;

@end

@implementation LHPageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _init];
    }
    return self;
}

- (void)_init{
    _obtainView = YES;
    elasticity= 1;
    _scrollView = [[LHPageScollView alloc] initWithFrame:self.bounds];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _scrollView.alwaysBounceHorizontal = YES;
    _scrollView.decelerationRate = 1;

    [self addSubview:_scrollView];
    _scrollView.decelerationRate = 10;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    mainView = [[UIView alloc] initWithFrame:CGRectMake(width, 0, width, height)];
    rightView = [[UIView alloc] initWithFrame:CGRectMake(width*2, 0, width, height)];
    
    [self.scrollView addSubview:leftView];
    [self.scrollView addSubview:mainView];
    [self.scrollView addSubview:rightView];
    
    self.scrollView.contentSize = CGSizeMake(width*3, 0);
    self.scrollView.contentOffset = CGPointMake(width, 0);

    [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)]];
}

- (void)pan:(UIPanGestureRecognizer *)pan{

    CGPoint point = [pan translationInView:self];

    CGFloat _x = self.scrollView.contentOffset.x-point.x*elasticity;
    self.scrollView.contentOffset = CGPointMake(_x, 0);
    [pan setTranslation:CGPointZero inView:self];

    if (_scrollView.contentOffset.x < self.frame.size.width && _obtainView) {
        _obtainView = NO;
        _toView =  [self.dataSource pageView:self viewBeforeView:_currentView];
        _toView.frame = self.bounds;
        [leftView addSubview:_toView];

    }else if(_scrollView.contentOffset.x > self.frame.size.width && _obtainView){
        _obtainView = NO;
        _toView = [self.dataSource pageView:self viewAfterView:_currentView];
        _toView.frame = self.bounds;
        [rightView addSubview:_toView];
    }
   
    if (!_toView) {
        elasticity = (1 - fabsf(_x-self.frame.size.width)/self.frame.size.width)/3;
    }

    if (pan.state == UIGestureRecognizerStateEnded) {
        elasticity = 1;
       _obtainView = YES;
        __weak __typeof(self)weakSelf = self;
        if ((_scrollView.contentOffset.x < self.frame.size.width-20) && _toView) {

            CGFloat time = _scrollView.contentOffset.x/self.frame.size.width/5;
            [UIView animateWithDuration:time animations:^{
                [weakSelf scrollToLeftAnima:NO];
            }];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf updateMainView];
            });

        }else if((_scrollView.contentOffset.x > self.frame.size.width+20) && _toView){

            CGFloat time = (_scrollView.contentOffset.x- self.frame.size.width)/self.frame.size.width/5;
            [UIView animateWithDuration:time animations:^{
                [weakSelf scrollToRightAnima:NO];
            }];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf updateMainView];
            });
        }else{

            [self scrollToMainAnima:YES];

        }
    }else if(pan.state == UIGestureRecognizerStateBegan){
        if ([self.delegate respondsToSelector:@selector(pageView:willTransitionToView:)]) {
            [self.delegate pageView:self willTransitionToView:_currentView];
        }
    }
}

- (void)setView:(UIView *)view direction:(LHPageViewDirection)direction anime:(BOOL)anime{
    if (view.superview) {
        [view removeFromSuperview];
    }
    _toView = view;
    _toView.frame = self.bounds;

    if (direction == LHPageViewDirectionForward) {
        [leftView addSubview:_toView];
        if (anime) {
            CGFloat time =  0.18;
            __weak __typeof(self)weakSelf = self;
            [UIView animateWithDuration:time animations:^{
                [weakSelf scrollToLeftAnima:NO];
            }];
        }else{
            [self scrollToLeftAnima:NO];
        }
    }else if (direction == LHPageViewDirectionReverse){
        [rightView addSubview:_toView];
        if (anime) {
            CGFloat time =  0.18;
            __weak __typeof(self)weakSelf = self;
            [UIView animateWithDuration:time animations:^{
                [weakSelf scrollToRightAnima:NO];
            }];
        }else{
             [self scrollToRightAnima:NO];
        }
    }
    if (anime) {
        __weak __typeof(self)weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.18 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf updateMainView];
        });
    }else{
        [self updateMainView];

    }
}

- (void) scrollToLeftAnima:(BOOL)anima{
     [_scrollView setContentOffset:CGPointMake(0, 0) animated:anima];
}

- (void)scrollToRightAnima:(BOOL)anima{
    [_scrollView setContentOffset:CGPointMake(self.frame.size.width*2, 0) animated:anima];
}

- (void)scrollToMainAnima:(BOOL)anima{
     [_scrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:anima];
}

- (void)updateMainView{



    _currentView = _toView;

    if (_currentView.superview) {
        [_currentView removeFromSuperview];
    }
    [mainView addSubview:_currentView];
    [self scrollToMainAnima:NO];
    if ([self.delegate respondsToSelector:@selector(pageView:didFinishAnimating:previousView:transitionCompleted:)]) {
        [self.delegate pageView:self didFinishAnimating:YES previousView:_currentView transitionCompleted:YES];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
