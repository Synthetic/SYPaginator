//
//  SYPaginatorViewController.m
//  SYPaginator
//
//  Created by Sam Soffes on 9/21/11.
//  Copyright (c) 2011 Synthetic. All rights reserved.
//

#import "SYPaginatorViewController.h"
#import "SYPageView.h"

@interface SYPaginatorViewController()
- (void)_initialize;
@end

@implementation SYPaginatorViewController

@synthesize paginatorView = _paginator;

#pragma mark - NSObject

- (id)init {
	if ((self = [super init])) {
		[self _initialize];
	}
	return self;
}


- (void)dealloc {
	_paginator.dataSource = nil;
	_paginator.delegate = nil;
}


#pragma mark - UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		[self _initialize];
	}
	return self;
}


- (void)viewDidLoad {
	[super viewDidLoad];
	
	_paginator.frame = self.view.bounds;
	[self.view addSubview:_paginator];
}


#pragma mark - Private

- (void)_initialize {
	_paginator = [[SYPaginatorView alloc] initWithFrame:CGRectZero];
	_paginator.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_paginator.dataSource = self;
	_paginator.delegate = self;
}


#pragma mark - SYPaginatorDataSource

- (NSInteger)numberOfPagesForPaginatorView:(SYPaginatorView *)paginator {
	return 0;
}


- (SYPageView *)paginatorView:(SYPaginatorView *)paginator viewForPageAtIndex:(NSInteger)page {
	return nil;
}

@end
