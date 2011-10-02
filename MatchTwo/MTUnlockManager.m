//
//  MTUnlockManager.m
//  MatchTwo
//
//  Created by  on 11-9-30.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import "MTUnlockManager.h"
#import "MTAbility.h"
#import "MTAbilityButton.h"

@implementation MTUnlockManager

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        unlocks = [NSMutableArray arrayWithObjects:
                   [MTUnlockItem item],                                         //0
                   
                   [MTUnlockAbility itemWithAbility:kMTAbilityHint level:1],    //1
                   [MTUnlockExtraTime item],
                   [MTUnlockExtraScore item],
                   [MTUnlockExtraBonus item],
                   [MTUnlockAbility itemWithAbility:kMTAbilityFreeze level:1],  //5               
                   
                   [MTUnlockExtraTime item],
                   [MTUnlockExtraScore item],
                   [MTUnlockExtraBonus item],
                   [MTUnlockExtraTime item],
                   [MTUnlockAbility itemWithAbility:kMTAbilityHint level:2],    //10
                   
                   [MTUnlockExtraScore item],
                   [MTUnlockExtraBonus item],
                   [MTUnlockExtraTime item],
                   [MTUnlockExtraScore item],                   
                   [MTUnlockAbility itemWithAbility:kMTAbilityHint level:3],    //15
                   
                   [MTUnlockExtraBonus item],
                   [MTUnlockExtraTime item],
                   [MTUnlockExtraScore item],  
                   [MTUnlockExtraBonus item],                   
                   [MTUnlockAbility itemWithAbility:kMTAbilityHighlight level:1],    //20
                   
                   [MTUnlockExtraTime item],
                   [MTUnlockExtraScore item],  
                   [MTUnlockExtraBonus item],     
                   [MTUnlockExtraTime item],
                   [MTUnlockExtraScore item],  
                   [MTUnlockExtraBonus item],     
                   [MTUnlockExtraTime item],
                   [MTUnlockExtraScore item],  
                   [MTUnlockExtraBonus item],                        
                   [MTUnlockAbility itemWithAbility:kMTAbilityFreeze level:2],    //30
                   
                   [MTUnlockExtraTime item],
                   [MTUnlockExtraScore item],  
                   [MTUnlockExtraBonus item],     
                   [MTUnlockExtraTime item],
                   [MTUnlockExtraScore item],  
                   [MTUnlockExtraBonus item],     
                   [MTUnlockExtraTime item],
                   [MTUnlockExtraScore item],  
                   [MTUnlockExtraBonus item],                        
                   [MTUnlockAbility itemWithAbility:kMTAbilityFreeze level:3],    //40
                   
                   [MTUnlockExtraTime item],
                   [MTUnlockExtraScore item],  
                   [MTUnlockExtraBonus item],     
                   [MTUnlockExtraTime item],
                   [MTUnlockExtraScore item],  
                   [MTUnlockExtraBonus item],     
                   [MTUnlockExtraTime item],
                   [MTUnlockExtraScore item],  
                   [MTUnlockExtraBonus item],                        
                   [MTUnlockAbility itemWithAbility:kMTAbilityShuffle level:1],    //50

                   [MTUnlockExtraTime item],
                   [MTUnlockExtraScore item],  
                   [MTUnlockExtraBonus item],     
                   [MTUnlockExtraTime item],
                   [MTUnlockExtraScore item],  
                   [MTUnlockExtraBonus item],     
                   [MTUnlockExtraTime item],
                   [MTUnlockExtraScore item],  
                   [MTUnlockExtraBonus item],                        
                   [MTUnlockAbility itemWithAbility:kMTAbilityHighlight level:2],    //60
                   
                   [MTUnlockExtraTime item],
                   [MTUnlockExtraScore item],  
                   [MTUnlockExtraBonus item],     
                   [MTUnlockExtraTime item],
                   [MTUnlockExtraScore item],  
                   [MTUnlockExtraBonus item],     
                   [MTUnlockExtraTime item],
                   [MTUnlockExtraScore item],  
                   [MTUnlockExtraBonus item],                        
                   [MTUnlockAbility itemWithAbility:kMTAbilityHighlight level:3],    //70
                   
                   [MTUnlockExtraTime item],
                   [MTUnlockExtraScore item],  
                   [MTUnlockExtraBonus item],     
                   [MTUnlockExtraTime item],
                   [MTUnlockExtraScore item],  
                   [MTUnlockExtraBonus item],     
                   [MTUnlockExtraTime item],
                   [MTUnlockExtraScore item],  
                   [MTUnlockExtraBonus item],                        
                   [MTUnlockAbility itemWithAbility:kMTAbilityShuffle level:2],    //80
                   
                   [MTUnlockExtraTime item],
                   [MTUnlockExtraScore item],  
                   [MTUnlockExtraBonus item],     
                   [MTUnlockExtraTime item],
                   [MTUnlockExtraScore item],  
                   [MTUnlockExtraBonus item],     
                   [MTUnlockExtraTime item],
                   [MTUnlockExtraScore item],  
                   [MTUnlockExtraBonus item],                        
                   [MTUnlockAbility itemWithAbility:kMTAbilityShuffle level:3],    //90

                   [MTUnlockExtraTime item],
                   [MTUnlockExtraScore item],  
                   [MTUnlockExtraBonus item],     
                   [MTUnlockExtraTime item],
                   [MTUnlockExtraScore item],  
                   [MTUnlockExtraBonus item],     
                   [MTUnlockExtraTime item],
                   [MTUnlockExtraScore item],  
                   [MTUnlockExtraBonus item],
                   [MTUnlockAbility itemWithAbility:kMTAbilityHint level:4],    //100
                   nil];
        [unlocks retain];
    }
    
    return self;
}

