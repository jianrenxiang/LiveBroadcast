//
//  LBUtils.h
//  LiveBroadcast
//
//  Created by 蚁族 on 2017/4/13.
//  Copyright © 2017年 蚁族. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^LBRefreshAndLoadMoreHandle)(void);

@interface LBUtils : NSObject
/** 开始下拉刷新 */
+ (void)beginPullRefreshForScrollView:(UIScrollView *)scrollView;

/** 判断头部是否在刷新 */
+ (BOOL)headerIsRefreshForScrollView:(UIScrollView *)scrollView;

/** 判断是否尾部在刷新 */
+ (BOOL)footerIsLoadingForScrollView:(UIScrollView *)scrollView;

/** 提示没有更多数据的情况 */
+ (void)noticeNoMoreDataForScrollView:(UIScrollView *)scrollView;

/**   重置footer */
+ (void)resetNoMoreDataForScrollView:(UIScrollView *)scrollView;

/**  停止下拉刷新 */
+ (void)endRefreshForScrollView:(UIScrollView *)scrollView;

/**  停止上拉加载 */
+ (void)endLoadMoreForScrollView:(UIScrollView *)scrollView;

/**  隐藏footer */
+ (void)hiddenFooterForScrollView:(UIScrollView *)scrollView;

/** 隐藏header */
+ (void)hiddenHeaderForScrollView:(UIScrollView *)scrollView;
//下拉刷新
+(void)addLoadMoreForScroller:(UIScrollView*)scrollView loadMoreCallBlack:(LBRefreshAndLoadMoreHandle)loadMoreCallBackBlocak;

//上拉刷新
+(void)addPullRefreshForScroller:(UIScrollView *)scrollView pullRefreshCallBlack:(LBRefreshAndLoadMoreHandle)pullRefreshCallBackBlocak;


@end
