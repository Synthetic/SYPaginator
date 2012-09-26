//
//  SYPaginatorScrollView.h
//  SYPaginator
//
//  Created by Sam Soffes on 3/8/12.
//  Copyright (c) 2012 Synthetic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYPaginatorScrollView : UIScrollView

#if defined(__IPHONE_5_0) && __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0
@property (nonatomic, weak) id<UIScrollViewDelegate> privateDelegate;
#else
@property (nonatomic, unsafe_unretained) id<UIScrollViewDelegate> privateDelegate;
#endif

@end
