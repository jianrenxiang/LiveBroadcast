//
//  LBBaseTableViewCell.m
//  LiveBroadcast
//
//  Created by 蚁族 on 2017/4/13.
//  Copyright © 2017年 蚁族. All rights reserved.
//

#import "LBBaseTableViewCell.h"

@implementation LBBaseTableViewCell

-(UITableView*)tableView{
    float version=[[[UIDevice currentDevice]systemVersion]floatValue];
    if (version>=7.0) {
        return (UITableView*)self.superview.superview;
    }else{
        return (UITableView*)self.superview;
    }
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor=[UIColor clearColor];
    }
    return self;
}

+(instancetype)cellWithTableView:(UITableView *)tableView{
    if (tableView==nil) {
        return [[self alloc]init];
    }
    NSString *className=NSStringFromClass([self class]);
    NSString *identifier=[className stringByAppendingString:@"cellID"];
    [tableView registerClass:[self class] forCellReuseIdentifier:identifier];
    return [tableView dequeueReusableCellWithIdentifier:identifier];
}

+ (instancetype)nibCellWithTableView:(UITableView *)tableView {
    if (tableView == nil) {
        return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    }
    NSString *classname = NSStringFromClass([self class]);
    NSString *identifier = [classname stringByAppendingString:@"nibCellID"];
    UINib *nib = [UINib nibWithNibName:classname bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:identifier];
    return [tableView dequeueReusableCellWithIdentifier:identifier];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
