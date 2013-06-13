BRImageBook
===========

Eine einfache Klasse um Bilder in einer Slideshow anzuzeigen.

``` objectivec
NSArray *images = @[@"cats1.jpeg",@"cats2.jpeg",@"cats3.jpeg",@"cats4.jpeg"];

_imageBookView = [[BRImageBookView alloc] initWithFrame:CGRectMake(0,0,100,100) imageCount:images.count andImageBlock:^UIImage *(int index){
    return [UIImage imageNamed:[images objectAtIndex:index]];
}];

_imageBookView.random = YES;
_imageBookView.animationTime = 1.0;
_imageBookView.cornerRadius = 20.0;
_imageBookView.animationType = BRImageBookViewAnimationTypeCurl;

[self.view addSubview:_imageBookView];
```

animationTime
------------
Die Dauer einer Animation.

displayTime
------------
Wie lange wird ein Bild angezeigt.

animationType
------------
- BRImageBookViewAnimationTypeCurl
![Curl Animation](https://dl.dropboxusercontent.com/u/362860/brimagebook_curl.png)

- BRImageBookViewAnimationTypeShift
![Shift Animation](https://dl.dropboxusercontent.com/u/362860/brimagebook_shift.png)
