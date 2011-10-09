//
//  MTTheme.m
//  MatchTwo
//
//  Created by  on 11-10-9.
//  Copyright (c) 2011年 StupidTent co. All rights reserved.
//

#import "MTTheme.h"
#import "GameConfig.h"

@implementation MTTheme

static ccColor3B primaryColor;
static ccColor3B foregroundColor;
static ccColor3B backgroundColor;

static NSString * backgroundLeft;
static NSString * backgroundRight;

#define kMTColorSpring ccc3(123, 169, 13)
#define kMTColorSummer ccc3(255, 167, 23)
#define kMTColorAutumn ccc3(251, 132, 14)
#define kMTColorWinter ccc3(203, 218, 226)
#define kMTColorDefault ccc3(247, 147, 30)

#define kMTBackgroundSpringLeft @"Background_Spring_Left.png"
#define kMTBackgroundSummerLeft @"Background_Summer_Left.png"
#define kMTBackgroundAutumnLeft @"Background_Autumn_Left.png"
#define kMTBackgroundWinterLeft @"Background_Winter_Left.png"

#define kMTBackgroundSpringRight @"Background_Spring_Right.png"
#define kMTBackgroundSummerRight @"Background_Summer_Right.png"
#define kMTBackgroundAutumnRight @"Background_Autumn_Right.png"
#define kMTBackgroundWinterRight @"Background_Winter_Right.png"

#define kMTBackgroundDefaultLeft @"Background_Left.png"
#define kMTBackgroundDefaultRight @"Background_Right.png"

+ (ccColor3B)primaryColor{
    return primaryColor;
}

+ (ccColor3B)foregroundColor{
    return foregroundColor;
}

+ (ccColor3B)backgroundColor{
    return backgroundColor;
}

+ (NSString *)backgroundLeft{
    return backgroundLeft;
}

+ (NSString *)backgroundRight{
    return backgroundRight;
}

+ (void)setTheme:(MTThemeConfig)config{
    foregroundColor = kMTColorActive;
    backgroundColor = kMTColorInactive;    
    switch (config) {
        case kMTThemeSpring:
            primaryColor = kMTColorSpring;
            backgroundLeft = kMTBackgroundSpringLeft;
            backgroundRight = kMTBackgroundSpringRight; 
            // Because the bkg is more black than white
            foregroundColor = kMTColorInactive;
            backgroundColor = kMTColorActive;
            break;
        case kMTThemeSummer:
            primaryColor = kMTColorSummer;
            backgroundLeft = kMTBackgroundSummerLeft;
            backgroundRight = kMTBackgroundSummerRight;            
            break;
        case kMTThemeAutumn:
            primaryColor = kMTColorAutumn;
            backgroundLeft = kMTBackgroundAutumnLeft;
            backgroundRight = kMTBackgroundAutumnRight;
            break;
        case kMTThemeWinter:
            primaryColor = kMTColorWinter;
            backgroundLeft = kMTBackgroundWinterLeft;
            backgroundRight = kMTBackgroundWinterRight;
        case kMTThemeDefault:
        default:
            primaryColor = kMTColorDefault;
            backgroundLeft = kMTBackgroundDefaultLeft;
            backgroundRight = kMTBackgroundDefaultRight;
            break;
    }
}

+ (MTThemeConfig)randomConfig{
    return rand()%4;
}

@end
