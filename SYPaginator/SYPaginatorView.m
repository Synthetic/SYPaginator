//
//  HFPaginator.m
//  HipstaFoundation
//
//  Created by Sam Soffes on 9/21/11.
//  Copyright (c) 2011 Synthetic. All rights reserved.
//

#import "SYPaginatorView.h"
#import "SYPageView.h"
#import "SYPaginatorScrollView.h"

@interface SYPaginatorView () <UIScrollViewDelegate>
- (void)_loadPage:(NSInteger)page;
- (void)_loadPagesToPreloadAroundPageAtIndex:(NSUInteger)index;
- (CGFloat)_offsetForPage:(NSUInteger)page;
- (void)_cleanup;
- (void)_removeViewAtIndex:(NSUInteger)index;
- (void)_reuseViewAtIndex:(NSUInteger)index;
- (void)_reusePages;
- (void)_setCurrentPageIndex:(NSUInteger)targetPage animated:(BOOL)animated scroll:(BOOL)scroll;
@end

@implementation SYPaginatorView {
	NSMutableDictionary  *_pages;
	NSMutableDictionary *_reuseablePages;
	BOOL _pageControlUsed;
}

@synthesize scrollView = _scrollView;
@synthesize pageControl = _pageControl;
@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;
@synthesize pageGapWidth = _pageGapWidth;
@synthesize numberOfPagesToPreload = _pagesToPreload;
@synthesize swipeableRect = _swipeableRect;
@synthesize currentPageIndex = _currentPageIndex;

- (void)setCurrentPageIndex:(NSUInteger)targetPage {
	[self setCurrentPageIndex:targetPage animated:YES];
}


- (NSUInteger)numberOfPages {
	return [self.dataSource numberOfPagesForPaginatorView:self];
}


- (void)setPageGapWidth:(CGFloat)pageGap {
	_pageGapWidth = pageGap;
	
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
	
	[_reuseablePages removeAllObjects];
}


#pragma mark - UIView

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		self.clipsToBounds = YES;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.numberOfPagesToPreload = 2;
		
		// Scroll view
		_scrollView = [[SYPaginatorScrollView alloc] initWithFrame:self.bounds];
		_scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		_scrollView.pagingEnabled = YES;
		_scrollView.showsVerticalScrollIndicator = NO;
		_scrollView.showsHorizontalScrollIndicator = NO;
		_scrollView.alwaysBounceHorizontal = YES;
		_scrollView.scrollsToTop = NO;
		[(SYPaginatorScrollView *)_scrollView setPrivateDelegate:self];
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
	
	NSUInteger numberOfPages = [self numberOfPages];
	_scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width * numberOfPages, _scrollView.bounds.size.height);
	
	for (NSNumber *key in _pages) {
		UIView *view = [_pages objectForKey:key];
		view.frame = [self frameForPageAtIndex:key.integerValue];
	}
}


- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	self.currentPageIndex = self.currentPageIndex;
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
	[self reloadDataRemovingCurrentPage:YES];
}


- (void)reloadDataRemovingCurrentPage:(BOOL)removeCurrentPage {
	NSUInteger numberOfPages = [self numberOfPages];
	CGSize size = _scrollView.bounds.size;
	_scrollView.contentSize = CGSizeMake(size.width * numberOfPages, size.height);
	
	if (numberOfPages <= 10) {
		_pageControl.numberOfPages = (NSInteger)numberOfPages;
		//		_pageControl.hidden = NO;
	} else {
		_pageControl.numberOfPages = 0;
		//		_pageControl.hidden = YES;
	}
	
	// Setup views
	if (!_pages) {
		_pages = [[NSMutableDictionary alloc] init];
	}
	
	if (!_reuseablePages) {
		_reuseablePages = [[NSMutableDictionary alloc] init];
	}
	
	// Remove views
	[_pages enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		if (!removeCurrentPage && [key integerValue] == self.currentPageIndex) {
			return;
		}
		
		[obj removeFromSuperview];
		[_pages removeObjectForKey:key];
	}];
	
	// Reload current page
	self.currentPageIndex = self.currentPageIndex;
}


- (void)setCurrentPageIndex:(NSUInteger)targetPage animated:(BOOL)animated {
	[self _setCurrentPageIndex:targetPage animated:animated scroll:YES];
}


- (CGRect)frameForPageAtIndex:(NSUInteger)page {
	CGSize size = _scrollView.frame.size;
	CGFloat x = [self _offsetForPage:page];
	return CGRectMake(x, 0.0f, size.width - _pageGapWidth, size.height);
}


- (SYPageView *)pageForIndex:(NSUInteger)page {
	return [_pages objectForKey:[NSNumber numberWithInteger:page]];
}


- (SYPageView *)dequeueReusablePageWithIdentifier:(NSString *)identifier {
	if (!identifier) {
		return nil;
	}
	
	NSMutableSet *pages = [_reuseablePages objectForKey:identifier];
	if (!pages || [pages count] == 0) {
		return nil;
	}
	
	SYPageView *page = [pages anyObject];
	[pages removeObject:page];
	
	return page;
}


- (SYPageView *)currentPage {
	return [_pages objectForKey:[NSNumber numberWithInteger:self.currentPageIndex]];
}


#pragma mark - Actions

- (void)_pageControlChanged:(id)sender {
	self.currentPageIndex = _pageControl.currentPage;
}


#pragma mark - Private


- (void)_loadPage:(NSInteger)page {
	if (!_pages || page < 0 || page >= self.numberOfPages) {
		return;
	}
	
	UIView *view = [self pageForIndex:page];
	if (!view) {
		view = [self.dataSource paginatorView:self viewForPageAtIndex:page];
		view.autoresizingMask = UIViewAutoresizingNone;
		
		if (view) {
			[_pages setObject:view forKey:[NSNumber numberWithInteger:page]];
			[_scrollView addSubview:view];
			view.frame = [self frameForPageAtIndex:page];
			
			[self _reusePages];
		}
	}
}


