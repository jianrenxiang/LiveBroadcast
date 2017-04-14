//
//  LBBaseTableViewController.m
//  LiveBroadcast
//
//  Created by 蚁族 on 2017/4/13.
//  Copyright © 2017年 蚁族. All rights reserved.
//

#import "LBBaseTableViewController.h"
#import "LBBaseTableHeaderFooterView.h"
#import <objc/runtime.h>
#import "MJExtension.h"
#import "MJRefresh.h"

const char LBBaseTableVcNavRightItemHandleKey;
const char LBBaseTableVcNavLeftItemHandleKey;

@interface LBBaseTableViewController ()

@property (nonatomic, weak) UIImageView *refreshImg;

@end



@implementation LBBaseTableViewController
@synthesize sepLineColor = _sepLineColor;
@synthesize needCellSepLine = _needCellSepLine;
@synthesize hiddenStatusBar = _hiddenStatusBar;
@synthesize navItemTitle = _navItemTitle;
@synthesize navRightItem = _navRightItem;
@synthesize navLeftItem = _navLeftItem;
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
-(LBBaseTableView*)tableView{
    if (!_tableView) {
        LBBaseTableView *table=[[LBBaseTableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [self.view addSubview:table];
        table.delegate=self;
        table.dataSource=self;
        table.backgroundColor=[UIColor whiteColor];
        table.separatorColor=[UIColor grayColor];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
}
/** 设置导航栏右边的item*/
- (void)lb_setUpNavRightItemTitle:(NSString *)itemTitle handle:(void(^)(NSString *rightItemTitle))handle {
    [self lb_setUpNavItemTitle:itemTitle handle:handle leftFlag:NO];
}
/** 设置导航栏左边的item*/
- (void)lb_setUpNavLeftItemTitle:(NSString *)itemTitle handle:(void(^)(NSString *leftItemTitle))handle {
    [self lb_setUpNavItemTitle:itemTitle handle:handle leftFlag:YES];
}


-(void)lb_navItemHandle:(UIBarButtonItem*)item{
    void (^handle)(NSString*)=objc_getAssociatedObject(self, &LBBaseTableVcNavRightItemHandleKey);
    if (handle) {
        handle(item.title);
    }
}

- (void)lb_setUpNavItemTitle:(NSString *)itemTitle handle:(void(^)(NSString *itemTitle))handle leftFlag:(BOOL)leftFlag{
    if (itemTitle.length==0||!handle) {
        if (itemTitle == nil) {
            itemTitle = @"";
        } else if ([itemTitle isKindOfClass:[NSNull class]]) {
            itemTitle = @"";
        }
         self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:itemTitle style:UIBarButtonItemStylePlain target:nil action:nil];
    }else{
        if (leftFlag) {
            objc_setAssociatedObject(self, &LBBaseTableVcNavLeftItemHandleKey, handle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:itemTitle style:UIBarButtonItemStylePlain target:self action:@selector(lb_navItemHandle:)];
        }else{
            
        }
    }
}


/** 监听通知*/
-(void)lb_observeNotiWithNotiName:(NSString *)notiName action:(SEL)action{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:action name:notiName object:nil];
}

/** 设置刷新类型*/
- (void)setRefreshType:(LBBaseTableVcFreshType)refreshType {
    _refreshType = refreshType;
    switch (refreshType) {
        case LBBaseTableVcFreshTypeNone: // 没有刷新
            break ;
        case LBBaseTableVcFreshTypeOnlyCanFresh: { // 只有下拉刷新
            [self lb_addRefresh];
        } break ;
        case LBBaseTableVcFreshTypeOnlyCanLoadMore: { // 只有上拉加载
            [self lb_addLoadMore];
        } break ;
        case LBBaseTableVcFreshTypeRefreshAndLoadMore: { // 下拉和上拉都有
            [self lb_addRefresh];
            [self lb_addLoadMore];
        } break ;
        default:
            break ;
    }
}

/** 导航栏标题*/
- (void)setNavItemTitle:(NSString *)navItemTitle {
    if ([navItemTitle isKindOfClass:[NSString class]] == NO) return ;
    if ([navItemTitle isEqualToString:_navItemTitle]) return ;
    _navItemTitle = navItemTitle.copy;
    self.navigationItem.title = navItemTitle;
}

- (NSString *)navItemTitle {
    return self.navigationItem.title;
}

/** statusBar是否隐藏*/
- (void)setHiddenStatusBar:(BOOL)hiddenStatusBar {
    _hiddenStatusBar = hiddenStatusBar;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)hiddenStatusBar {
    return _hiddenStatusBar;
}

- (void)setBarStyle:(UIStatusBarStyle)barStyle {
    if (_barStyle == barStyle) return ;
    _barStyle = barStyle;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)prefersStatusBarHidden {
    return self.hiddenStatusBar;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.barStyle;
}
- (void)setShowRefreshIcon:(BOOL)showRefreshIcon {
    _showRefreshIcon = showRefreshIcon;
    self.refreshImg.hidden = !showRefreshIcon;
}

- (UIImageView *)refreshImg {
    if (!_refreshImg) {
        UIImageView *refreshImg = [[UIImageView alloc] init];
        [self.view addSubview:refreshImg];
        _refreshImg = refreshImg;
        [self.view bringSubviewToFront:refreshImg];
        refreshImg.image = [UIImage imageNamed:@"refresh"];
        WeakSelf(weakSelf);
        [refreshImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.view).mas_offset(-15);
            make.size.mas_equalTo(CGSizeMake(44, 44));
            make.bottom.mas_equalTo(weakSelf.view).mas_offset(-20);
        }];
        refreshImg.layer.cornerRadius = 22;
        refreshImg.backgroundColor = [UIColor whiteColor];
        
        [refreshImg setTapActionWithBlock:^{
            [self startAnimation];
            [weakSelf lb_beginRefresh];
        }];
    }
    return _refreshImg;
}

