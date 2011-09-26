//
//  CCLabelBMFont+KerningHack.m
//  MatchTwo
//
//  Created by  on 11-9-26.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import "CCLabelBMFont.h"

@implementation CCLabelBMFont (KerningHack)

-(int) kerningAmountForFirst:(unichar)first second:(unichar)second
{
    // Hack!
    // Because the padding support for Heiro is broken and there's no easy way to fix that...
    return -3;
    // Hack End
}

@end
