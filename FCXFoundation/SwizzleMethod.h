//
//  SwizzleMethod.h
//  HBTourClient
//
//  Created by 冯 传祥 on 16/6/23.
//  Copyright © 2016年 冯 传祥. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  swizzle实例方法
 *
 *  @param class            类
 *  @param originalSelector 原始方法
 *  @param swizzledSelector 要替换的方法
 */
void SwizzleInstanceMethod(Class class, SEL originalSelector, SEL swizzledSelector);

/**
 *  swizzle类方法
 *
 *  @param class            类
 *  @param originalSelector 原始方法
 *  @param swizzledSelector 要替换的方法
 */
void SwizzleClassMethod(Class class, SEL originalSelector, SEL swizzledSelector);