- (void)startAnimation {
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1.5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    [self.refreshImg.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

/** 右边item*/
- (void)setNavRightItem:(UIBarButtonItem *)navRightItem {
    
    _navRightItem = navRightItem;
    self.navigationItem.rightBarButtonItem = navRightItem;
}

- (UIBarButtonItem *)navRightItem {
    return self.navigationItem.rightBarButtonItem;
}
/** 左边item*/
- (void)setNavLeftItem:(UIBarButtonItem *)navLeftItem {
    
    _navLeftItem = navLeftItem;
    self.navigationItem.leftBarButtonItem = navLeftItem;
}

- (UIBarButtonItem *)navLeftItem {
    return self.navigationItem.leftBarButtonItem;
}

/** 需要系统分割线*/
- (void)setNeedCellSepLine:(BOOL)needCellSepLine {
    _needCellSepLine = needCellSepLine;
    self.tableView.separatorStyle = needCellSepLine ? UITableViewCellSeparatorStyleSingleLine : UITableViewCellSeparatorStyleNone;
}

- (BOOL)needCellSepLine {
    return self.tableView.separatorStyle == UITableViewCellSeparatorStyleSingleLine;
}


/** 开始下拉*/
- (void)lb_beginRefresh {
    if (self.refreshType == LBBaseTableVcFreshTypeOnlyCanFresh || self.refreshType == LBBaseTableVcFreshTypeRefreshAndLoadMore) {
        [LBUtils beginPullRefreshForScrollView:self.tableView];
    }
}
//下拉
-(void)lb_addRefresh{
    [LBUtils addPullRefreshForScroller:self.tableView pullRefreshCallBlack:^{
        [self lb_refresh];
    }];
}
//上啦
-(void)lb_addLoadMore{
    [LBUtils addLoadMoreForScroller:self.tableView loadMoreCallBlack:^{
        [self lb_loadMore];
    }];
}

-(void)lb_refresh{
    if (self.refreshType==LBBaseTableVcFreshTypeNone||self.refreshType==LBBaseTableVcFreshTypeOnlyCanLoadMore) {
        return;
    }
    self.isRefresh=YES;
    self.isLoadMore=NO;
}

-(void)lb_loadMore{
    if (self.refreshType == LBBaseTableVcFreshTypeNone || self.refreshType == LBBaseTableVcFreshTypeOnlyCanFresh) {
        return ;
    }
    if (self.dataArray.count == 0) {
        return ;
    }
    self.isRefresh = NO;
    self.isLoadMore = YES;
}

/** 表视图偏移*/
- (void)setTableEdgeInset:(UIEdgeInsets)tableEdgeInset {
    _tableEdgeInset = tableEdgeInset;
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    [self.view layoutIfNeeded];
    [self.view setNeedsLayout];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
    [self.view sendSubviewToBack:self.tableView];
}
- (void)setSepLineColor:(UIColor *)sepLineColor {
    if (!self.needCellSepLine) return;
    _sepLineColor = sepLineColor;
    
    if (sepLineColor) {
        self.tableView.separatorColor = sepLineColor;
    }
}

- (UIColor *)sepLineColor {
    return _sepLineColor ? _sepLineColor : [UIColor whiteColor];
}

/** 刷新数据*/
- (void)lb_reloadData {
    [self.tableView reloadData];
}

#pragma ---数据配置---

-(void)lb_commonConfigResponseWithResponse:(id)response isRefresh:(BOOL)isRefresh modelClass:(__weak Class)modelClass{
    [self lb_commonConfigResponseWithResponse:response isRefresh:isRefresh modelClass:modelClass emptText:nil];
}

-(void)lb_commonConfigResponseWithResponse:(id)response isRefresh:(BOOL)isRefresh modelClass:(__weak Class)modelClass emptText:(NSString *)emptText{
    if ([response isKindOfClass:[NSArray class]]==NO)return;
    if (self.isRefresh) {
        [self lb_endRefresh];
        [self.dataArray removeAllObjects];
        self.dataArray =[modelClass mj_objectArrayWithKeyValuesArray:response];
        // 刷新界面
        [self lb_reloadData];
    }else{
        // 停止上拉
        [self lb_endLoadMore];
        
        // 没有数据提示没有更多了
        if ([response count] == 0) {
            [self lb_noticeNoMoreData];
        } else {
            
            // 设置模型数组
            NSArray *newModels = [modelClass mj_objectArrayWithKeyValuesArray:response];
            if (newModels.count < 50) {
                [self lb_hiddenLoadMore];
            }
            [self.dataArray addObjectsFromArray:newModels];
            
            // 刷新界面
            [self lb_reloadData];

    }
    }
    
}

/** 停止刷新*/
- (void)lb_endRefresh {
    if (self.refreshType == LBBaseTableVcFreshTypeOnlyCanFresh || self.refreshType == LBBaseTableVcFreshTypeRefreshAndLoadMore) {
        [LBUtils endRefreshForScrollView:self.tableView];
    }
}

/** 停止上拉加载*/
- (void)lb_endLoadMore {
    if (self.refreshType == LBBaseTableVcFreshTypeOnlyCanFresh || self.refreshType == LBBaseTableVcFreshTypeRefreshAndLoadMore) {
        [LBUtils endLoadMoreForScrollView:self.tableView];
    }
}

/** 隐藏刷新*/
- (void)lb_hiddenRrefresh {
    if (self.refreshType == LBBaseTableVcFreshTypeOnlyCanFresh || self.refreshType == LBBaseTableVcFreshTypeRefreshAndLoadMore) {
        [LBUtils hiddenHeaderForScrollView:self.tableView];
    }
}

/** 隐藏上拉加载*/
- (void)lb_hiddenLoadMore {
    if (self.refreshType == LBBaseTableVcFreshTypeOnlyCanLoadMore || self.refreshType == LBBaseTableVcFreshTypeRefreshAndLoadMore) {
        [LBUtils hiddenFooterForScrollView:self.tableView];
    }
}

/** 提示没有更多信息*/
- (void)lb_noticeNoMoreData {
    if (self.refreshType == LBBaseTableVcFreshTypeOnlyCanLoadMore || self.refreshType == LBBaseTableVcFreshTypeRefreshAndLoadMore) {
        [LBUtils noticeNoMoreDataForScrollView:self.tableView];
    }
}

/** 头部正在刷新*/
- (BOOL)isHeaderRefreshing {
    return [LBUtils headerIsRefreshForScrollView:self.tableView];
}

//* 尾部正在刷新
- (BOOL)isFooterRefreshing {
    return [LBUtils footerIsLoadingForScrollView:self.tableView];
}


#pragma mark - <UITableViewDataSource, UITableViewDelegate>
// 分组数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self respondsToSelector:@selector(lb_numberOfSections)]) {
        return self.lb_numberOfSections;
    }
    return 0;
}

