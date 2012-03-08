//
//  HFPaginator.m
//  HipstaFoundation
//
//  Created by Sam Soffes on 9/21/11.
//  Copyright (c) 2011 Synthetic. All rights reserved.
//

#import "SYPaginatorView.h"

@interface SYPaginatorView () <UIScrollViewDelegate>
- (NSUInteger)_numberOfPages;
- (void)_loadPage:(NSUInteger)page;
- (void)_loadPagesToPreloadAroundPageAtIndex:(NSUInteger)index;
- (CGFloat)_offsetForPage:(NSUInteger)page;
- (void)_cleanup;
@end

@implementation SYPaginatorView {
	NSMutableArray *_views;
	BOOL _pageControlUsed;
}

@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;
@synthesize views = _views;
@synthesize pageGap = _pageGap;
@synthesize pagesToPreload = _pagesToPreload;
@synthesize swipeableRect = _swipeableRect;

- (void)setCurrentPage:(NSUInteger)targetPage {
	[self setCurrentPage:targetPage animated:YES];
}


- (NSUInteger)currentPage {
	return (NSUInteger)_pageControl.currentPage;
}


- (NSUInteger)numberOfPages {
	return (NSUInteger)_pageControl.numberOfPages;
}


- (void)setPageGap:(CGFloat)pageGap {
	_pageGap = pageGap;
	
	CGRect rect = _scrollView.frame;
	rect.origin.x -= roundf(pageGap / 2.0f);
	rect.size.width += pageGap;
	
	_scrollView.frame = rect;
	[self setNeedsLayout];
}


#pragma mark - NSObject

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	self.dataSource = nil;
	_scrollView.delegate = nil;
	
	[_views removeAllObjects];
}


#pragma mark - UIView

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		self.clipsToBounds = YES;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.pagesToPreload = 1;
		
		// Scroll view
		_scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
		_scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		_scrollView.pagingEnabled = YES;
		_scrollView.delegate = self;
		_scrollView.showsVerticalScrollIndicator = NO;
		_scrollView.showsHorizontalScrollIndicator = NO;
		_scrollView.alwaysBounceHorizontal = YES;
		_scrollView.scrollsToTop = NO;
		[self addSubview:_scrollView];
		
		// Page control
		CGSize size = self.bounds.size;
		_pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0f, size.height - 18.0f, size.width, 18.0f)];
		_pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
		_pageControl.currentPage = 0;
		[_pageControl addTarget:self action:@selector(_pageControlChanged:) forControlEvents:UIControlEventValueChanged];
		[self addSubview:_pageControl];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_cleanup)
													 name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
	}
	return self;
}


- (void)layoutSubviews {
	[super layoutSubviews];
	
	NSUInteger numberOfPages = [self _numberOfPages];
	_scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width * numberOfPages, _scrollView.bounds.size.height);
	
	for (NSUInteger page = 0; page < numberOfPages; page++) {
		if (page >= [_views count]) {
			break;
		}
		UIView *view = [_views objectAtIndex:page];
		if (![view isKindOfClass:[UIView class]]) {
			continue;
		}
		
		view.frame = [self frameForViewAtPage:page];
	}
}


- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	self.currentPage = self.currentPage;
}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
	if (CGRectIsEmpty(_swipeableRect) == NO) {
		BOOL contains = CGRectContainsPoint(_swipeableRect, point);
		return contains;
	}
	return [super pointInside:point withEvent:event];
}


#pragma mark - Managing data

- (void)reloadData {
	NSUInteger numberOfPages = [self _numberOfPages];
	CGSize size = _scrollView.bounds.size;
	_scrollView.contentSize = CGSizeMake(size.width * numberOfPages, size.height);
	_pageControl.numberOfPages = (NSInteger)numberOfPages;
	
	// Setup views
	if (!_views) {
		_views = [[NSMutableArray alloc] initWithCapacity:numberOfPages];
	} else {
		for (UIView *view in _views) {
			if (![view isKindOfClass:[UIView class]]) {
				continue;
			}
			[view removeFromSuperview];
		}
		[_views removeAllObjects];
	}
	
	for (NSUInteger i = 0; i < numberOfPages; i++) {
		[_views addObject:[NSNull null]];
    }
	
	// Reload current page
	self.currentPage = self.currentPage;
}


