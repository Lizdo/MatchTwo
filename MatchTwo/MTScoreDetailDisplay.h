//
//  MTScoreDetailDisplay.h
//  MatchTwo
//
//  Created by  on 11-11-3.
//  Copyright (c) 2011年 StupidTent co. All rights reserved.
//

#import "CCLayer.h"
#import "MTScoreDisplay.h"
#import "MTAbility.h"
#import "MTAbilityDetailDisplay.h"

@interface MTScoreDetailDisplay : CCNode<CCRGBAProtocol, CCStandardTouchDelegate>{
    MTScoreDisplay * scoreDisplay;
    MTAbilityDetailDisplay * abilityDetailDisplay;
    NSMutableArray * abilities;
}

- (void)showAbilityDetailFor:(MTAbility *)ability;
- (void)hideAbilityDetail;
@end
