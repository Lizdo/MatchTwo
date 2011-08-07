//
//  MTPiece.h
//  MatchTwo
//
//  Created by  on 11-8-1.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameConfig.h"

@interface MTPiece : CCSprite {
    int row;
    int column;
    
    int type;
    
    BOOL selected;
    BOOL enabled;
}

@property int row;
@property int column;
@property int type;
@property BOOL selected;
@property BOOL enabled;

- (id)initWithType:(int)type;

//- (id)initWithRow:(int)theRow andColumn:(int)theColumn;
//+ (MTPiece *)pieceWithRow:(int)theRow andColumn:(int)theColumn;

- (void)disappear;


@end
