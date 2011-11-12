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

static NSString * background;



#define kMTColorSpring ccc3(123, 169, 13)
#define kMTColorSummer ccc3(255, 167, 23)
#define kMTColorAutumn ccc3(251, 132, 14)
#define kMTColorWinter ccc3FromHex(0x0095A8)
#define kMTColorDefault ccc3(247, 147, 30)

#define kMTBackgroundSpring @"Background_Spring.png"
#define kMTBackgroundSummer @"Background_Summer.png"
#define kMTBackgroundAutumn @"Background_Autumn.png"
#define kMTBackgroundWinter @"Background_Winter.png"

#define kMTBackgroundDefault @"Background_Default.png"

+ (ccColor3B)primaryColor{
    return primaryColor;
}

+ (ccColor3B)foregroundColor{
    return foregroundColor;
}

+ (ccColor3B)backgroundColor{
    return backgroundColor;
}

+ (NSString *)background{
    return background;
}

+ (void)setTheme:(MTThemeConfig)config{
    foregroundColor = kMTColorActive;
    backgroundColor = kMTColorInactive;    
    switch (config) {
        case kMTThemeSpring:
            primaryColor = kMTColorSpring;
            background = kMTBackgroundSpring;
            // Because the bkg is more black than white
            foregroundColor = kMTColorInactive;
            backgroundColor = kMTColorActive;
            break;
        case kMTThemeSummer:
            primaryColor = kMTColorSummer;
            background = kMTBackgroundSummer;
            break;
        case kMTThemeAutumn:
            primaryColor = kMTColorAutumn;
            background = kMTBackgroundAutumn;
            break;
        case kMTThemeWinter:
            primaryColor = kMTColorWinter;
            background = kMTBackgroundWinter;
            break;
        case kMTThemeMainMenu:
            primaryColor = kMTColorDefault;
            background = kMTBackgroundDefault;
            break;
        case kMTThemeDefault:
        default:
            primaryColor = kMTColorDefault;
            background = kMTBackgroundDefault;
            break;
    }
}

+ (MTThemeConfig)randomConfig{
    return rand()%5;
}

@end
