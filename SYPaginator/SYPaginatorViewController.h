//
//  SYPaginatorViewController.h
//  SYPaginator
//
//  Created by Sam Soffes on 9/21/11.
//  Copyright (c) 2011 Synthetic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SYPaginatorView.h"

@interface SYPaginatorViewController : UIViewController <SYPaginatorViewDataSource, SYPaginatorViewDelegate>

@property (nonatomic, readonly) SYPaginatorView *paginator;

@end