- (void)dealloc{
    [unlocks removeAllObjects];
    [unlocks release];
    [super dealloc];
}

- (NSString *)descriptionForLevel:(int)level{
    MTUnlockItem * unlock = [unlocks objectAtIndex:level];
    if (unlock == nil) {
        CCLOGERROR(@"Level Out of Bounds");
    }
    return [unlock description];
}
- (CCSprite *)badgeForLevel:(int)level{
    MTUnlockItem * unlock = [unlocks objectAtIndex:level];
    if (unlock == nil) {
        CCLOGERROR(@"Level Out of Bounds");
    }    
    return [unlock badge];
}

- (int)levelForAbility:(NSString *)abilityName{
    int currentLevel = [MTSharedManager instance].level;
    for (int i = currentLevel; i>0; i--) {
        id unlock = [unlocks objectAtIndex:i];
        if ([unlock isKindOfClass:[MTUnlockAbility class]]) {
            if ([unlock ability] == abilityName) {
                return [unlock level];
            }
        }
    }
    return 0;
}


- (NSDictionary *)bonusUnlocks{
    int extraTimeCount = 0;
    int extraScoreCount = 0;
    int extraBonusCount = 0;
    
    int currentLevel = [MTSharedManager instance].level;
    for (int i = 1; i <= currentLevel; i++) {
        id unlock = [unlocks objectAtIndex:i];
        if ([unlock isKindOfClass:[MTUnlockExtraTime class]]) {
            extraTimeCount++;
        }else if([unlock isKindOfClass:[MTUnlockExtraScore class]]) {
            extraScoreCount++;
        }else if([unlock isKindOfClass:[MTUnlockExtraBonus class]]) {
            extraBonusCount++;
        }
    }
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInt:extraTimeCount], kMTUnlockExtraTimeCount,
            [NSNumber numberWithInt:extraScoreCount], kMTUnlockExtraScoreCount,
            [NSNumber numberWithInt:extraBonusCount], kMTUnlockExtraBonusCount,
             nil];
}

@end



#pragma mark -
#pragma mark Unlock Item Definition


@implementation MTUnlockItem

+ (id)item{
    return [[[self alloc]init]autorelease];
}

- (CCSprite *)badge{
    CCLOGERROR(@"OVERRIDE ME!!!");
    return nil;
}

@end



@implementation MTUnlockAbility

@synthesize ability,level;

+ (id)itemWithAbility:(NSString *)n level:(int)l{
    MTUnlockAbility * unlock = [[self alloc]init];
    unlock.ability = n;
    unlock.level = l;
    return [unlock autorelease];
}

- (NSString *)description{
    if (level == 1) {
        return [NSString stringWithFormat:@"新技能!『%s』", [MTAbility descriptionForAbility:ability]];
    }else{
        return [NSString stringWithFormat:@"增加『%s』的持续时间", [MTAbility descriptionForAbility:ability]];
    }
}

- (CCSprite *)badge{
    int index = [MTAbilityButton idForButtonName:ability];
    return [CCSprite spriteWithFile:@"Unlocks.png" rect:[MTAbilityButton rectForIndex:index]];
}

@end


@implementation MTUnlockExtraTime

- (NSString *)description{
    return @"『额外时间』\n\t每个关卡获得5秒\n\t额外时间";
}

- (CCSprite *)badge{
    return [CCSprite spriteWithFile:@"Unlocks.png" 
                               rect:[MTAbilityButton rectForIndex:8]
            ];
}

@end

@implementation MTUnlockExtraScore

- (NSString *)description{
    return @"『额外分数』\n\t你消除方块会获得\n\t额外的分数";
}

- (CCSprite *)badge{
    return [CCSprite spriteWithFile:@"Unlocks.png" 
                               rect:[MTAbilityButton rectForIndex:9]
            ];
}

@end

@implementation MTUnlockExtraBonus

- (NSString *)description{
    return @"『额外奖励』\n\t你会获得更多\n\t奖励方块";
}

- (CCSprite *)badge{
    return [CCSprite spriteWithFile:@"Unlocks.png" 
                               rect:[MTAbilityButton rectForIndex:10]
            ];
}

@end

