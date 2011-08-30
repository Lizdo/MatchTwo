//
//  MTTimeLine.m
//  MatchTwo
//
//  Created by  on 11-8-7.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import "MTTimeLine.h"
#import "GameConfig.h"
#import "CCDrawingPrimitives+MT.h"

@interface MTTimeLine()

- (ccColor4F)fillColor;

@end

@implementation MTTimeLine

@synthesize frozen, highlight, game;

- (void)setPercentage:(float)newPercentage{
    if (newPercentage > 1) {
        newPercentage = 1;
    }
    if (newPercentage < 0) {
        newPercentage = 0;
    }
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
    // Draw Fill
    if (frozen) {
        glColor4f(0.6,0.8,0.8,0.4);
    }else if(highlight){
        glColor4f(1.0,0.5,0.0,0.4);        
    }else{
        ccColor4F c = [self fillColor];
        glColor4f(c.r, c.g, c.b, c.a);
    }

    glLineWidth(1.0);
    glEnable(GL_LINE_SMOOTH);
    CGPoint otherPoints[4] = {
        ccp(0, 0),
        ccp(kMTTimeLineWidth * percentage, 0),
        ccp(kMTTimeLineWidth * percentage, kMTTimeLineHeight),
        ccp(0, kMTTimeLineHeight)
    };
    ccDrawPolyFill(otherPoints, 4, YES);
    
    // Draw Border
//    glColor4f(0.6, 0.6, 0.6, 1);  
//    glLineWidth(1.0);
//    glEnable(GL_LINE_SMOOTH);
//    CGPoint points[4] = {
//        ccp(1.5, 1),
//        ccp(kMTTimeLineWidth-1, 1),
//        ccp(kMTTimeLineWidth-1, kMTTimeLineHeight-1.5),
//        ccp(1.5, kMTTimeLineHeight-1.5)
//    };
//    ccDrawPoly(points, 4, YES);
}

- (ccColor4F)fillColor{
    float greenNess = 0.6 * sin(percentage);
    ccColor4F c = {0.1, 0.7 - greenNess, 0.1, 0.4};
    return c;

}

@end
