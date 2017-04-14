//
//  LBHomeHeaderOptionalView.h
//  LiveBroadcast
//
//  Created by 蚁族 on 2017/4/14.
//  Copyright © 2017年 蚁族. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBHomeHeaderOptionalView : UIView
/**
 *  标题数组
 */
@property(nonatomic,strong)NSArray <NSString*>*titles;
/**
 *  点击item的回调
 */
@property(nonatomic,copy)void(^homeHeaderOptionalViewItemClickHandle)(LBHomeHeaderOptionalView *optionalView,NSString *title,NSInteger currentIndex);

@end