- (void)_loadPagesToPreloadAroundPageAtIndex:(NSUInteger)index {
	if (self.numberOfPagesToPreload > 0) {
		for (NSInteger offset = 1; offset <= self.numberOfPagesToPreload; offset++) {
			[self _loadPage:index + offset];
			[self _loadPage:index - offset];
		}
	}
}


- (CGFloat)_offsetForPage:(NSUInteger)page {
	return (page == 0) ? roundf(_pageGapWidth / 2.0f) : (_scrollView.bounds.size.width * page) + roundf(_pageGapWidth / 2.0f);
}


- (void)_cleanup {
	NSMutableSet *keysToRemove = [[NSMutableSet alloc] init];
	for (NSNumber *key in _pages) {
		if (key.integerValue != self.currentPageIndex) {
			[keysToRemove addObject:key];
		}
	}
	
	for (NSNumber *key in keysToRemove) {
		[self _removeViewAtIndex:key.integerValue];
	}
	
	[_reuseablePages removeAllObjects];
}


- (void)_removeViewAtIndex:(NSUInteger)index {
	[[self pageForIndex:index] removeFromSuperview];
	[_pages removeObjectForKey:[NSNumber numberWithInteger:index]];
}


- (void)_reuseViewAtIndex:(NSUInteger)index {
	SYPageView *view = [self pageForIndex:index];
	if (!view.reuseIdentifier) {
		NSAssert(view.reuseIdentifier, @"[SYPaginatorView] You should specify a reuse identifier for you SYPageViews.");
		[self _removeViewAtIndex:index];
		return;
	}
	
	[view removeFromSuperview];
	[_pages removeObjectForKey:[NSNumber numberWithInteger:index]];
	[view prepareForReuse];
	
	NSMutableSet *set = [_reuseablePages objectForKey:view.reuseIdentifier];
	if (!set) {
		set = [[NSMutableSet alloc] init];
		[_reuseablePages setObject:set forKey:view.reuseIdentifier];
	}
	
	[set addObject:view];
}


- (void)_reusePages {
	// Check for reuse
	// TODO: This could be faster
	NSArray *allKeys = [_pages allKeys];
	NSInteger numberOfKeys = allKeys.count;
	if (numberOfKeys - _pagesToPreload - _pagesToPreload > 0) {
		NSArray *sortedKeys = [allKeys sortedArrayUsingSelector:@selector(compare:)];
		NSInteger currentIndex = [sortedKeys indexOfObject:[NSNumber numberWithInteger:self.currentPageIndex]];
		
		// Remove before current index
		NSInteger location = currentIndex + _pagesToPreload;
		NSInteger length = numberOfKeys - location - 1;
		if (location > 0 && length > 0) {
			NSArray *keys = [sortedKeys subarrayWithRange:NSMakeRange(location, length)];
			for (NSNumber *key in keys) {
				[self _reuseViewAtIndex:key.integerValue];
			}
		}
		
		// Remove after current index
		length = currentIndex - _pagesToPreload;
		if (currentIndex - _pagesToPreload > 0 && length > 0) {
			NSArray *keys = [sortedKeys subarrayWithRange:NSMakeRange(0, length)];
			for (NSNumber *key in keys) {
				[self _reuseViewAtIndex:key.integerValue];
			}
		}
	}
}


- (void)_setCurrentPageIndex:(NSUInteger)targetPage animated:(BOOL)animated scroll:(BOOL)scroll {
	if (scroll && _delegate && [_delegate respondsToSelector:@selector(paginatorViewDidBeginPaging:)]) {
		[_delegate paginatorViewDidBeginPaging:self];
	}
	
	if (!targetPage > [self numberOfPages]) {
		targetPage = 0;
	}
	
	_currentPageIndex = targetPage;
	
	if (!_pageControl.hidden) {
		_pageControl.currentPage = (NSInteger)targetPage;
	}
	
	[self _loadPage:targetPage];
	[self _loadPagesToPreloadAroundPageAtIndex:targetPage];
	
	if (scroll) {	
		CGFloat targetX = [self _offsetForPage:targetPage] - roundf(_pageGapWidth / 2.0f);
		if (_scrollView.contentOffset.x != targetX) {
			CGSize size = _scrollView.bounds.size;
			CGRect rect = CGRectMake(targetX, 0.0f, size.width, size.height);
			[_scrollView scrollRectToVisible:rect animated:animated];
			_pageControlUsed = YES;
		}
		
		if (_delegate && [_delegate respondsToSelector:@selector(paginatorView:didScrollToPageAtIndex:)]) {
			[_delegate paginatorView:self didScrollToPageAtIndex:self.currentPageIndex];
		}
	}
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)sender {
	if (_pageControlUsed) {
		return;
	}
	
	CGFloat pageWidth = _scrollView.frame.size.width;
	NSInteger pageIndex = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	
	[self _setCurrentPageIndex:pageIndex animated:NO scroll:NO];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	if (_delegate && [_delegate respondsToSelector:@selector(paginatorViewDidBeginPaging:)]) {
		[_delegate paginatorViewDidBeginPaging:self];
	}
	
	_pageControlUsed = NO;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	if (_delegate && [_delegate respondsToSelector:@selector(paginatorView:didScrollToPageAtIndex:)]) {
		[_delegate paginatorView:self didScrollToPageAtIndex:self.currentPageIndex];
	}
	
	[self _loadPagesToPreloadAroundPageAtIndex:self.currentPageIndex];
	
	_pageControlUsed = NO;
}

@end
