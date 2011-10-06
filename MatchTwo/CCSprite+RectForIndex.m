//
//  CCSprite+CCSprite_RectForIndex.m
//  MatchTwo
//
//  Created by  on 11-10-6.
//  Copyright (c) 2011年 StupidTent co. All rights reserved.
//

#import "CCSprite+RectForIndex.h"

@implementation CCSprite (RectForIndex)

+ (CGRect)rectForIndex:(int)index textureSize:(int)texSize canvasSize:(int)canvasSize{
    int rows = canvasSize/texSize;
    int idX = index % rows;
    int idY = index / rows;
    return CGRectMake(idX * texSize, 
                      idY * texSize, 
                      texSize, 
                      texSize);
}

+ (CCSprite *)spriteWithFile:(NSString *)file index:(int)index textureSize:(int)texSize canvasSize:(int)canvasSize{
    CCSprite * s = [CCSprite spriteWithFile:file 
                                       rect:[CCSprite rectForIndex:index textureSize:texSize canvasSize:canvasSize]];
    return s;
}

@end
