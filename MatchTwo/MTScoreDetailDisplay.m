//
//  MTScoreDetailDisplay.m
//  MatchTwo
//
//  Created by  on 11-11-3.
//  Copyright (c) 2011年 StupidTent co. All rights reserved.
//

#import "MTScoreDetailDisplay.h"

@interface MTScoreDetailDisplay ()
- (void)addBackground;
- (void)addScoreDisplay;
- (void)addScoreDetails;
- (void)addAbilityList;
- (void)addNextLevelUnlock;
@end

@implementation MTScoreDetailDisplay

- (MTScoreDetailDisplay *)init{
    self = [super init];
    if (self) {
        [self addBackground];
        [self addScoreDisplay];
        [self addScoreDetails];
        [self addAbilityList];
        [self addNextLevelUnlock];
    }
    return self;
}

- (void)addBackground{
    CCSprite * background = [CCSprite spriteWithFile:@"ScoreDetailBackground.png"];
    background.anchorPoint = ccp(0,0);    
    background.position = ccp(0,0);
    [self addChild:background];
}

- (void)addScoreDisplay{
    scoreDisplay = [[MTScoreDisplay alloc] init];
    scoreDisplay.position = ccp(30, 1024-661);    
    [self addChild:scoreDisplay];
}

- (void)addScoreDetails{
    
}

- (void)addAbilityList{
    
}

- (void)addNextLevelUnlock{
    
}

- (void)setColor:(ccColor3B)color{
    
}

- (ccColor3B)color{
    return ccBLACK;
}

// Set the opacity of all of our children that support it
-(void) setOpacity: (GLubyte) opacity{
    for( CCNode *node in [self children] ){
        if( [node conformsToProtocol:@protocol( CCRGBAProtocol)]){
            [(id<CCRGBAProtocol>) node setOpacity: opacity];
        }
    }
}

-(GLubyte) opacity{
    for( CCNode *node in [self children] ){
        if( [node conformsToProtocol:@protocol( CCRGBAProtocol)]){
            return [(id<CCRGBAProtocol>)node opacity];
        }
    }
    return 1.0;
}


@end
