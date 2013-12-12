//
//  CommonDetailDataSource.m
//  UPDIS
//
//  Created by Melvin on 13-7-3.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import "CommonDetailDataSource.h"
#import "CommonDetailItem.h"
#import "CommonDetailItemCell.h"
#import "BaseFunction.h"
#import "CommentModel.h"
#import "MessageDataModel.h"
#import "CommentItem.h"
#import "CommentItemCell.h"

@implementation CommonDetailDataSource

///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)dealloc{
    TT_RELEASE_SAFELY(_commonDetailDataSourceModel);
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object {
    if ([object isKindOfClass:[CommonDetailItem class]]) {
        return [CommonDetailItemCell class];
    } else if([object isKindOfClass:[CommentItem class]]){
        return [CommentItemCell class];
    }
    else {
        return [super tableView:tableView cellClassForObject:object];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView*)tableView
             cell:(UITableViewCell*)cell willAppearAtIndexPath:(NSIndexPath*)indexPath{
    if (([indexPath row]+2)==[self.items count]) {
        if (self.loadList) {
            [_commonDetailDataSourceModel load:TTURLRequestCachePolicyDefault more:YES];
        }
    }
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL) tableView: (UITableView *)tableView canEditRowAtIndexPath:  (NSIndexPath *)indexPath {
    return NO;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithConentId:(NSString *)contentId loadList:(BOOL)loadList{
    if (self = [super init]) {
        [self setContentId:contentId];
        [self setLoadList:loadList];
        _commonDetailDataSourceModel = [[CommonDetailDataSourceModel alloc] initWithConentId:contentId
                                                                                    loadList:self.loadList];
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<TTModel>)model {
    return _commonDetailDataSourceModel;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(CommentItem *)createItem:(CommentModel *)commentModel{
    NSString *title = [NSString stringWithFormat:@"%@ 于%@的留言",(commentModel.isAnonymous?@"匿名":commentModel.author),commentModel.datetime];

    NSString *iconUrl = @"bundle://default_user_icon.png";
    if (commentModel.iconUrl&&![commentModel.iconUrl isKindOfClass:[NSNull class]]) {
        iconUrl = commentModel.iconUrl;
    }
    CommentItem *item = [CommentItem itemWithTitle:nil
                                           caption:title
                                              text:nil
                                           datestr:nil
                                          imageURL:iconUrl
                                               URL:nil
                                         styleText:[TTStyledText textFromXHTML:[BaseFunction flattenHTML:commentModel.content]
                                                                    lineBreaks:YES
                                                                          URLs:YES]];

    return item;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableViewDidLoadModel:(UITableView*)tableView {
    NSMutableArray* items = [[NSMutableArray alloc] init];
    if (self.loadList) {
        for (CommentModel *commentModel in _commonDetailDataSourceModel.listData) {
            [items addObject:[self createItem:commentModel]];
        }
    }
    else{
        MessageDataModel *dataModel = _commonDetailDataSourceModel.pageData;
        if (self.delegate&&[self.delegate respondsToSelector:@selector(contentLoadOver:)]) {
            [self.delegate contentLoadOver:dataModel];
        }
        if (dataModel.comments&&[dataModel.comments count]>0) {
            for (CommentModel *commentModel in dataModel.comments) {
                [items addObject:[self createItem:commentModel]];
            }
        }
        else{
            [items addObject:[TTTableImageItem itemWithText:nil
                                                   imageURL:nil
                                                        URL:nil]];
        }
    }
    self.items = items;
    TT_RELEASE_SAFELY(items);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)titleForLoading:(BOOL)reloading {
    return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)titleForEmpty {
    return @"暂无数据";
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)subtitleForError:(NSError*)error {
    return NSLocalizedString(@"Sorry, there was an error loading the data stream.", @"");
}


@end
