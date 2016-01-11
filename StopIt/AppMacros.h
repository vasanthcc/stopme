//
//  AppMacros.h
//  Stop ME
//
//  Created by Vasanth Raviachandran on 19/11/13.
//  Copyright (c) 2013 Vasanth Raviachandran. All rights reserved.
//

#ifndef SM_AppMacros_h
#define SM_AppMacros_h

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorFromARGB(argbValue) [UIColor \
colorWithRed:((float)((argbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((argbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(argbValue & 0xFF))/255.0 \
alpha:((float)((argbValue & 0xFF000000) >> 24))/255.0]

#define TOTAL @"TOTAL"
#define FIVESTAR @"FIVESTAR"
#define BEST @"BEST"

#define Level0_MaxPoints @"500"//500
#define Level1_MaxPoints @"400"//400
#define Level2_MaxPoints @"300"//300
#define Level3_MaxPoints @"300"//300

#pragma  mark Common Size Keys
#define SCREEN_FRAME [[UIScreen mainScreen] bounds]
#define device_width [UIScreen mainScreen].bounds.size.width
#define device_height [UIScreen mainScreen].bounds.size.height
#define view_frame self.view.frame

#define StatusBarHeight 20
#define StatusBarOffset 25

#endif
