//
//  VHDocumentView.h
//  UIModel
//
//  Created by vhall on 17/3/21.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VHDocumentView : UIImageView
@property(nonatomic,copy) NSString  *imagePath;
- (void)drawDocHandList:(NSArray*)docList whiteBoardHandList:(NSArray*)boardList;
@end
