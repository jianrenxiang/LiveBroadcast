//
//  LBMainTabbarViewController.m
//  LiveBroadcast
//
//  Created by 蚁族 on 2017/4/11.
//  Copyright © 2017年 蚁族. All rights reserved.
//

#import "LBMainTabbarViewController.h"
#import "LBMainNaviViewController.h"
#import "HomeViewController.h"
#import "DiscoverViewController.h"
#import "KsingViewController.h"
#import "MineViewController.h"
#import "MessageViewController.h"
#import "LBTabBar.h"
@interface LBMainTabbarViewController ()

@end

@implementation LBMainTabbarViewController
/**
 *  重复页面只加载一次
 */
+(void)initialize{
//    获取tabbaritem
    UITabBarItem *apperance=[UITabBarItem appearance];
    NSMutableDictionary *attrs=[NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName]=[UIColor redColor];
    [apperance setTitleTextAttributes:attrs forState:UIControlStateSelected];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setValue:[[LBTabBar alloc]init] forKey:@"tabBar"];
//    初始化所有控制器
    [self setUpChildViewControllers];
}

-(void)setUpChildViewControllers{
    HomeViewController *home=[[HomeViewController alloc]init];
    [self setOneChildViewController:home title:@"首页" normalImage:@"home" selectImage:@"home"];
    DiscoverViewController *discover=[[DiscoverViewController alloc]init];
    [self setOneChildViewController:discover title:@"发现" normalImage:@"discover" selectImage:@"discover_red"];
//    KsingViewController *Ksing=[[KsingViewController alloc]init];
//    [self setOneChildViewController:Ksing title:@"k歌" normalImage:@"discover" selectImage:@"discover"];
    MessageViewController *message=[[MessageViewController alloc]init];
    [self setOneChildViewController:message title:@"消息" normalImage:@"mes" selectImage:@"mes"];
    MineViewController *mine=[[MineViewController alloc]init];
    [self setOneChildViewController:mine title:@"我的" normalImage:@"me" selectImage:@"me_red"];
    
}

-(void)setOneChildViewController:(UIViewController*)vc title:(NSString *)title normalImage:(NSString *)normalImage selectImage:(NSString *)selectImage{
    vc.tabBarItem.title=title;
    vc.tabBarItem.image=[UIImage imageNamed:normalImage];
    vc.tabBarItem.selectedImage=[[UIImage imageNamed:selectImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:[[LBMainNaviViewController alloc]initWithRootViewController:vc]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
