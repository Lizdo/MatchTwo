//
//  AppDelegate.h
//  MatchTwo
//
//  Created by  on 11-8-1.
//  Copyright StupidTent co. 2011年. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

- (void)loadAudioResource;

@end
