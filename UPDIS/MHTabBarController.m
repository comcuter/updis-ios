/*!
 * \file MHTabBarController.m
 *
 * Copyright (c) 2011 Matthijs Hollemans
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "MHTabBarController.h"

static const float TAB_BAR_HEIGHT = 30.0f;
static const NSInteger TAG_OFFSET = 1000;

@implementation MHTabBarController
{
	UIView *tabButtonsContainerView;
	UIView *contentContainerView;
}

@synthesize viewControllers = _viewControllers;
@synthesize selectedIndex = _selectedIndex;
@synthesize delegate = _delegate;



- (void)selectTabButton:(UIButton *)button
{
	[button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

	UIImage *image = [[UIImage imageNamed:([self.viewControllers count]==2?@"tag2":@"tag1")] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
//	[button setBackgroundImage:image forState:UIControlStateNormal];
	[button setBackgroundImage:image forState:UIControlStateSelected];
	
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setSelected:YES];
}

- (void)deselectTabButton:(UIButton *)button{
    [button setSelected:NO];
}

- (void)removeTabButtons
{
	NSArray *buttons = [tabButtonsContainerView subviews];
	for (UIButton *button in buttons)
		[button removeFromSuperview];
}

- (void)addTabButtons
{
	NSUInteger index = 0;
	for (UIViewController *viewController in self.viewControllers)
	{
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.tag = TAG_OFFSET + index;
		[button setTitle:viewController.title forState:UIControlStateNormal];
		[button addTarget:self action:@selector(tabButtonPressed:) forControlEvents:UIControlEventTouchDown];
		button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
		button.titleLabel.shadowOffset = CGSizeMake(0, 1);
        [button setTitleEdgeInsets:UIEdgeInsetsMake(-3, 0, 0, 0)];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[self deselectTabButton:button];
		[tabButtonsContainerView addSubview:button];

		++index;
	}
}

- (void)reloadTabButtons
{
	[self removeTabButtons];
	[self addTabButtons];

	// Force redraw of the previously active tab.
	NSUInteger lastIndex = _selectedIndex;
	_selectedIndex = NSNotFound;
	self.selectedIndex = lastIndex;
}

- (void)layoutTabButtons
{
	NSUInteger index = 0;
	NSUInteger count = [self.viewControllers count];

	CGRect rect = CGRectMake(0, 0, floorf(self.view.bounds.size.width / count), TAB_BAR_HEIGHT);


	NSArray *buttons = [tabButtonsContainerView subviews];
	for (UIButton *button in buttons)
	{
		if (index == count - 1)
			rect.size.width = self.view.bounds.size.width - rect.origin.x;

		button.frame = rect;
		rect.origin.x += rect.size.width;


		++index;
	}
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];

	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;


	CGRect rect = CGRectMake(0, 0, self.view.bounds.size.width, TAB_BAR_HEIGHT);
    rect.origin.y = TAB_BAR_HEIGHT-3;
	rect.size.height = self.view.bounds.size.height - TAB_BAR_HEIGHT+3;
	contentContainerView = [[UIView alloc] initWithFrame:rect];
	contentContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:contentContainerView];
    
	tabButtonsContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, TAB_BAR_HEIGHT)];
	tabButtonsContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[self.view addSubview:tabButtonsContainerView];


    

	[self reloadTabButtons];

    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 27)];
    [bgView setBackgroundColor:[UIColor colorWithPatternImage:TTIMAGE(@"bundle://bgmenu.png")]];
    [self.view insertSubview:bgView atIndex:0];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	tabButtonsContainerView = nil;
	contentContainerView = nil;
}

- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	[self layoutTabButtons];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// Only rotate if all child view controllers agree on the new orientation.
	for (UIViewController *viewController in self.viewControllers)
	{
		if (![viewController shouldAutorotateToInterfaceOrientation:interfaceOrientation])
			return NO;
	}
	return YES;
}

- (void)setViewControllers:(NSArray *)newViewControllers
{
//	NSAssert([newViewControllers count] >= 2, @"MHTabBarController requires at least two view controllers");

	UIViewController *oldSelectedViewController = self.selectedViewController;

	// Remove the old child view controllers.
	for (UIViewController *viewController in _viewControllers)
	{
		[viewController willMoveToParentViewController:nil];
		[viewController removeFromParentViewController];
	}

	_viewControllers = [newViewControllers copy];

	// This follows the same rules as UITabBarController for trying to
	// re-select the previously selected view controller.
	NSUInteger newIndex = [_viewControllers indexOfObject:oldSelectedViewController];
	if (newIndex != NSNotFound)
		_selectedIndex = newIndex;
	else if (newIndex < [_viewControllers count])
		_selectedIndex = newIndex;
	else
		_selectedIndex = 0;

	// Add the new child view controllers.
	for (UIViewController *viewController in _viewControllers)
	{
		[self addChildViewController:viewController];
		[viewController didMoveToParentViewController:self];
	}

	if ([self isViewLoaded])
		[self reloadTabButtons];
}

- (void)setSelectedIndex:(NSUInteger)newSelectedIndex
{
	[self setSelectedIndex:newSelectedIndex animated:NO];
}

- (void)setSelectedIndex:(NSUInteger)newSelectedIndex animated:(BOOL)animated
{
	NSAssert(newSelectedIndex < [self.viewControllers count], @"View controller index out of bounds");

	if ([self.delegate respondsToSelector:@selector(mh_tabBarController:shouldSelectViewController:atIndex:)])
	{
		UIViewController *toViewController = [self.viewControllers objectAtIndex:newSelectedIndex];
		if (![self.delegate mh_tabBarController:self shouldSelectViewController:toViewController atIndex:newSelectedIndex])
			return;
	}

	if (![self isViewLoaded])
	{
		_selectedIndex = newSelectedIndex;
	}
	else if (_selectedIndex != newSelectedIndex)
	{
		UIViewController *fromViewController;
		UIViewController *toViewController;

		if (_selectedIndex != NSNotFound)
		{
			UIButton *fromButton = (UIButton *)[tabButtonsContainerView viewWithTag:TAG_OFFSET + _selectedIndex];
			[self deselectTabButton:fromButton];
			fromViewController = self.selectedViewController;
		}

		NSUInteger oldSelectedIndex = _selectedIndex;
		_selectedIndex = newSelectedIndex;

		UIButton *toButton;
		if (_selectedIndex != NSNotFound)
		{
			toButton = (UIButton *)[tabButtonsContainerView viewWithTag:TAG_OFFSET + _selectedIndex];
			[self selectTabButton:toButton];
			toViewController = self.selectedViewController;
		}

		if (toViewController == nil)  // don't animate
		{
			[fromViewController.view removeFromSuperview];
		}
		else if (fromViewController == nil)  // don't animate
		{
			toViewController.view.frame = contentContainerView.bounds;
			[contentContainerView addSubview:toViewController.view];

			if ([self.delegate respondsToSelector:@selector(mh_tabBarController:didSelectViewController:atIndex:)])
				[self.delegate mh_tabBarController:self didSelectViewController:toViewController atIndex:newSelectedIndex];
		}
		else if (animated)
		{
			CGRect rect = contentContainerView.bounds;
			if (oldSelectedIndex < newSelectedIndex)
				rect.origin.x = rect.size.width;
			else
				rect.origin.x = -rect.size.width;

			toViewController.view.frame = rect;
			tabButtonsContainerView.userInteractionEnabled = NO;

			[self transitionFromViewController:fromViewController
				toViewController:toViewController
				duration:0.3
				options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionCurveEaseOut
				animations:^
				{
					CGRect rect = fromViewController.view.frame;
					if (oldSelectedIndex < newSelectedIndex)
						rect.origin.x = -rect.size.width;
					else
						rect.origin.x = rect.size.width;

					fromViewController.view.frame = rect;
					toViewController.view.frame = contentContainerView.bounds;
				}
				completion:^(BOOL finished)
				{
					tabButtonsContainerView.userInteractionEnabled = YES;

					if ([self.delegate respondsToSelector:@selector(mh_tabBarController:didSelectViewController:atIndex:)])
						[self.delegate mh_tabBarController:self didSelectViewController:toViewController atIndex:newSelectedIndex];
				}];
		}
		else  // not animated
		{
			[fromViewController.view removeFromSuperview];

			toViewController.view.frame = contentContainerView.bounds;
			[contentContainerView addSubview:toViewController.view];

			if ([self.delegate respondsToSelector:@selector(mh_tabBarController:didSelectViewController:atIndex:)])
				[self.delegate mh_tabBarController:self didSelectViewController:toViewController atIndex:newSelectedIndex];
		}
	}
}

- (UIViewController *)selectedViewController
{
	if (self.selectedIndex != NSNotFound)
		return [self.viewControllers objectAtIndex:self.selectedIndex];
	else
		return nil;
}

- (void)setSelectedViewController:(UIViewController *)newSelectedViewController
{
	[self setSelectedViewController:newSelectedViewController animated:NO];
}

- (void)setSelectedViewController:(UIViewController *)newSelectedViewController animated:(BOOL)animated;
{
	NSUInteger index = [self.viewControllers indexOfObject:newSelectedViewController];
	if (index != NSNotFound)
		[self setSelectedIndex:index animated:animated];
}

- (void)tabButtonPressed:(UIButton *)sender
{
	[self setSelectedIndex:sender.tag - TAG_OFFSET animated:YES];
}

@end
