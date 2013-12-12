//
//  CommonDetailDataSourceModel.m
//  UPDIS
//
//  Created by Melvin on 13-7-3.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import "CommonDetailDataSourceModel.h"
#import "MURLJSONResponse.h"
#import "CommentModel.h"
#import "BaseFunction.h"


@implementation CommonDetailDataSourceModel

///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)dealloc{
    TT_RELEASE_SAFELY(_pageData);
    TT_RELEASE_SAFELY(_listData);
    TT_RELEASE_SAFELY(_contentId);
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithConentId:(NSString *)contentId loadList:(BOOL)loadList{
    if (self = [super init]) {
        [self setContentId:contentId];
        [self setLoadList:loadList];
        _pageData = [[MessageDataModel alloc] init];
        [self setCurrentPage:1];
        _listData = [[NSMutableArray array] retain];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
    if (!self.isLoading) {
        if (self.loadList) {
            if (more) {
                if (_currentPage==_totalPage) {
                    _finished = YES;
                    return;
                }
                _currentPage++;
            }
            else {
                _currentPage = 1;
                _finished = NO;
                [_listData removeAllObjects];
            }
        }
        NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:@"userid"];
        NSString *url = nil;
        if (self.loadList) {
            url = [NSString stringWithFormat:INTERFACE_FETCH_COMMENT,MAIN_DOMAIN,self.contentId,self.currentPage];
        }
        else{
            url = [NSString stringWithFormat:INTERFACE_FETCH_DETAIL,MAIN_DOMAIN,self.contentId,userId];
        }
        TTURLRequest* request = [TTURLRequest
                                 requestWithURL: url
                                 delegate: self];
        request.cachePolicy = TTURLRequestCachePolicyNone;
        request.cacheExpirationAge = TT_CACHE_EXPIRATION_AGE_NEVER;
        NSString *cookie = [NSString stringWithFormat:@"JSESSIONID=%@; Path=/rest/; HttpOnly",[[NSUserDefaults standardUserDefaults] valueForKey:@"cookies"]];
        [request setValue:cookie forHTTPHeaderField:@"Cookie"];
        MURLJSONResponse* response = [[MURLJSONResponse alloc] init];
        request.response = response;
        TT_RELEASE_SAFELY(response);
        [request send];
    }
}

#pragma mark -
#pragma mark ReLoginAssisantDelegate
- (void) relogin:(BOOL)success{
    if (success) {
        
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidFinishLoad:(TTURLRequest*)request {
    MURLJSONResponse* response = request.response;
    TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);

    NSDictionary* feed = response.rootObject;
    if ([[feed objectForKey:@"sessionTimeout"] integerValue]) {
        //超时
        [[ReLoginAssisant sharedManager] reloginUser];
        [super requestDidFinishLoad:request];
        return;
    }
    if (self.loadList) {
        TTDASSERT([[feed objectForKey:@"comments"] isKindOfClass:[NSArray class]]);
        [self setTotalPage:[[feed objectForKey:@"total_page"] integerValue]];
        NSArray* entries = [feed objectForKey:@"comments"];

        NSMutableArray* listData = [NSMutableArray arrayWithCapacity:[entries count]];
        for (NSDictionary* comment in entries) {
            CommentModel *commentModel = [[CommentModel alloc] init];
            commentModel.author = [comment objectForKey:@"author"];
            commentModel.commentId = [comment objectForKey:@"commentId"];
            commentModel.content = [comment objectForKey:@"content"];
            commentModel.datetime = [comment objectForKey:@"datetime"];
            commentModel.iconUrl = [comment objectForKey:@"iconUrl"];
            commentModel.isAnonymous = [[comment objectForKey:@"isAnonymous"] integerValue];
            [listData addObject:commentModel];
            TT_RELEASE_SAFELY(commentModel);
        }
        _finished = YES;
        [_listData addObjectsFromArray: listData];
    }
    else{
        TTDASSERT([[feed objectForKey:@"data"] isKindOfClass:[NSDictionary class]]);
        NSDictionary *entry = [[feed objectForKey:@"data"] objectForKey:@"content"];
        _pageData.author = [entry objectForKey:@"author"];
        _pageData.category = [entry objectForKey:@"category"];
        _pageData.comments = [entry objectForKey:@"comments"];

        if ([BaseFunction checkIsNull:[entry objectForKey:@"content"]]) {
            _pageData.content = [entry objectForKey:@"content"];
        }
        else{
            _pageData.content = @"";
        }
        
//        _pageData.content = [entry objectForKey:@"content"];
        _pageData.contentId = [entry objectForKey:@"contentId"];
        _pageData.datetime = [entry objectForKey:@"datetime"];
        _pageData.dept = [entry objectForKey:@"dept"];
        _pageData.iconUrl = [entry objectForKey:@"iconUrl"];
        _pageData.messageDetailMeta = [entry objectForKey:@"messageDetailMeta"];
        _pageData.messageListMeta = [entry objectForKey:@"messageListMeta"];
        _pageData.readCount = [entry objectForKey:@"readCount"];
        _pageData.subtitle = [entry objectForKey:@"subtitle"];
        _pageData.title = [entry objectForKey:@"title"];

        NSArray *comments = [[feed objectForKey:@"data"] objectForKey:@"comment"];
        NSMutableArray* commentsArray = [NSMutableArray arrayWithCapacity:[comments count]];
        if (comments) {
            for (NSDictionary *comment in comments) {
                CommentModel *commentModel = [[CommentModel alloc] init];
                commentModel.author = [comment objectForKey:@"author"];
                commentModel.commentId = [comment objectForKey:@"commentId"];
                commentModel.content = [comment objectForKey:@"content"];
                commentModel.datetime = [comment objectForKey:@"datetime"];
                commentModel.iconUrl = [comment objectForKey:@"iconUrl"];
                commentModel.isAnonymous = [[comment objectForKey:@"isAnonymous"] integerValue];
                [commentsArray addObject:commentModel];
                TT_RELEASE_SAFELY(commentModel);
            }
        }
        _finished = YES;
        _pageData.comments = [NSArray arrayWithArray:commentsArray];
    }
    [super requestDidFinishLoad:request];
}

@end
