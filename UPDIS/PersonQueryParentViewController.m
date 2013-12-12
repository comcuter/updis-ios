//
//  PersonQueryParentViewController.m
//  UPDIS
//
//  Created by Melvin on 13-7-12.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import "PersonQueryParentViewController.h"
#import "CoreAnimationEffect.h"
#import "CommentItem.h"
#import "UserItem.h"

@interface PersonQueryParentViewController ()

@end

@implementation PersonQueryParentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithType:(QueryType)queryType
{
    self = [super init];
    if (self) {
        // Custom initialization
        [self setQueryType:queryType];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (!self.personQueryViewController) {
        PersonQueryViewController *temp = [[PersonQueryViewController alloc] initWithNibName:@"PersonQueryViewController" bundle:nil withType:self.queryType];
        self.personQueryViewController = temp;
        TT_RELEASE_SAFELY(temp);
        [self addChildViewController:self.personQueryViewController];
    }
    
 
    [self.view addSubview:self.personQueryViewController.view];


    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 6.0) {
    [self.personQueryViewController.btnQuery addTarget:self action:@selector(queryPerson:) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        UITapGestureRecognizer *click1 = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(queryPerson:)];

        click1.numberOfTouchesRequired = 1;
        [self.personQueryViewController.btnQuery addGestureRecognizer:click1];
        TT_RELEASE_SAFELY(click1);
    }
    currentViewController = self.personQueryViewController;
}

-(void)queryPerson:(id)sender{

    if (!self.personListViewController) {
        CommonListViewController *temp = [[CommonListViewController alloc] initWithListType:ListTypeQueryPersonList];
        self.personListViewController = temp;
        TT_RELEASE_SAFELY(temp);
        [self.personListViewController setDelegate:self];
        [[self.personListViewController view] setFrame:self.view.frame];
        [self addChildViewController:self.personListViewController];
    }


    [self.personQueryViewController.txtUserName resignFirstResponder];
    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
    NSLog(@"bounds %@",NSStringFromCGRect(self.view.bounds));
    
    NSString *userName = [[self.personQueryViewController txtUserName] text];
    if ([userName isEqualToString:@""]) {
        userName = nil;
    }
    NSString *deptName = [[self.personQueryViewController btnShowDept] titleForState:UIControlStateNormal];
    NSString *subjectName = [[self.personQueryViewController btnShowSubject] titleForState:UIControlStateNormal];

    //deptName,userName,specialtyName

    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    if (userName) {
        [parmDic setObject:userName forKey:@"userName"];
    }
    if (deptName) {
        [parmDic setObject:deptName forKey:@"deptName"];
    }
    if (subjectName) {
        [parmDic setObject:subjectName forKey:@"specialtyName"];
    }

    debug_NSLog(@"queryPerson:%@",parmDic);

    if ([self.personListViewController commonListDataSource]) {
        [[self.personListViewController commonListDataSource] setPostParm:parmDic];
    }
    else{
        [self.personListViewController setParm:parmDic];
    }
    [self transitionFromViewController:currentViewController toViewController:self.personListViewController duration:1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
    }  completion:^(BOOL finished) {
        if (finished) {
            currentViewController = self.personListViewController;
            showList = YES;
        }else{
            
        }
    }];
}
-(void)dealloc{
    [_personListViewController setDelegate:nil];
    TT_RELEASE_SAFELY(_personListViewController);
    TT_RELEASE_SAFELY(_personQueryViewController);
    TT_RELEASE_SAFELY(_webContentViewController);
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark CommonListViewControllerDelegate
-(void)itemClick:(TTTableTextItem *)item listType:(ListType)listType{
    if ([item isKindOfClass:[UserItem class ]]) {
        NSString *fileName = @"member.htm";
        if (self.queryType==QueryTypeContacts) {
            fileName = @"contacts.htm";
        }
        UserItem *commentItem = (UserItem *)item;
        debug_NSLog(@"get user id:%@",commentItem.userId);
        if (!self.webContentViewController) {
            WebContentViewController *temp = [[WebContentViewController alloc] initWithFileName:fileName
                                                                                       pageData:[NSDictionary dictionaryWithObjectsAndKeys:commentItem.userId,@"userId", nil]];

            
            self.webContentViewController = temp;
            TT_RELEASE_SAFELY(temp);

            [self.webContentViewController setDelegate:self];
            [self addChildViewController:self.webContentViewController];
        }
        else{
            [self.webContentViewController setPageData:[NSDictionary dictionaryWithObjectsAndKeys:commentItem.userId,@"userId", nil]];
            [self.webContentViewController setFileName:fileName];
        }


        if (showList) {
            [self transitionFromViewController:currentViewController toViewController:self.webContentViewController duration:0.35 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{

            }  completion:^(BOOL finished) {
                if (finished) {
                    currentViewController = self.webContentViewController;
                    showList = NO;
                    showDetail = YES;
                }else{

                }
            }];
        }
    }
}

#pragma mark -
#pragma mark 返回查询form
-(void)clickCurrentTab{
    if (showList) {
        [self transitionFromViewController:currentViewController toViewController:self.personQueryViewController duration:0.35 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            
        }  completion:^(BOOL finished) {
            if (finished) {
                currentViewController = self.personQueryViewController;
                showList = NO;
            }else{

            }
        }];
    }
    else{


        [[self.personQueryViewController btnShowDept] setTitle:nil forState:UIControlStateNormal];
        [[self.personQueryViewController btnShowDept] setTitle:nil forState:UIControlStateHighlighted];
        [[self.personQueryViewController btnShowDept] setTitle:nil forState:UIControlStateSelected];


        [[self.personQueryViewController btnShowSubject] setTitle:nil forState:UIControlStateNormal];
        [[self.personQueryViewController btnShowSubject] setTitle:nil forState:UIControlStateHighlighted];
        [[self.personQueryViewController btnShowSubject] setTitle:nil forState:UIControlStateSelected];

        
    }
}

#pragma mark -
#pragma mark WebContentViewControllerDelegate
-(void)back2ListView{
    if (showDetail) {
        [self transitionFromViewController:currentViewController toViewController:self.personListViewController duration:0.35 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{

        }  completion:^(BOOL finished) {
            if (finished) {
                currentViewController = self.personListViewController;
                showList = YES;
                showDetail = NO;
            }else{

            }
        }];
    }
}

@end
