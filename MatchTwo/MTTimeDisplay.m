//
//  MTTimeDisplay.m
//  MatchTwo
//
//  Created by  on 11-9-18.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import "MTTimeDisplay.h"
#import "MTGame.h"

@interface MTTimeDisplay ()
@end

@implementation MTTimeDisplay

@synthesize frozen, highlight, game;

- (void)update{
    int seconds = round(game.remainingTime);
    NSString * secondsString = [MTTimeDisplay stringWithSeconds:seconds];
    if ([self.string isEqualToString:secondsString]) {
        return;
    }
    
    //Only Update when there's a time change
    self.string = secondsString;
       
    if ([game isAbilityActive:kMTAbilityFreeze]) {
        self.color = kMTColorFrozen;
    }else if ([game isAbilityActive:kMTAbilityExtraTime]) {
        self.color = kMTColorBuff;
        [self runAction:[CCBlink actionWithDuration:0.2 blinks:1]];        
    }else if (seconds < 30){
        self.color = kMTColorDebuff;
        [self runAction:[CCBlink actionWithDuration:0.1 blinks:1]];        
    }else if (seconds % 30 == 0){
        // Magnify at 30/60/90 seconds
        self.color = [MTTheme primaryColor];
        [self runAction:[CCSequence actions:
                         [CCScaleTo actionWithDuration:0.1 scale:1.5],
                         [CCScaleTo actionWithDuration:0.1 scale:1],                         
                         nil]];
    }else{
        self.color = [MTTheme primaryColor];
    }
}
                   
+ (NSString *)stringWithSeconds:(int)seconds{
    int h = seconds/3600;
    int m = (seconds - 3600*h)/60;
    int s = seconds - 3600*h - 60*m;
    if (h > 0){
        return [NSString stringWithFormat:@"%d:%02d:%02d", h,m,s];
    }else if (m>0){
        return [NSString stringWithFormat:@"%d:%02d",m,s];
    }else{
        return [NSString stringWithFormat:@"%d", s];
    }
}

@end
