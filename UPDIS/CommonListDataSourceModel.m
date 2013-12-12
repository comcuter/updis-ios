//
//  CommonListDataSourceModel.m
//  UPDIS
//
//  Created by Melvin on 13-7-1.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import "CommonListDataSourceModel.h"
#import "MURLJSONResponse.h"
#import "MessageDataModel.h"
#import "UserModel.h"
#import "BaseFunction.h"

@implementation CommonListDataSourceModel

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithListType:(ListType)listType {
    if (self = [super init]) {
        [self setListType:listType];
        [self setCurrentPage:1];
        _listData = [[NSMutableArray array] retain];
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) dealloc {
    TT_RELEASE_SAFELY(_pageData);
    TT_RELEASE_SAFELY(_listData);
    TT_RELEASE_SAFELY(_parm);
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
    if (!self.isLoading) {
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
        NSString *url = nil;
        if (self.listType==ListTypeDicDept||self.listType==ListTypeDicSubject) {
            url = [NSString stringWithFormat:INTERFACE_FETCH_DIC_DATA,MAIN_DOMAIN];
        }
        else{
            if (self.listType==ListTypeQueryPersonList) {
                url = [NSString stringWithFormat:INTERFACE_FETCH_USER_LIST,MAIN_DOMAIN,1,self.currentPage];
                if (self.parm) {
                    if ([self.parm objectForKey:@"userName"]) {
                        url = [url stringByAppendingFormat:@"&userName=%@",[[self.parm objectForKey:@"userName"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }
                    if ([self.parm objectForKey:@"deptName"]) {
                        url = [url stringByAppendingFormat:@"&deptName=%@",[[self.parm objectForKey:@"deptName"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }
                    if ([self.parm objectForKey:@"specialtyName"]) {
                        url = [url stringByAppendingFormat:@"&specialtyName=%@",[[self.parm objectForKey:@"specialtyName"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    }
                }

            }
            else{
                url = [NSString stringWithFormat:INTERFACE_FETCH_DATA_LIST,MAIN_DOMAIN,self.listType,self.currentPage];
            }
        }


        debug_NSLog(@"url:%@",url);
        TTURLRequest* request = [TTURLRequest
                                 requestWithURL: url
                                 delegate: self];
        request.cachePolicy = cachePolicy;
        request.cacheExpirationAge = (60*2);//2分钟
        NSString *cookie = [NSString stringWithFormat:@"JSESSIONID=%@; Path=/rest/; HttpOnly",[[NSUserDefaults standardUserDefaults] valueForKey:@"cookies"]];
        [request setValue:cookie forHTTPHeaderField:@"Cookie"];
        TTDPRINT(@"cookie:%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"cookies"]);
        MURLJSONResponse* response = [[MURLJSONResponse alloc] init];
        request.response = response;
        TT_RELEASE_SAFELY(response);
        [request send];
    }
}

-(void)relogin:(BOOL)success{
    if (success) {
        [self load:TTURLRequestCachePolicyNetwork more:NO];
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


    if (self.listType==ListTypeDicDept||self.listType==ListTypeDicSubject) {
        NSDictionary* data = [feed objectForKey:@"data"];
        NSArray *entries = nil;
        if (self.listType==ListTypeDicDept) {
            entries = [data objectForKey:@"dept"];
        }
        else{
            entries = [data objectForKey:@"subject"];
        }
        for (NSDictionary* entry in entries) {
            [_listData addObject:entry];
        }

    }
    else{
        [self setTotalPage:[[feed objectForKey:@"total_page"] integerValue]];
        NSArray* entries = [feed objectForKey:@"data"];

        NSMutableArray* listData = [NSMutableArray arrayWithCapacity:[entries count]];


        if (self.listType==ListTypeQueryPersonList) {

            for (NSDictionary* entry in entries) {
                UserModel *userModel = [[UserModel alloc] init];
                userModel.userId = [entry objectForKey:@"userId"];
                userModel.name = [entry objectForKey:@"name"];
                if ([BaseFunction checkIsNull:[entry objectForKey:@"dept"]]) {
                    userModel.dept = [entry objectForKey:@"dept"];
                }
                else{
                    userModel.dept = @"";
                }
                userModel.birthday = [entry objectForKey:@"birthday"];
                userModel.gender = [entry objectForKey:@"gender"];
                userModel.specialty = [entry objectForKey:@"specialty"];
                userModel.educational = [entry objectForKey:@"educational"];
                userModel.degree = [entry objectForKey:@"degree"];
                userModel.graduationDate = [entry objectForKey:@"graduationDate"];
                userModel.entryDate = [entry objectForKey:@"entryDate"];
                userModel.rank = [entry objectForKey:@"rank"];
                userModel.titles = [entry objectForKey:@"titles"];
                
                if ([BaseFunction checkIsNull:[entry objectForKey:@"iconUrl"]]) {
                    userModel.iconUrl = [entry objectForKey:@"iconUrl"];
                }
                else{
                    userModel.iconUrl = @"bundle://default_user_icon.png";
                }
                
                userModel.resume = [entry objectForKey:@"resume"];
                userModel.mobilePhone = [entry objectForKey:@"mobilePhone"];
                userModel.officePhone = [entry objectForKey:@"officePhone"];
                userModel.homeNum = [entry objectForKey:@"homeNum"];
                userModel.mail = [entry objectForKey:@"mail"];
                [listData addObject:userModel];
                TT_RELEASE_SAFELY(userModel);
            }
        }
        else{
            for (NSDictionary* entry in entries) {
                MessageDataModel *dataModel = [[MessageDataModel alloc] init];
                dataModel.author = [entry objectForKey:@"author"];
                dataModel.category = [entry objectForKey:@"category"];
                dataModel.comments = [entry objectForKey:@"comments"];
                dataModel.content = [entry objectForKey:@"content"];
                dataModel.contentId = [entry objectForKey:@"contentId"];
                dataModel.datetime = [entry objectForKey:@"datetime"];
                dataModel.dept = [entry objectForKey:@"dept"];
                dataModel.iconUrl = [entry objectForKey:@"iconUrl"];
                dataModel.messageDetailMeta = [entry objectForKey:@"messageDetailMeta"];
                dataModel.messageListMeta = [entry objectForKey:@"messageListMeta"];
                dataModel.readCount = [entry objectForKey:@"readCount"];
                dataModel.subtitle = [entry objectForKey:@"subtitle"];
                dataModel.title = [entry objectForKey:@"title"];
                [listData addObject:dataModel];
                TT_RELEASE_SAFELY(dataModel);
            }
        }
        [_listData addObjectsFromArray: listData];
    }
    
    _finished = YES;
    
    [super requestDidFinishLoad:request];
}

@end
