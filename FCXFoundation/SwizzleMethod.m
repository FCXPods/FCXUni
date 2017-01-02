//
//  SwizzleMethod.m
//  HBTourClient
//
//  Created by 冯 传祥 on 16/6/23.
//  Copyright © 2016年 冯 传祥. All rights reserved.
//

#import "SwizzleMethod.h"
#import <objc/runtime.h>


void SwizzleInstanceMethod(Class class, SEL originalSelector, SEL swizzledSelector) {
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    if (class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else {
        
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

void SwizzleClassMethod(Class class, SEL originalSelector, SEL swizzledSelector) {
    
    Method origMethod = class_getClassMethod(class, originalSelector);
    Method newMethod = class_getClassMethod(class, swizzledSelector);
    
    class = object_getClass((id)class);
    
    if(class_addMethod(class, originalSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, newMethod);
    }
}
