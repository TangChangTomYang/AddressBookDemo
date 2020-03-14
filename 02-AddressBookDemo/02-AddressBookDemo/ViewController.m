//
//  ViewController.m
//  02-AddressBookDemo
//
//  Created by yangrui on 2020/3/13.
//  Copyright © 2020 yangrui. All rights reserved.
//

#import "ViewController.h"
#import <AddressBook/AddressBook.h>

@interface ViewController ()

@end

@implementation ViewController


/**
 使用步骤:
 0. 导入框架 #import <AddressBook/AddressBook.h>
 1. 请求授权
 2. 判断授权状态, 如果已经授权则继续; 如果未授权则提示用户, 并返回
 3. 创建通讯录对象
 4. 从通讯录对象中, 获取所有的联系人
 5. 遍历所有的联系人
 6. 释放不再使用的对象
 
 
 
 在github 上有一个 RHAddressBook 第三方框架, 做的比较好
 
 
                     
 */


- (void)viewDidLoad {
    [super viewDidLoad];
   
    // 判断当前的授权状态, 如果没有授权, 则请求授权
    /**
        kABAuthorizationStatusNotDetermined
        kABAuthorizationStatusRestricted
        kABAuthorizationStatusDenied
        kABAuthorizationStatusAuthorized
     */
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    if (status == kABAuthorizationStatusNotDetermined) { // 用户从来没有决定过
        // 创建通讯录对象
        ABAddressBookRef addBookRef = ABAddressBookCreate();
        // 请求用户授权, 使用通讯录
        ABAddressBookRequestAccessWithCompletion(addBookRef,
                                                 ^(bool granted, CFErrorRef error) {
            if (granted) {
                NSLog(@"请求访问通讯录授权成功");
                [self accessAddressooK];
            }
            else{
                NSLog(@"请求访问通讯录授权  失败");
            }
        });
    }
    else{
        [self accessAddressooK];
    }
    
  
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self accessAddressooK];
}

 

-(void)accessAddressooK{
    // 判断当前的授权状态, 如果没有授权, 则请求授权
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    if (status == kABAuthorizationStatusRestricted ) {
        NSLog(@" 不允许访问 通讯录 ");
        return;
    }
    
    
    ABAddressBookRef addBookRef = ABAddressBookCreate();
    if(status == kABAuthorizationStatusDenied){
        NSLog(@"请到 设置 打开通讯录 访问权限, 再 访问 通讯录");
        return;
        
    }
    
    
    
    if(status == kABAuthorizationStatusAuthorized){
        NSLog(@" 你 可以 访问通讯录 ");
        // 创建通讯录对象
        ABAddressBookRef addBookRef = ABAddressBookCreate();
        
        CFArrayRef peopleArrayRef = ABAddressBookCopyArrayOfAllPeople(addBookRef);
        
        // 遍历通讯录
        NSInteger peopleCount = CFArrayGetCount(peopleArrayRef);
        for(int i=0; i< peopleCount; i++){
            
            // 数组里面每个对象, 都是一个联系人记录
            ABRecordRef recordRef =  CFArrayGetValueAtIndex(peopleArrayRef, i);
            
            // 获取ABRecordID, 其实就是一个 int32_t
            ABRecordID recordID = ABRecordGetRecordID(recordRef);
            
            NSLog(@"id: %d",recordID);
            
            // CompositeName 是复合名称的意思 (firstName lastName)
            NSString *name = CFBridgingRelease(ABRecordCopyCompositeName(recordRef));
            NSLog(@"name: %@", name);
            
            NSString *nickname = CFBridgingRelease(ABRecordCopyValue(recordRef, kABPersonNicknameProperty));
             NSLog(@"nickname: %@", nickname);
            
            // 获取姓名
            NSString *firstName = CFBridgingRelease(ABRecordCopyValue(recordRef, kABPersonFirstNameProperty));
            NSString *lastName = CFBridgingRelease(ABRecordCopyValue(recordRef, kABPersonLastNameProperty));
            
            NSLog(@"姓名:  %@-%@",firstName, lastName );
            
            ABMultiValueRef phoneValueRef  = ABRecordCopyValue(recordRef, kABPersonPhoneProperty);
            // 遍历所有的电话
            // kABPersonPhoneProperty 电话
            NSInteger phoneNumCount = ABMultiValueGetCount(phoneValueRef);
            for(int i=0; i<phoneNumCount; i++){
                // 取出标签
                NSString *label = CFBridgingRelease(ABMultiValueCopyLabelAtIndex(phoneValueRef, i));
                // 取出号码
                NSString *num = CFBridgingRelease(ABMultiValueCopyValueAtIndex(phoneValueRef, i));
                NSLog(@"label: %@, num: %@", label, num);
            }
        }
        NSLog(@"通讯录一共有 : %ld 人", peopleCount);
    }
}

@end
