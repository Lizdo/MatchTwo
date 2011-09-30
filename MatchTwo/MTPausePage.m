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
- (void)setupMenus;
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

    CCLabelTTF * level = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",[MTSharedManager instance].level]
                                            fontName:kMTFontNumbers
                                            fontSize:kMTFontSizeCaption];
    level.position = ccp(260, 1024-340);
    level.anchorPoint = ccp(1,0);
    level.color = kMTColorPrimary;
    [self addChild:level];
    
    // Next Level Unlock
    [self addLabel:[CCLabelTTF labelWithString:@"下一级解锁"
                                      fontName:kMTFont
                                      fontSize:kMTFontSizeNormal]
                at:ccp(373,1024-230)];
    
//    CCLabelTTF * unlock = [CCLabelTTF labelWithString:[[MTSharedManager instance] nextLevelUnlockDescription]
//                                          fontName:kMTFont
//                                          fontSize:kMTFontSizeSmall];
    
    CCLabelTTF * unlock = [CCLabelTTF labelWithString:[[MTSharedManager instance] nextLevelUnlockDescription]
                                           dimensions:CGSizeMake(300, 100)
                                            alignment:CCTextAlignmentLeft
                                        lineBreakMode:CCLineBreakModeTailTruncation
                                             fontName:kMTFont
                                             fontSize:kMTFontSizeSmall];
    unlock.position = ccp(477, 1024 - 255);
    unlock.anchorPoint = ccp(0,1);
    unlock.color = kMTColorInactive;
    [self addChild:unlock];    
    
    
    // Remaining Time
    [self addLabel:[CCLabelTTF labelWithString:@"剩余时间"
                                      fontName:kMTFont
                                      fontSize:kMTFontSizeNormal]
                at:ccp(90,1024-410)];
    
    CCLabelTTF * time = [CCLabelTTF labelWithString:[game remainingTimeString]
                                           fontName:kMTFontNumbers
                                           fontSize:kMTFontSizeLarge];
    time.position = ccp(250, 1024-480);
    time.anchorPoint = ccp(1,0);
    time.color = kMTColorPrimary;
    [self addChild:time];
    
    // Level Objective
    [self addLabel:[CCLabelTTF labelWithString:@"关卡任务"
                                      fontName:kMTFont
                                      fontSize:kMTFontSizeNormal]
                at:ccp(373,1024-410)];
    
    CCLabelTTF * obj = [CCLabelTTF labelWithString:[game objectiveString]
                                          fontName:kMTFont
                                          fontSize:kMTFontSizeSmall];
    obj.position = ccp(477, 1024 - 455);
    obj.anchorPoint = ccp(0,0);
    obj.color = kMTColorInactive;
    [self addChild:obj];
    
    CCLabelTTF * objStatus = [CCLabelTTF labelWithString:@""
                                                fontName:kMTFont
                                                fontSize:kMTFontSizeNormal];
    objStatus.position = ccp(477, 1024 - 507);
    objStatus.anchorPoint = ccp(0,0);
    
    if (game.obj != kMTObjectiveNone) {
        [self addChild:objStatus];        
    }
    
    if (game.objState == kMTObjectiveStateFailed) {
        objStatus.string = @"失败";
        objStatus.color = kMTColorDebuff;
    }else if (game.objState == kMTObjectiveStateComplete){
        objStatus.string = @"成功";
        objStatus.color = kMTColorBuff;
    }else{
        objStatus.string = @"进行中";
        objStatus.color = kMTColorBuff;
    }


}

- (void)addMenus{
    menu = [CCMenu menuWithItems:
                 [CCMenuItemFont itemFromString:@"继续游戏"
                                          block:^(id sender){[game resumeFromPauseMenu];}],
                 [CCMenuItemFont itemFromString:@"重新开始"
                                          block:^(id sender){[game restartFromPauseMenu];}],
                 [CCMenuItemFont itemFromString:@"回主菜单"
                                          block:^(id sender){
                                              [[MTSharedManager instance] replaceSceneWithID:0];}],                         
                 nil];
    stamp = [CCSprite spriteWithFile:@"Stamp_Pause.png"];    
}

- (void)setupMenus{    
    for (CCMenuItemFont * child in menu.children) {
        child.color = kMTColorActive;
    }
    [menu alignItemsVerticallyWithPadding:kMTMenuPadding];
    menu.position = ccp(560, 1024-775);
    [self addChild:menu];
    
    stamp.position = ccp(214, 1024-785);
    [self addChild:stamp];
}


// Update MTGame related stuff.
- (void)show{
    [self addBackground];
    [self addStats];
    [self addMenus];
    [self setupMenus];
}


- (void)addLabel:(CCLabelTTF *)child at:(CGPoint)p{
    child.position = p;
    child.anchorPoint = ccp(0,0);
    child.color = kMTColorInactive;
    [self addChild:child];
}

@end
