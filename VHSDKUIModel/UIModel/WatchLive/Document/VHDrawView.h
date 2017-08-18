//
//  VHWhiteBoardView.h
//  UIModel
//
//  Created by yangyang on 2017/3/13.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VHDrawView : UIView
@property(nonatomic,copy) NSString *curImageURL;//当前url
@property(nonatomic,copy) NSArray  *drawData;//绘制数据
@property(nonatomic,assign) float  scale;//绘制缩放比

- (void)updateBoard;
@end
