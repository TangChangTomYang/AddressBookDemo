//
//  ViewController.m
//  01-AddressBookUIDemo
//
//  Created by yangrui on 2020/3/13.
//  Copyright © 2020 yangrui. All rights reserved.
//

#import "ViewController.h"
#import <AddressBookUI/AddressBookUI.h>

@interface ViewController ()<ABPeoplePickerNavigationControllerDelegate>

@end

@implementation ViewController

/**
AddressBookUI

具体代码实现:
0. 导入框架:
    #import <AddressBookUI/AddressBookUI.h>
1. 创建选择联系人的控制器
2. 设置代理 (用来接收用户选择的联系人信息)
3. 弹出联系人控制器
4. 实现代理
5. 在对应的代理方法中 获取练习 人信息

*/



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //  1. 创建一个联系人的选择控制器
    ABPeoplePickerNavigationController *peoplePickerNav = [[ABPeoplePickerNavigationController alloc] init];
    
    peoplePickerNav.peoplePickerDelegate = self;
     
    peoplePickerNav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:peoplePickerNav animated:YES completion:nil];
}


#pragma mark- <ABPeoplePickerNavigationControllerDelegate>
 
/**
 选择了联系人时调用
 针对一条联系人记录, 里面的属性共分两种:
 1. 一种是简单的属性,比如名字:  姓, 名 (firstName, lastName)
 2. 一种是复杂的属性, 有点类似于一个字典(dictionary)但不是, 比如: 联系号码: (办公号码, 家庭号码), (标签 + 号码)
 
 */
-(void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker
                        didSelectPerson:(ABRecordRef)person {
    
    /** 简单属性
     一个联系人对象, 就是一条ABRecordRef
     如果想要从这个记录里面获取详细的数据, 必须使用一个方法 ABRecodCopyValue
     */
    NSString *firstname =  CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
    NSString *lastname =  CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
    
    NSLog(@"姓名: %@ %@", firstname, lastname);
    
    /** 复杂属性
     获取电话号码
     电话是存储在一个 ABMultiValueRef 类型的对象中, 一个人的通讯 录中可能有多个电话
     */
    ABMultiValueRef phoneNumValueRef  = ABRecordCopyValue(person, kABPersonPhoneProperty);
    // 遍历所有的电话
    NSInteger phoneNumCount = ABMultiValueGetCount(phoneNumValueRef);
    for(int i=0; i<phoneNumCount; i++){
        // 取出标签
        NSString *label = CFBridgingRelease(ABMultiValueCopyLabelAtIndex(phoneNumValueRef, i));
        // 取出号码
        NSString *num = CFBridgingRelease(ABMultiValueCopyValueAtIndex(phoneNumValueRef, i));
        NSLog(@"label: %@, num: %@", label, num);
    }
    
    
    NSLog(@" 选择了联系人时调用");
}

/**
 选择了联系 人某个 属性时调用
 如果选择某个联系人的代理方法实现了, 那么这个方法就不会执行
 也就意味着, 不会进入x联系人详情页面了
 
 一句话:
 实现了 peoplePickerNavigationController: didSelectPerson: 方法, 就不会进入到详情页面了
 
 */
-(void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker
                        didSelectPerson:(ABRecordRef)person
                               property:(ABPropertyID)property
                             identifier:(ABMultiValueIdentifier)identifier NS_AVAILABLE_IOS(8_0){
    
    NSLog(@"选择了联系 人某个 属性时调用");
}

/**
 用户选择了取消时调用
 */
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    NSLog(@"用户选择了取消时调用");
}


- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person NS_DEPRECATED_IOS(2_0, 8_0){
    NSLog(@" 选择练习人继续");
    return YES;
}



- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier{
    NSLog(@" 选择练习人属性 继续");
    return YES;
}

@end
