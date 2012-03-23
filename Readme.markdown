# SYPaginator

Simple paging scroll view to make complicated tasks easier. We use this in several of the [Synthetic](http://heysynthetic.com) apps including [Hipstamatic](http://hipstamatic.com), [D-Series](http://disposable.hipstamatic.com), and [IncrediBooth](http://incredibooth.com).

## Adding to Your Project

1. Add SYPaginator as a submodule by running the following command from the root of your project

        $ git submodule add https://github.com/Synthetic/SYPaginator.git Vendor/SYPaginator
    
    You can also just download the code and put it in your project too.

2. Drag the SYPaginator project into your projet.

3. Add `libSYPaginator.a` and `SYPaginatorResources.bundle` as Build Dependencies to your target

4. Drag `SYPaginatorResources.bundle` from the file browser sidebar into the Copy Bundle Resources build phase.

5. Add `#import <SYPaginator/SYPaginator.h>` where ever you'd like to use SYPaginator.


## Example App 

There is an example app included with SYPaginator. Check it out for basic usage.
