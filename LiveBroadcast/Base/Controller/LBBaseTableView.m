//
//  LBBaseTableView.m
//  LiveBroadcast
//
//  Created by 蚁族 on 2017/4/13.
//  Copyright © 2017年 蚁族. All rights reserved.
//

#import "LBBaseTableView.h"

@implementation LBBaseTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if ([super initWithFrame:frame style:style]) {
        self.tableFooterView=[UIView new];
        self.backgroundColor=[UIColor whiteColor];
    }
    return self;
}

-(void)lb_registerCellClass:(Class)cellClass identifier:(NSString *)identifier{
    if (cellClass&&identifier.length) {
        [self registerClass:cellClass forCellReuseIdentifier:identifier];
    }
}

-(void)lb_registerCellNib:(Class)cellNib nibIdentifier:(NSString *)nibIdentifier{
    if (cellNib && nibIdentifier.length) {
        UINib *nib = [UINib nibWithNibName:[cellNib description] bundle:nil];
        [self registerNib:nib forCellReuseIdentifier:nibIdentifier];
    }
}

-(void)lb_registerHeaderFooterClass:(Class)headerFooterClass identifier:(NSString *)identifier{
    if (headerFooterClass && identifier.length) {
        [self registerClass:headerFooterClass forHeaderFooterViewReuseIdentifier:identifier];
    }
}

- (void)lb_registerHeaderFooterNib:(Class)headerFooterNib nibIdentifier:(NSString *)nibIdentifier {
    if (headerFooterNib && nibIdentifier.length) {
        UINib *nib = [UINib nibWithNibName:[headerFooterNib description] bundle:nil];
        [self registerNib:nib forHeaderFooterViewReuseIdentifier:nibIdentifier];
    };
}

-(void)lb_updateWithUpdateBlock:(void (^)(LBBaseTableView *))updateBlock{
    if (updateBlock) {
        [self beginUpdates];
        updateBlock(self);
        [self endUpdates];
    }
}

-(UITableViewCell*)lb_cellAtIndexPath:(NSIndexPath *)indexPath{
    if (!indexPath) return nil;
    NSInteger sectionNumber = self.numberOfSections;
    NSInteger section = indexPath.section;
    NSInteger rowNumber = [self numberOfRowsInSection:section];
    if (indexPath.section + 1 > sectionNumber || indexPath.section < 0) { // section 越界
        NSLog(@"刷新section: %ld 已经越界, 总组数: %ld", indexPath.section, sectionNumber);
        return nil;
    } else if (indexPath.row + 1 > rowNumber || indexPath.row < 0) { // row 越界
        NSLog(@"刷新row: %ld 已经越界, 总行数: %ld 所在section: %ld", indexPath.row, rowNumber, section);
        return nil;
    }
    return [self cellForRowAtIndexPath:indexPath];
}

- (void)lb_reloadSingleRowAtIndexPath:(NSIndexPath *)indexPath {
    [self lb_reloadSingleRowAtIndexPath:indexPath animation:None];
}

- (void)lb_reloadSingleRowAtIndexPath:(NSIndexPath *)indexPath animation:(LBBaseTableViewRowAnimation)animation {
    if (!indexPath) return ;
    NSInteger sectionNumber = self.numberOfSections;
    NSInteger section = indexPath.section;
    NSInteger rowNumber = [self numberOfRowsInSection:section];
    if (indexPath.section + 1 > sectionNumber || indexPath.section < 0) { // section 越界
        NSLog(@"刷新section: %ld 已经越界, 总组数: %ld", indexPath.section, sectionNumber);
    } else if (indexPath.row + 1 > rowNumber || indexPath.row < 0) { // row 越界
        NSLog(@"刷新row: %ld 已经越界, 总行数: %ld 所在section: %ld", indexPath.row, rowNumber, section);
    } else {
        [self beginUpdates];
        [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimation)animation];
        [self endUpdates];
    }
}

/** 刷新多行、动画默认*/
- (void)lb_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    [self lb_reloadRowsAtIndexPaths:indexPaths animation:None];
}
- (void)lb_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths animation:(LBBaseTableViewRowAnimation)animation {
    if (!indexPaths.count) return ;
    WeakSelf(weakSelf);
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSIndexPath class]]) {
            [weakSelf lb_reloadSingleRowAtIndexPath:obj animation:animation];
        }
    }];
}

/** 刷新某个section、动画默认*/
- (void)lb_reloadSingleSection:(NSInteger)section {
    [self lb_reloadSingleSection:section animation:None];
}
- (void)lb_reloadSingleSection:(NSInteger)section animation:(LBBaseTableViewRowAnimation)animation {
    NSInteger sectionNumber = self.numberOfSections;
    if (section + 1 > sectionNumber || section < 0) { // section越界
        NSLog(@"刷新section: %ld 已经越界, 总组数: %ld", section, sectionNumber);
    } else {
        [self beginUpdates];
        [self reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:(UITableViewRowAnimation)animation];
        [self endUpdates];
    }
}

/** 刷新多个section、动画默认*/
- (void)lb_reloadSections:(NSArray <NSNumber *>*)sections {
    [self lb_reloadSections:sections animation:None];
}
- (void)lb_reloadSections:(NSArray<NSNumber *> *)sections animation:(LBBaseTableViewRowAnimation)animation {
    if (!sections.count) return ;
    WeakSelf(weakSelf);
    [sections enumerateObjectsUsingBlock:^(NSNumber *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSNumber class]]) {
            [weakSelf lb_reloadSingleSection:obj.integerValue animation:animation];
        }
    }];
}

