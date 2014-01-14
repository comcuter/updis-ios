//
//  CommonListViewController.m
//  UPDIS
//
//  Created by Melvin on 13-7-1.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import "CommonListViewController.h"


@interface CommonListViewController ()

@end

@implementation CommonListViewController

- (void)dealloc
{
    [_commonListDataSource setDelegate:nil];
    TT_RELEASE_SAFELY(_commonListDataSource);
    TT_RELEASE_SAFELY(_parm);
    [super dealloc];
}

- (id)initWithListType:(ListType)listType
{
    self = [super init];
    if (self) {
        self.variableHeightRows = YES;
        self.tableViewStyle = UITableViewStylePlain;
        [self setListType:listType];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    if (self.listType == ListTypeQueryPersonList) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:TTIMAGE(@"bundle://bg_2.png")]];
        [_tableView setBackgroundColor:[UIColor clearColor]];
    }
    [_tableView setBackgroundColor:[UIColor clearColor]];
}

- (void)createModel
{
    if (!self.commonListDataSource) {
        CommonListDataSource *temp = [[CommonListDataSource alloc] initWithListType:self.listType];
        self.commonListDataSource = temp;
        TT_RELEASE_SAFELY(temp);
        [self.commonListDataSource setDelegate:self];
        if (self.listType == ListTypeQueryPersonList) {
            if (self.parm) {
                [self.commonListDataSource setPostParm:self.parm];
            }
        }
        self.dataSource = self.commonListDataSource;
    }
}

- (id<UITableViewDelegate>)createDelegate
{
    return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}

-(void)itemClick:(TTTableTextItem *)item
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(itemClick:listType:)]) {
        [self.delegate itemClick:item listType:self.listType];
    }
}
- (void)dataLoadError
{
    _flags.isViewInvalid = YES;
    [self.model load:TTURLRequestCachePolicyNetwork more:NO];
}

@end
