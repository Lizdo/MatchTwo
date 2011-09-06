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

@synthesize game;



- (id)init{
    self = [super init];
    if (self) {
        // Move the background down
        
        CCLabelTTF * timeUpLabel = [CCLabelTTF labelWithString:@"时间到了..."
                                                      fontName:kMTFont
                                                      fontSize:kMTFontSizeCaption];
        CGSize winSize = [[CCDirector sharedDirector] winSize];    
        timeUpLabel.position = ccp(winSize.width/2, 700);
        [self addChild:timeUpLabel];
        
        menu = [CCMenu menuWithItems:[CCMenuItemFont itemFromString:@"重新开始"
                                                                   block:^(id sender){[game restart];}],
                     [CCMenuItemFont itemFromString:@"主菜单"
                                              block:^(id sender){
                                                  [[MTSharedManager instance] replaceSceneWithID:0];}],                         
                     nil];
        [menu alignItemsVerticallyWithPadding:kMTMenuPadding];
    }
    return self;
}


- (void)show{
    
}

@end