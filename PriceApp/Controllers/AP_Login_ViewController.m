//
//  AP_Login_ViewController.m
//  MapApp
//
//  Created by Thanh Hai Tran on 4/9/18.
//  Copyright © 2018 Thanh Hai Tran. All rights reserved.
//

#import "AP_Login_ViewController.h"

#import "AP_Main_ViewController.h"

#import "PA_Root_ViewController.h"


@interface AP_Login_ViewController ()
{
    IBOutlet UITextField * uName, * pass;
    
    IBOutlet UIButton * check;
}

@end

@implementation AP_Login_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(![self getValue:@"check"])
    {
        [self addValue:@"1" andKey:@"check"];
    }

    [check setImage:[UIImage imageNamed: [[self getValue:@"check"] isEqualToString:@"1"] ? @"on" : @"off"] forState:UIControlStateNormal];
    
    [self.view actionForTouch:@{} and:^(NSDictionary *touchInfo) {
        [self.view endEditing:YES];
    }];
    
    if([[self getValue:@"check"] isEqualToString:@"1"])
    {
        uName.text = [self getValue:@"name"];
        
        pass.text = [self getValue:@"pass"];
        
        if([self getValue:@"name"] && [self getValue:@"pass"] && ![[self getValue:@"name"] isEqualToString:@""] && ![[self getValue:@"pass"] isEqualToString:@""])
        {
            [self didRequestLogin];
        }
    }
}

- (IBAction)didPressCheck:(UIButton*)sender
{
    [self addValue:[[self getValue:@"check"] isEqualToString:@"1"] ? @"0" : @"1" andKey:@"check"];

    [sender setImage:[UIImage imageNamed: [[self getValue:@"check"] isEqualToString:@"1"] ? @"on" : @"off"] forState:UIControlStateNormal];
}

//"Username": "nhapgia",
//"Password": "123456"

- (IBAction)didPressLogIn:(id)sender
{
    if(![self isValid])
    {
        [self showToast:@"Bạn phải nhập đầy đủ thông tin đăng nhập" andPos:0];
        
        return;
    }
    
    if([uName isFirstResponder] || [pass isFirstResponder])
    {
        [self.view endEditing:YES];
        
        [self performSelector:@selector(didRequestLogin) withObject:nil afterDelay:0.6];
    }
    else
    {
        [self didRequestLogin];
    }
}

- (void)didRequestLogin
{
    NSDictionary * infoPlist = [self dictWithPlist:@"Info"];
    
    [[LTRequest sharedInstance] didRequestInfo:@{@"absoluteLink":[NSString stringWithFormat:@"%@/Account/Signin", infoPlist[@"host"]],
                                                 @"method":@"GET",
                                                 @"Getparam":@{@"UserName":uName.text,@"Password":pass.text},
                                                 @"overrideAlert":@(1),
                                                 @"overrideLoading":@(1),
                                                 @"host":self
                                                     } withCache:^(NSString *cacheString) {
                                                     
                                                 } andCompletion:^(NSString *responseString, NSString *errorCode, NSError *error, BOOL isValidated) {
                                                     
                                                     switch ([errorCode intValue]) {
                                                         case 200:
                                                         {
                                                             NSDictionary * dict = [responseString objectFromJSONString];
                                                             
                                                             if(![dict[@"Result"] boolValue])
                                                             {
                                                                 [self showToast:dict[@"Message"] andPos:0];
                                                                 
                                                                 return ;
                                                             }
                                                             
                                                             [ObjectInfo shareInstance].uInfo = dict[@"Data"];

                                                             [ObjectInfo shareInstance].token = dict[@"Data"][@"TokenId"];
                                                                                                                          
                                                             if([[self getValue:@"check"] isEqualToString:@"1"])
                                                             {
                                                                 [self addValue:uName.text andKey:@"name"];

                                                                 [self addValue:pass.text andKey:@"pass"];
                                                             }
                                                             else
                                                             {
                                                                 [self removeValue:@"name"];

                                                                 [self removeValue:@"pass"];
                                                             }
                                                             
                                                             [[ObjectInfo shareInstance] didRequestForAll];
                                                             
                                                             uName.text = @"";
                                                             
                                                             pass.text = @"";
                                                             
                                                             [self.navigationController pushViewController:[PA_Root_ViewController new] animated:YES];
                                                        }
                                                         
                                                         break;
                                                         
                                                         case 401:
                                                         {
                                                             [self showToast:@"Đăng nhập thất bại, sai thông tin tài khoản" andPos:0];
                                                         }
                                                         
                                                         break;
                                                         
                                                         case 403:
                                                         {
                                                             [self showToast:@"Đăng nhập thất bại, tài khoản hiện tạm bị khóa" andPos:0];
                                                         }
                                                         
                                                         break;
                                                         
                                                         default:
                                                         {
                                                             [self showToast:@"Đăng nhập không thành công, mời bạn thử lại" andPos:0];
                                                         }
                                                         break;
                                                     }
                                                 }];
}

- (BOOL)isValid
{
    return [uName hasText] && [pass hasText];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
