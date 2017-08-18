//
//  VHWhiteBoardView.m
//  UIModel
//
//  Created by yangyang on 2017/3/13.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//

#import "VHDrawView.h"
#import "VHallMsgModels.h"
#import "UIImage+Tint.h"
#import "VHallMsgModels.h"

#define DEFAULT_LineWidth 3

@implementation VHDrawView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init
{
    self = [super init];
    if(self)
    {
        _scale = 1.0;
    }
    return self;
}

- (void)updateBoard
{
    [self setNeedsDisplay];
}

-(void)setDrawData:(NSArray *)drawData
{
    _drawData = drawData;
//    [self setNeedsDisplay];
}

- (void) drawRect: (CGRect) rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (VHFlashMsg *flashMsg in _drawData)
    {
        if(self.curImageURL && ![flashMsg.imageUrl isEqualToString:self.curImageURL])
            break;
        
        switch (flashMsg.drawType) {
            case VHDrawType_Handwriting:
                [self drawLine:(VHFlashMsg_Handwriting *)flashMsg context:context];
                break;
            case VHDrawType_Circle:
                [self drawCircle:(VHFlashMsg_Shape *)flashMsg context:context];
                break;
            case VHDrawType_Rectangle:
                [self drawSquare:(VHFlashMsg_Shape *)flashMsg context:context];
                break;
            case VHDrawType_Arrow:
                [self drawArrow:(VHFlashMsg_Shape *)flashMsg context:context];
                break;
            case VHDrawType_DoubleArrow:
                [self drawArrow:(VHFlashMsg_Shape *)flashMsg context:context];
                break;
            case VHDrawType_Text:
                [self drawText:(VHFlashMsg_Text *)flashMsg context:context];
                break;
            case VHDrawType_Anchor:
                [self drawArch:(VHFlashMsg_Anchor *)flashMsg context:context];
                break;
            default:
                break;
        }
    }
}

//划线
-(void)drawLine:(VHFlashMsg_Handwriting *)flashMsg context:(CGContextRef)context
{
    CGContextSetLineCap(context, kCGLineCapRound);
    long c = flashMsg.color;
    CGContextSetLineWidth(context, flashMsg.lineSize);  //线宽
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetRGBStrokeColor(context, ((c>>16)&0xFF) / 255.0, ((c>>8)&0xFF) / 255.0, (c&0xFF) / 255.0, 0.7);  //线的颜色
    CGContextBeginPath(context);
    
    for (int i = 0; i<flashMsg.points.count; i++) {
        NSArray* p = flashMsg.points[i];
        float x = [p[0] floatValue] * _scale;
        float y = [p[1] floatValue] * _scale;
        if(i==0)
            CGContextMoveToPoint(context, x, y);    //起点坐标
        else
            CGContextAddLineToPoint(context, x, y); //终点坐标
    }
    CGContextStrokePath(context);
}

