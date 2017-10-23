//
//  VHDocumentView.m
//  UIModel
//
//  Created by vhall on 17/3/21.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//

#import "VHDocumentView.h"
#import "VHDrawView.h"
#import "UIImageView+WebCache.h"

@interface VHDocumentView()
@property(nonatomic,strong) VHDrawView *pptDrawView;
@property(nonatomic,strong) UIView     *boardContainer;//白板容器
@property(nonatomic,strong) VHDrawView *boardDrawView;

@property(nonatomic,assign) float boardWidth;
@property(nonatomic,assign) float boardHeight;
@property(nonatomic,assign) float boardScale;
@property(nonatomic,strong) NSString *completedImagePath;
@end

@implementation VHDocumentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setImagePath:(NSString *)imagePath
{
    _imagePath = imagePath;
    
//    self.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]]];

    self.boardWidth = 1024;
    self.boardHeight = 768;
    self.boardScale  = 1;
    self.completedImagePath = nil;
    
    self.image = nil;
    
    __weak typeof(self) ws = self;
     [self drawDocHandList:nil whiteBoardHandList:nil];
    [self sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [[SDImageCache sharedImageCache]clearMemory];
        [ws loadImageCompleted:imageURL];
    }];
}

- (void)loadImageCompleted:(NSURL *)imageURL
{
    //缩放ppt 控制画布大小 1024x1024以下画布不做缩放处理
    _boardWidth = self.image.size.width * self.image.scale;
    _boardHeight = self.image.size.height * self.image.scale;
    if(_boardWidth<=0 || _boardHeight<=0)
        return;
        
    float s  = 1024/_boardWidth;
    float s1 = 1024/_boardHeight;
    s = (s<s1)?s:s1;
    
    if(s < 1)
    {
        _boardScale = s;
        _boardWidth = _boardWidth * _boardScale;
        _boardHeight = _boardHeight * _boardScale;
    }
    
    
    self.completedImagePath = [imageURL absoluteString];
//    NSLog(@"url:%@ %fx%f %f",_completedImagePath,_boardWidth,_boardHeight,_boardScale);
    [self pptDrawPoint];
   
}
//- (void)setFrame:(CGRect)frame
//{
//    [super setFrame:frame];
//    
//}

- (void)drawDocHandList:(NSArray*)docList whiteBoardHandList:(NSArray*)boardList
{
    //NSLog(@"%lu %lu",(unsigned long)docList.count,(unsigned long)boardList.count);
    if(docList && docList.count > 0)
    {
        if(!_pptDrawView)
        {
            _pptDrawView = [[VHDrawView alloc]init];
            _pptDrawView.backgroundColor = [UIColor clearColor];
            [self addSubview:_pptDrawView];
        }
        _pptDrawView.drawData = docList;
        [self pptDrawPoint];
       
        [self bringSubviewToFront:_pptDrawView];
    }
    else
    {
        [_pptDrawView removeFromSuperview];
        _pptDrawView = nil;
    }
    
    
    if (boardList)
    {
        if (!_boardContainer)
        {
            _boardContainer =[[UIView alloc] initWithFrame:self.bounds];
            _boardContainer.backgroundColor=MakeColorRGB(0xe2e8eb);
            [self addSubview:_boardContainer];
        }
        if (!_boardDrawView)
        {
            _boardDrawView =[[VHDrawView alloc] init];
            _boardDrawView.backgroundColor = [UIColor whiteColor];
        }
        [_boardContainer addSubview:_boardDrawView];
         _boardDrawView.drawData = boardList;
        [self whiteBoardPoint];
        [self bringSubviewToFront:_boardContainer];
    }else
    {
        [_boardContainer removeFromSuperview];
        _boardContainer =nil;
    }

}

-(void)layoutSubviews
{
//    if (_pptDrawView) {
//         _pptDrawView.frame = CGRectMake(0,0,self.image.size.width,self.image.size.height);
//    }
    
    [self pptDrawPoint];
    [self whiteBoardPoint];
}

