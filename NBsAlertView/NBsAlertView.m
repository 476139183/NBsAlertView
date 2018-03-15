//
/*!
 //  @header  NBsAlertView.m
 //  @abstarct 我叫段雨田
 欢迎加我qq:476139183
 如果是妹子可以电话联系:18565835927😄
 //  NBsAlertView
 //  @author Created by Yutian Duan on 16/3/16.
 //  @version 1.00 16/3/16 Creation(版本信息)
 Copyright © 2016年 Yutian Duan. All rights reserved.
 
 */

#import "NBsAlertView.h"

#define kBaseTag 1000
#define kContentViewWidth 260.0f
#define kButtonHeight 45.0f
#define kMarginLeftRight 9.0f
#define kMarginTopButtom 22.0f

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface NBsAlertView () {
  UIView *contentView;
  UIButton *cancelBtn;
  
  UIImage *titleImage;
  UILabel *titleLabel;
  
  NSLayoutConstraint *contentViewHeightConstraint;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) NSMutableArray *buttonTitleList;

@property (nonatomic, strong)   NSMutableArray *textFields;
@property (nonatomic, assign)  BOOL ablethou;

@property (nonatomic, copy) void (^dialogViewCompleteHandle)(NBsAlertView *, NSInteger);

@end


@implementation NBsAlertView

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                 buttonTitles:(NSString *)otherButtonTitles, ... {
  
  if (self == [super initWithFrame:CGRectZero]) {
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
    self.title = title;
    self.message = message;
    
    va_list args;
    va_start(args, otherButtonTitles);
    _buttonTitleList = [[NSMutableArray alloc] initWithCapacity:10];
    for (NSString *str = otherButtonTitles; str != nil; str = va_arg(args,NSString*)) {
      [_buttonTitleList addObject:str];
    }
    va_end(args);
    [self setup];
  }
  return self;
}

- (void)dealloc {
  
}

#pragma mark - Message

#pragma mark - Private

- (NSMutableArray *)textFields {
  if (!_textFields) {
    _textFields = [NSMutableArray array];
  }
  return _textFields;
}

- (UIFont *)messageFont {
  if (!_messageFont) {
    _messageFont = [UIFont systemFontOfSize:16];
  }
  return _messageFont;
}

- (void)setAlertViewStyle:(NBsAlertViewStyle)alertViewStyle {
  _alertViewStyle = alertViewStyle;
  if (_alertViewStyle != NBsAlertViewStyleDefault&&_alertViewStyle != NBsAlertViewStyleAutomatic) {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setup];
  }
}

/**
 *  view初始化
 */
