//
//  LBHomeHeaderOptionalView.m
//  LiveBroadcast
//
//  Created by 蚁族 on 2017/4/14.
//  Copyright © 2017年 蚁族. All rights reserved.
//

#import "LBHomeHeaderOptionalView.h"

@interface LBHomeHeaderOptionalView ()
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation LBHomeHeaderOptionalView

-(void)setTitles:(NSArray<NSString *> *)titles{
    _titles=titles;
    if (titles.count) {
        for (int i=0; i<titles.count; i++) {
            UILabel *item=[[UILabel alloc]init];
            [self addSubview:item];
            CGFloat btnW=self.width/titles.count;
            item.frame=CGRectMake(btnW*i, 0, btnW, self.height);
            item.text=titles[i];
            item.font=[UIFont boldSystemFontOfSize:17];
            item.tag=i+1;
            item.textAlignment=NSTextAlignmentCenter;
            item.textColor=[UIColor whiteColor];
            item.userInteractionEnabled=YES;
             [item addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemTapGest:)]];
        }
    }
    
}
// 点击item执行回调
- (void)itemTapGest:(UITapGestureRecognizer *)tapGest {
    UILabel *item=(UILabel*)tapGest.view;
    if (item) {
        if (self.homeHeaderOptionalViewItemClickHandle) {
            self.homeHeaderOptionalViewItemClickHandle(self,item.text,item.tag-1);
        }
        self.currentIndex=item.tag-1;
    }

}

@end
