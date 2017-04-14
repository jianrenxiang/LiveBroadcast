//
//  LBBaseTableHeaderFooterView.m
//  LiveBroadcast
//
//  Created by 蚁族 on 2017/4/13.
//  Copyright © 2017年 蚁族. All rights reserved.
//

#import "LBBaseTableHeaderFooterView.h"

@implementation LBBaseTableHeaderFooterView

+ (instancetype)headerFooterViewWithTableView:(UITableView *)tableView {
    if (tableView == nil) {
        return [[self alloc] init];
    }
    NSString *classname = NSStringFromClass([self class]);
    NSString *identifer = [classname stringByAppendingString:@"HeaderFooterID"];
    [tableView registerClass:[self class] forHeaderFooterViewReuseIdentifier:identifer];
    return [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifer];
}

+ (instancetype)nibHeaderFooterViewWithTableView:(UITableView *)tableView {
    if (tableView == nil) {
        return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    }
    NSString *classname = NSStringFromClass([self class]);
    NSString *identifer = [classname stringByAppendingString:@"nibHeaderFooterID"];
    UINib *nib = [UINib nibWithNibName:classname bundle:nil];
    [tableView registerNib:nib forHeaderFooterViewReuseIdentifier:identifer];
    return [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifer];
}


@end
