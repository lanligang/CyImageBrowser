//
//  CyImageBrowser.m
//  manager
//
//  Created by ios2 on 2020/8/27.
//  Copyright © 2020 CY. All rights reserved.
//


#import "CYBrowerMacro.h"
#import "CyImageBrowser.h"
#import "CyBrowerCell.h"

static NSString *_browImgViewCellIdentifier = @"browImgViewCell";

static float info_defaultHeight = 120.0;                             // 详情的默认高度 可以 在外部进行单独修改 infoView.frame

@interface CyImageBrowser()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)UICollectionView *browerCollectionView;  //浏览器
@property (nonatomic,strong)UILabel *pageLable;                      //页码标签
@property (nonatomic,strong)NSMutableArray *dataSource;              //数据源
@property (nonatomic,strong)UIImageView *animationImgView;           //动画执行文件
@property(nonatomic,weak)UIView * pageOriginalView;                  //原始的View
@property(nonatomic,assign)NSInteger currentPage;                    //当前页码数
@property(nonatomic,assign)CGPoint begain_center;                    //启动时候的中心点坐标
@property (nonatomic,strong)UIView *infoView;                        //主要用于图片信息加载的View

@end

@implementation CyImageBrowser

#pragma mark - struct method - 构造方法
-(instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self configerUI];
		UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(onPanGusture:)];
		[self addGestureRecognizer:pan];
	}
	return self;
}
#pragma mark - init UI
-(void)configerUI {
	self.browerCollectionView.frame = self.bounds;
	self.pageLable.text = @"-/-";
}
#pragma mark - panGusture target method
-(void)onPanGusture:(UIPanGestureRecognizer *)pan {
	CGPoint p = [pan translationInView:self.superview];
	CGPoint targetPoint = CGPointMake(self.begain_center.x + p.x, self.begain_center.y + p.y);
	CGFloat changeY =  MAX(0,(targetPoint.y - self.begain_center.y)/targetPoint.y);
	CGFloat scale = 1 - changeY;
	scale = MAX(0.4, scale);
	if (pan.state == UIGestureRecognizerStateBegan) {
		self.begain_center = self.center;
	}else if(pan.state == UIGestureRecognizerStateChanged){
		self.center = targetPoint;
		self.transform = CGAffineTransformMakeScale(scale,scale);
		self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:scale];
	}else{
		if (scale < 0.75) {
			[self siglTapDismiss];  //消失----
		}else{
			[UIView animateWithDuration:0.2 animations:^{
				self.transform = CGAffineTransformMakeScale(1.0,1.0);
				self.center = self.begain_center;
				self.backgroundColor = [UIColor blackColor];
			}];
		}
	}
}

#pragma mark - override method
-(void)willMoveToSuperview:(UIView *)newSuperview {
	[super willMoveToSuperview:newSuperview];
	if (newSuperview) {
		!_makePageLable?:_makePageLable(self.pageLable);
		!_makeInfoView?:_makeInfoView(self.infoView);
		//只修改一次 保证 无论 block 使用 strong 还是weak  防止循环引用问题
		_makePageLable = nil;
		_makeInfoView = nil;
	}
}

#pragma mark - protocol method   协议方法

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return  self.dataSource.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	CyBrowerCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:_browImgViewCellIdentifier forIndexPath:indexPath];
	item.backgroundColor = [UIColor clearColor];
	[item configerModel:self.dataSource[indexPath.row]];
	__weak typeof(self)weakSelf = self;

	[item setSingleGustureTap:^{
		[weakSelf siglTapDismiss]; //单击手势
	}];

	[item setLongGustureAction:^(id  _Nonnull sender) {
		NSLog(@"用户正在长按-> 如果想继续使用请在下面位置处理   longGestureAction 代码块处理！");
		!weakSelf.longGestureAction?:weakSelf.longGestureAction(weakSelf.dataSource[weakSelf.currentPage],weakSelf.currentPage);
	}];

	return item;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
	CGPoint p = CGPointMake(scrollView.contentOffset.x + CGRectGetWidth(scrollView.frame)/2.0, CGRectGetHeight(scrollView.frame)/2.0);
	NSIndexPath * indexPath =  [self.browerCollectionView indexPathForItemAtPoint:p];
	if (indexPath) {
		self.currentPage = indexPath.row;
	}
}

