//
//  MTLevelFailPage.m
//  MatchTwo
//
//  Created by  on 11-9-6.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import "MTLevelFailPage.h"
#import "MTSharedManager.h"
#import "MTGame.h"


@implementation MTLevelFailPage


- (void)addMenus{
    menu = [CCMenu menuWithItems:
            [MTMenuItem itemFromString:@"重新开始"
                                     block:^(id sender){[game restartFromPauseMenu];}],
            [MTMenuItem itemFromString:@"主菜单"
                                     block:^(id sender){
                                         [[MTSharedManager instance] replaceSceneWithID:0];}],                         
            nil];
    stamp = [CCSprite spriteWithFile:@"Stamp_Fail.png"];    
}

@end