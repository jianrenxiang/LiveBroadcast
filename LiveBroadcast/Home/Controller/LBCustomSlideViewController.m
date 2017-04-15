//
//  LBCustomSlideViewController.m
//  LiveBroadcast
//
//  Created by 蚁族 on 2017/4/14.
//  Copyright © 2017年 蚁族. All rights reserved.
//

#import "LBCustomSlideViewController.h"

@interface LBCustomSlideViewController ()<UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableDictionary *displayVcs;
@property (nonatomic, strong) NSMutableDictionary *memoryCache;
@end

@implementation LBCustomSlideViewController

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.scrollView.frame=self.view.bounds;
    self.scrollView.contentSize=CGSizeMake(kScreenWidth*[self childViewControllerCount], self.view.height);
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


-(void)setSeletedIndex:(NSInteger)seletedIndex{
    _seletedIndex=seletedIndex;
    [self.scrollView setContentOffset:CGPointMake(kScreenWidth*seletedIndex, 0) animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)childViewControllerCount{
    if ([self.dataSoure respondsToSelector:@selector(numberOfChildViewControllersInSlideViewController:)]) {
        return [self.dataSoure numberOfChildViewControllersInSlideViewController:self];
    }
    return 0;
}

-(void)reloadData{
    [self.displayVcs removeAllObjects];
    [self.memoryCache removeAllObjects];
    for (NSInteger index=0; index<self.childViewControllers.count; index++) {
        UIViewController *viewController=self.childViewControllers[index];
        [viewController.view removeFromSuperview];
        [viewController willMoveToParentViewController:nil];
        [viewController removeFromParentViewController];
    }
    
    //?
    self.scrollView.frame = self.view.bounds;
    self.scrollView.contentSize = CGSizeMake(kScreenWidth * [self childViewControllerCount], self.scrollView.frame.size.height);
    [self scrollViewDidScroll:self.scrollView];
}

//scrollViewDelegate---
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger currentPage=scrollView.contentOffset.x/kScreenWidth;
    NSInteger start=currentPage==0?currentPage:(currentPage);
    NSInteger end=(currentPage ==[self childViewControllerCount]-1)?currentPage:(currentPage);
//    这个for循环表示的点击哪，加载哪
    for (NSInteger index=start; index<=end; index++) {
        UIViewController *viewController=[self.displayVcs objectForKey:@(index)];
        if (viewController==nil) {
            [self initializedViewControllerAtIndex:index];
        }
    }
//    删除左右两边的UIViewController
    for (NSInteger index=0; index<=start-1; index++) {
        UIViewController *viewController=[self.displayVcs objectForKey:@(index)];
        [self removmeChildViewController:viewController atIndex:index];
    }
    
    for (NSInteger index=end+1; index<=[self childViewControllerCount]-1; index++) {
        UIViewController *viewController=[self.displayVcs objectForKey:@(index)];
        [self removmeChildViewController:viewController atIndex:index];
    }
    if ([self.delegate respondsToSelector:@selector(customSlideViewController:slideOffset:)]) {
        [self.delegate customSlideViewController:self slideOffset:scrollView.contentOffset];
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(customSlideViewController:slideOffIndex:)]) {
        [self.delegate customSlideViewController:self slideOffIndex:scrollView.contentOffset.x / kScreenWidth];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(customSlideViewController:slideOffset:)]) {
        [self.delegate customSlideViewController:self slideOffset:scrollView.contentOffset];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([self.delegate respondsToSelector:@selector(customSlideViewController:slideOffset:)]) {
        [self.delegate customSlideViewController:self slideOffset:scrollView.contentOffset];
    }
}

//创建控制器
-(void)initializedViewControllerAtIndex:(NSInteger)index{
    UIViewController *viewController=[self.memoryCache objectForKey:@(index)];
    if (viewController==nil) {
        if ([self.dataSoure respondsToSelector:@selector(slideViewController:viewControllerAtIndex:)]) {
            UIViewController *viewController=[self.dataSoure slideViewController:self viewControllerAtIndex:index];
            [self addChildViewController:viewController atIndex:index];
        }
    }else{
        [self addChildViewController:viewController atIndex:index];
    }
}


// 添加控制器
- (void)addChildViewController:(UIViewController *)childController atIndex:(NSInteger)index{
    if ([self.childViewControllers containsObject:childController]) {
        return;
    }
    [self addChildViewController:childController];
    [self.displayVcs setObject:childController forKey:@(index)];
    //移动到self
    [childController didMoveToParentViewController:self];
    [self.scrollView addSubview:childController.view];
    childController.view.frame=CGRectMake(index*kScreenWidth, 0, kScreenWidth, kScreenHeight);
}
//删除控制器
-(void)removmeChildViewController:(UIViewController*)childController atIndex:(NSInteger)index{
    if (childController==nil) {
        return;
    }
    [childController.view removeFromSuperview];
    [childController willMoveToParentViewController:nil];
    [childController removeFromParentViewController];
    [self.displayVcs removeObjectForKey:@(index)];
    if (![self.memoryCache objectForKey:@(index)]) {
        [self.memoryCache setObject:childController forKey:@(index)];
    }
}

//懒加载
- (UIScrollView *)scrollView {
	if(_scrollView == nil) {
		UIScrollView *scroll= [[UIScrollView alloc] init];
        [self.view addSubview:scroll];
        _scrollView = scroll;
        scroll.delegate=self;
        scroll.showsHorizontalScrollIndicator=NO;
        scroll.showsVerticalScrollIndicator=NO;
        scroll.pagingEnabled=YES;
        scroll.bounces=NO;
	}
	return _scrollView;
}

- (NSMutableDictionary *)displayVcs {
	if(_displayVcs == nil) {
		_displayVcs = [[NSMutableDictionary alloc] init];
	}
	return _displayVcs;
}

- (NSMutableDictionary *)memoryCache {
	if(_memoryCache == nil) {
		_memoryCache = [[NSMutableDictionary alloc] init];
	}
	return _memoryCache;
}

@end