#pragma mark target method -
-(void)siglTapDismiss {
	[self dismiss];
}
#pragma mark - public method
#pragma mark  ----  构造方法
+(instancetype)cyImageBrower {
	CyImageBrowser *brower = [[CyImageBrowser alloc]initWithFrame:CGRectMake(0, 0, CY_BROWER_W, CY_BROWER_H)];
	return brower;
}
#pragma mark - 显示到 window 上
-(void)showBrowerInfos:(CyBrowerInfos *)browerInfos {
	NSArray *windows = [UIApplication sharedApplication].windows;
	UIWindow *window = windows.firstObject;
	[window addSubview:self];
	[self.dataSource removeAllObjects];
	if (browerInfos.items) {
		[self.dataSource addObjectsFromArray:browerInfos.items];
	}
	__weak typeof(self)weakSelf = self;
	NSInteger currentPage = browerInfos.currentIndex;
	UIView *showView = [self.dataSource[currentPage] showView];
	self.browerCollectionView.alpha = 0;
	if (showView) {
		UIImageView *animationImgView = [UIImageView new];
		animationImgView.image =  [self imageFromView:showView];
		animationImgView.contentMode = showView.contentMode;
		animationImgView.frame = [self getRectFromWindow:showView];//读取到位置
		CGFloat showView_w = CGRectGetWidth(animationImgView.bounds);
		CGFloat showView_h = CGRectGetHeight(animationImgView.bounds);
		//结束的位置
		CGRect endFrame = CGRectMake((CY_BROWER_W - showView_w )/2.0, (CY_BROWER_H - showView_h)/2.0, showView_w, showView_h);
		self.backgroundColor = [UIColor clearColor];
		[self addSubview:animationImgView];
		self.animationImgView = animationImgView;
		[UIView animateWithDuration:0.5 animations:^{
			animationImgView.frame = endFrame;
			self.backgroundColor = [UIColor blackColor];
		} completion:^(BOOL finished) {
			if (finished) {
				[UIView animateWithDuration:0.5 animations:^{
					self.browerCollectionView.alpha = 1;
					animationImgView.transform = CGAffineTransformMakeScale(1.5, 1.5);
					animationImgView.alpha = 0;
				}];
			}
		}];
	}else{
		[UIView animateWithDuration:0.3 animations:^{
			self.browerCollectionView.alpha = 1.0;
			self.backgroundColor = [UIColor blackColor];
		}];
	}

	[self.browerCollectionView performBatchUpdates:^{
	} completion:^(BOOL finished) {
		if (weakSelf.dataSource.count > 0) {
			NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentPage inSection:0];
			[weakSelf.browerCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:(UICollectionViewScrollPositionCenteredHorizontally) animated:NO];
			weakSelf.currentPage = indexPath.row;
			weakSelf.infoView.hidden = weakSelf.isShowInformation?NO:YES; //是否显示 ——> 详情
		}
	}];

}

-(void)dismiss
{
	[self removeFromSuperview]; //临时的一个 消失方法
}
#pragma mark - getter ---
-(UICollectionView *)browerCollectionView {
	if (!_browerCollectionView) {
		UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
		layout.minimumLineSpacing = CGFLOAT_MIN;
		layout.minimumInteritemSpacing = CGFLOAT_MIN;
		layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
		layout.itemSize = CGSizeMake(CY_BROWER_W, CY_BROWER_H);
		_browerCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
		_browerCollectionView.backgroundColor = [UIColor clearColor];
		[_browerCollectionView registerClass:[CyBrowerCell class] forCellWithReuseIdentifier:_browImgViewCellIdentifier];
		_browerCollectionView.delegate  = self;
		_browerCollectionView.dataSource = self;
		_browerCollectionView.pagingEnabled = YES;
		[self addSubview:_browerCollectionView];//添加到 View 上
	 }
	return _browerCollectionView;
}
//页码标签
-(UILabel *)pageLable {
	if (!_pageLable) {
		_pageLable = [[UILabel alloc]init];
		_pageLable.textColor = [UIColor whiteColor];
		_pageLable.font = [UIFont systemFontOfSize:14.0];
		_pageLable.textAlignment = NSTextAlignmentCenter;
		CGFloat y = 0;
		if (@available(iOS 13.0,*)) {
			UIWindow *window = (UIWindow *)[UIApplication sharedApplication].windows.firstObject;
			y = CGRectGetHeight(window.windowScene.statusBarManager.statusBarFrame);
		}else{
			y =  CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
		}
		_pageLable.frame = CGRectMake(0, y, CY_BROWER_W, 25);
		[self addSubview:_pageLable];
	 }
	return _pageLable;
}
//数据源--
-(NSMutableArray *)dataSource {
	if (!_dataSource) {
		_dataSource = [[NSMutableArray alloc]init];
	 }
	return _dataSource;
}

//描绘图片内容的View
-(UIView *)infoView {
	if (!_infoView) {
		_infoView = [[UIView alloc]init];
		_infoView.hidden = self.isShowInformation?NO:YES;
		[self addSubview:_infoView];
		_infoView.userInteractionEnabled = NO; //只是显示 不做任何的 交互
		_infoView.frame = (CGRect) {
			0,CY_BROWER_H - info_defaultHeight, /*   x   ,   y  */
			CY_BROWER_W,info_defaultHeight      /* width , height  */
		};
	 }
	return _infoView;
}

#pragma mark - setter

-(void)setCurrentPage:(NSInteger)currentPage {
	_currentPage = currentPage;
	NSInteger totalCount = self.dataSource.count;
	if (_changePageFormart) {
		_changePageFormart(self.pageLable,_currentPage,totalCount); //用户在外部自行格式化 ----
	}else{
		self.pageLable.text = [NSString stringWithFormat:@"%ld/%ld",currentPage + 1,(long)totalCount];
	}
	[self bringSubviewToFront:self.infoView]; //放到最顶层
	!_changePageInfo?:_changePageInfo(self.infoView,self.dataSource[_currentPage]);  //修改页码底部的信息
}

-(void)setIsShowInformation:(BOOL)isShowInformation {
	_isShowInformation = isShowInformation;
	//是否显示详细信息
	self.infoView.hidden = _isShowInformation?NO:YES;
}
#pragma mark - private method
-(UIImage *)imageFromView:(UIView *) theView {
    // 开启一个绘图的上下文
	CGFloat scale =  [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(theView.frame.size.width*scale, theView.frame.size.height*scale), NO, 0.0);
    // 作用于CALayer层的方法。将view的layer渲染到当前的绘制的上下文中。
    [theView drawViewHierarchyInRect:CGRectMake(0, 0, theView.frame.size.width*scale, theView.frame.size.height*scale) afterScreenUpdates:YES];
    // 获取图片
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束绘图上下文
    UIGraphicsEndImageContext();
	return viewImage;
}
//获取 一个View 相对 window 的位置
-(CGRect)getRectFromWindow:(UIView *)view {
	NSArray *windows = [UIApplication sharedApplication].windows;
	UIWindow *window = windows.firstObject;
	return  [view convertRect:view.bounds toView:window];
}

@end
