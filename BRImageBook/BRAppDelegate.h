//
//  BRAppDelegate.h
//  BRImageBook
//
//  Created by Cornelius Horstmann on 03.06.13.
//  Copyright (c) 2013 brototyp.de. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BRViewController;

@interface BRAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) BRViewController *viewController;

@end