-(void)pptDrawPoint
{
    if(![_completedImagePath isEqualToString:self.imagePath])
        return;
    if (_pptDrawView)
    {
        _pptDrawView.curImageURL = _completedImagePath;
        _pptDrawView.scale = _boardScale;
        
        _pptDrawView.transform = CGAffineTransformIdentity;
        _pptDrawView.frame = CGRectMake(0,0,self.boardWidth,self.boardHeight);
       
        float s  = self.width/self.boardWidth;
        float s1 = self.height/self.boardHeight;
        s = (s<s1)?s:s1;
        _pptDrawView.transform = CGAffineTransformMakeScale(s,s);
        _pptDrawView.center = CGPointMake(self.width/2,self.height/2);
        [_pptDrawView updateBoard];
    }
}

-(void)whiteBoardPoint
{
    if (_boardContainer)
    {
        [_boardContainer setFrame:self.bounds];
        _boardDrawView.transform = CGAffineTransformIdentity;
        _boardDrawView.frame =CGRectMake(0,0,1024,768);
        float s  = _boardContainer.width/1024;
        float s1 = _boardContainer.height/768;
        s = (s<s1)?s:s1;
        _boardDrawView.transform = CGAffineTransformMakeScale(s,s);
        _boardDrawView.center = CGPointMake(_boardContainer.width/2,_boardContainer.height/2);
        [_boardDrawView updateBoard];
    }
}


// 根据图片url获取图片尺寸
+(CGSize)getImageSizeWithURL:(id)imageURL
{
    NSURL* URL = nil;
    if([imageURL isKindOfClass:[NSURL class]]){
        URL = imageURL;
    }
    if([imageURL isKindOfClass:[NSString class]]){
        URL = [NSURL URLWithString:imageURL];
    }
    if(URL == nil)
        return CGSizeZero;                  // url不正确返回CGSizeZero
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    NSString* pathExtendsion = [URL.pathExtension lowercaseString];
    
    CGSize size = CGSizeZero;
    if([pathExtendsion isEqualToString:@"png"]){
        size =  [self getPNGImageSizeWithRequest:request];
    }
    else if([pathExtendsion isEqual:@"gif"])
    {
        size =  [self getGIFImageSizeWithRequest:request];
    }
    else{
        size = [self getJPGImageSizeWithRequest:request];
    }
    if(CGSizeEqualToSize(CGSizeZero, size))                    // 如果获取文件头信息失败,发送异步请求请求原图
    {
        NSData* data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:URL] returningResponse:nil error:nil];
        UIImage* image = [UIImage imageWithData:data];
        if(image)
        {
            size = image.size;
        }
    }
    return size;
}
//  获取PNG图片的大小
+(CGSize)getPNGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 8)
    {
        int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        [data getBytes:&w3 range:NSMakeRange(2, 1)];
        [data getBytes:&w4 range:NSMakeRange(3, 1)];
        int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
        int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
        [data getBytes:&h1 range:NSMakeRange(4, 1)];
        [data getBytes:&h2 range:NSMakeRange(5, 1)];
        [data getBytes:&h3 range:NSMakeRange(6, 1)];
        [data getBytes:&h4 range:NSMakeRange(7, 1)];
        int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}
//  获取gif图片的大小
+(CGSize)getGIFImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=6-9" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 4)
    {
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        short w = w1 + (w2 << 8);
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(2, 1)];
        [data getBytes:&h2 range:NSMakeRange(3, 1)];
        short h = h1 + (h2 << 8);
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}
//  获取jpg图片的大小
+(CGSize)getJPGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=0-999" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if ([data length] <= 0x58) {
        return CGSizeZero;
    }
    
    if ([data length] < 210) {// 肯定只有一个DQT字段
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        short w = (w1 << 8) + w2;
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        short h = (h1 << 8) + h2;
        return CGSizeMake(w, h);
    } else {
        short word = 0x0;
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        if (word == 0xdb) {
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) {// 两个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            } else {// 一个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            }
        } else if (word == 0xe1){
            short w1 = 0, w2 = 0;
            [data getBytes:&w1 range:NSMakeRange(0x14b, 0x1)];
            [data getBytes:&w2 range:NSMakeRange(0x14c, 0x1)];
            short w = (w1 << 8) + w2;
            short h1 = 0, h2 = 0;
            [data getBytes:&h1 range:NSMakeRange(0x149, 0x1)];
            [data getBytes:&h2 range:NSMakeRange(0x14a, 0x1)];
            short h = (h1 << 8) + h2;
            return CGSizeMake(w, h);
        } else {
            return CGSizeZero;
        }
    }
}


@end
