//
//  BRImageBookView.m
//  mediaviewer
//
//  Created by Cornelius Horstmann on 23.02.13.
//  Copyright (c) 2013 brototyp.de. All rights reserved.
//

#import "BRImageBookView.h"
#import <QuartzCore/QuartzCore.h>

@interface BRImageBookView()

- (void)reinit;
- (void)setShadowLayer;
- (void)animate;
- (void)loadNextImageView;

@end

@implementation BRImageBookView {
    __strong ImageBlock _imageBlock;

    NSTimer *_animationTimer;

    UIView *_imagesView;
    CALayer *_shadowLayer;

    UIImageView *_frontImageView;
    UIImageView *_nextImageView;

    int _currentIndex;
    int _imageCount;
}

#pragma mark public
- (id)initWithFrame:(CGRect)frame imageCount:(int)imageCount andImageBlock:(ImageBlock)imageBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = NO;
        self.backgroundColor = [UIColor clearColor];
        
        _random = NO;
        _hasShadow = YES;
        
        _animationTime = 0.5;
        _displayTime = 3.0;
        _cornerRadius = 5;
        
        _animationType = BRImageBookViewAnimationTypeShift;
        
        [self setImageCount:imageCount andImageBlock:imageBlock];
    }
    return self;
}

- (void)setImageCount:(int)imageCount andImageBlock:(ImageBlock)imageBlock{
    [_animationTimer invalidate];
    _imageBlock = imageBlock;
    _imageCount = imageCount;
    _currentIndex = 0;
    _animationTimer = [NSTimer scheduledTimerWithTimeInterval:_displayTime target:self selector:@selector(animate) userInfo:NULL repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:_animationTimer forMode:NSRunLoopCommonModes];
    [self reinit];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self reinit];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if(_shadowLayer) _shadowLayer.frame = self.bounds;
}

- (void)setCornerRadius:(float)cornerRadius{
    _cornerRadius = cornerRadius;
    _imagesView.layer.cornerRadius = _cornerRadius;
    [self setShadowLayer];
}

- (void)setHasShadow:(BOOL)hasShadow{
    _hasShadow = hasShadow;
    [self setShadowLayer];
}

#pragma mark private
- (void)reinit{
    if(!_imageBlock) return;
    [self setShadowLayer];
    if(!_imagesView){
        _imagesView = [[UIView alloc] initWithFrame:self.bounds];
        _imagesView.backgroundColor = [UIColor clearColor];
        _imagesView.layer.cornerRadius = _cornerRadius;
        _imagesView.clipsToBounds = YES;
        _imagesView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:_imagesView];
    }
    
    if(!_frontImageView){
        _frontImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
        _frontImageView.transform = CGAffineTransformMakeTranslation(-_frontImageView.frame.size.width, 0);
        [_imagesView addSubview:_frontImageView];
    }
    if(_random)
        _frontImageView.image = _imageBlock(arc4random() %_imageCount);
    else
        _frontImageView.image = _imageBlock(_currentIndex);
}

- (void)setShadowLayer{
    if(_hasShadow){
        if(!_shadowLayer){
            _shadowLayer = [CALayer new];
            [self.layer addSublayer:_shadowLayer];
        }
        _shadowLayer.frame = self.bounds;
        _shadowLayer.cornerRadius = _cornerRadius;
        
        _shadowLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
        _shadowLayer.shadowColor = [UIColor blackColor].CGColor;
        _shadowLayer.shadowOpacity = 0.6;
        _shadowLayer.shadowOffset = CGSizeMake(0,0);
        _shadowLayer.shadowRadius = 3;
    } else {
        if(_shadowLayer){
            [_shadowLayer removeFromSuperlayer];
            _shadowLayer = NULL;
        }
    }
}

- (void)animate {
    if(!_imageBlock) return;
    [_animationTimer invalidate]; _animationTimer = NULL;
    
    [self loadNextImageView];
    [_imagesView addSubview:_nextImageView];
    [_imagesView bringSubviewToFront:_frontImageView];

    switch (_animationType) {
        case BRImageBookViewAnimationTypeCurl:
            [self animationCurl];
            break;
        
        case BRImageBookViewAnimationTypeShift:
            [self animationShift];
            break;
            
        default:
            break;
    }
}

- (void)animationShift{
    [UIView animateWithDuration:_animationTime animations:^{
        _frontImageView.transform = CGAffineTransformMakeTranslation(-_frontImageView.frame.size.width*2, 0);
        _nextImageView.transform = CGAffineTransformMakeTranslation(-_frontImageView.frame.size.width, 0);
    } completion:^(BOOL finished){
        [_frontImageView removeFromSuperview];
        _frontImageView = _nextImageView;
        _nextImageView = NULL;
        if(!_animationTimer){
            _animationTimer = [NSTimer scheduledTimerWithTimeInterval:_displayTime target:self selector:@selector(animate) userInfo:NULL repeats:NO];
            [[NSRunLoop mainRunLoop] addTimer:_animationTimer forMode:NSRunLoopCommonModes];
        }
    }];
}

- (void)animationCurl{
    _nextImageView.frame = _frontImageView.frame;
    [UIView transitionFromView:_frontImageView toView:_nextImageView duration:_animationTime options:UIViewAnimationOptionTransitionCurlUp completion:^(BOOL finished){
        [_frontImageView removeFromSuperview];
        _frontImageView = _nextImageView;
        _nextImageView = NULL;
        if(!_animationTimer){
            _animationTimer = [NSTimer scheduledTimerWithTimeInterval:_displayTime target:self selector:@selector(animate) userInfo:NULL repeats:NO];
            [[NSRunLoop mainRunLoop] addTimer:_animationTimer forMode:NSRunLoopCommonModes];
        }
    }];
}

#pragma mark helpers
- (void)loadNextImageView{
    if(_random){
        int oldIndex = _currentIndex;
        do {
            _currentIndex = arc4random() %_imageCount;
        } while (_currentIndex == oldIndex && _imageCount > 1);
    } else {
        _currentIndex++;
        if(_currentIndex >= _imageCount) _currentIndex = 0;
    }
    _nextImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
    _nextImageView.image = _imageBlock(_currentIndex);
}

@end
