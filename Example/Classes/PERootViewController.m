//
//  PERootViewController.m
//  Paginator Example
//
//  Created by Sam Soffes on 3/8/12.
//  Copyright (c) 2012 Synthetic. All rights reserved.
//

#import "PERootViewController.h"
#import "PEPageView.h"

@implementation PERootViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"Paginator";
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	
	self.view.backgroundColor = [UIColor blackColor];
	self.paginatorView.pageGapWidth = 30.0f;
}


#pragma mark - SYPaginatorViewDataSource

- (NSUInteger)numberOfPagesForPaginatorView:(SYPaginatorView *)paginator {
	return 10;
}


- (UIView *)paginatorView:(SYPaginatorView *)paginator viewForPage:(NSUInteger)page {
	static NSString *identifier = @"identifier";
	
	PEPageView *view = [paginator dequeueReusableViewWithIdentifier:identifier];
	if (!view) {
		view = [[PEPageView alloc] initWithReuseIdentifier:identifier];
	}
	
	view.textLabel.text = [NSString stringWithFormat:@"Page %i of %i", page + 1, paginator.numberOfPages];
	
	return view;
}

@end
