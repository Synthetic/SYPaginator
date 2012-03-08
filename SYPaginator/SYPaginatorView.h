//
//  SYPaginatorView.h
//  SYPaginator
//
//  Created by Sam Soffes on 9/21/11.
//  Copyright (c) 2011 Synthetic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol SYPaginatorViewDataSource;
@protocol SYPaginatorViewDelegate;

/**
 This class manages a paging UIScrollView and a UIPageControl.
 
 Use the `currentPage` to get the current page. You **must** supply a `dataSource` with all of the required methods.
 */
@interface SYPaginatorView : UIView

@property (nonatomic, readonly) UIScrollView *scrollView;
@property (nonatomic, readonly) UIPageControl *pageControl;
@property (nonatomic, readonly) NSArray *views;

@property (nonatomic) NSUInteger currentPage;
@property (nonatomic, readonly) NSUInteger numberOfPages;
@property (nonatomic, unsafe_unretained) id<SYPaginatorViewDataSource> dataSource;
@property (nonatomic, unsafe_unretained) id<SYPaginatorViewDelegate> delegate;
@property (nonatomic) CGFloat pageGap;
@property (nonatomic) NSUInteger pagesToPreload;
@property (nonatomic) CGRect swipeableRect;

// Managing data
- (void)reloadData;
- (void)setCurrentPage:(NSUInteger)targetPage animated:(BOOL)animated;
- (CGRect)frameForViewAtPage:(NSUInteger)page;

@end


@protocol SYPaginatorViewDataSource <NSObject>

@required

- (NSUInteger)numberOfPagesForPaginatorView:(SYPaginatorView *)paginator;
- (UIView *)paginatorView:(SYPaginatorView *)paginator viewForPage:(NSUInteger)page;

@end


@protocol SYPaginatorViewDelegate <NSObject>

@optional

- (void)paginatorViewDidBeginPaging:(SYPaginatorView *)paginator;
- (void)paginatorView:(SYPaginatorView *)paginator didScrollToPage:(NSUInteger)page;

@end
