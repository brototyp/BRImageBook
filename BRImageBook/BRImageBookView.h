//
//  BRImageBookView.h
//  mediaviewer
//
//  Created by Cornelius Horstmann on 23.02.13.
//  Copyright (c) 2013 brototyp.de. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    BRImageBookViewAnimationTypeShift,
    BRImageBookViewAnimationTypeCurl,
} BRImageBookViewAnimationType;

@class BRImageBookView;

typedef UIImage *(^ ImageBlock)(int index);

@protocol BRImageBookViewDelegate <NSObject>

- (NSUInteger)numberOfPhotosInImageBookView:(BRImageBookView *)bookView;
- (UIImage*)imageBookView:(BRImageBookView *)bookView imageAtIndex:(NSUInteger)index;

@end

@interface BRImageBookView : UIView

@property (nonatomic,readwrite) BOOL random;
@property (nonatomic,readwrite) BOOL hasShadow;
@property (nonatomic,readwrite) float animationTime;
@property (nonatomic,readwrite) float displayTime;
@property (nonatomic,readwrite) float cornerRadius;
@property (nonatomic,readwrite) BRImageBookViewAnimationType animationType;

- (id)initWithFrame:(CGRect)frame imageCount:(int)imageCount andImageBlock:(ImageBlock)imageBlock;
- (void)setImageCount:(int)imageCount andImageBlock:(ImageBlock)imageBlock;

@end
