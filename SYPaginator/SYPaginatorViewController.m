//
//  SYPaginatorViewController.m
//  SYPaginator
//
//  Created by Sam Soffes on 9/21/11.
//  Copyright (c) 2011 Synthetic. All rights reserved.
//

#import "SYPaginatorViewController.h"

@interface SYPaginatorViewController()
- (void)_initializePaginatorViewController;
@end

@implementation SYPaginatorViewController

@synthesize paginator = _paginator;

#pragma mark - NSObject

- (id)init {
	if ((self = [super init])) {
		[self _initializePaginatorViewController];
	}
	return self;
}


- (void)dealloc {
	_paginator.dataSource = nil;
}


#pragma mark - UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		[self _initializePaginatorViewController];
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	_paginator.frame = self.view.bounds;
	[self.view addSubview:_paginator];
}


#pragma mark - Private

- (void)_initializePaginatorViewController {
	_paginator = [[SYPaginatorView alloc] initWithFrame:CGRectZero];
	_paginator.dataSource = self;
	_paginator.delegate = self;
}


#pragma mark - HFPaginatorDataSource

- (NSUInteger)numberOfPagesForPaginatorView:(SYPaginatorView *)paginator {
	return 0;
}


- (UIView *)paginatorView:(SYPaginatorView *)paginator viewForPage:(NSUInteger)page {
	return nil;
}

@end
