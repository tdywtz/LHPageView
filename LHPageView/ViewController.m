//
//  ViewController.m
//  LHLabel
//
//  Created by bangong on 16/6/30.
//  Copyright © 2016年 auto. All rights reserved.
//

#import "ViewController.h"
#import "LHPageView.h"
#import "CCView.h"

@interface ViewController ()<LHPageViewDataSource,LHPageViewDelegate>
{
    NSMutableArray *_array;
    LHPageView *_pageView;
    NSTimer *_timer;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _array = [[NSMutableArray alloc] init];

    _pageView = [[LHPageView alloc] initWithFrame:CGRectMake(10, 100, 300, 100)];
    _pageView.backgroundColor = [UIColor lightGrayColor];
    _pageView.dataSource = self;
    _pageView.delegate = self;
    [self.view addSubview:_pageView];

    for (int i = 0; i < 3; i ++) {

        UILabel *retureview = [[UILabel alloc] init];
        CGFloat red = arc4random()%255/255.0;
        CGFloat green = arc4random()%255/255.0;
        CGFloat blue = arc4random()%255/255.0;
        retureview.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
        NSString *str = @"加载时天下我那个号";
        str = [str substringToIndex:arc4random()%8];
        retureview.text = str;
        [_array addObject:retureview];
    }

    [_pageView setView:_array[0] direction:LHPageViewDirectionReverse anime:NO];

    [self scheduledTimer];


    CCView *view = [[CCView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:view];

  
}

- (void)scheduledTimer{
     _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(time) userInfo:nil repeats:YES];
}

- (void)cancelTimer{
    [_timer invalidate];
    _timer = nil;
}

- (void)time{
    NSInteger index = [_array indexOfObject:_pageView.currentView];
    index ++;
    if (index >= _array.count) {
        index = 0;
    }
    [_pageView setView:_array[index] direction:LHPageViewDirectionReverse anime:YES];
}

- (void)pageView:(LHPageView *)pageView didFinishAnimating:(BOOL)finished previousView:(UIView *)previousView transitionCompleted:(BOOL)completed{
    if (completed) {
        //是手势拖动，重新开启
        [self scheduledTimer];
    }
}


- (UIView *)pageView:(LHPageView *)pageView viewBeforeView:(UIView *)view{

    NSInteger index = [_array indexOfObject:view];
    //关闭
    [self cancelTimer];
    index--;
    if (index >= 0) {
        return _array[index];
    }
    return nil;
}



- (UIView *)pageView:(LHPageView *)pageViewController viewAfterView:(UIView *)view{
    NSInteger index = [_array indexOfObject:view];
    index++;
    //关闭
    [self cancelTimer];
    if (index < _array.count) {
        return _array[index];
    }
    return nil;
}

- (NSInteger)presentationCountForPageView:(LHPageView *)pageView{
    return _array.count;
}

- (NSInteger)presentationIndexForPageView:(LHPageView *)pageView{

    return [_array indexOfObject:pageView.currentView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
