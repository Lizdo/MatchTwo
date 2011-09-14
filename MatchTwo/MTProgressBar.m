//
//  MTProgressBar.m
//  MatchTwo
//
//  Created by  on 11-9-14.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import "MTProgressBar.h"


@implementation MTProgressBar

@synthesize percentage;

- (void)update:(ccTime)dt{
    CGPoint worldPosition = [self convertToNodeSpace:self.position];
    rect = CGRectMake(worldPosition.x, worldPosition.y,
                      self.contentSize.width, self.contentSize.height);
}

- (void) visit
{
    if (!self.visible) {
        return;
    }
    glEnable(GL_SCISSOR_TEST);
    glScissor(rect.origin.x,
              rect.origin.y,
              rect.size.width,
              rect.size.height);   
    [super visit];
    glDisable(GL_SCISSOR_TEST);
}

@end
