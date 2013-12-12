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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc{
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

#pragma mark -
#pragma mark CommonListDataSourceDelegate
-(void)itemClick:(TTTableTextItem *)item{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(itemClick:listType:)]) {
        [self.delegate itemClick:item listType:self.listType];
    }
}
- (void)dataLoadError{
    _flags.isViewInvalid = YES;
    //reload data
    [self.model load:TTURLRequestCachePolicyNetwork more:NO];
}
- (void)dataLoadOver{
    
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createModel {
    if (!self.commonListDataSource) {
        CommonListDataSource *temp = [[CommonListDataSource alloc] initWithListType:self.listType];
        self.commonListDataSource = temp;
        TT_RELEASE_SAFELY(temp);
//        if (self.listType==ListTypeDicDept||self.listType==ListTypeDicSubject||self.listType==ListTypeQueryPersonList) {
            [self.commonListDataSource setDelegate:self];
//        }
        if (self.listType==ListTypeQueryPersonList) {
            if (self.parm) {
                [self.commonListDataSource setPostParm:self.parm];
            }
        }
        self.dataSource = self.commonListDataSource;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
    return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}
-(void)loadView{
    [super loadView];

    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    if (self.listType==ListTypeQueryPersonList) {
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:TTIMAGE(@"bundle://bg_2.png")]];
        [_tableView setBackgroundColor:[UIColor clearColor]];
    }
    [_tableView setBackgroundColor:[UIColor clearColor]];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
