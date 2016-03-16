//
/*!
 //  @header  NBsAlertView.h
 //  @abstarct 我叫段雨田
 欢迎加我qq:476139183
 如果是妹子可以电话联系:18565835927😄
 //  NBsAlertView
 //  @author Created by Yutian Duan on 16/3/16.
 //  @version 1.00 16/3/16 Creation(版本信息)
   Copyright © 2016年 Yutian Duan. All rights reserved.
 
 */

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, NBsAlertViewStyle) {
     NBsAlertViewStyleDefault = 0,
     NBsAlertViewStyleSecureTextInput,//密文输入
     NBsAlertViewStylePlainTextInput,
     NBsAlertViewStyleLoginAndPasswordInput,
     NBsAlertViewStyleAutomatic
};

@interface NBsAlertView : UIView
@property (nonatomic,strong) UILabel *msgLabel;
/**
 *消息字体大小(alertViewStyle为Default),否则为输入框字体大小
 **/
@property (nonatomic,strong) UIFont *messageFont;

@property (nonatomic) BOOL   seriesAlert;

@property (nonatomic) NBsAlertViewStyle alertViewStyle;

/**
 *  @两个按钮纯文本显示（block回调方式）
 */
-(id)initWithTitle:(NSString *)title
           message:(NSString *)message
      buttonTitles:(NSString *)otherButtonTitles,... NS_REQUIRES_NIL_TERMINATION;

/**
 *  显示弹出框
 */
-(void)showWithCompletion:(void (^)(NBsAlertView *alertView ,NSInteger selectIndex))completeBlock;

-(void)showInView:(UIView *)baseView completion:(void (^)(NBsAlertView *alertView ,NSInteger selectIndex))completeBlock;
-(void)closeView;
/**
 *获取指定的textField
 **/
- (UITextField *)textFieldAtIndex:(NSInteger)textFieldIndex;

@end
