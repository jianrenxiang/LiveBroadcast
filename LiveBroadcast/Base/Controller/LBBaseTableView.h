//
//  LBBaseTableView.h
//  LiveBroadcast
//
//  Created by 蚁族 on 2017/4/13.
//  Copyright © 2017年 蚁族. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,LBBaseTableViewRowAnimation){
    //淡入淡出
    Fade = UITableViewRowAnimationFade,
    //从右滑入
    Right = UITableViewRowAnimationRight,
    Left = UITableViewRowAnimationLeft,
    Top = UITableViewRowAnimationTop,
    Bottom = UITableViewRowAnimationBottom,
    None = UITableViewRowAnimationNone,
    Middle = UITableViewRowAnimationMiddle,
    Automatic = 100
};

@class LBBaseTableViewCell;

@interface LBBaseTableView : UITableView

-(void)lb_updateWithUpdateBlock:(void(^)(LBBaseTableView *tableView))updateBlock;

- (UITableViewCell *)lb_cellAtIndexPath:(NSIndexPath *)indexPath;

/** 注册普通的UITableViewCell*/
- (void)lb_registerCellClass:(Class)cellClass identifier:(NSString *)identifier;
/** 注册一个从xib中加载的UITableViewCell*/
- (void)lb_registerCellNib:(Class)cellNib nibIdentifier:(NSString *)nibIdentifier;
/** 注册一个普通的UITableViewHeaderFooterView*/
- (void)lb_registerHeaderFooterClass:(Class)headerFooterClass identifier:(NSString *)identifier;
/** 注册一个从xib中加载的UITableViewHeaderFooterView*/
- (void)lb_registerHeaderFooterNib:(Class)headerFooterNib nibIdentifier:(NSString *)nibIdentifier;
#pragma 以下方法自写

/** 刷新单行、动画默认*/
- (void)lb_reloadSingleRowAtIndexPath:(NSIndexPath *)indexPath;

/** 刷新单行、动画默认*/
- (void)nh_reloadSingleRowAtIndexPath:(NSIndexPath *)indexPath animation:(LBBaseTableViewRowAnimation)animation;

/** 刷新多行、动画默认*/
- (void)nh_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

/** 刷新多行、动画默认*/
- (void)nh_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths animation:(LBBaseTableViewRowAnimation)animation;

/** 刷新某个section、动画默认*/
- (void)nh_reloadSingleSection:(NSInteger)section;

/** 刷新某个section、动画自定义*/
- (void)nh_reloadSingleSection:(NSInteger)section animation:(LBBaseTableViewRowAnimation)animation;

/** 刷新多个section、动画默认*/
- (void)nh_reloadSections:(NSArray <NSNumber *>*)sections;

/** 刷新多个section、动画自定义*/
- (void)nh_reloadSections:(NSArray <NSNumber *>*)sections animation:(LBBaseTableViewRowAnimation)animation;

#pragma mark - 对cell进行删除操作
/** 删除单行、动画默认*/
- (void)lb_deleteSingleRowAtIndexPath:(NSIndexPath *)indexPath;

/** 删除单行、动画自定义*/
- (void)lb_deleteSingleRowAtIndexPath:(NSIndexPath *)indexPath animation:(LBBaseTableViewRowAnimation)animation;

/** 删除多行、动画默认*/
- (void)nh_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

/** 删除多行、动画自定义*/
- (void)nh_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths animation:(LBBaseTableViewRowAnimation)animation;

/** 删除某个section、动画默认*/
- (void)nh_deleteSingleSection:(NSInteger)section;

/** 删除某个section、动画自定义*/
- (void)nh_deleteSingleSection:(NSInteger)section animation:(LBBaseTableViewRowAnimation)animation;

/** 删除多个section*/
- (void)nh_deleteSections:(NSArray <NSNumber *>*)sections;

/** 删除多个section*/
- (void)nh_deleteSections:(NSArray <NSNumber *>*)sections animation:(LBBaseTableViewRowAnimation)animation;

#pragma mark - 对cell进行删除操作
/** 增加单行 动画无*/
- (void)nh_insertSingleRowAtIndexPath:(NSIndexPath *)indexPath;

/** 增加单行，动画自定义*/
- (void)nh_insertSingleRowAtIndexPath:(NSIndexPath *)indexPath animation:(LBBaseTableViewRowAnimation)animation;

/** 增加单section，动画无*/
- (void)nh_insertSingleSection:(NSInteger)section;

/** 增加单section，动画自定义*/
- (void)nh_insertSingleSection:(NSInteger)section animation:(LBBaseTableViewRowAnimation)animation;

/** 增加多行，动画无*/
- (void)nh_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

/** 增加多行，动画自定义*/
- (void)nh_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths animation:(LBBaseTableViewRowAnimation)animation;

/** 增加多section，动画无*/
- (void)nh_insertSections:(NSArray <NSNumber *>*)sections;

/** 增加多section，动画自定义*/
- (void)nh_insertSections:(NSArray <NSNumber *>*)sections animation:(LBBaseTableViewRowAnimation)animation;
@end
