//
//  LiveBroadcastHeader.h
//  LiveBroadcast
//
//  Created by 蚁族 on 2017/4/11.
//  Copyright © 2017年 蚁族. All rights reserved.
//

#ifndef LiveBroadcastHeader_h
#define LiveBroadcastHeader_h

/**
 *  弱指针
 */
#define WeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;

/***  普通字体 */
#define kFont(size) [UIFont systemFontOfSize:size]

/***  当前屏幕宽度 */
#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width
/***  当前屏幕高度 */
#define kScreenHeight  [[UIScreen mainScreen] bounds].size.height
//颜色
#define kRGBAColor(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define kRGBColor(r,g,b) kRGBAColor(r,g,b,1.0f)
#define kCommonBlackColor [UIColor colorWithRed:0.17f green:0.23f blue:0.28f alpha:1.00f]
#endif /* LiveBroadcastHeader_h */
