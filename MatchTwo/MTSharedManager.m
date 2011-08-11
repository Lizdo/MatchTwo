//
//  MTSharedManager.m
//  MatchTwo
//
//  Created by  on 11-8-8.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import "MTSharedManager.h"

@implementation MTSharedManager

@synthesize noMusic, noSoundEffect, totalScore;

static MTSharedManager * _instance = nil;


+ (id)alloc {
    @synchronized ([MTSharedManager class])
    {
        NSAssert(_instance == nil, @"Attempted to allocate a second instance of the Game Manager singleton");
        _instance = [super alloc];
        return _instance;
    }
    return nil; 
}

- (id)init
{
    self = [super init];
    if (self) {
        // Load from user defalts
        noMusic = [[NSUserDefaults standardUserDefaults] boolForKey:@"noMusic"];
        noSoundEffect = [[NSUserDefaults standardUserDefaults] boolForKey:@"noSoundEffect"];
        totalScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"totalScore"];
    }
    return self;
}

+ (MTSharedManager *)instance{
    @synchronized([MTSharedManager class])
    {
        if(!_instance)
            [[self alloc] init];
        return _instance;
    }
    return nil;
}

- (void)save{
    [[NSUserDefaults standardUserDefaults] setBool:noMusic forKey:@"noMusic"];
    [[NSUserDefaults standardUserDefaults] setBool:noSoundEffect forKey:@"noSoundEffect"];
    [[NSUserDefaults standardUserDefaults] setInteger:totalScore forKey:@"totalScore"];
}

@end
