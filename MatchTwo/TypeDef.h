//
//  TypeDef.h
//  MatchTwo
//
//  Created by  on 11-11-10.
//  Copyright (c) 2011年 StupidTent co. All rights reserved.
//

#ifndef MatchTwo_TypeDef_h
#define MatchTwo_TypeDef_h



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
