//
//  MTTouchToStartLayer.h
//  MatchTwo
//
//  Created by  on 11-10-23.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@protocol MTTouchToStartProtocol <NSObject>
- (void)start;
@end

@interface MTTouchToStartLayer : CCLayerColor {
    CCNode<MTTouchToStartProtocol> * delegate;
}

@property (nonatomic, assign) CCNode<MTTouchToStartProtocol> * delegate;

@end
