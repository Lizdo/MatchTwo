//
//  MTBoard.h
//  MatchTwo
//
//  Created by  on 11-8-3.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MTSharedManager.h"

@class MTPiece;
@class MTLogicHelper;
@class MTGame;

typedef enum{
    kMTCollapseDirectionDown,
    kMTCollapseDirectionUp,
    kMTCollapseDirectionLeft,
    kMTCollapseDirectionRight,
}MTCollapseDirection;

@interface MTBoard : CCLayer <CCTargetedTouchDelegate>{
    MTPiece * selectedPiece1;
    MTPiece * selectedPiece2;
    
    // Initial Value
    int rowNumber;
    int columnNumber;
    int types;
    
    BOOL checkingInProgress;
    
    MTLogicHelper * helper;
    MTGame * game;
}

@property (readonly) int rowNumber;
@property (readonly) int columnNumber;
@property (assign) MTGame * game;

- (id)initWithRowNumber:(int)row andColumnNumber:(int)col;

- (void)pause;
- (void)resume;

- (void)shuffle;
- (BOOL)findLink;

- (MTPiece *)randomPiece;
- (MTPiece *)pieceAtRow:(int)row andColumn:(int)column;
- (void)collapse:(MTCollapseDirection)direction;

@end
