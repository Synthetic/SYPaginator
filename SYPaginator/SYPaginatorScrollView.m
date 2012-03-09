//
//  SYPaginatorScrollView.m
//  SYPaginator
//
//  Created by Sam Soffes on 3/8/12.
//  Copyright (c) 2012 Synthetic. All rights reserved.
//

#import "SYPaginatorScrollView.h"

@implementation SYPaginatorScrollView

- (void)setDelegate:(id<UIScrollViewDelegate>)delegate {
	return;
}


- (id<UIScrollViewDelegate>)privateDelegate {
	return [self delegate];
}


- (void)setPrivateDelegate:(id<UIScrollViewDelegate>)privateDelegate {
	[super setDelegate:privateDelegate];
}

@end
