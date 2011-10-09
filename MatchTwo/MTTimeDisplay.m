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
    self.string = [MTTimeDisplay stringWithSeconds:seconds];
    
    if ([game isAbilityActive:kMTAbilityFreeze]) {
        self.color = kMTColorFrozen;
    }else if ([game isAbilityActive:kMTAbilityExtraTime]) {
        self.color = kMTColorBuff;
    }else if (seconds <= 30){
        self.color = kMTColorDebuff;
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
