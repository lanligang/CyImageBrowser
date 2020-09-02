//
//  CyImageBrowser.h
//  manager
//
//  Created by ios2 on 2020/8/27.
//  Copyright © 2020 CY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CyBrowerInfos.h"

NS_ASSUME_NONNULL_BEGIN

@interface CyImageBrowser : UIView

@property(nonatomic,assign)BOOL isShowInformation;                       //设置info View 的位置   图片信息

@property (nonatomic,copy)void(^makeInfoView)(UIView *infoView);         //底部详细信息的View

@property (nonatomic,copy)void(^makePageLable)(UILabel *pageLable);      //修改 pageLable 的样式 以及位置


@property (nonatomic,strong)void(^changePageFormart)(UILabel *pageLable,
											  NSInteger page,
                                             NSInteger totalCount);  //修改页码   在此方法中自定义显示格式 以及详情View 的显示样式 与否

@property (nonatomic,copy)void(^changePageInfo)(UIView *infoView,CyBrowerInfo * info); // 详细信息 修改


@property (nonatomic,strong)void(^longGestureAction)(CyBrowerInfo *info,
                                                       NSInteger page);     //长按了某个 item 在此方法中自定义处理长按

//构建方法 ---
+(instancetype)cyImageBrower;  //持有 时 不进行strong 引用
//显示方法
-(void)showBrowerInfos:(CyBrowerInfos *)browerInfos; //显示浏览详情


@end

NS_ASSUME_NONNULL_END