/** 删除单行、动画默认*/
- (void)lb_deleteSingleRowAtIndexPath:(NSIndexPath *)indexPath {
    [self lb_deleteSingleRowAtIndexPath:indexPath animation:Fade];
}
- (void)lb_deleteSingleRowAtIndexPath:(NSIndexPath *)indexPath animation:(LBBaseTableViewRowAnimation)animation {
    if (!indexPath) return ;
    NSInteger sectionNumber = self.numberOfSections;
    NSInteger section = indexPath.section;
    NSInteger rowNumber = [self numberOfRowsInSection:section];
    
    NSLog(@"sectionNumber %ld  section%ld rowNumber%ld",sectionNumber, section , rowNumber);
    if (indexPath.section + 1 > sectionNumber || indexPath.section < 0) { // section 越界
        NSLog(@"删除section: %ld 已经越界, 总组数: %ld", indexPath.section, sectionNumber);
    } else if (indexPath.row + 1 > rowNumber || indexPath.row < 0) { // row 越界
        NSLog(@"删除row: %ld 已经越界, 总行数: %ld 所在section: %ld", indexPath.row, rowNumber, section);
    } else {
        [self beginUpdates];
        [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimation)animation];
        [self endUpdates];
    }
}

/** 删除多行、动画默认*/
- (void)lb_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    [self lb_deleteRowsAtIndexPaths:indexPaths animation:Fade];
}
- (void)lb_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths animation:(LBBaseTableViewRowAnimation)animation {
    if (!indexPaths.count) return ;
    WeakSelf(weakSelf);
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSIndexPath class]]) {
            [weakSelf lb_deleteSingleRowAtIndexPath:obj animation:animation];
        }
    }];
}

/** 删除某个section、动画默认*/
- (void)lb_deleteSingleSection:(NSInteger)section {
    
    [self lb_deleteSingleSection:section animation:Fade];
}
- (void)lb_deleteSingleSection:(NSInteger)section animation:(LBBaseTableViewRowAnimation)animation {
    NSInteger sectionNumber = self.numberOfSections;
    if (section + 1 > sectionNumber || section < 0) { // section 越界
        NSLog(@"刷新section: %ld 已经越界, 总组数: %ld", section, sectionNumber);
    } else {
        [self beginUpdates];
        [self deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:(UITableViewRowAnimation)animation];
        [self endUpdates];
    }
}

/** 删除多个section*/
- (void)lb_deleteSections:(NSArray *)sections {
    [self lb_deleteSections:sections animation:Fade];
}
- (void)lb_deleteSections:(NSArray<NSNumber *> *)sections animation:(LBBaseTableViewRowAnimation)animation {
    if (!sections.count) return ;
    WeakSelf(weakSelf);
    [sections enumerateObjectsUsingBlock:^(NSNumber *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSNumber class]]) {
            [weakSelf lb_deleteSingleSection:obj.integerValue animation:animation];
        }
    }];
}

/** 增加单行 动画无*/
- (void)lb_insertSingleRowAtIndexPath:(NSIndexPath *)indexPath {
    [self lb_insertSingleRowAtIndexPath:indexPath animation:None];
}
/** 增加单行，动画自定义*/
- (void)lb_insertSingleRowAtIndexPath:(NSIndexPath *)indexPath animation:(LBBaseTableViewRowAnimation)animation {
    if (!indexPath) return ;
    NSInteger sectionNumber = self.numberOfSections;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSInteger rowNumber = [self numberOfRowsInSection:section];
    if (section > sectionNumber || section < 0) {
        // section 越界
        NSLog(@"section 越界 : %ld", section);
    } else if (row > rowNumber || row < 0) {
        NSLog(@"row 越界 : %ld", row);
    } else {
        [self beginUpdates];
        [self insertRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimation)animation];
        [self endUpdates];
    }
    
}

/** 增加单section，动画无*/
- (void)lb_insertSingleSection:(NSInteger)section {
    [self lb_insertSingleSection:section animation:None];
}
/** 增加单section，动画自定义*/
- (void)lb_insertSingleSection:(NSInteger)section animation:(LBBaseTableViewRowAnimation)animation {
    NSInteger sectionNumber = self.numberOfSections;
    if (section + 1 > sectionNumber || section < 0) {
        // section越界
        NSLog(@" section 越界 : %ld", section);
    } else {
        [self beginUpdates];
        [self insertSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:(UITableViewRowAnimation)animation];
        [self endUpdates];
    }
}

/** 增加多行，动画无*/
- (void)lb_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    [self lb_insertRowsAtIndexPaths:indexPaths animation:None];
}
/** 增加多行，动画自定义*/
- (void)lb_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths animation:(LBBaseTableViewRowAnimation)animation {
    if (indexPaths.count == 0) return ;
    WeakSelf(weakSelf);
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSIndexPath class]]) {
            [weakSelf lb_insertSingleRowAtIndexPath:obj animation:animation];
        }
    }];
}

/** 增加多section，动画无*/
- (void)lb_insertSections:(NSArray <NSNumber *>*)sections {
    [self lb_insertSections:sections animation:None];
}
/** 增加多section，动画默认*/
- (void)lb_insertSections:(NSArray <NSNumber *>*)sections animation:(LBBaseTableViewRowAnimation)animation {
    if (sections.count == 0) return ;
    WeakSelf(weakSelf);
    [sections enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSNumber class]]) {
            [weakSelf lb_insertSingleSection:obj.integerValue animation:animation];
        }
    }];
}


@end
