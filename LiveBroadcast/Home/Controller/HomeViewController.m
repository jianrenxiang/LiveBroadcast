//
//  HomeViewController.m
//  LiveBroadcast
//
//  Created by 蚁族 on 2017/4/12.
//  Copyright © 2017年 蚁族. All rights reserved.
//

#import "HomeViewController.h"
#import "LBHomeHeaderOptionalView.h"
@interface HomeViewController ()
@property(nonatomic,weak)LBHomeHeaderOptionalView *optionalView;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置导航栏
    [self setUpItems];
}

- (void)setUpItems {
    self.optionalView.titles=@[@"关注",@"附近",@"热门"];
    self.optionalView.homeHeaderOptionalViewItemClickHandle=^(LBHomeHeaderOptionalView *optionalView,NSString *title,NSInteger currentIndex){
        NSLog(@"%ld",currentIndex);
    };


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
