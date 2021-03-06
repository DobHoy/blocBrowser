//
//  BLCAwesomeFloatingToolbar.h
//  BlocBrowser
//
//  Created by Srikanth Narayanamohan on 16/04/2015.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BLCAwesomeFloatingToolbar;

@protocol BLCAwesomeFloatingToolBarDelgate <NSObject>

@optional

-(void) floatingToolbar:(BLCAwesomeFloatingToolbar *)toolbar didSelectButtonWithTitle:(NSString *)title;
-(void) floatingToolbar:(BLCAwesomeFloatingToolbar *)toolbar didTryToPanWithOffset:(CGPoint)offset;
-(void) floatingToolbar:(BLCAwesomeFloatingToolbar *)toolbar didPinchToolbarWithScale:(CGFloat)scale;
-(void) floatingToolbarRotateColors:(BLCAwesomeFloatingToolbar *)toolbar;

@end

@interface BLCAwesomeFloatingToolbar : UIView

- (instancetype) initWithFourTitles:(NSArray *) titles;

- (void) setEnabled: (BOOL) enabled forButtonWithTitle:(NSString *)title;

- (void) rotateColors;

@property (nonatomic, weak) id<BLCAwesomeFloatingToolBarDelgate> delegate;



@end
