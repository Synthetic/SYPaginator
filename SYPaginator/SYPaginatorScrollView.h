//
//  SYPaginatorScrollView.h
//  SYPaginator
//
//  Created by Sam Soffes on 3/8/12.
//  Copyright (c) 2012 Synthetic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYPaginatorScrollView : UIScrollView

@property (nonatomic, unsafe_unretained) id<UIScrollViewDelegate> privateDelegate;

@end
