//
//  UINavigationController+InteractivePush.m
//  Pods
//
//  Created by Ricky on 2017/1/19.
//
//

#import <objc/runtime.h>

#import "UINavigationController+InteractivePush.h"

static void rt_swizzle_selector(Class cls, SEL origin, SEL swizzle) {
    method_exchangeImplementations(class_getInstanceMethod(cls, origin),
                                   class_getInstanceMethod(cls, swizzle));
}


@interface RTNavigationPushTransition : NSObject <UIViewControllerAnimatedTransitioning>
@end

@implementation RTNavigationPushTransition

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return UINavigationControllerHideShowBarDuration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    fromVC.view.transform = CGAffineTransformIdentity;
    toVC.view.frame = containerView.bounds;
    toVC.view.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(containerView.bounds), 0);
    [containerView addSubview:toVC.view];
    [UIView transitionWithView:containerView
                      duration:[self transitionDuration:transitionContext]
                       options:[transitionContext isInteractive] ? UIViewAnimationOptionCurveLinear : UIViewAnimationOptionCurveEaseIn
                    animations:^{
                        fromVC.view.transform = CGAffineTransformMakeTranslation(-CGRectGetWidth(containerView.bounds) * 2 / 7, 0);
                        toVC.view.transform = CGAffineTransformIdentity;
                    }
                    completion:^(BOOL finished) {
                        if (finished) {
                            fromVC.view.transform = CGAffineTransformIdentity;
                        }
                        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                    }];
}

@end

@implementation UINavigationController (RTInteractivePush)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        rt_swizzle_selector(self, @selector(setDelegate:), @selector(setRt_delegate:));
        rt_swizzle_selector(self, @selector(delegate), @selector(rt_delegate));
    });
}

- (void)rt_viewDidLoad
{
    [self rt_viewDidLoad];
    
    if (self.rt_isInteractivePushEnabled) {
        [self rt_setupInteractivePush];
    }
}

- (void)setRt_delegate:(id<UINavigationControllerDelegate>)delegate
{
    objc_setAssociatedObject(self, @selector(rt_delegate), delegate, OBJC_ASSOCIATION_ASSIGN);
}

- (id<UINavigationControllerDelegate>)rt_delegate
{
    return objc_getAssociatedObject(self, @selector(rt_delegate));
}

#pragma mark - Methods

- (void)rt_setupInteractivePush
{
    UIScreenEdgePanGestureRecognizer *pan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self
                                                                                              action:@selector(rt_onPushGesture:)];
    pan.edges = UIRectEdgeRight;
    [pan requireGestureRecognizerToFail:self.interactivePopGestureRecognizer];
    [self.view addGestureRecognizer:pan];
    
    self.rt_interactivePushGestureRecognizer = pan;
    self.rt_delegate = self;
}

- (void)rt_distoryInteractivePush
{
    [self.view removeGestureRecognizer:self.rt_interactivePushGestureRecognizer];
    self.rt_interactivePushGestureRecognizer = nil;
    self.rt_delegate = nil;
}

- (void)rt_onPushGesture:(UIPanGestureRecognizer *)gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            UIViewController *nextSiblingController = [self.topViewController rt_nextSiblingController];
            if (nextSiblingController) {
                [self pushViewController:nextSiblingController
                                animated:YES];
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [gesture translationInView:gesture.view];
            CGFloat ratio = -translation.x / self.view.bounds.size.width;
            ratio = MAX(0, MIN(1, ratio));
            [self.rt_interactiveTransition updateInteractiveTransition:ratio];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            CGPoint velocity = [gesture velocityInView:gesture.view];
            
            if (velocity.x < -200) {
                [self.rt_interactiveTransition finishInteractiveTransition];
            }
            else if (velocity.x > 200) {
                [self.rt_interactiveTransition cancelInteractiveTransition];
            }
            else if (self.rt_interactiveTransition.percentComplete > 0.5) {
                [self.rt_interactiveTransition finishInteractiveTransition];
            }
            else {
                [self.rt_interactiveTransition cancelInteractiveTransition];
            }
        }
            break;
        default:
            break;
    }
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if ([self.delegate respondsToSelector:aSelector]) {
        return self.delegate;
    }
    return nil;
}

#pragma mark - Properties

- (BOOL)rt_isInteractivePushEnabled
{
    return [objc_getAssociatedObject(self, @selector(setRt_enableInteractivePush:)) boolValue];
}

- (void)setRt_enableInteractivePush:(BOOL)enableInteractivePush
{
    BOOL enabled = self.rt_isInteractivePushEnabled;
    if (enabled != enableInteractivePush) {
        objc_setAssociatedObject(self, @selector(setRt_enableInteractivePush:), @(enableInteractivePush), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        if (self.isViewLoaded) {
            if (enableInteractivePush) {
                [self rt_setupInteractivePush];
            }
            else {
                [self rt_distoryInteractivePush];
            }
        }
        else {
            rt_swizzle_selector(self.class, @selector(viewDidLoad), @selector(rt_viewDidLoad));
        }
    }
}

- (void)setRt_interactivePushGestureRecognizer:(UIPanGestureRecognizer * _Nullable)interactivePushGestureRecognizer
{
    objc_setAssociatedObject(self, @selector(rt_interactivePushGestureRecognizer), interactivePushGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIPanGestureRecognizer *)rt_interactivePushGestureRecognizer
{
    return objc_getAssociatedObject(self, @selector(rt_interactivePushGestureRecognizer));
}

- (UIPercentDrivenInteractiveTransition *)rt_interactiveTransition
{
    UIPercentDrivenInteractiveTransition *percent = objc_getAssociatedObject(self, @selector(rt_interactiveTransition));
    if (!percent) {
        percent = [[UIPercentDrivenInteractiveTransition alloc] init];
        objc_setAssociatedObject(self, @selector(rt_interactiveTransition), percent, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return percent;
}

#pragma mark - UINavigationController Delegate

- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>)animationController
{
    id <UIViewControllerInteractiveTransitioning> transitioning = nil;
    if ([self.delegate respondsToSelector:@selector(navigationController:interactionControllerForAnimationController:)]) {
        transitioning = [self.delegate navigationController:navigationController
                interactionControllerForAnimationController:animationController];
    }
    
    if (!transitioning) {
        transitioning = self.rt_interactiveTransition;
    }
    return transitioning;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC
{
    id <UIViewControllerAnimatedTransitioning> transitioning = nil;
    if ([self.delegate respondsToSelector:@selector(navigationController:animationControllerForOperation:fromViewController:toViewController:)]) {
        transitioning = [self.delegate navigationController:navigationController
                            animationControllerForOperation:operation
                                         fromViewController:fromVC
                                           toViewController:toVC];
    }
    if (!transitioning) {
        if (operation == UINavigationControllerOperationPush && self.rt_interactivePushGestureRecognizer.state == UIGestureRecognizerStateBegan) {
            transitioning = [[RTNavigationPushTransition alloc] init];
        }
    }
    return transitioning;
}

@end


@implementation UIViewController (RTInteractivePush)

- (nullable __kindof UIViewController *)rt_nextSiblingController
{
    return nil;
}

@end
