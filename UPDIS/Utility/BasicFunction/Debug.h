//
//  Debug.h
//  PhoneReport
//  宏定义debug模式
//  Created by Melvin on 11-6-14.
//  Copyright 2011年 ChangWei. All rights reserved.
//
#ifdef DEBUG
#define debug_NSLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define debug_NSLog(format, ...)
#endif