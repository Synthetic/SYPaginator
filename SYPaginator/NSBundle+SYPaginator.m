//
//  NSBundle+SYPaginator.m
//  SYPaginator
//
//  Created by Sam Soffes on 3/20/12.
//  Copyright (c) 2012 Synthetic. All rights reserved.
//

#import "NSBundle+SYPaginator.h"

@implementation NSBundle (SYPaginator)

+ (NSBundle *)paginatorBundle {
	static NSBundle *paginatorBundle = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSString *bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"SYPaginatorResources.bundle"];
		paginatorBundle = [[NSBundle alloc] initWithPath:bundlePath];
	});
	return paginatorBundle;
}

@end