// 指定组返回的cell数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self respondsToSelector:@selector(lb_numberOfRowsInSection:)]) {
        return [self lb_numberOfRowsInSection:section];
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([self respondsToSelector:@selector(lb_headerAtSection:)]) {
        return [self lb_headerAtSection:section];
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if ([self respondsToSelector:@selector(lb_footerAtSection:)]) {
        return [self lb_footerAtSection:section];
    }
    return nil;
}

// 每一行返回指定的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self respondsToSelector:@selector(lb_cellAtIndexPath:)]) {
        return [self lb_cellAtIndexPath:indexPath];
    }
    // 1. 创建cell
    LBBaseTableViewCell *cell = [LBBaseTableViewCell cellWithTableView:self.tableView];
    
    // 2. 返回cell
    return cell;
}

// 点击某一行 触发的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LBBaseTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([self respondsToSelector:@selector(lb_didSelectCellAtIndexPath:cell:)]) {
        [self lb_didSelectCellAtIndexPath:indexPath cell:cell];
    }
}

- (UIView *)refreshHeader {
    return self.tableView.mj_header;
}

// 设置分割线偏移间距并适配
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.needCellSepLine) return ;
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    if ([self respondsToSelector:@selector(lb_sepEdgeInsetsAtIndexPath:)]) {
        edgeInsets = [self lb_sepEdgeInsetsAtIndexPath:indexPath];
    }
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) [tableView setSeparatorInset:edgeInsets];
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) [tableView setLayoutMargins:edgeInsets];
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) [cell setSeparatorInset:edgeInsets];
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) [cell setLayoutMargins:edgeInsets];
}