- (void)setCurrentPage:(NSUInteger)targetPage animated:(BOOL)animated {
	if (_delegate && [_delegate respondsToSelector:@selector(paginatorViewDidBeginPaging:)]) {
		[_delegate paginatorViewDidBeginPaging:self];
	}
	
	if (!targetPage > [self _numberOfPages]) {
		targetPage = 0;
	}
	
	_pageControl.currentPage = (NSInteger)targetPage;
	
	[self _loadPage:targetPage];
	[self _loadPagesToPreloadAroundPageAtIndex:targetPage];
	
	CGFloat targetX = [self _offsetForPage:targetPage] - roundf(_pageGap / 2.0f);
	if (_scrollView.contentOffset.x != targetX) {
		CGSize size = _scrollView.bounds.size;
		CGRect rect = CGRectMake(targetX, 0.0f, size.width, size.height);
		[_scrollView scrollRectToVisible:rect animated:animated];
		_pageControlUsed = YES;
	}
		
	if (_delegate && [_delegate respondsToSelector:@selector(paginatorView:didScrollToPage:)]) {
		[_delegate paginatorView:self didScrollToPage:self.currentPage];
	}
}


- (CGRect)frameForViewAtPage:(NSUInteger)page {
	CGSize size = _scrollView.frame.size;
	CGFloat x = [self _offsetForPage:page];
	return CGRectMake(x, 0.0f, size.width - _pageGap, size.height);
}


#pragma mark - Actions

- (void)_pageControlChanged:(id)sender {
	// Reset to update scroll view. Kinda ugly, I know.
	self.currentPage = self.currentPage;
}


#pragma mark - Private

- (NSUInteger)_numberOfPages {
	return [self.dataSource numberOfPagesForPaginatorView:self];
}


- (void)_loadPage:(NSUInteger)page {
	if (page >= [self _numberOfPages] || !_views || page >= [_views count]) {
		return;
	}
	
	// Replace the placeholder if necessary
	UIView *view = [_views objectAtIndex:page];
	if (!view || (NSNull *)view == [NSNull null]) {
		view = [self.dataSource paginatorView:self viewForPage:page];
		view.autoresizingMask = UIViewAutoresizingNone;
		
		if (view) {
			[_views replaceObjectAtIndex:(NSUInteger)page withObject:view];			
			[_scrollView addSubview:view];
			view.frame = [self frameForViewAtPage:page];
		}
	}
}


- (void)_loadPagesToPreloadAroundPageAtIndex:(NSUInteger)index {
	if (self.pagesToPreload > 0) {
		for (NSInteger offset = 1; offset <= self.pagesToPreload; offset++) {
			[self _loadPage:index + offset];
			[self _loadPage:index - offset];
		}
	}
}


- (CGFloat)_offsetForPage:(NSUInteger)page {
	return (page == 0) ? roundf(_pageGap / 2.0f) : (_scrollView.bounds.size.width * page) + roundf(_pageGap / 2.0f);
}


- (void)_cleanup {
	for (NSUInteger i = 0; i < [_views count]; i++) {
		UIView *view = [_views objectAtIndex:i];
		if ([view isKindOfClass:[UIView class]] && i != self.currentPage) {
			[view removeFromSuperview];
			[_views replaceObjectAtIndex:i withObject:[NSNull null]];
		}
	}
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)sender {
	if (_pageControlUsed) {
		return;
	}
	
	CGFloat pageWidth = _scrollView.frame.size.width;
	NSInteger page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	
	_pageControl.currentPage = page;
	
	[self _loadPage:page];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	if (_delegate && [_delegate respondsToSelector:@selector(paginatorDidBeginPaging:)]) {
		[_delegate paginatorViewDidBeginPaging:self];
	}
	
	_pageControlUsed = NO;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	if (_delegate && [_delegate respondsToSelector:@selector(paginator:didScrollToPage:)]) {
		[_delegate paginatorView:self didScrollToPage:self.currentPage];
	}
	
	[self _loadPagesToPreloadAroundPageAtIndex:self.currentPage];
	
	_pageControlUsed = NO;
}

@end
