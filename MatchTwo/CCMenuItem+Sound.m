//
//  CCMenuItem+Sound.m
//  MatchTwo
//
//  Created by  on 11-11-2.
//  Copyright (c) 2011年 StupidTent co. All rights reserved.
//

#import "CCMenuItem.h"
#import "SimpleAudioEngine.h"

@implementation CCMenuItem (Sound)

- (void)activate{
    // Play an additional sound
    [[SimpleAudioEngine sharedEngine] playEffect:@"button.caf"];

    // Original Implementation
    if(isEnabled_)
        [invocation_ invoke];
}

@end
