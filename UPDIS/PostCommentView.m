//
//  PostCommentView.m
//  UPDIS
//
//  Created by Melvin on 13-7-4.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import "PostCommentView.h"

@implementation PostCommentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        [self setBackgroundColor:[UIColor colorWithPatternImage:[TTIMAGE(@"bundle://input-bar.png") resizableImageWithCapInsets:UIEdgeInsetsMake(19.0f, 3.0f, 19.0f, 3.0f)]]];

        self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin);
        _btnSelect = [self createButtonWithTitle:@"匿名"
                                           image:@"bundle://ico04.png"
                                          imageH:@"bundle://ico05.png"
                                    isBackground:NO];

        [_btnSelect setLeft:self.width-_btnSelect.width-5];
        [_btnSelect setTop:(self.height-_btnSelect.height)/2];
        [_btnSelect setTag:10];
        [self addSubview:_btnSelect];

        _btnPost = [self createButtonWithTitle:@"提交"
                                         image:@"bundle://btn6.png"
                                        imageH:@"bundle://btn6.png"
                                  isBackground:YES];
        [_btnPost setLeft:_btnSelect.left-_btnPost.width-5];
        [_btnPost setTop:(self.height-_btnPost.height)/2];
        [_btnSelect setTag:11];
        [self addSubview:_btnPost];


//        [[_btnPost layer] setBorderWidth:1];
//        [[_btnPost layer] setBorderColor:[[UIColor blueColor] CGColor]];

        if (!self.txtComment) {
            UITextView *temp = [[UITextView alloc] initWithFrame:CGRectMake(5, 2, _btnPost.left-5*2, self.height-4)];
            self.txtComment = temp;
            TT_RELEASE_SAFELY(temp);
            
            self.txtComment.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            self.txtComment.backgroundColor = [UIColor whiteColor];
            self.txtComment.scrollIndicatorInsets = UIEdgeInsetsMake(13.0f, 0.0f, 14.0f, 7.0f);
            self.txtComment.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 13.0f, 0.0f);
            self.txtComment.scrollEnabled = YES;
            self.txtComment.scrollsToTop = NO;
            self.txtComment.userInteractionEnabled = YES;
            self.txtComment.font = [UIFont systemFontOfSize:16.0f];
            self.txtComment.textColor = [UIColor blackColor];
            self.txtComment.backgroundColor = [UIColor whiteColor];
            self.txtComment.keyboardAppearance = UIKeyboardAppearanceDefault;
            self.txtComment.keyboardType = UIKeyboardTypeDefault;
            self.txtComment.returnKeyType = UIReturnKeyDefault;
//            [[self.txtComment layer] setBorderWidth:1];
//            [[self.txtComment layer] setBorderColor:[[UIColor blueColor] CGColor]];
            [self addSubview:self.txtComment];
        }
    [self.txtComment setBackgroundColor:[UIColor whiteColor]];


//    [self.txtComment becomeFirstResponder];
    }
    return self;
}

-(UIButton *)createButtonWithTitle:(NSString *)title
                             image:(NSString *)image
                            imageH:(NSString *)imageH
                      isBackground:(BOOL)isBackground{
    UIButton *temp = [UIButton buttonWithType:UIButtonTypeCustom];
    if (title) {
        [temp setTitle:title forState:UIControlStateNormal];
    }
    if (image) {
        if (isBackground) {
            [temp setBackgroundImage:TTIMAGE(image) forState:UIControlStateNormal];
        }
        else{
            [temp setImage:TTIMAGE(image) forState:UIControlStateNormal];
        }
    }
    if (imageH) {
        if (isBackground) {
            [temp setBackgroundImage:TTIMAGE(imageH) forState:UIControlStateSelected];
        }
        else{
            [temp setImage:TTIMAGE(imageH) forState:UIControlStateSelected];
        }
    }
    [temp addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [[temp titleLabel] setFont:[UIFont systemFontOfSize:14]];
    [temp sizeToFit];
    return temp;
}

-(void)buttonClick:(id)sender{
    UIButton *temp = (UIButton *)sender;
    [temp setSelected:!temp.selected];
}


#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{

    return YES;
}
//- (BOOL)textViewShouldEndEditing:(UITextView *)textView;

//- (void)textViewDidBeginEditing:(UITextView *)textView;
//- (void)textViewDidEndEditing:(UITextView *)textView;

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (void)textViewDidChange:(UITextView *)textView
{

}

#pragma mark - Message input view
+ (CGFloat)textViewLineHeight
{
    return 35.0f; // for fontSize 15.0f
}

+ (CGFloat)maxLines
{
    return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 4.0f : 8.0f;
}

+ (CGFloat)maxHeight
{
    return ([PostCommentView maxLines] + 1.0f) * [PostCommentView textViewLineHeight];
}
-(void)dealloc{
    [_txtComment setDelegate:nil];
    TT_RELEASE_SAFELY(_txtComment);
    TT_RELEASE_SAFELY(_btnPost);
    TT_RELEASE_SAFELY(_btnSelect);
    [super dealloc];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
