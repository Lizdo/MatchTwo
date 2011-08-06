//
//  MTLogicHelper.h
//  MatchTwo
//
//  Created by  on 11-8-1.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameConfig.h"

typedef enum{
    TileState_Empty,
    TileState_Source,
    TileState_Destination,
    TileState_FirstStep,
    TileState_SecondStep,
    TileState_Occupied
}TileState;

@interface MTTile : NSObject {
    int x;
    int y;
    TileState state;
    MTTile * lastConnectedTile;
}

@property int x;
@property int y;
@property (assign) MTTile * lastConnectedTile;
@property TileState state;

+ (MTTile *)tileWithX:(int)idx andY:(int)idy;
- (BOOL)isEmpty;

@end

@interface MTLogicHelper : NSObject{
    NSMutableArray * tiles;
    NSMutableArray * lineTiles;
    
    MTTile * source;
    MTTile * destination;    
    
    int rowNumber;
    int columnNumber;    
}

- (id)initWithRows:(int)rowNumber andColumns:(int)colNumber;

- (void)reset;  // Reset all tiles to Empty;
- (NSArray *)check;

- (CGPoint)GLLocationForTile:(MTTile *)t;
- (NSArray *)GLLocationForTiles:(NSArray *)array;

- (MTTile *)tileWithRow:(int)row andColumn:(int)column;
- (void)setSourceRow:(int)row andColumn:(int)column;
- (void)setDestinationRow:(int)row andColumn:(int)column;

- (NSArray *)adjucentEmptyTilesFrom:(MTTile*)t;


@end
