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

#define kMTScoreDisplayScoreLabelPositionX (kMTLevelDisplayWidth+kMTScoreDisplayPadding)
#define kMTScoreDisplayScoreLabelPositionY kMTScoreDisplayPadding

#define kMTScoreBarWidth 200
#define kMTScoreBarHeight 20

#define kMTScoreBarPositionX kMTScoreDisplayScoreLabelPositionX
#define kMTScoreBarPositionY (kMTScoreDisplayScoreLabelHeight + kMTScoreDisplayPadding * 3)

- (MTScoreDisplay *)init{
    self = [super init];
    if (self) {
        // Add Level Display
        level = [CCLabelTTF labelWithString:@""
                                 dimensions:CGSizeZero
                                  alignment:CCTextAlignmentRight
                                   fontName:kMTFont
                                   fontSize:kMTFontSizeNormal];
        level.position = ccp(kMTLevelDisplayWidth, 
                             kMTScoreDisplayPadding + kMTLevelDisplayheight/2);
        [self addChild:level z:1];
        level.anchorPoint = ccp(1.0, 0.5);
        
        // Add Score Display
        score = [CCLabelTTF labelWithString:@""
                                 dimensions:CGSizeZero
                                  alignment:CCTextAlignmentRight
                                   fontName:kMTFont
                                   fontSize:kMTFontSizeSmall];
        score.position = ccp(kMTScoreDisplayScoreLabelPositionX + kMTScoreDisplayScoreLabelWidth
                             , kMTScoreDisplayScoreLabelPositionY + kMTScoreDisplayScoreLabelHeight/2);
        score.anchorPoint = ccp(1.0, 0.5);
        [self addChild:score z:1];  
        
        manager = [MTSharedManager instance];
    }
    return self;
}

- (void)update:(ccTime)dt{
    int lv = [manager level];
    int currentLevelScore = [manager scoreForLevel:lv];
    int nextLevelScore = [manager scoreForLevel:lv+1];
    percentage = (manager.totalScore - currentLevelScore + 0.01f)/(nextLevelScore - currentLevelScore + 0.01f);
    
    level.string = [NSString stringWithFormat:@"%d",lv];
    score.string = [NSString stringWithFormat:@"%d/%d",manager.totalScore,nextLevelScore];
    
    if ([game isAbilityActive:kMTAbilityDoubleScore]) {
        score.color = ccORANGE;
    }else{
        score.color = ccWHITE;
    }
}

- (void)draw{
    [super draw];
    
    // Draw the Timeline here
    glColor4f(1.0, 0.5, 0.5, 0.8);
    glLineWidth(1.0);
    glEnable(GL_LINE_SMOOTH);
    CGPoint fill[4] = {
        ccp(kMTScoreBarPositionX, kMTScoreBarPositionY),
        ccp(kMTScoreBarPositionX + kMTScoreBarWidth * percentage, kMTScoreBarPositionY),
        ccp(kMTScoreBarPositionX + kMTScoreBarWidth * percentage, kMTScoreBarPositionY + kMTScoreBarHeight),
        ccp(kMTScoreBarPositionX, kMTScoreBarHeight + kMTScoreBarPositionY)
    };
    ccDrawPolyFill(fill, 4, YES);
    
    // Draw Border
    glColor4f(0.6, 0.6, 0.6, 1);  
    glLineWidth(1.0);
    glEnable(GL_LINE_SMOOTH);
    CGPoint border[4] = {
        ccp(kMTScoreBarPositionX, kMTScoreBarPositionY),
        ccp(kMTScoreBarPositionX + kMTScoreBarWidth, kMTScoreBarPositionY),
        ccp(kMTScoreBarPositionX + kMTScoreBarWidth, kMTScoreBarPositionY + kMTScoreBarHeight),
        ccp(kMTScoreBarPositionX, kMTScoreBarPositionY + kMTScoreBarHeight)
    };
    ccDrawPoly(border, 4, YES);    
}

@end
