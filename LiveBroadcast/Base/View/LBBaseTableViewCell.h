//
//  LBBaseTableViewCell.h
//  LiveBroadcast
//
//  Created by 蚁族 on 2017/4/13.
//  Copyright © 2017年 蚁族. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBBaseTableViewCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

+(instancetype)nibCellWithTableView:(UITableView*)tableView;

@end
