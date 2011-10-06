//
//  CCSprite+CCSprite_RectForIndex.h
//  MatchTwo
//
//  Created by  on 11-10-6.
//  Copyright (c) 2011年 StupidTent co. All rights reserved.
//

#import "CCSprite.h"

@interface CCSprite (CCSprite_RectForIndex)

+ (CGRect)rectForIndex:(int)index textureSize:(int)texSize canvasSize:(int)canvasSize;
+ (CCSprite *)spriteWithFile:(NSString *)file index:(int)index textureSize:(int)texSize canvasSize:(int)canvasSize;
@end
