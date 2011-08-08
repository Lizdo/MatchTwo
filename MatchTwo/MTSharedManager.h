//
//  MTSharedManager.h
//  MatchTwo
//
//  Created by  on 11-8-8.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTSharedManager : NSObject{
    BOOL isMusicOn;
    BOOL isSoundEffectOn;
    
    int totalScore;
}

@property BOOL isMusicOn;
@property BOOL isSoundEffectOn;
@property int totalScore;

+ (MTSharedManager *)instance;

@end
