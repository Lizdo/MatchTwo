//
//  MTLine.m
//  MatchTwo
//
//  Created by  on 11-8-1.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import "MTLine.h"


@implementation MTLine

- (MTLine *)initWithPoints:(NSArray *)thePoints{
    self = [super init];
    if (self) {
        points = [thePoints copy];
    }
    return self;
}

+ (id)lineWithPoints:(NSArray *)thePoints{
    MTLine * line = [[MTLine alloc]initWithPoints:thePoints];
    return [line autorelease];
}

- (void)draw{
    if (points == nil || [points count] < 2) {
        return;
    }
    glColor4f(1.0, 1.0, 1.0, 1.0);  
    glLineWidth(4.0);
    glEnable(GL_LINE_SMOOTH);
    
    for (int i = 0; i < [points count]-1; i++) {
        ccDrawLine([[points objectAtIndex:i] CGPointValue],
                   [[points objectAtIndex:i+1] CGPointValue]);
    }

}


- (void)dealloc{
    [points release];
    [super dealloc];
}

@end
