//
//  MTBoard.h
//  MatchTwo
//
//  Created by  on 11-8-3.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class MTPiece;
@class MTLogicHelper;

@interface MTBoard : CCLayer <CCTargetedTouchDelegate>{
    MTPiece * selectedPiece1;
    MTPiece * selectedPiece2;
    
    
    // Initial Value
    int rowNumber;
    int columnNumber;
    
    BOOL checkingInProgress;
    
    MTLogicHelper * helper;
}

@property (readonly) int rowNumber;
@property (readonly) int columnNumber;

- (id)initWithRowNumber:(int)row andColumnNumber:(int)col;

@end
