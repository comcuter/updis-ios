//
//  StyleSheet.m
//  NTMuseum
//
//  Created by Melvin on 12-8-11.
//  Copyright (c) 2012年 Melvin. All rights reserved.
//

#import "NTStyleSheet.h"

@implementation NTStyleSheet

- (TTStyle*)pageDot:(UIControlState)state
{
    if (state == UIControlStateSelected) {
        return [self pageDotWithColor:RGBCOLOR(228, 0, 127)];
    } else {
        return [self pageDotWithColor:RGBCOLOR(166, 166, 166)];
    }
}
- (TTStyle*)tabStrip
{
    UIColor* border = [TTSTYLEVAR(tabTintColor) multiplyHue:0 saturation:0 value:0.4];
    return
    [TTReflectiveFillStyle styleWithColor:TTSTYLEVAR(tabTintColor) next:
     [TTFourBorderStyle styleWithTop:nil right:nil bottom:border left:nil width:1 next:nil]];
}

- (TTStyle*)tabRound:(UIControlState)state
{
    if (state == UIControlStateSelected) {
        return
        [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:TT_ROUNDED] next:
         [TTInsetStyle styleWithInset:UIEdgeInsetsMake(9, 1, 8, 1) next:
          [TTShadowStyle styleWithColor:RGBACOLOR(255,255,255,0.8) blur:0 offset:CGSizeMake(0, 1) next:
           [TTReflectiveFillStyle styleWithColor:TTSTYLEVAR(tabBarTintColor) next: //styleWithColor:RGBCOLOR( , , ) next:
            [TTInnerShadowStyle styleWithColor:RGBACOLOR(0,0,0,0.3) blur:1 offset:CGSizeMake(1, 1) next:
             [TTInsetStyle styleWithInset:UIEdgeInsetsMake(-1, -1, -1, -1) next:
              [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(0, 10, 0, 10) next:
               [TTTextStyle styleWithFont:[UIFont boldSystemFontOfSize:13]  color:[UIColor whiteColor]
                          minimumFontSize:8 shadowColor:[UIColor colorWithWhite:0 alpha:0.5]
                             shadowOffset:CGSizeMake(0, -1) next:nil]]]]]]]];
    } else {
        return
        [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(0, 10, 0, 10) next:
         [TTTextStyle styleWithFont:[UIFont boldSystemFontOfSize:13]  color:self.linkTextColor
                    minimumFontSize:8 shadowColor:[UIColor colorWithWhite:1 alpha:0.9]
                       shadowOffset:CGSizeMake(0, -1) next:nil]];
    }
}

- (TTStyle*)tabOverflowLeft
{
    UIImage* image = TTIMAGE(@"bundle://Three20.bundle/images/overflowLeft.png");
    TTImageStyle *style = [TTImageStyle styleWithImage:image next:nil];
    style.contentMode = UIViewContentModeCenter;
    return style;
}

- (TTStyle*)tabOverflowRight
{
    UIImage* image = TTIMAGE(@"bundle://Three20.bundle/images/overflowRight.png");
    TTImageStyle *style = [TTImageStyle styleWithImage:image next:nil];
    style.contentMode = UIViewContentModeCenter;
    return style;
}

- (UIColor*)tableSubTextColor
{
    return RGBCOLOR(87,87,87);
}

@end