//画箭头
-(void)drawArrow:(VHFlashMsg_Shape *)flashMsg context:(CGContextRef)context
{
    CGContextSetLineCap(context, kCGLineCapRound);
    float startX = [[flashMsg.startPoint objectAtIndex:0] floatValue] * _scale;
    float startY = [[flashMsg.startPoint objectAtIndex:1] floatValue] * _scale;
    float endX   = [[flashMsg.endPoint   objectAtIndex:0] floatValue] * _scale;
    float endY   = [[flashMsg.endPoint   objectAtIndex:1] floatValue] * _scale;
    long  c =  flashMsg.color;
    
    UIColor *rgbColor = [ UIColor colorWithRed: ((c>>16)&0xFF) / 255.0  green: ((c>>8)&0xFF) / 255.0  blue: (c&0xFF) / 255.0  alpha:0.7];
    //绘制杆
    CGContextMoveToPoint(context, startX, startY);
    CGContextSetRGBStrokeColor(context, ((c>>16)&0xFF) / 255.0, ((c>>8)&0xFF) / 255.0, (c&0xFF) / 255.0, 0.7);  //线的颜色
    CGContextAddLineToPoint(context, endX, endY);
    CGContextSetLineWidth(context, DEFAULT_LineWidth);
    CGContextStrokePath(context);
    
    //绘制箭头
    float roatX = (endX - startX);
    float roatY = (endY - startY);
    double z= sqrt(roatX*roatX + roatY*roatY);
    CGFloat acosValue = acos(roatX/z);
    CGContextSaveGState(context);
    CGContextTranslateCTM(context,endX,endY);
    if (!(fabsf(roatX)<=0.01 && fabsf(roatY) <=0.01))
    CGContextRotateCTM(context, roatY>0? acosValue: - acosValue);
    CGContextMoveToPoint(context,     0, -10 * _scale);
    CGContextAddLineToPoint(context,  0,  10 * _scale);
    CGContextAddLineToPoint(context,   10 * _scale, 0);
    CGContextSetFillColorWithColor(context, rgbColor.CGColor);
    CGContextFillPath(context);
    CGContextRestoreGState(context);
    if(flashMsg.drawType==VHDrawType_DoubleArrow)
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context,startX,startY);
        if (!(fabsf(roatX)<=0.01 && fabsf(roatY) <=0.01))
        CGContextRotateCTM(context, roatY>0? acosValue: - acosValue);
        CGContextMoveToPoint(context,      0, -10 * _scale);
        CGContextAddLineToPoint(context,   0,  10 * _scale);
        CGContextAddLineToPoint(context,  -10 * _scale,  0);
        CGContextSetFillColorWithColor(context, rgbColor.CGColor);
        CGContextFillPath(context);
        CGContextRestoreGState(context);
    }
}

//画圆
-(void)drawCircle:(VHFlashMsg_Shape *)flashMsg context:(CGContextRef)context
{
    CGContextSetLineCap(context, kCGLineCapRound);
    float startX = [[flashMsg.startPoint objectAtIndex:0] floatValue] * _scale;
    float startY = [[flashMsg.startPoint objectAtIndex:1] floatValue] * _scale;
    float endX   = [[flashMsg.endPoint   objectAtIndex:0] floatValue] * _scale;
    float endY   = [[flashMsg.endPoint   objectAtIndex:1] floatValue] * _scale;
    long  c =  flashMsg.color;
    CGContextSetLineWidth(context, DEFAULT_LineWidth);  //线宽
    CGContextSetRGBStrokeColor(context, ((c>>16)&0xFF) / 255.0, ((c>>8)&0xFF) / 255.0, (c&0xFF) / 255.0, 0.7);  //线的颜色
    CGContextAddEllipseInRect(context, CGRectMake(startX, startY, endX-startX, endY-startY)); //椭圆
    CGContextDrawPath(context,kCGPathStroke);
}

//方形
-(void)drawSquare:(VHFlashMsg_Shape *)flashMsg context:(CGContextRef)context
{
    CGContextSetLineCap(context, kCGLineCapRound);
    float startX = [[flashMsg.startPoint objectAtIndex:0] floatValue] * _scale;
    float startY = [[flashMsg.startPoint objectAtIndex:1] floatValue] * _scale;
    float endX   = [[flashMsg.endPoint   objectAtIndex:0] floatValue] * _scale;
    float endY   = [[flashMsg.endPoint   objectAtIndex:1] floatValue] * _scale;
    long  c =  flashMsg.color;
    CGContextSetLineWidth(context, DEFAULT_LineWidth);  //线宽
    CGContextSetRGBStrokeColor(context, ((c>>16)&0xFF) / 255.0, ((c>>8)&0xFF) / 255.0, (c&0xFF) / 255.0, 0.7);  //线的颜色
    CGContextStrokeRect(context,CGRectMake(startX, startY, endX-startX, endY-startY));//画方框
    CGContextDrawPath(context,kCGPathStroke);
}

