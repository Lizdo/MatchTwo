//
//  TypeDef.h
//  MatchTwo
//
//  Created by  on 11-11-10.
//  Copyright (c) 2011年 StupidTent co. All rights reserved.
//

#ifndef MatchTwo_TypeDef_h
#define MatchTwo_TypeDef_h

//! helper macro that creates an ccColor3B type
static inline ccColor3B
ccc3FromHex(int rgb)
{
    int r = (rgb >> 16) & 0xFF;
    int g = (rgb >> 8) & 0xFF;
    int b = (rgb >> 0) & 0xFF;
	ccColor3B c = ccc3(r, g, b);
	return c;
}

typedef enum {
    kMTObjectiveNone = 0,
    kMTObjectiveFinishFast = 1,
    kMTObjectiveNoAbility = 2,
    kMTObjectiveThreeInARow = 3,
}MTObjective;

typedef enum {
    kMTObjectiveStateInProgress = 0,
    kMTObjectiveStateComplete = 1,
    kMTObjectiveStateFailed = 2,
}MTObjectiveState;

typedef enum{
    kMTGameModeNormal = 0,
    kMTGameModeDown = 1,
    kMTGameModeUp = 2,
    kMTGameModeLeft = 3,    
    kMTGameModeRight = 4,        
}MTGameMode;

#define kMTAbilityDidActivateNotification       @"kMTAbilityDidActivateNotification"
#define kMTAbilityWillDeactivateNotification    @"kMTAbilityWillDeactivateNotification"

#endif //MatchTwo_TypeDef_h