// 每一行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self respondsToSelector:@selector(lb_cellheightAtIndexPath:)]) {
        return [self lb_cellheightAtIndexPath:indexPath];
    }
    return tableView.rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self respondsToSelector:@selector(lb_sectionHeaderHeightAtSection:)]) {
        return [self lb_sectionHeaderHeightAtSection:section];
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([self respondsToSelector:@selector(lb_sectionFooterHeightAtSection:)]) {
        return [self lb_sectionFooterHeightAtSection:section];
    }
    return 0.01;
}

- (NSInteger)lb_numberOfSections { return 0; }

- (NSInteger)lb_numberOfRowsInSection:(NSInteger)section { return 0; }

- (UITableViewCell *)lb_cellAtIndexPath:(NSIndexPath *)indexPath { return [LBBaseTableViewCell cellWithTableView:self.tableView]; }

- (CGFloat)lb_cellheightAtIndexPath:(NSIndexPath *)indexPath { return 0; }

- (void)lb_didSelectCellAtIndexPath:(NSIndexPath *)indexPath cell:(LBBaseTableViewCell *)cell { }

- (UIView *)lb_headerAtSection:(NSInteger)section { return [LBBaseTableHeaderFooterView headerFooterViewWithTableView:self.tableView]; }

- (UIView *)lb_footerAtSection:(NSInteger)section { return [LBBaseTableHeaderFooterView headerFooterViewWithTableView:self.tableView]; }

- (CGFloat)lb_sectionHeaderHeightAtSection:(NSInteger)section { return 0.01; }

- (CGFloat)lb_sectionFooterHeightAtSection:(NSInteger)section { return 0.01; }

- (UIEdgeInsets)lb_sepEdgeInsetsAtIndexPath:(NSIndexPath *)indexPath { return UIEdgeInsetsMake(0, 15, 0, 0); }

- (void)dealloc { [[NSNotificationCenter defaultCenter] removeObserver:self]; }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)endRefreshIconAnimation {
    [self.refreshImg.layer removeAnimationForKey:@"rotationAnimation"];
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