-(void)setup {
  //内容视图
  contentView = [[UIView alloc]init];
  contentView.translatesAutoresizingMaskIntoConstraints = NO;
  contentView.clipsToBounds = YES;
  contentView.backgroundColor = UIColorFromRGB(0xe8e8e8);
  [contentView.layer setCornerRadius:5.0f];
  [self addSubview:contentView];
  
  NSDictionary *bindDic_contentView = NSDictionaryOfVariableBindings(contentView);
  
  NSString *formatStr_contentView = [NSString stringWithFormat:@"H:[contentView(%f)]",kContentViewWidth];
  NSArray *contentView_H = [NSLayoutConstraint constraintsWithVisualFormat:formatStr_contentView options:0 metrics:nil views:bindDic_contentView];
  NSLayoutConstraint *contentView_CX = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
  NSLayoutConstraint *contentView_CY = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
  [self addConstraints:contentView_H];
  [self addConstraint:contentView_CX];
  [self addConstraint:contentView_CY];
  
  //标题
  titleLabel = [[UILabel alloc]init];
  titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
  titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
  titleLabel.backgroundColor = [UIColor clearColor];
  titleLabel.text = _title;
  titleLabel.textAlignment = NSTextAlignmentCenter;
  titleLabel.textColor = UIColorFromRGB(0x333333);
  [contentView addSubview:titleLabel];
  
  NSDictionary *dic_titleLabel = @{@"width":@(150.0f)};
  NSArray *titleLabel_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[titleLabel(width)]" options:0 metrics:dic_titleLabel views:NSDictionaryOfVariableBindings(titleLabel)];
  NSLayoutConstraint *titleLabel_CX = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
  [contentView addConstraints:titleLabel_H];
  [contentView addConstraint:titleLabel_CX];
  
  //横线
  UIView *lineView = [[UIView alloc]init];
  lineView.translatesAutoresizingMaskIntoConstraints = NO;
  lineView.backgroundColor = UIColorFromRGB(0xdadbdd);
  [contentView addSubview:lineView];
  
  //多按钮
  NSMutableDictionary *bindBtnsDic = [NSMutableDictionary dictionary];
  NSDictionary *dic_btns = @{@"leftRight":@(0),@"height":@(kButtonHeight)};
  NSString *formatStr_btns = @"H:|-leftRight-";
  float btnWidth = (kContentViewWidth - (_buttonTitleList.count - 1)) / _buttonTitleList.count;
  
  if (_buttonTitleList.count == 0) {
    self.alertViewStyle = NBsAlertViewStyleAutomatic;
  }
  
  if(_buttonTitleList.count > 1) {
    //分割线
    UIView *lineView1 = [[UIView alloc]init];
    lineView1.translatesAutoresizingMaskIntoConstraints = NO;
    lineView1.backgroundColor = UIColorFromRGB(0xdadbdd);
    [contentView addSubview:lineView1];
    
    NSString *formate_H = [NSString stringWithFormat:@"H:|-%f-[lineView1(%f)]",btnWidth,1.0f];
    NSString *formate_V = [NSString stringWithFormat:@"V:[lineView1(%f)]|",kButtonHeight];
    NSArray *lineView1_H = [NSLayoutConstraint constraintsWithVisualFormat:formate_H options:0 metrics:nil views:NSDictionaryOfVariableBindings(lineView1)];
    NSArray *lineView1_V = [NSLayoutConstraint constraintsWithVisualFormat:formate_V options:0 metrics:nil views:NSDictionaryOfVariableBindings(lineView1)];
    [contentView addConstraints:lineView1_H];
    [contentView addConstraints:lineView1_V];
  }
  
  for (int i = 0; i < _buttonTitleList.count; i++) {
    UIButton *btn = [[UIButton alloc]init];
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
    [btn setTitle:[_buttonTitleList objectAtIndex:i] forState:UIControlStateNormal];
    [btn.layer setMasksToBounds:YES];
    if(i > 0 && i == _buttonTitleList.count - 1) {
      [btn setTitleColor:UIColorFromRGB(0xb51d23) forState:UIControlStateNormal];
    } else {
      [btn setTitleColor:UIColorFromRGB(0x646464) forState:UIControlStateNormal];
    }
    
    [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTag:kBaseTag + i];
    [contentView addSubview:btn];
    
    NSString *btnFlag = [NSString stringWithFormat:@"btn%d",i];
    [bindBtnsDic setObject:btn forKey:btnFlag];
    
    if(i > 0 && i == _buttonTitleList.count - 1) {
      formatStr_btns = [formatStr_btns stringByAppendingFormat:@"-1-[%@(%f)]",btnFlag,btnWidth];
    } else {
      formatStr_btns = [formatStr_btns stringByAppendingFormat:@"[%@(%f)]",btnFlag,btnWidth];
    }
    
    NSString *btn_formatStr = [NSString stringWithFormat:@"V:[btn(height@500)]|"];
    NSArray *btn_V = [NSLayoutConstraint constraintsWithVisualFormat:btn_formatStr options:0 metrics:dic_btns views:NSDictionaryOfVariableBindings(btn)];
    [contentView addConstraints:btn_V];
  }
  
  formatStr_btns = [formatStr_btns stringByAppendingString:@"-leftRight-|"];
  
  if (_buttonTitleList.count> 0) {
    //按钮约束
    NSArray *btns_H = [NSLayoutConstraint constraintsWithVisualFormat:formatStr_btns options:0 metrics:dic_btns views:bindBtnsDic];
    [contentView addConstraints:btns_H];
  }
  
  UIButton *relateBtn = bindBtnsDic[@"btn0"];
  NSMutableDictionary *bindDic = nil;
  NSDictionary *paramDic = @{@"topMargin":@(kMarginTopButtom),@"lineHeight":@(1.0),@"msgMarginLeftRight":@(17.0f),@"marginTop":@(kMarginTopButtom),@"marginLeft":@(kMarginLeftRight)};
  
  if (self.alertViewStyle == NBsAlertViewStyleDefault) {
    //消息体
    UIFont *msgFont = self.messageFont;
    _msgLabel = [[UILabel alloc]init];
    _msgLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _msgLabel.backgroundColor = [UIColor clearColor];
    _msgLabel.font = msgFont;
    _msgLabel.textAlignment = NSTextAlignmentCenter;
    _msgLabel.textColor = UIColorFromRGB(0x333333);
    _msgLabel.text = _message;
    _msgLabel.numberOfLines = 0;
    [contentView addSubview:_msgLabel];
    NSString *formatStr;
    if (relateBtn) {
      bindDic =  [@{@"titleLabel":titleLabel,
                    @"msgLabel":_msgLabel,
                    @"lineView":lineView,
                    @"relateBtn":relateBtn} mutableCopy];
      
      formatStr = @"V:|-topMargin-[titleLabel]-topMargin-[msgLabel]-topMargin-[lineView(lineHeight)][relateBtn]|";
      
    } else {
      bindDic =  [@{@"titleLabel":titleLabel,
                    @"msgLabel":_msgLabel,
                    @"lineView":lineView} mutableCopy];
      formatStr = @"V:|-topMargin-[titleLabel]-topMargin-[msgLabel]-topMargin-[lineView(lineHeight)]|";
      
    }
    
    //文本约束
    NSArray *msgLabel_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-msgMarginLeftRight-[msgLabel]-msgMarginLeftRight-|" options:0 metrics:paramDic views:bindDic];
    [contentView addConstraints:msgLabel_H];
    
    NSArray *views_V = [NSLayoutConstraint constraintsWithVisualFormat:formatStr options:0 metrics:paramDic views:bindDic];
    
    [contentView addConstraints:views_V];
    
  } else if (self.alertViewStyle == NBsAlertViewStyleAutomatic) {
    NSLog(@"可以自由操作");
    //消息体
    UIFont *msgFont = self.messageFont;
    _msgLabel = [[UILabel alloc]init];
    _msgLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _msgLabel.backgroundColor = [UIColor clearColor];
    _msgLabel.font = msgFont;
    _msgLabel.textAlignment = NSTextAlignmentCenter;
    _msgLabel.textColor = UIColorFromRGB(0x333333);
    _msgLabel.text = _message;
    _msgLabel.numberOfLines = 0;
    [contentView addSubview:_msgLabel];
    NSString *formatStr;
    if (relateBtn) {
      bindDic =  [@{@"titleLabel":titleLabel,
                    @"msgLabel":_msgLabel,
                    @"lineView":lineView,
                    @"relateBtn":relateBtn} mutableCopy];
      
      formatStr = @"V:|-topMargin-[titleLabel]-topMargin-[msgLabel]-topMargin-[lineView(lineHeight)][relateBtn]|";
      
    } else {
      bindDic =  [@{@"titleLabel":titleLabel,
                    @"msgLabel":_msgLabel,
                    @"lineView":lineView} mutableCopy];
      formatStr = @"V:|-topMargin-[titleLabel]-topMargin-[msgLabel]-topMargin-[lineView(lineHeight)]|";
      
    }
    
    //文本约束
    NSArray *msgLabel_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-msgMarginLeftRight-[msgLabel]-msgMarginLeftRight-|" options:0 metrics:paramDic views:bindDic];
    [contentView addConstraints:msgLabel_H];
    
    NSArray *views_V = [NSLayoutConstraint constraintsWithVisualFormat:formatStr options:0 metrics:paramDic views:bindDic];
    [contentView addConstraints:views_V];
    
  } else {
    bindDic =  [@{@"titleLabel":titleLabel,
                  @"lineView":lineView,
                  @"relateBtn":relateBtn} mutableCopy];
    NSString *formatStr = @"V:|-topMargin-[titleLabel]-topMargin-";
    int textFieldCount = self.alertViewStyle == NBsAlertViewStyleLoginAndPasswordInput? 2:1;
    for (int i = 0; i < textFieldCount; i++) {
      UITextField *textField = [[UITextField alloc] init];
      textField.borderStyle = UITextBorderStyleRoundedRect;
      textField.translatesAutoresizingMaskIntoConstraints = NO;
      textField.font = self.messageFont;
      textField.secureTextEntry = (i==1 || self.alertViewStyle == NBsAlertViewStyleSecureTextInput);
      textField.layer.masksToBounds = YES;
      
      if (textFieldCount > 1) {
        textField.placeholder = i? @"请输入密码":@"请输入用户名";
      } else {
        textField.placeholder = @"请输入内容";
      }
      
      [self.textFields addObject:textField];
      [contentView addSubview:textField];
      
      NSString *textFieldFlag = [NSString stringWithFormat:@"textField%d",i];
      [bindDic setValue:textField forKey:textFieldFlag];
      
      if(i > 0 && i == _buttonTitleList.count - 1) {
        formatStr = [formatStr stringByAppendingFormat:@"-1-[%@]", textFieldFlag];
      } else {
        formatStr = [formatStr stringByAppendingFormat:@"[%@]", textFieldFlag];
      }
      NSString *formatStr_textFields = [NSString stringWithFormat:@"H:|-msgMarginLeftRight-[%@]-msgMarginLeftRight-|", textFieldFlag];
      NSArray *textField_H = [NSLayoutConstraint constraintsWithVisualFormat:formatStr_textFields options:0 metrics:paramDic views:bindDic];
      [contentView addConstraints:textField_H];
    }
    formatStr = [formatStr stringByAppendingString:@"-topMargin-[lineView(lineHeight)][relateBtn]|"];
    
    NSArray *views_V = [NSLayoutConstraint constraintsWithVisualFormat:formatStr options:0 metrics:paramDic views:bindDic];
    [contentView addConstraints:views_V];
  }
  
  //横线约束
  NSArray *lineView_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[lineView]|" options:0 metrics:paramDic views:bindDic];
  [contentView addConstraints:lineView_H];
  
  //自动布局后的高度
  CGSize size = [contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
  NSDictionary *dic_contentView = @{@"height":@(size.height)};
  NSArray *contentView_Height = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[contentView(height@400)]" options:0 metrics:dic_contentView views:bindDic_contentView];
  [self addConstraints:contentView_Height];
  contentViewHeightConstraint = contentView_Height[0];
}

/**
 *  关闭视图
 */
- (void)closeView {
  [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
  [UIView animateWithDuration:0.3f animations:^{
    contentView.alpha = 0;
    contentView.transform = CGAffineTransformMakeScale(0.01, 0.01);
  } completion:^(BOOL finished) {
    [self removeFromSuperview];
  }];
}

/**
 *  点击按钮事件
 *
 *  @param sender OK按钮
 */
- (void)buttonAction:(UIButton *)sender {
  NSInteger selIndex = sender.tag - kBaseTag;
  __weak typeof(*&self) weakSelf = self;
  if(_dialogViewCompleteHandle) {
    _dialogViewCompleteHandle(weakSelf, selIndex);
  }
  [self closeView];
}

#pragma mark - Message
- (void)showInView:(UIView *)baseView completion:(void (^)(NBsAlertView *, NSInteger))completeBlock {
  self.dialogViewCompleteHandle = completeBlock;
  
  if(!_seriesAlert) {
    for (UIView *subView in baseView.subviews) {
      if([subView isKindOfClass:[NBsAlertView class]])
      {
        return;
      }
    }
  }
  self.translatesAutoresizingMaskIntoConstraints = NO;
  [baseView addSubview:self];
  
  NSArray *view_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[self]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self)];
  NSArray *view_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[self]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(self)];
  
  [baseView addConstraints:view_H];
  [baseView addConstraints:view_V];
  
  contentView.alpha = 0;
  contentView.transform = CGAffineTransformMakeScale(0.01, 0.01);
  
  [UIView animateWithDuration:0.3f animations:^{
    contentView.alpha = 1.0;
    contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
  }];
  
  if (self.alertViewStyle== NBsAlertViewStyleAutomatic) {
    [self performSelector:@selector(closeView) withObject:nil afterDelay:2.0];
  }
}

/**
 *  延迟显示弹出框
 *
 *
 */
- (void)showInViewWithcompletion:(void (^)(NBsAlertView *, NSInteger))completeBlock {
  UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
  [self showInView:keyWindow completion:completeBlock];
}


/**
 *  显示弹出框
 */
- (void)showWithCompletion:(void (^)(NBsAlertView *, NSInteger))completeBlock {
  UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
  
  if (keyWindow !=nil) {
    [self showInView:keyWindow completion:completeBlock];
  } else {
    [self performSelector:@selector(showInViewWithcompletion:) withObject:completeBlock afterDelay:0.6];
  }
  
}

- (UITextField *)textFieldAtIndex:(NSInteger)textFieldIndex {
  UITextField *textField = self.textFields[textFieldIndex];
  return textField;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

