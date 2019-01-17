//
//  ZSRollBtn.m
//  ZhishanFund
//
//  Created by qzwh on 2018/11/26.
//  Copyright © 2018年 qzwh. All rights reserved.
//

#import "ZSRollBtn.h"
#import "UIView+ZSFrame.h"

#define kRegularFont(x)         [UIFont fontWithName:@"PingFangSC-Regular" size:x] ?: [UIFont systemFontOfSize:x]
#define kMediumFont(x)          [UIFont fontWithName:@"PingFangSC-Medium" size:x] ?: [UIFont systemFontOfSize:x]
#define kSCREEN_WIDTH           [UIScreen mainScreen].bounds.size.width
#define kSCREEN_HEIGHT          [UIScreen mainScreen].bounds.size.height

#define kBtnTag     1000
#define kNewIconTag 100

@interface ZSRollBtn ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, copy) void(^clickBtnIndexBlock)(NSInteger index);
@end

@implementation ZSRollBtn

- (instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr; {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleArr = titleArr;
        self.margin = 20;
        self.spaceBtn = 32;
        self.btnHeight = 42;
        self.lineHeight = 2;
        self.lineWidth = 62;
        self.selectBtnTextFont = kMediumFont(15);
        self.noSelectBtnTextFont = kRegularFont(15);
        self.lineColor = [UIColor purpleColor];
        self.selectBtnColor = [UIColor purpleColor];
        self.noSelectBtnColor = [UIColor lightGrayColor];
        
        [self createUI];
        
        //默认选中下标为0
        self.selectBtnIndex = 0;
    }
    return self;
}

- (void)createUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.lineView];
    
    CGFloat x = self.margin;
    for (int i = 0; i < self.titleArr.count; i++) {
        //计算文字的长度 即为按钮的宽度  这里可以添加按钮的宽度
        CGFloat width = [self calculateContentWidthWithText:self.titleArr[i] height:self.btnHeight font:self.selectBtnTextFont];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(x, 0, width, self.btnHeight);
        [btn setTitle:self.titleArr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = self.noSelectBtnTextFont;
        btn.tag = kBtnTag + i;
        [btn addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:btn];
        
        x += (width + self.spaceBtn);
    }
    
    //重置按钮和scrollView
    [self resetBtnFrame];
}

- (void)setSelectBtnIndex:(NSInteger)selectBtnIndex {
    _selectBtnIndex = selectBtnIndex;
    
    UIButton *btn = (UIButton *)[self.scrollView viewWithTag:kBtnTag+selectBtnIndex];
    [self handleAction:btn];
}

//重置按钮边距
- (void)setMargin:(CGFloat)margin {
    _margin = margin;
    
    [self resetBtnFrame];
}

//重置按钮间距
- (void)setSpaceBtn:(CGFloat)spaceBtn {
    _spaceBtn = spaceBtn;
    
    [self resetBtnFrame];
}

//重置按钮高度
- (void)setBtnHeight:(CGFloat)btnHeight {
    _btnHeight = btnHeight;
    
    [self resetBtnFrame];
}

//重置线条宽度
- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    
    self.lineView.frame = CGRectMake(self.margin, self.btnHeight-self.lineHeight, lineWidth, self.lineHeight);
}

//重置线条高度
- (void)setLineHeight:(CGFloat)lineHeight {
    _lineHeight = lineHeight;
    
    self.lineView.frame = CGRectMake(self.margin, self.btnHeight-self.lineHeight, self.lineWidth, lineHeight);
}

//重置线条颜色
- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    
    self.lineView.backgroundColor = lineColor;
}

//重置选中字体类型
- (void)setSelectBtnTextFont:(UIFont *)selectBtnTextFont {
    _selectBtnTextFont = selectBtnTextFont;
    
    UIButton *btn = (UIButton *)[self.scrollView viewWithTag:kBtnTag+self.selectBtnIndex];
    btn.titleLabel.font = selectBtnTextFont;
}

//重置未选中字体样式
- (void)setNoSelectBtnTextFont:(UIFont *)noSelectBtnTextFont {
    _noSelectBtnTextFont = noSelectBtnTextFont;
    
    for (int i = 0; i < self.titleArr.count; i++) {
        if (i != self.selectBtnIndex) {
            UIButton *btn = (UIButton *)[self.scrollView viewWithTag:kBtnTag+i];
            btn.titleLabel.font = noSelectBtnTextFont;
        }
    }
}

//重置选中按钮颜色
- (void)setSelectBtnColor:(UIColor *)selectBtnColor {
    _selectBtnColor = selectBtnColor;
    
    for (int i = 0; i < self.titleArr.count; i++) {
        UIButton *btn = (UIButton *)[self.scrollView viewWithTag:kBtnTag+i];
        if (i == self.selectBtnIndex) {
            [btn setTitleColor:selectBtnColor forState:UIControlStateNormal];
        }
    }
}

