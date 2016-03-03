//
//  NavigationController.m
//  mcare-ui
//
//  Created by sam on 12-11-6.
//
//

#import "NavigationController.h"

@interface NavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation NavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    __weak __typeof(self) weakSelf = self;
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = weakSelf;
    }
}

#pragma mark -
#pragma mark - UINavigationControllerDelegate -

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate
{
    self.interactivePopGestureRecognizer.enabled = ([self respondsToSelector:@selector(interactivePopGestureRecognizer)] && [self.viewControllers count] > 1);
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
        
    [super pushViewController:viewController animated:animated];
}

//ios < 6.0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return [[self.viewControllers lastObject] shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

//ios >= 6.0
- (BOOL)shouldAutorotate
{
    return self.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return self.topViewController.supportedInterfaceOrientations;
}

//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//  //  return  self.topViewController.preferredInterfaceOrientationForPresentation; //[[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
//}

@end
