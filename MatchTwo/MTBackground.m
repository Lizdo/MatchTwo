//
//  MTBackground.m
//  MatchTwo
//
//  Created by  on 11-8-10.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import "MTBackground.h"
#import "MTSFX.h"

@implementation MTBackground

- (id)init{
    self = [super init];
    if (self) {
        [self addChild:[[[MTParticleLoopingStar alloc]init]autorelease]];
    }
    return self;
}

@end
