//
//  MTAbilityDetailDisplay.h
//  MatchTwo
//
//  Created by  on 11-11-6.
//  Copyright (c) 2011年 StupidTent co. All rights reserved.
//

#import "CCNode.h"
#import "MTAbility.h"

@interface MTAbilityDetailDisplay : CCNode{
    MTAbility * ability;
}

- (MTAbilityDetailDisplay *)initWithAbility:(MTAbility *)theAbility;
+ (id)detailDisplayForAbility:(MTAbility *)theAbility;

@end
