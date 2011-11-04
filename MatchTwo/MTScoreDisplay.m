//
//  MTScoreDisplay.m
//  MatchTwo
//
//  Created by  on 11-8-31.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import "MTScoreDisplay.h"
#import "MTGame.h"
#import "MTSharedManager.h"

@implementation MTScoreDisplay

@synthesize game;

#define kMTScoreDisplayPadding 2

#define kMTLevelDisplayWidth 60
#define kMTLevelDisplayheight kMTScoreDisplayHeight

#define kMTScoreDisplayScoreLabelWidth 200
#define kMTScoreDisplayScoreLabelHeight 20

#define kMTScoreDisplayScoreLabelPositionX (kMTLevelDisplayWidth+kMTScoreDisplayPadding*5)
#define kMTScoreDisplayScoreLabelPositionY kMTScoreDisplayPadding

#define kMTScoreBarWidth 300
#define kMTScoreBarHeight 16

#define kMTScoreBarPositionX kMTScoreDisplayScoreLabelPositionX
#define kMTScoreBarPositionY (kMTScoreDisplayScoreLabelHeight + kMTScoreDisplayPadding * 3)



- (MTScoreDisplay *)init{
    self = [super init];
    if (self) {
        // Add Level Display
        level = [CCLabelTTF labelWithString:@""
                                 dimensions:CGSizeZero
                                  alignment:CCTextAlignmentRight
                                   fontName:kMTFontNumbers
                                   fontSize:kMTFontSizeCaption];
        level.position = ccp(0, -20.0f);
        level.color = [MTTheme primaryColor];
        [self addChild:level z:1];
        level.anchorPoint = ccp(0.0, 0.0);
        
        // Add Score Display
        score = [CCLabelTTF labelWithString:@""
                                 dimensions:CGSizeZero
                                  alignment:CCTextAlignmentRight
                                   fontName:kMTFontSmallNumbers
                                   fontSize:kMTFontSizeSmall];
        score.position = ccp(kMTScoreBarWidth, 0.0f);
        score.color = [MTTheme foregroundColor];
        score.anchorPoint = ccp(1.0, 0.0);
        [self addChild:score z:1];
        
        manager = [MTSharedManager instance];
        
        self.contentSize = CGSizeMake(kMTScoreBarWidth, 120);
        
        //Make it refresh once
        [self update:0.01];
    }
    return self;
}

- (void)update:(ccTime)dt{
    int lv = [manager level];
    int currentLevelScore = [manager scoreForLevel:lv];
    int nextLevelScore = [manager scoreForLevel:lv+1];
    percentage = (manager.totalScore - currentLevelScore + 0.01f)/(nextLevelScore - currentLevelScore + 0.01f);
    
    level.string = [NSString stringWithFormat:@"%d",lv];
    score.string = [NSString stringWithFormat:@"%d/%d€",manager.totalScore,nextLevelScore];
    
    if (game && [game isAbilityActive:kMTAbilityDoubleScore]) {
        score.color = kMTColorBuff;
    }else{
        score.color = [MTTheme foregroundColor];
    }
}

- (void)draw{
    [super draw];
    
    // Draw Baseline
    glColor4f([MTTheme backgroundColor].r/255.0,
              [MTTheme backgroundColor].g/255.0,
              [MTTheme backgroundColor].b/255.0,
              1.0);
    glLineWidth(1.0); 
    CGPoint baseLine[2] = {
        ccp(0,0),
        ccp(kMTScoreBarWidth, 0)
    };
    ccDrawLine(baseLine[0], baseLine[1]);
    
    // Draw Overlay
    glColor4f([MTTheme primaryColor].r/255.0,
              [MTTheme primaryColor].g/255.0,
              [MTTheme primaryColor].b/255.0,
              1.0);
    glLineWidth(3.0);
    CGPoint overLay[2] = {
        ccp(0,1),
        ccp(kMTScoreBarWidth*percentage, 1)
    };
    ccDrawLine(overLay[0], overLay[1]);
    
    
    
//    // Draw the Timeline here
//    glColor4f(1.0, 0.8, 0.2, 0.4);
//    glLineWidth(1.0);
//    glEnable(GL_LINE_SMOOTH);
//    CGPoint fill[4] = {
//        ccp(kMTScoreBarPositionX, kMTScoreBarPositionY),
//        ccp(kMTScoreBarPositionX + kMTScoreBarWidth * percentage, kMTScoreBarPositionY),
//        ccp(kMTScoreBarPositionX + kMTScoreBarWidth * percentage, kMTScoreBarPositionY + kMTScoreBarHeight),
//        ccp(kMTScoreBarPositionX, kMTScoreBarHeight + kMTScoreBarPositionY)
//    };
//    ccDrawPolyFill(fill, 4, YES);
//    
//    // Draw Border
//    glColor4f(0.6, 0.6, 0.6, 1);  
//    glLineWidth(1.0);
//    glEnable(GL_LINE_SMOOTH);
//    CGPoint border[4] = {
//        ccp(kMTScoreBarPositionX, kMTScoreBarPositionY),
//        ccp(kMTScoreBarPositionX + kMTScoreBarWidth, kMTScoreBarPositionY),
//        ccp(kMTScoreBarPositionX + kMTScoreBarWidth, kMTScoreBarPositionY + kMTScoreBarHeight),
//        ccp(kMTScoreBarPositionX, kMTScoreBarPositionY + kMTScoreBarHeight)
//    };
//    ccDrawPoly(border, 4, YES);    
}

@end
