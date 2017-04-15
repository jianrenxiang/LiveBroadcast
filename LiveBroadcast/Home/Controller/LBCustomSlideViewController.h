//
//  LBCustomSlideViewController.h
//  LiveBroadcast
//
//  Created by 蚁族 on 2017/4/14.
//  Copyright © 2017年 蚁族. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LBCustomSlideViewController;
@protocol  LBCustomSliderViewControllerDelegate  <NSObject>
@optional
//滚动偏移量
-(void)customSlideViewController:(LBCustomSlideViewController *)slideViewController slideOffset:(CGPoint)slideOffset;
-(void)customSlideViewController:(LBCustomSlideViewController *)slideViewController slideOffIndex:(NSInteger)slideIndex;
@end

@protocol LBCustomSliderViewControllerDataSouer <NSObject>

-(UIViewController*)slideViewController:(LBCustomSlideViewController*)slideViewCoantroller viewControllerAtIndex:(NSInteger)index;
-(NSInteger )numberOfChildViewControllersInSlideViewController:(LBCustomSlideViewController*)slideViewController;
@end
@interface LBCustomSlideViewController : UIViewController

@property(nonatomic,weak)id <LBCustomSliderViewControllerDelegate> delegate;
@property(nonatomic,weak)id <LBCustomSliderViewControllerDataSouer> dataSoure;
@property (nonatomic, assign) NSInteger seletedIndex;
-(void)reloadData;
@end
