//
//  CyBrowerInfos.h
//  manager
//
//  Created by ios2 on 2020/8/27.
//  Copyright © 2020 CY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface CyBrowerInfo : NSObject

@property (nonatomic,strong,nullable)id image;              // image  imageName  url Data

@property (nonatomic,weak,nullable)UIView *showView;        //view 原始View

@property(nonatomic,assign,readonly)BOOL isWeb;

@property (nonatomic,strong)id imgInfo;            //图片详情  根据需求自定义

@end


@interface CyBrowerInfos : NSObject

//数组中存放的 对象
@property (nonatomic,strong)NSArray <CyBrowerInfo *>*items;
//当前的索引值
@property(nonatomic,assign)NSInteger currentIndex;

@end


NS_ASSUME_NONNULL_END