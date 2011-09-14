//
//  MTProgressBar.h
//  MatchTwo
//
//  Created by  on 11-9-14.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MTProgressBar : CCNode {
    float percentage;
    CGRect rect;
}

@property float percentage;

- (void)update:(ccTime)dt;

@end
