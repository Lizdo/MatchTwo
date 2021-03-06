//
//  MTFloatingLabel.h
//  MatchTwo
//
//  Created by  on 11-8-30.
//  Copyright 2011年 StupidTent co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


// Simple Text Label Subclass that will remove itself from parent once animation finishes.



@interface MTFloatingLabel : CCLabelTTF {
    
}

- (MTFloatingLabel *)initWithString:(NSString *)t;
+ (id)labelWithString:(NSString *)t;

- (void)fadeIn;
- (void)fadeOut;

@end


@interface MTFloatingLabelManager:NSObject{
    NSMutableArray * labels;
}

- (MTFloatingLabel *)addLabelWithString:(NSString *)t;

@end


@interface MTFloatingScore : CCLabelBMFont {
}

- (MTFloatingScore *)initWithScore:(int)score;
+ (id)labelWithScore:(int)score;

- (void)fadeIn;
- (void)fadeOut;

@end




