//
//  MTTheme.h
//  MatchTwo
//
//  Created by  on 11-10-9.
//  Copyright (c) 2011年 StupidTent co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ccTypes.h"
#import "CCSprite.h"

typedef enum{
    kMTThemeDefault = 0,
    kMTThemeSpring = 1,
    kMTThemeSummer = 2,
    kMTThemeAutumn = 3,
    kMTThemeWinter = 4,
}MTThemeConfig;

@interface MTTheme : NSObject

+ (ccColor3B)primaryColor;
+ (ccColor3B)foregroundColor;
+ (ccColor3B)backgroundColor;

+ (NSString *)backgroundLeft;
+ (NSString *)backgroundRight;

+ (void)setTheme:(MTThemeConfig)config;
+ (MTThemeConfig)randomConfig;

@end
