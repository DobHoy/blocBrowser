//
//  BLCAwesomeFloatingToolbar.m
//  BlocBrowser
//
//  Created by Srikanth Narayanamohan on 16/04/2015.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "BLCAwesomeFloatingToolbar.h"

@interface BLCAwesomeFloatingToolbar()


@property (nonatomic, strong) NSArray *currentTitles;
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSArray *labels;
@property (nonatomic, weak) UILabel *currentLabel;

//Gesture Recognizers
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;
@property (nonatomic, strong) UILongPressGestureRecognizer *longGesture;

@end

@implementation BLCAwesomeFloatingToolbar


-(instancetype) initWithFourTitles:(NSArray *)titles
{
    self = [super init];
    
    if(self)
    {
        self.currentTitles = titles;
        self.colors = @[[UIColor colorWithRed:199/255.0 green:158/255.0 blue:203/255.0 alpha:1],
                        [UIColor colorWithRed:255/255.0 green:105/255.0 blue:97/255.0 alpha:1],
                        [UIColor colorWithRed:222/255.0 green:165/255.0 blue:164/255.0 alpha:1],
                        [UIColor colorWithRed:255/255.0 green:179/255.0 blue:71/255.0 alpha:1]];
        NSMutableArray *labelsArray = [[NSMutableArray alloc]init];
        
        for (NSString *currentTitle in self.currentTitles) {
            UILabel *label = [[UILabel alloc]init];
            label.userInteractionEnabled = NO;
            label.alpha = 0.25;
            
            NSUInteger currentTitleIndex = [self.currentTitles indexOfObject:currentTitle]; // 0 through 3
            NSString *titleForThisLabel = [self.currentTitles objectAtIndex:currentTitleIndex];
            UIColor *colorForThisLabel = [self.colors objectAtIndex:currentTitleIndex];
            
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:10];
            label.text = titleForThisLabel;
            label.backgroundColor = colorForThisLabel;
            label.textColor = [UIColor whiteColor];
            
            [labelsArray addObject:label];
        }
        
        self.labels = labelsArray;
        
        for(UILabel *thisLabel in self.labels){
            [self addSubview:thisLabel];
            
        }
        self.tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapFired:)];
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panFired:)];
        self.pinchGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchFired:)];
        self.longGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longFired:)];
        
        self.longGesture.minimumPressDuration = 1.0f;
        self.longGesture.allowableMovement = 100.0f;
        
        [self addGestureRecognizer:self.longGesture];
        [self addGestureRecognizer:self.tapGesture];
        [self addGestureRecognizer:self.panGesture];
        [self addGestureRecognizer:self.pinchGesture];
        
    
    }
    return self;
    
}

-(void) panFired:(UIPanGestureRecognizer *) recognizer{
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:self];
        
        NSLog(@"new translation: %@", NSStringFromCGPoint(translation));
        
        if([self.delegate respondsToSelector:@selector(floatingToolbar:didTryToPanWithOffset:)]){
            [self.delegate floatingToolbar:self didTryToPanWithOffset:translation];
            
        }
        
        [recognizer setTranslation:CGPointZero inView:self];
    }
    
    
}

-(void) pinchFired:(UIPinchGestureRecognizer *) recognizer {
    
    if(recognizer.state == UIGestureRecognizerStateChanged)
    {
        CGFloat scale = [recognizer scale];
        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didPinchToolbarWithScale:)]) {
            [self.delegate floatingToolbar:self didPinchToolbarWithScale:scale];
        }
    }
    
}

-(void) longFired:(UILongPressGestureRecognizer *) recognizer {
    
    
    
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        if([self.delegate respondsToSelector:@selector(floatingToolbar:rotateColors:)]){
//            [self.delegate floatingToolbar:self rotateColors];
            NSLog(@"rotation of colors to be implemented!");
            
        }
    }
    
}

-(void) tapFired:(UITapGestureRecognizer *) recognizer{
    
    if (recognizer.state ==UIGestureRecognizerStateRecognized)
    {
        CGPoint location = [recognizer locationInView:self];
        UIView *tappedView = [self hitTest:location withEvent:nil];
        
        if([self.labels containsObject:tappedView])
        {
            if([self.delegate respondsToSelector:@selector(floatingToolbar:didSelectButtonWithTitle:)]){
                [self.delegate floatingToolbar:self didSelectButtonWithTitle:((UILabel *)tappedView).text];
                
            }
        }
        
    }
}

-(void) layoutSubviews{
    
    
    for(UILabel *thisLabel in self.labels)
    {
        NSUInteger currentLabelIndex = [self.labels indexOfObject:thisLabel];
        
        CGFloat labelHeight = CGRectGetHeight(self.bounds) / 2;
        CGFloat labelWidth = CGRectGetWidth(self.bounds) / 2;
        CGFloat labelX = 0;
        CGFloat labelY = 0;
        
        if (currentLabelIndex < 2) {
            labelY = 0;
            
        } else {
            labelY = CGRectGetHeight(self.bounds) / 2;
            
        }
        
        if(currentLabelIndex % 2 == 0){
            labelX = 0;
        } else {
            labelX = CGRectGetWidth(self.bounds)/2;
        
        }
        
        thisLabel.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight);
    }
    
}

#pragma mark - Touch Handling

- (UILabel *) labelFromTouches:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    UIView *subview = [self hitTest:location withEvent:event];
    return (UILabel *)subview;
}




-(void) setEnabled:(BOOL)enabled forButtonWithTitle:(NSString *)title{
    NSUInteger index = [self.currentTitles indexOfObject:title];
    
    if (index != NSNotFound) {
        UILabel *label = [self.labels objectAtIndex:index];
        label.userInteractionEnabled = enabled;
        label.alpha = enabled ? 1.0 : 0.25;
    }
}

@end
