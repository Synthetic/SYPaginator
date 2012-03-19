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

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super initWithCoder:aDecoder])) {
		// If you are using a nib for your page views, the reuse identifier is set to its class name (though this isn't the best, it is relatively simple and only applies if using nibs)
		self.reuseIdentifier = NSStringFromClass([self class]);
	}
	return self;
}

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
