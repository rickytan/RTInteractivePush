//
//  UINavigationController+InteractivePush.h
//  Pods
//
//  Created by Ricky on 2017/1/19.
//
//

#import <UIKit/UIKit.h>

@interface UINavigationController (RTInteractivePush)
@property (nonatomic, assign, getter=rt_isInteractivePushEnabled) BOOL rt_enableInteractivePush;
@property (nonatomic, readonly, nullable) UIPanGestureRecognizer *rt_interactivePushGestureRecognizer;
@end


@interface UIViewController (RTInteractivePush)

- (nullable __kindof UIViewController *)rt_nextSiblingController;

@end
