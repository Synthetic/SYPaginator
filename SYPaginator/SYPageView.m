//
//  SYPageView.m
//  SYPaginator
//
//  Created by Sam Soffes on 3/8/12.
//  Copyright (c) 2012 Synthetic. All rights reserved.
//

#import "SYPageView.h"

@interface SYPageView ()
@property (nonatomic, strong, readwrite) NSString *reuseIdentifier;
@end

@implementation SYPageView

@synthesize reuseIdentifier = _reuseIdentifier;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithFrame:CGRectZero])) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.reuseIdentifier = reuseIdentifier;
	}
	return self;
}


- (void)prepareForReuse {
	// Subclasses may override this
}

@end