-(void)drawArch:(VHFlashMsg_Anchor *)flashMsg context:(CGContextRef)context
{
    //CGContextSetLineCap(context, kCGLineCapRound);
    float startX = [[flashMsg.point objectAtIndex:0] floatValue] * _scale;
    float startY = [[flashMsg.point objectAtIndex:1] floatValue] * _scale;
    long  c =  flashMsg.color;
    CGContextSetRGBStrokeColor(context, ((c>>16)&0xFF) / 255.0, ((c>>8)&0xFF) / 255.0, (c&0xFF) / 255.0, 0.7);
    UIColor *rgbColor = [ UIColor colorWithRed: ((c>>16)&0xFF) / 255.0  green: ((c>>8)&0xFF) / 255.0  blue: (c&0xFF) / 255.0  alpha: 0.7 ];
    UIImage *image = [UIImage imageNamed:@"UIModel.bundle/point"];
    UIImage *images  = [self imageWithTintColor:rgbColor blendMode:kCGBlendModeDestinationIn UIImage:image];
    [images drawAtPoint:CGPointMake(startX, startY)];
}


-(void)drawText:(VHFlashMsg_Text *)flashMsg context:(CGContextRef)context
{
    CGContextSetLineCap(context, kCGLineCapRound);
  
    float    x = [[flashMsg.point objectAtIndex:0] floatValue] * _scale;
    float    y = [[flashMsg.point objectAtIndex:1] floatValue] * _scale;
    long     c = flashMsg.color;
    
    UIColor *rgbColor = [ UIColor colorWithRed: ((c>>16)&0xFF) / 255.0  green: ((c>>8)&0xFF) / 255.0  blue: (c&0xFF) / 255.0  alpha: 0.7 ];
    CGContextSetFillColorWithColor(context, rgbColor.CGColor);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGAffineTransform  myTextTransform =CGAffineTransformMakeScale(1, -1);
    CGContextSetTextMatrix(context, myTextTransform);
    
    
    NSDictionary *dic =nil;
    if (flashMsg.fb == 1 && flashMsg.fi == 1)
    {
      
        CGAffineTransform matrix =  CGAffineTransformMake(1, 0, tanf(15 * (CGFloat)M_PI / 180), 1, 0, 0);
        UIFontDescriptor *desc = [ UIFontDescriptor fontDescriptorWithName :[ UIFont fontWithName:@"Helvetica-Bold" size:flashMsg.fs ].fontName matrix :matrix];
        UIFont *font = [UIFont fontWithDescriptor:desc size:flashMsg.fs * _scale];
       dic = @{NSFontAttributeName:font,NSForegroundColorAttributeName:rgbColor};
        
    }else if ((flashMsg.fb == 1) && (flashMsg.fi == 0))
    {
       
        dic = @{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:flashMsg.fs],NSForegroundColorAttributeName:rgbColor};
        
    }else if ((flashMsg.fi == 1) && (flashMsg.fb == 0))
    {
       
        CGAffineTransform matrix =  CGAffineTransformMake(1, 0, tanf(15 * (CGFloat)M_PI / 180), 1, 0, 0);
        UIFontDescriptor *desc = [ UIFontDescriptor fontDescriptorWithName :[ UIFont systemFontOfSize :flashMsg.fs ].fontName matrix :matrix];
        UIFont *font = [UIFont fontWithDescriptor:desc size:flashMsg.fs];
        dic = @{NSFontAttributeName:font,NSForegroundColorAttributeName:rgbColor};
        
    }else
    {
        dic = @{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:flashMsg.fs],NSForegroundColorAttributeName:rgbColor};
        
    }

    [flashMsg.text drawAtPoint:CGPointMake(x,y) withAttributes:dic];
}

- (UIImage *) imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode UIImage:(UIImage*)image
{
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, 14, 20);
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    [image drawInRect:bounds blendMode:blendMode alpha:1.0f];
    
    if (blendMode != kCGBlendModeDestinationIn) {
        [image drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    }
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}

- (double)distanceFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint
{
    double num1 = pow(fromPoint.x - toPoint.x, 2);
    double num2 = pow(fromPoint.y - toPoint.y, 2);
    double distance = sqrt(num1 + num2);
    return distance;
}

@end
