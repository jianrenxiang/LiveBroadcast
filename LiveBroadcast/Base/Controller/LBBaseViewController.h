//
//  LBBaseViewController.h
//  LiveBroadcast
//
//  Created by 蚁族 on 2017/4/12.
//  Copyright © 2017年 蚁族. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBBaseViewController : UIViewController
/**
 *  加载中。。.
 */
-(void)showLoadingAnimation;
/**
 *  停止加载
 */
-(void)hideLoadingAnimation;
/**
 *  数据请求
 */
-(void)loadData;

@property(nonatomic,assign)BOOL isNetworkReachable;
@end
