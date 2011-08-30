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

@class MTGame;

@interface MTPiece : CCSprite {
    int row;
    int column;
    
    int type;
    
    BOOL selected;
    BOOL enabled;
    
    BOOL hinted;
    BOOL shaking;
    
    MTPiece * pairedPiece;
    
    MTGame * game;
    
    MTPiece * shufflePiece;
    int newRow;
    int newColomn;
    
    // Used for ability activation
    CCSprite * badge;
    NSString * ability;
}

@property int row;
@property int column;
@property int type;
@property BOOL selected;
@property BOOL enabled;
@property BOOL hinted;
@property (assign) MTPiece * pairedPiece;
@property (assign) MTPiece * shufflePiece;
@property (assign) MTGame * game;
@property (retain) NSString * ability;

- (id)initWithType:(int)type;

//- (id)initWithRow:(int)theRow andColumn:(int)theColumn;
//+ (MTPiece *)pieceWithRow:(int)theRow andColumn:(int)theColumn;

- (void)disappear;
- (void)shake;
- (void)shuffle;

- (void)assignAbility:(NSString *)abilityName;

@end
