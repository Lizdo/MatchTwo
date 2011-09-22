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


- (void)addMenus{        
        // Buttons
    menu = [CCMenu menuWithItems:
            [CCMenuItemFont itemFromString:@"下一关"
                                     block:^(id sender){
                                         [[MTSharedManager instance] gotoNextLevel:game.levelID];}],
            [CCMenuItemFont itemFromString:@"主菜单"
                                     block:^(id sender){
                                         [[MTSharedManager instance] replaceSceneWithID:0];}],                     
            nil];

}

- (NSString *)scoreDescription{
    NSString * s = [NSString stringWithFormat:@"剩余时间: %8.0f\n", game.remainingTime];
    s = [s stringByAppendingFormat:@"时间奖励: %8d\n", game.timeBonus];
    if (game.obj != kMTObjectiveNone) {
        s = [s stringByAppendingFormat:@"任务奖励: %8d\n", game.objBonus];
    }
    s = [s stringByAppendingFormat:@"总得分: %8d\n", game.timeBonus + game.objBonus + game.completeBonus];
    // Add level unlock description here, next level unlock description
    return s;
}


@end
