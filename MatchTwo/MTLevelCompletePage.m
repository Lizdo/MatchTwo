//
//  MTLevelCompletePage.m
//  MatchTwo
//
//  Created by  on 11-9-6.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import "MTLevelCompletePage.h"
#import "MTSharedManager.h"
#import "MTGame.h"

@interface MTLevelCompletePage ()
- (NSString *)scoreDescription;
@end

@implementation MTLevelCompletePage

@synthesize game;



- (id)init{
    self = [super init];
    if (self) {
        // Move the background down        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        CCLayerColor * overlay = [CCLayerColor layerWithColor:ccc4(20, 20, 20, 255)];
        [self addChild:overlay];
        overlay.position = ccp(0, winSize.height);
        [overlay runAction:[CCMoveTo actionWithDuration:kMTMenuPageLoadingTime position:ccp(0,0)]];
        
        
        // Level Complete Letters
        CCLabelTTF * levelSuccessLabel = [CCLabelTTF labelWithString:@"恭喜过关..."
                                                            fontName:kMTFont
                                                            fontSize:kMTFontSizeCaption];
        levelSuccessLabel.position = ccp(winSize.width/2, 800);
        [self addChild:levelSuccessLabel];    
        
        
        // Update Score
        scoreDetails = [CCLabelTTF labelWithString:@""
                                                  dimensions:CGSizeMake(winSize.width, 200)
                                                   alignment:UITextAlignmentCenter 
                                               lineBreakMode:UILineBreakModeWordWrap 
                                                    fontName:kMTFont
                                                    fontSize:kMTFontSizeNormal];
        scoreDetails.position = ccp(winSize.width/2, 600);
        scoreDetails.color = ccGRAY;
        [self addChild:scoreDetails];
        
        
        // Buttons
        menu = [CCMenu menuWithItems:[CCMenuItemFont itemFromString:@"下一关"
                                                                   block:^(id sender){
                                                                       [[MTSharedManager instance] gotoNextLevel:game.levelID];}],
                     [CCMenuItemFont itemFromString:@"主菜单"
                                              block:^(id sender){
                                                  [[MTSharedManager instance] replaceSceneWithID:0];}],                     
                     nil];
        
        [menu alignItemsVerticallyWithPadding:kMTMenuPadding];
        menu.position = ccp(menu.position.x,
                            menu.position.y - 100);
        [self addChild:menu];
        
    }
    return self;
}

// TODO: Show it in several steps...
- (void)show{
    scoreDetails.string = [self scoreDescription];
}

- (NSString *)scoreDescription{
    NSString * s = [NSString stringWithFormat:@"剩余时间: %8.0f\n", game.remainingTime];
    s = [s stringByAppendingFormat:@"时间奖励: %8d\n", game.timeBonus];
    if (game.obj != kMTOptionalObjectiveNone) {
        s = [s stringByAppendingFormat:@"任务奖励: %8d\n", game.objBonus];
    }
    s = [s stringByAppendingFormat:@"总得分: %8d\n", game.timeBonus + game.objBonus + game.completeBonus];
    // Add level unlock description here, next level unlock description
    return s;
}


@end
