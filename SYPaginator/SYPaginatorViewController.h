//
//  SYPaginatorViewController.h
//  SYPaginator
//
//  Created by Sam Soffes on 9/21/11.
//  Copyright (c) 2011 Synthetic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYPaginatorView.h"

@interface SYPaginatorViewController : UIViewController <SYPaginatorViewDataSource, SYPaginatorViewDelegate>

@property (nonatomic, strong, readonly) SYPaginatorView *paginatorView;

@end
