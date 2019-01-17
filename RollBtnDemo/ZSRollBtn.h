//
//  ZSRollBtn.h
//  ZhishanFund
//
//  Created by qzwh on 2018/11/26.
//  Copyright © 2018年 qzwh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSRollBtn : UIView

- (instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr;

- (void)clickBtnWithIndex:(void(^)(NSInteger index))block;

//选中按钮下标  默认为0
@property (nonatomic, assign) NSInteger selectBtnIndex;

//按钮距离边界距离
@property (nonatomic, assign) CGFloat margin;
//按钮之间的间距
@property (nonatomic, assign) CGFloat spaceBtn;
//按钮高度
@property (nonatomic, assign) CGFloat btnHeight;
//线条高度
@property (nonatomic, assign) CGFloat lineHeight;
//线条宽度
@property (nonatomic, assign) CGFloat lineWidth;
//线条颜色
@property (nonatomic, strong) UIColor *lineColor;
//选中按钮字体样式
@property (nonatomic, strong) UIFont *selectBtnTextFont;
//未选中按钮字体样式
@property (nonatomic, strong) UIFont *noSelectBtnTextFont;
//选中按钮字体颜色
@property (nonatomic, strong) UIColor *selectBtnColor;
//未选中按钮字体颜色
@property (nonatomic, strong) UIColor *noSelectBtnColor;

//哪个按钮右上方会出现NewIcon
@property (nonatomic, strong) NSString *iconNewStr;
//newIcon是否出现
@property (nonatomic, assign) BOOL isNewIcon;

@end
