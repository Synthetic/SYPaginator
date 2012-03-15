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

@protocol SYPaginatorViewDataSource;
@protocol SYPaginatorViewDelegate;

/**
 This class manages a paging UIScrollView and a UIPageControl.
 
 Use the `currentPage` to get the current page. You **must** supply a `dataSource` with all of the required methods.
 */
@interface SYPaginatorView : UIView

// Configuring
@property (nonatomic, unsafe_unretained) id<SYPaginatorViewDataSource> dataSource;
@property (nonatomic, unsafe_unretained) id<SYPaginatorViewDelegate> delegate;

// UI
@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, strong, readonly) UIPageControl *pageControl;

@property (nonatomic, assign) NSUInteger currentPageIndex;
@property (nonatomic, assign, readonly) NSUInteger numberOfPages;
@property (nonatomic, assign) CGFloat pageGapWidth;
@property (nonatomic, assign) NSUInteger numberOfPagesToPreload;
@property (nonatomic, assign) CGRect swipeableRect;

- (void)reloadData;
- (void)setCurrentPageIndex:(NSUInteger)targetPage animated:(BOOL)animated;
- (CGRect)frameForPageAtIndex:(NSUInteger)page;
- (id)pageForIndex:(NSUInteger)page;
- (id)dequeueReusablePageWithIdentifier:(NSString *)identifier;
//- (void)reloadPagesAtIndexes:(NSArray *)indexs withPageAnimation:(SYPageViewAnimation)animation;

@end


@protocol SYPaginatorViewDataSource <NSObject>

@required

- (NSUInteger)numberOfPagesForPaginatorView:(SYPaginatorView *)paginator;
- (UIView *)paginatorView:(SYPaginatorView *)paginator viewForPageAtIndex:(NSUInteger)page;

@end


@protocol SYPaginatorViewDelegate <NSObject>

@optional

- (void)paginatorViewDidBeginPaging:(SYPaginatorView *)paginator;
- (void)paginatorView:(SYPaginatorView *)paginator willDisplayView:(UIView *)view atIndex:(NSUInteger)pageIndex;
- (void)paginatorView:(SYPaginatorView *)paginator didScrollToPageAtIndex:(NSUInteger)page;

@end
