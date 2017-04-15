//
//  LBHomeBaseViewController.m
//  LiveBroadcast
//
//  Created by 蚁族 on 2017/4/15.
//  Copyright © 2017年 蚁族. All rights reserved.
//

#import "LBHomeBaseViewController.h"

@interface LBHomeBaseViewController ()

@end

@implementation LBHomeBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.needCellSepLine = NO;
}

- (NSInteger)nh_numberOfSections {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}


-(LBBaseTableViewCell*)lb_cellAtIndexPath:(NSIndexPath *)indexPath{
    LBBaseTableViewCell *cell=[LBBaseTableViewCell cellWithTableView:self.tableView];
    cell.backgroundColor=[UIColor redColor];
    cell.textLabel.text=@"撒规划局";
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
