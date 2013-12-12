//
//  CommonListDataSource.m
//  UPDIS
//
//  Created by Melvin on 13-7-1.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import "CommonListDataSource.h"
#import "MessageDataModel.h"
#import "UserModel.h"
#import "CommonListItemCell.h"
#import "CommonListItem.h"
#import "BaseFunction.h"
#import "CommentItem.h"
#import "CommentItemCell.h"
#import "UserItem.h"
#import "UserItemCell.h"

#import "CommonLoadingItem.h"
#import "CommonLoadingItemCell.h"
// Three20 Additions
#import <Three20Core/NSDateAdditions.h>

@implementation CommonListDataSource


///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)dealloc{
    TT_RELEASE_SAFELY(_commonListDataSourceModel);
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object {
    if ([object isKindOfClass:[CommonListItem class]]) {
        return [CommonListItemCell class];
    } else if ([object isKindOfClass:[CommentItem class]]){
        return [CommentItemCell class];
    }
    else if([object isKindOfClass:[UserItem class]]){
        return [UserItemCell class];
    }
    else if([object isKindOfClass:[CommonLoadingItem class]]){
        return [CommonLoadingItemCell class];
    }
    else {
        return [super tableView:tableView cellClassForObject:object];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL) tableView: (UITableView *)tableView canEditRowAtIndexPath:  (NSIndexPath *)indexPath {
    return NO;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView*)tableView
             cell:(UITableViewCell*)cell willAppearAtIndexPath:(NSIndexPath*)indexPath{

    if (self.listType==ListTypeDicDept||self.listType==ListTypeDicSubject){
        
    }
    else{
        if (([indexPath row]+2)==[self.items count]) {
            [_commonListDataSourceModel load:TTURLRequestCachePolicyDefault more:YES];
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithListType:(ListType)listType {
    if (self = [super init]) {
        [self setListType:listType];
        debug_NSLog(@"initWithListType");
        _commonListDataSourceModel = [[CommonListDataSourceModel alloc] initWithListType:listType];
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////s
- (void)setPostParm:(NSDictionary *)parm{
    debug_NSLog(@"setPostParm");
    [_commonListDataSourceModel setParm:parm];
    [_commonListDataSourceModel setCurrentPage:1];
    [_commonListDataSourceModel load:TTURLRequestCachePolicyNone more:NO];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<TTModel>)model {
    return _commonListDataSourceModel;
}

-(void)itemClick:(id)sender{
    if (self.listType==ListTypeDicDept||self.listType==ListTypeDicSubject){
        CommentItem *item = (CommentItem *)sender;
        if (self.delegate&&[self.delegate respondsToSelector:@selector(itemClick:)]) {
            [self.delegate itemClick:item];
        }
    }
    if (self.listType==ListTypeQueryPersonList) {
        UserItem *item = (UserItem*)sender;
        if (self.delegate&&[self.delegate respondsToSelector:@selector(itemClick:)]) {
            [self.delegate itemClick:item];
        }
    }
}



///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableViewDidLoadModel:(UITableView*)tableView {
    NSMutableArray* items = [[NSMutableArray alloc] init];

    if (self.listType==ListTypeDicDept||self.listType==ListTypeDicSubject) {
        for (NSDictionary *dic in _commonListDataSourceModel.listData) {
            NSString *title = nil;
            if (self.listType==ListTypeDicDept) {
                title = [dic objectForKey:@"deptname"];
            }
            else{
                title = [dic objectForKey:@"subjectname"];
            }
            TTTableTextItem *item = [TTTableTextItem itemWithText:title
                                                         delegate:self
                                                         selector:@selector(itemClick:)];
            [items addObject:item];
        }
    }
    else{

        if (self.listType==ListTypeQueryPersonList) {
            for (UserModel *userModel in _commonListDataSourceModel.listData) {
                
                @try {
                    if ([BaseFunction checkIsNull:userModel.dept]) {
                        
                    }
                    UserItem *item = [UserItem itemWithTitle:userModel.name
                                                     caption:[BaseFunction checkIsNull:userModel.dept]?[NSString stringWithFormat:@"部门:%@",userModel.dept]:@""
                                                        text:[BaseFunction checkIsNull:userModel.specialty]?[NSString stringWithFormat:@"专业:%@",userModel.specialty]:@""
                                                     datestr:nil
                                                    imageURL:userModel.iconUrl
                                                         URL:nil
                                                      userId:userModel.userId
                                                    delegate:self
                                                    selector:@selector(itemClick:)];
                    
                    [items addObject:item];
                }
                @catch (NSException *exception) {
                    continue;
                }
                @finally {
                    
                }

            }
        }
        else{
            for (MessageDataModel* dataModel in _commonListDataSourceModel.listData) {
                TTDPRINT(@"Response text: %@", dataModel.title);

                NSString *url = [NSString stringWithFormat:@"tt://commonDetail/%@",dataModel.contentId];
                NSString *iconUrl = nil;
                if (dataModel.iconUrl&&![dataModel.iconUrl isKindOfClass:[NSNull class]]) {
                    iconUrl = dataModel.iconUrl;
                }
                CommonListItem *item = [CommonListItem itemWithTitle:dataModel.title
                                                             caption:nil
                                                                text:dataModel.messageListMeta
                                                             datestr:nil
                                                            imageURL:iconUrl
                                                                 URL:url
                                                           contentId:dataModel.contentId];


                [items addObject:item];
            }

            if (!_commonListDataSourceModel.finished) {
//                [items addObject:[TTTableMoreButton itemWithText:@"更多…"]];
            }
            else{
                if ([_commonListDataSourceModel.listData count]>0) {

                    if (_commonListDataSourceModel.totalPage!=_commonListDataSourceModel.currentPage) {
                    CommonLoadingItem *loadingItem = [CommonLoadingItem itemWithText:@"正在加载..."];
                    [items addObject:loadingItem];
                    }
                }
            }
            if ([_commonListDataSourceModel.listData count]==0) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(dataLoadError)]) {
                    [self.delegate dataLoadError];
                }
            }
            
        }
    }

    self.items = items;
    TT_RELEASE_SAFELY(items);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)titleForLoading:(BOOL)reloading {
    if (reloading) {
        return @"正在更新数据";
    } else {
        return @"正在更新数据";
    }
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
