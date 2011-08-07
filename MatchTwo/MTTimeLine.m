//
//  MTTimeLine.m
//  MatchTwo
//
//  Created by  on 11-8-7.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import "MTTimeLine.h"
#import "GameConfig.h"

@implementation MTTimeLine

- (void)setPercentage:(float)newPercentage{
    NSAssert(newPercentage >= 0 && newPercentage <= 1.0, @"Wrong percentage set!");
    percentage = newPercentage;
}

- (float)percentage{
    return percentage;
}

- (id)init{
    self = [super init];
    if (self) {
        //self.contentSize = CGSizeMake(kMTTimeLineWidth, kMTTimeLineHeight);
    }
    return self;
}

- (void)draw{
    glColor4f(1.0, 1.0, 0.0, 1.0);  
    glLineWidth(1.0);
    glEnable(GL_LINE_SMOOTH);
    CGPoint points[4] = {
        ccp(0, 0),
        ccp(kMTTimeLineWidth * percentage, 0),
        ccp(kMTTimeLineWidth * percentage, kMTTimeLineHeight),
        ccp(0, kMTTimeLineHeight)
    };
    ccDrawPoly(points, 4, YES);
}

@end
