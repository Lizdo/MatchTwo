//
//  MTScoreDetailDisplay.m
//  MatchTwo
//
//  Created by  on 11-11-3.
//  Copyright (c) 2011年 StupidTent co. All rights reserved.
//

#import "MTScoreDetailDisplay.h"
#import "MTSharedManager.h"

@interface MTScoreDetailDisplay ()
- (void)addBackground;
- (void)addScoreDisplay;
- (void)addScoreDetails;
- (void)addAbilityList;
- (void)addNextLevelUnlock;
- (CGPoint)positionForAbility:(MTAbility *)ability;
- (MTAbility *)abilityInLocation:(CGPoint)location;
@end

@implementation MTScoreDetailDisplay

- (MTScoreDetailDisplay *)init{
    self = [super init];
    if (self) {
        self.anchorPoint = ccp(0,0);
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
    self.contentSize = background.contentSize;
}

- (void)addScoreDisplay{
    scoreDisplay = [[MTScoreDisplay alloc] init];
    scoreDisplay.position = ccp(30, 1024-661);    
    [self addChild:scoreDisplay];
}

- (void)addScoreDetails{
    
}

- (void)addAbilityList{
    abilities = [[[MTSharedManager instance] unlockedAbilities] copy];
    for (MTAbility * ability in abilities) {
        CCSprite * icon = [MTAbility spriteForAbility:ability.name];
        icon.position = [self positionForAbility:ability];
        [self addChild:icon];
    }
}

- (void)addNextLevelUnlock{
    
}

- (void)showAbilityDetailFor:(MTAbility *)ability{
    [self hideAbilityDetail];
    abilityDetailDisplay = [MTAbilityDetailDisplay detailDisplayForAbility:ability];
    abilityDetailDisplay.anchorPoint = ccp(0,0);    
    abilityDetailDisplay.position = ccp(381.0f, 50.0f);
    [self addChild:abilityDetailDisplay];
}

- (void)hideAbilityDetail{
    if (abilityDetailDisplay) {
        [abilityDetailDisplay removeFromParentAndCleanup:YES];
        abilityDetailDisplay = nil;
    }    
}

#define MTAScoreDisplayAbilityStartingX 70.0f
#define MTAScoreDisplayAbilityStartingY 183.0f
#define MTAScoreDisplayAbilityInterval 65.0f
#define MTAScoreDisplayAbilitySize 60.0f

- (CGPoint)positionForAbility:(MTAbility *)ability{
    int index = [abilities indexOfObject:ability];
    return ccp(MTAScoreDisplayAbilityStartingX + MTAScoreDisplayAbilityInterval * index,
               MTAScoreDisplayAbilityStartingY);
}

- (MTAbility *)abilityInLocation:(CGPoint)location{
    for (MTAbility * ability in abilities) {
        float distance = ccpDistance(location,
                                     [self positionForAbility:ability]);
        if (distance <= MTAScoreDisplayAbilitySize) {
            return ability;
        }
    }
    return nil;
}


#pragma mark -
#pragma mark Handle Touch Events

- (void)onEnter
{
    [[CCTouchDispatcher sharedDispatcher] addStandardDelegate:self priority:0];
    abilityDetailDisplay.visible = NO;
    [super onEnter];
}

- (void)onExit
{
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
    [super onExit];
}   


- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    // World Space
	location = [[CCDirector sharedDirector] convertToGL:location];
    // Local Space
    location = [self convertToNodeSpace:location];
    
    // Check if any sprite is clicked, add the detail view
    if ([abilities count] > 0) {
        MTAbility * ability = [self abilityInLocation:location];
        if (ability) {
            [self showAbilityDetailFor:ability];
        }
    }

    
}


#pragma mark -
#pragma mark CCRGBAProtocol

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
