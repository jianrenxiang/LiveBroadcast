//
//  LBTabBar.m
//  LiveBroadcast
//
//  Created by 蚁族 on 2017/4/12.
//  Copyright © 2017年 蚁族. All rights reserved.
//

#import "LBTabBar.h"

@implementation LBTabBar

-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        UIButton *KsingButton=[[UIButton alloc]init];
        [KsingButton setBackgroundImage:[UIImage imageNamed:@"k"] forState:UIControlStateNormal];
        [KsingButton setBackgroundImage:[UIImage imageNamed:@"k_red"] forState:UIControlStateHighlighted];
        [self addSubview:KsingButton];
        [KsingButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            //获取k图片的大小
            make.size.mas_equalTo([KsingButton backgroundImageForState:UIControlStateNormal].size);
        }];
        [KsingButton addTarget:self action:@selector(KsingClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)KsingClick{
    LBLog(@"k歌被点击了");
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width=self.width/5;
    int index=0;
    for (UIControl *control in self.subviews) {
        if (![control isKindOfClass:[UIControl class]]||[control isKindOfClass:[UIButton class]]) continue;
        control.width=width;
        control.x=index>1?width*(index+1):width*index;
        index++;
    }
    
}

@end
