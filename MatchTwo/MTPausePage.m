//
//  MTPausePage.m
//  MatchTwo
//
//  Created by  on 11-9-20.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import "MTPausePage.h"
#import "MTGame.h"

@interface MTPausePage ()
- (void)addBackground;
- (void)addStats;
- (void)addMenus;
- (void)addLabel:(CCLabelTTF *)child at:(CGPoint)p;
@end

@implementation MTPausePage

@synthesize game;

- (void)addBackground{
    CGSize winSize = [[CCDirector sharedDirector] winSize];        
    CCSprite * image = [CCSprite spriteWithFile:@"Background_Left.png"];
    image.position = ccp(winSize.width/2, winSize.height/2);
    [self addChild:image];
}

- (void)addStats{
    // Your Level String
    [self addLabel:[CCLabelTTF labelWithString:@"你的等级"
                                      fontName:kMTFont
                                      fontSize:kMTFontSizeNormal]
                at:ccp(90,1024-230)];
    
    // Next Level Unlock
    [self addLabel:[CCLabelTTF labelWithString:@"下一级解锁"
                                      fontName:kMTFont
                                      fontSize:kMTFontSizeNormal]
                at:ccp(341,1024-230)];
    
    // Remaining Time
    [self addLabel:[CCLabelTTF labelWithString:@"剩余时间"
                                      fontName:kMTFont
                                      fontSize:kMTFontSizeNormal]
                at:ccp(90,1024-410)];
    
    // Level Objective
    [self addLabel:[CCLabelTTF labelWithString:@"关卡任务"
                                      fontName:kMTFont
                                      fontSize:kMTFontSizeNormal]
                at:ccp(341,1024-410)];

}

- (void)addMenus{
    CCMenu * menu = [CCMenu menuWithItems:
                 [CCMenuItemFont itemFromString:@"继续游戏"
                                          block:^(id sender){[game resumeFromPauseMenu];}],
                 [CCMenuItemFont itemFromString:@"重新开始"
                                          block:^(id sender){[game restartFromPauseMenu];}],
                 [CCMenuItemFont itemFromString:@"回主菜单"
                                          block:^(id sender){
                                              [[MTSharedManager instance] replaceSceneWithID:0];}],                         
                 nil];
    for (CCMenuItemFont * child in menu.children) {
        child.color = kMTColorActive;
    }
    [menu alignItemsVerticallyWithPadding:kMTMenuPadding];
    menu.position = ccp(560, 1024-775);
    [self addChild:menu];
}


// Update MTGame related stuff.
- (void)show{
    [self addBackground];
    [self addStats];
    [self addMenus];    
}


- (void)addLabel:(CCLabelTTF *)child at:(CGPoint)p{
    child.position = p;
    child.anchorPoint = ccp(0,0);
    child.color = kMTColorInactive;
    [self addChild:child];
}

@end
