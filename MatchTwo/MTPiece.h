//
//  MTPiece.h
//  MatchTwo
//
//  Created by  on 11-8-1.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MTPiece : CCNode {
    int row;
    int column;    
}

- (id)initWithRow:(int)theRow andColumn:(int)theColumn;
+ (MTPiece *)pieceWithRow:(int)theRow andColumn:(int)theColumn;

@end
