//
//  PEPageView.m
//  Paginator Example
//
//  Created by Sam Soffes on 3/8/12.
//  Copyright (c) 2012 Synthetic. All rights reserved.
//

#import "PEPageView.h"

@implementation PEPageView

@synthesize textLabel = _textLabel;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithReuseIdentifier:reuseIdentifier])) {
		self.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];

		_textLabel = [[UILabel alloc] initWithFrame:self.bounds];
		_textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		_textLabel.backgroundColor = [UIColor clearColor];
		_textLabel.textAlignment = UITextAlignmentCenter;
		_textLabel.textColor = [UIColor whiteColor];
		[self addSubview:_textLabel];
	}
	return self;
}

@end
