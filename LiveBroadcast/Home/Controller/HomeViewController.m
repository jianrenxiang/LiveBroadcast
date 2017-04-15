//
//  HomeViewController.m
//  LiveBroadcast
//
//  Created by 蚁族 on 2017/4/12.
//  Copyright © 2017年 蚁族. All rights reserved.
//

#import "HomeViewController.h"
#import "LBHomeHeaderOptionalView.h"
#import "LBCustomSlideViewController.h"
#import "LBHomeBaseViewController.h"
@interface HomeViewController ()<LBCustomSliderViewControllerDelegate,LBCustomSliderViewControllerDataSouer>
@property(nonatomic,weak)LBHomeHeaderOptionalView *optionalView;
@property(nonatomic,weak)LBCustomSlideViewController *slideViewController;
@property (nonatomic, strong) NSMutableArray *controllers;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置导航栏
    [self setUpViews];
}

- (void)setUpViews {
    
    for (int i=0; i<3; i++) {
        UIViewController *homeBase=[[UIViewController alloc]init];
        if (i==0) {
            homeBase.view.backgroundColor=[UIColor yellowColor];
        }else if (i==1){
            homeBase.view.backgroundColor=[UIColor blueColor];
        }else if (i==2){
            homeBase.view.backgroundColor=[UIColor redColor];
        }
        [self.controllers addObject:homeBase];
    }
    
    WeakSelf(weakSelf);
    self.optionalView.titles=@[@"关注",@"附近",@"热门"];
    self.optionalView.homeHeaderOptionalViewItemClickHandle=^(LBHomeHeaderOptionalView *optionalView,NSString *title,NSInteger currentIndex){
        NSLog(@"%ld",currentIndex);
        weakSelf.slideViewController.seletedIndex=currentIndex;
        for (UILabel *item in self.optionalView.subviews) {
            item.font=[UIFont systemFontOfSize:17];
        }
        UILabel *item= self.optionalView.subviews[currentIndex];
        item.font=[UIFont systemFontOfSize:20];
    };
    [self.slideViewController reloadData];
}

#pragma LBCustomSliderViewControllerDelegate-dataSoure------

-(NSInteger)numberOfChildViewControllersInSlideViewController:(LBCustomSlideViewController *)slideViewController{
    return 3;
}

-(UIViewController*)slideViewController:(LBCustomSlideViewController *)slideViewCoantroller viewControllerAtIndex:(NSInteger)index{
    return self.controllers[index];
}

-(void)customSlideViewController:(LBCustomSlideViewController *)slideViewController slideOffset:(CGPoint)slideOffset{
    self.optionalView.contentOffset=slideOffset;
}

- (LBHomeHeaderOptionalView *)optionalView {
	if(_optionalView == nil) {
		LBHomeHeaderOptionalView *optional= [[LBHomeHeaderOptionalView alloc] init];
        optional.size=CGSizeMake(kScreenWidth/3*2, 44);
        self.navigationItem.titleView=optional;
        _optionalView = optional;
        optional.backgroundColor = [UIColor redColor];
	}
	return _optionalView;
}

- (LBCustomSlideViewController *)slideViewController {
	if(_slideViewController == nil) {
		LBCustomSlideViewController *slide= [[LBCustomSlideViewController alloc] init];
        [slide willMoveToParentViewController:self];
        [self addChildViewController:slide];
        [self.view addSubview:slide.view];
        slide.view.frame=CGRectMake(0, 0, kScreenWidth, kScreenHeight-49);
        slide.delegate=self;
        slide.dataSoure=self;
        _slideViewController=slide;
	}
	return _slideViewController;
}

- (NSMutableArray *)controllers {
	if(_controllers == nil) {
		_controllers = [[NSMutableArray alloc] init];
	}
	return _controllers;
}

@end
