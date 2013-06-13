//
//  BRViewController.m
//  BRImageBook
//
//  Created by Cornelius Horstmann on 03.06.13.
//  Copyright (c) 2013 brototyp.de. All rights reserved.
//

#import "BRViewController.h"
#import "BRImageBookView.h"

@interface BRViewController (){
    BRImageBookView *_imageBookView;
    NSArray *_images;
}

@end

@implementation BRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _images = @[@"cats1.jpeg",@"cats2.jpeg",@"cats3.jpeg",@"cats4.jpeg"];
    
    float width = self.view.frame.size.width * 0.8;
    
    __block NSArray *images = _images;
    _imageBookView = [[BRImageBookView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-width)/2, (self.view.frame.size.height-width)/2, width/2-10, width/2-10) imageCount:_images.count andImageBlock:^UIImage *(int index){
        return [UIImage imageNamed:[images objectAtIndex:index]];
    }];
    
    _imageBookView.random = YES;
    _imageBookView.animationTime = 1.0;
    _imageBookView.cornerRadius = 20.0;
    _imageBookView.animationType = BRImageBookViewAnimationTypeCurl;
    
    [self.view addSubview:_imageBookView];
    
    _imageBookView = [[BRImageBookView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-width)/2+width/2, (self.view.frame.size.height-width)/2, width/2-10, width/2-10) imageCount:_images.count andImageBlock:^UIImage *(int index){
        return [UIImage imageNamed:[images objectAtIndex:index]];
    }];
    
    _imageBookView.random = YES;
    _imageBookView.displayTime = 2.0;
    _imageBookView.animationTime = 1.0;
    _imageBookView.cornerRadius = 0.0;
    _imageBookView.animationType = BRImageBookViewAnimationTypeShift;
    
    [self.view addSubview:_imageBookView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
