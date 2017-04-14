//
//  LBBaseTableViewController.h
//  LiveBroadcast
//
//  Created by 蚁族 on 2017/4/13.
//  Copyright © 2017年 蚁族. All rights reserved.
//

#import "LBBaseViewController.h"
#import "LBBaseTableViewCell.h"
#import "LBBaseTableView.h"
typedef void (^LBTabelVcCellSelectedHandle)(LBBaseViewController *cell,NSIndexPath *indexPath);

typedef NS_ENUM(NSUInteger,LBBaseTableVcFreshType){
    /**
     *  无法刷新
     */
    LBBaseTableVcFreshTypeNone=0,
    /**
     *  下拉刷新
     */
    LBBaseTableVcFreshTypeOnlyCanFresh,
    /**
     *  上拉刷新
     */
    LBBaseTableVcFreshTypeOnlyCanLoadMore,
    /**
     *  上下都能刷新
     */
    LBBaseTableVcFreshTypeRefreshAndLoadMore
};


@interface LBBaseTableViewController : LBBaseViewController<UITableViewDelegate,UITableViewDataSource>{
    /**
     *  用来存储数据的
     */
    NSMutableArray *_dataArray;
}

/** 表视图偏移*/
@property (nonatomic, assign) UIEdgeInsets tableEdgeInset;

@property(nonatomic,strong)LBBaseTableView *tableView;
/**
 *  刚才执行的是否为刷新
 */
@property(nonatomic,assign)NSInteger isRefresh;
/**
 *  是否上拉加载
 */
@property(nonatomic,assign)NSInteger isLoadMore;

/** 隐藏statusBar*/
@property (nonatomic, assign) BOOL hiddenStatusBar;

/** statusBar风格*/
@property (nonatomic, assign) UIStatusBarStyle barStyle;

//是否显示刷新图片
@property (nonatomic, assign) BOOL showRefreshIcon;

/** 导航右边Item*/
@property (nonatomic, strong) UIBarButtonItem *navRightItem;

/** 导航左边Item*/
@property (nonatomic, strong) UIBarButtonItem *navLeftItem;

/** 标题*/
@property (nonatomic, copy) NSString *navItemTitle;

/** 是否需要系统的cell的分割线*/
@property (nonatomic, assign) BOOL needCellSepLine;

/** 分割线颜色*/
@property (nonatomic, assign) UIColor *sepLineColor;

/** 加载刷新类型*/
@property (nonatomic, assign) LBBaseTableVcFreshType refreshType;

/** 数据源数量*/
@property (nonatomic, strong) NSMutableArray *dataArray;

/** 是否在下拉刷新*/
@property (nonatomic, assign, readonly) BOOL isHeaderRefreshing;

/** 是否在上拉加载*/
@property (nonatomic, assign, readonly) BOOL isFooterRefreshing;

/** 刷新数据*/
- (void)lb_reloadData;
/** 开始下拉*/
- (void)lb_beginRefresh;

/** 停止刷新*/
- (void)lb_endRefresh;

/** 停止上拉加载*/
- (void)lb_endLoadMore;

/** 隐藏刷新*/
- (void)lb_hiddenRrefresh;

/** 隐藏上拉加载*/
- (void)lb_hiddenLoadMore;

/** 提示没有更多信息*/
- (void)lb_noticeNoMoreData;

/** 设置导航栏右边的item*/
- (void)lb_setUpNavRightItemTitle:(NSString *)itemTitle handle:(void(^)(NSString *rightItemTitle))handle;

/** 设置导航栏左边的item*/
- (void)lb_setUpNavLeftItemTitle:(NSString *)itemTitle handle:(void(^)(NSString *rightItemTitle))handle;

/** 监听通知*/
- (void)lb_observeNotiWithNotiName:(NSString *)notiName action:(SEL)action;

//配置数据
-(void)lb_commonConfigResponseWithResponse:(id)response isRefresh:(BOOL)isRefresh modelClass:(__weak Class)modelClass;

-(void)lb_commonConfigResponseWithResponse:(id)response isRefresh:(BOOL)isRefresh modelClass:(__weak Class)modelClass emptText:(NSString *)emptText;
/** 监听通知*/
-(void)lb_observeNotiWithNotiName:(NSString *)notiName action:(SEL)action;

#pragma mark - 子类去重写
/** 分组数量*/
- (NSInteger)lb_numberOfSections;

/** 某个分组的cell数量*/
- (NSInteger)lb_numberOfRowsInSection:(NSInteger)section;

/** 某行的cell*/
- (LBBaseTableViewCell *)lb_cellAtIndexPath:(NSIndexPath *)indexPath;

/** 点击某行*/
- (void)lb_didSelectCellAtIndexPath:(NSIndexPath *)indexPath cell:(LBBaseTableViewCell *)cell;

/** 某行行高*/
- (CGFloat)lb_cellheightAtIndexPath:(NSIndexPath *)indexPath;

/** 某个组头*/
- (UIView *)lb_headerAtSection:(NSInteger)section;

/** 某个组尾*/
- (UIView *)lb_footerAtSection:(NSInteger)section;

/** 某个组头高度*/
- (CGFloat)lb_sectionHeaderHeightAtSection:(NSInteger)section;

/** 某个组尾高度*/
- (CGFloat)lb_sectionFooterHeightAtSection:(NSInteger)section;

/** 分割线偏移*/
- (UIEdgeInsets)lb_sepEdgeInsetsAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark - 子类去继承
/** 刷新方法*/
- (void)lb_refresh;

/** 上拉加载方法*/
- (void)lb_loadMore;


- (void)endRefreshIconAnimation;

@property (nonatomic, weak, readonly) UIView *refreshHeader;



@end
