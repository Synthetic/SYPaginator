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

- (NSInteger)numberOfPagesForPaginatorView:(SYPaginatorView *)paginatorView {
	return 99999;
}

- (SYPageView *)paginatorView:(SYPaginatorView *)paginatorView viewForPageAtIndex:(NSInteger)pageIndex {
	static NSString *identifier = @"identifier";
	
	PEPageView *view = (PEPageView *)[paginatorView dequeueReusablePageWithIdentifier:identifier];
	if (!view) {
		view = [[PEPageView alloc] initWithReuseIdentifier:identifier];
	}
	
	view.textLabel.text = [NSString stringWithFormat:@"Page %i of %i", pageIndex + 1, paginatorView.numberOfPages];
	
	return view;
}

@end
