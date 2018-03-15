//
/*!
 //  @header  ViewController.m
 //  @abstarct 我叫段雨田
     欢迎加我qq:476139183
     如果是妹子可以电话联系:18565835927😄
 //  NBsAlertView
 //  @author Created by Yutian Duan on 16/3/16.
 //  @version 1.00 16/3/16 Creation(版本信息)
   Copyright © 2016年 Yutian Duan. All rights reserved.
 
 */

#import "ViewController.h"
#import "NBsAlertView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    NBsAlertView *myalertview = [[NBsAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:@"请输入帐号"
                                                       buttonTitles: @"好的",nil];
    
    myalertview.alertViewStyle = 1;
    
    //
    [myalertview showWithCompletion:^(NBsAlertView *alertView, NSInteger selectIndex)
     
     {
         NSLog(@"点击了%d", (int)selectIndex);
         
         
     }];
    
}


-(void)click
{
    
    
    // 输入为空 时 自动消失
    NBsAlertView *myalertview = [[NBsAlertView alloc]initWithTitle:@"温馨提示"
                                                           message:@"请输入帐号"
                                                      buttonTitles: nil];

    myalertview.alertViewStyle = 4;
    
    //
    [myalertview showWithCompletion:^(NBsAlertView *alertView, NSInteger selectIndex)
     
     {
         
         
         
     }];
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
