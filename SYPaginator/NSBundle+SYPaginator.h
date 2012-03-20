//
//  NSBundle+SYPaginator.h
//  SYPaginator
//
//  Created by Sam Soffes on 3/20/12.
//  Copyright (c) 2012 Synthetic. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SYPaginatorLocalizedString(key) [[NSBundle paginatorBundle] localizedStringForKey:(key) value:@"" table:@"SYPaginator"]

@interface NSBundle (SYPaginator)

+ (NSBundle *)paginatorBundle;

@end