//重置未选中按钮颜色
- (void)setNoSelectBtnColor:(UIColor *)noSelectBtnColor {
    _noSelectBtnColor = noSelectBtnColor;
    
    for (int i = 0; i < self.titleArr.count; i++) {
        UIButton *btn = (UIButton *)[self.scrollView viewWithTag:kBtnTag+i];
        
        if (i != self.selectBtnIndex) {
            [btn setTitleColor:noSelectBtnColor forState:UIControlStateNormal];
        }
    }
}

//这里可以设置按钮右上角角标
- (void)setIconNewStr:(NSString *)iconNewStr {
    _iconNewStr = iconNewStr;
    
    CGFloat x = self.margin;
    for (int i = 0; i < self.titleArr.count; i++) {
        UIButton *btn = (UIButton *)[self.scrollView viewWithTag:kBtnTag+i];
        btn.frame = CGRectMake(x, 0, btn.zs_width, self.btnHeight);
        
        //特殊按钮处理
        if ([self.titleArr[i] isEqualToString:self.iconNewStr]) {
            UIImageView *newIconImage = [[UIImageView alloc] initWithFrame:CGRectMake(x+btn.zs_width-5, 4, 21, 12)];
            newIconImage.image = [UIImage imageNamed:@"ic_details_news"];
            newIconImage.tag = kNewIconTag;
            [self.scrollView addSubview:newIconImage];
        }
        
        x += (btn.zs_width + self.spaceBtn);
    }
}

- (void)setIsNewIcon:(BOOL)isNewIcon {
    _isNewIcon = isNewIcon;
    
    UIImageView *newIcon = [self.scrollView viewWithTag:kNewIconTag];
    newIcon.hidden = !isNewIcon;
}

//重置按钮位置以及大小
- (void)resetBtnFrame {
    //还没有创建btn
    if (self.subviews.count == 0) {
        return;
    }
    
    CGFloat x = self.margin;
    
    //重定位下划线
    UIButton *btn = (UIButton *)[self.scrollView viewWithTag:kBtnTag];
    CGFloat lineX = x + ((btn.zs_width - self.lineWidth)/2);
    self.lineView.frame = CGRectMake(lineX, self.lineView.zs_y, self.lineWidth, self.lineHeight);
    
    for (int i = 0; i < self.titleArr.count; i++) {
        UIButton *btn = (UIButton *)[self.scrollView viewWithTag:kBtnTag+i];
        btn.frame = CGRectMake(x, 0, btn.zs_width, self.btnHeight);
        
        x += (btn.zs_width + self.spaceBtn);
    }
    
    //计算scrollView的contentSize
    //添加按钮的个数过少，宽度
    CGFloat contentWidth = (x + self.margin - self.spaceBtn);
    if (contentWidth >= kSCREEN_WIDTH) {
        self.scrollView.contentSize = CGSizeMake(contentWidth, 0);
    } else {
        self.scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH, 0);
        self.spaceBtn = (self.spaceBtn + ((kSCREEN_WIDTH)-contentWidth)/(self.titleArr.count-1));
    }
}

- (void)clickBtnWithIndex:(void(^)(NSInteger index))block {
    self.clickBtnIndexBlock = [block copy];
}

- (void)handleAction:(UIButton *)sender {
    //清除选中颜色
    for (int i = 0; i < self.titleArr.count; i++) {
        UIButton *btn = (UIButton *)[self.scrollView viewWithTag:kBtnTag+i];
        [btn setTitleColor:self.noSelectBtnColor forState:UIControlStateNormal];
    }
    //添加选中颜色
    [sender setTitleColor:self.selectBtnColor forState:UIControlStateNormal];
    
    //自动移动scrollView
    CGFloat centerX = kSCREEN_WIDTH / 2;
    [UIView animateWithDuration:0.5 animations:^{
        if (sender.zs_x <= centerX) {
            self.scrollView.contentOffset = CGPointZero;
        } else if (sender.zs_x >= (self.scrollView.contentSize.width - centerX)) {
            self.scrollView.contentOffset = CGPointMake(self.scrollView.contentSize.width-self.zs_width, 0);
        } else {
            self.scrollView.contentOffset = CGPointMake(sender.zs_x - centerX, 0);
        }
    }];
    
    //设置线条位置
    CGFloat lineX = sender.zs_x + ((sender.zs_width - self.lineWidth)/2);
    self.lineView.frame = CGRectMake(lineX, self.lineView.zs_y, self.lineWidth, self.lineHeight);
    
    if (self.clickBtnIndexBlock) {
        self.clickBtnIndexBlock(sender.tag - kBtnTag);
    }
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(self.margin, self.btnHeight-self.lineHeight, self.lineWidth, self.lineHeight)];
        _lineView.backgroundColor = self.lineColor;
    }
    return _lineView;
}

//计算文字宽度
- (CGFloat)calculateContentWidthWithText:(NSString *)text
                                  height:(CGFloat)height
                                    font:(UIFont *)font {
    CGSize size = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    return size.width;
}

@end
