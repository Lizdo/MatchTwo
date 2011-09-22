//
//  MTObjectiveHelper.m
//  MatchTwo
//
//  Created by Liz on 11-9-22.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import "MTObjectiveHelper.h"

@implementation MTObjectiveHelper

+ (NSString *)descriptionForObjective:(MTObjective)obj{
    switch (obj) {
        case kMTObjectiveFinishFast:
            return @"在2/3时间内完成";
            break;
        case kMTObjectiveNoAbility:
            return @"不使用任何能力";
            break;
        case kMTObjectiveThreeInARow:
            return @"连续消除3组同样图案";
            break;
        case kMTObjectiveNone:
        default:
            return @"没有任务";
            break;
    }
}

@end
