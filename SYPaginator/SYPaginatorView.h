//
//  SYPaginatorView.h
//  SYPaginator
//
//  Created by Sam Soffes on 9/21/11.
//  Copyright (c) 2011 Synthetic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
	SYPageViewAnimationNone,
	SYPageViewAnimationTop,
	SYPageViewAnimationBottom
} SYPageViewAnimation;

typedef enum {
	SYPageViewPaginationDirectionHorizontal,
	SYPageViewPaginationDirectionVertical
} SYPageViewPaginationDirection;

@protocol SYPaginatorViewDataSource;
@protocol SYPaginatorViewDelegate;
@class SYPageView;
@class SYPageControl;

/**
 This class manages a paging UIScrollView and a UIPageControl.
 
 Use the `currentPage` to get the current page. You **must** supply a `dataSource` with all of the required methods.
 */
@interface SYPaginatorView : UIView

// Configuring
#if defined(__IPHONE_5_0) && __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0
@property (nonatomic, weak) id<SYPaginatorViewDataSource> dataSource;
@property (nonatomic, weak) id<SYPaginatorViewDelegate> delegate;
#else
@property (nonatomic, unsafe_unretained) id<SYPaginatorViewDataSource> dataSource;
@property (nonatomic, unsafe_unretained) id<SYPaginatorViewDelegate> delegate;
#endif

// UI
@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, strong, readonly) SYPageControl *pageControl;

@property (nonatomic, assign) NSInteger currentPageIndex;
@property (nonatomic, assign, readonly) NSInteger numberOfPages;
@property (nonatomic, assign) CGFloat pageGapWidth;
@property (nonatomic, assign) NSInteger numberOfPagesToPreload;
@property (nonatomic, assign) CGRect swipeableRect;
@property (nonatomic, assign) SYPageViewPaginationDirection paginationDirection;

- (void)reloadData;
- (void)reloadDataRemovingCurrentPage:(BOOL)removeCurrentPage;
- (void)setCurrentPageIndex:(NSInteger)targetPage animated:(BOOL)animated;
- (CGRect)frameForPageAtIndex:(NSInteger)page;
- (SYPageView *)pageForIndex:(NSInteger)page;
- (SYPageView *)dequeueReusablePageWithIdentifier:(NSString *)identifier;
- (SYPageView *)currentPage;

@end


@protocol SYPaginatorViewDataSource <NSObject>

@required

- (NSInteger)numberOfPagesForPaginatorView:(SYPaginatorView *)paginatorView;
- (SYPageView *)paginatorView:(SYPaginatorView *)paginatorView viewForPageAtIndex:(NSInteger)pageIndex;

@end


@protocol SYPaginatorViewDelegate <NSObject>

@optional

- (void)paginatorViewDidBeginPaging:(SYPaginatorView *)paginatorView;
- (void)paginatorView:(SYPaginatorView *)paginatorView willDisplayView:(UIView *)view atIndex:(NSInteger)pageIndex;
- (void)paginatorView:(SYPaginatorView *)paginatorView didScrollToPageAtIndex:(NSInteger)pageIndex;

@end
