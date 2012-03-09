//
//  SYPageView.h
//  SYPaginator
//
//  Created by Sam Soffes on 3/8/12.
//  Copyright (c) 2012 Synthetic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYPageView : UIView

@property (nonatomic, strong, readonly) NSString *reuseIdentifier;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)prepareForReuse;

@end
