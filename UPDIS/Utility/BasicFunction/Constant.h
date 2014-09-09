



#define IN_TEST_ENVIRONMENT 0

#if IN_TEST_ENVIRONMENT == 0
    #define MAIN_DOMAIN             @"http://phone.updis.cn:8010/rest" 
#elif IN_TEST_ENVIRONMENT == 1
    #define MAIN_DOMAIN             @"http://phone.updis.cn:8081/rest"
#else
    #define MAIN_DOMAIN             @"http://172.30.6.59:8080"
#endif

//用户登录
#define USER_LOGIN                  @"/users/login"
//用户登出
#define USER_LOGOUT                 @"%@/users/logout"
//验证用户设备
#define USER_REGPHONE               @"/users/deviceVerify"

//用户查询数据字典接口
#define INTERFACE_FETCH_DIC_DATA    @"%@/users/fetchDictData"
//人员查询数据列表
#define INTERFACE_FETCH_USER_LIST   @"%@/users/queryPerson?flag=%d&currentPage=%d"
//人员查询数据列表
#define INTERFACE_FETCH_USER_DETAIL @"%@/users/queryPerson?flag=2&userId=%d"

//列表数据接口
#define INTERFACE_FETCH_DATA_LIST   @"%@/messages/fetchListData?categoryType=%d&currentPage=%d"
//详情页数据接口
#define INTERFACE_FETCH_DETAIL      @"%@/messages/fetchDetail?contentId=%@&userid=%@"
//评论列表
#define INTERFACE_FETCH_COMMENT     @"%@/messages/fetchComment?messageId=%@&currentPage=%d"
//提交评论
#define INTERFACE_POST_COMMENT      @"%@/messages/postComment?contentId=%@&comment=%@&isAnonymous=%@"

//发布消息
#define INTERFACE_POST_MESSAGE      @"%@/messages/postMessage?categoryType=%d&title=%@&content=%@&publishDept=%@&SMSContent=%@"

// 待处理项目列表
#define PENDING_PROJECTS            @"/project/getPendingProjects"
// 任务下达单
#define URL_GET_ACTVIE_TASK         @"%@/project/getActiveTask?id=%d"
// 所长审批
#define URL_REVIEW_ACTIVE_TASK      @"%@/project/reviewActiveTask?id=%d"
// 负责人签字
#define URL_PROJECT_LEAD_REVIEW_ACTIVE_TASK @"%@/project/projectLeadReviewActiveTask?id=%d"
#define URL_PROJECT_LEAD_REJECT_ACTIVE_TASK @"%@/project/projectLeadRejectActiveTask"
// 总师审批
#define URL_ZONG_SHI_REVIEW_ACTIVE_TASK @"%@/project/zongShiReviewActiveTask"
#define URL_ZONG_SHI_REJECT_ACTIVE_TASK @"%@/project/zongShiRejectActiveTask?id=%d"
// projectTypeList
#define URL_ZONG_SHI_REVIEW_PROJECT_TYPE_LIST @"%@/project/projectTypeList"
// categoryTypeList
#define URL_ZONG_SHI_REVIEW_CATEGORY_TYPE_LIST @"%@/project/categoryList?projectTypeId=%d"
// chiefEngineerList
#define URL_ZONG_SHI_REVIEW_CHIEF_ENGINEER_LIST @"%@/project/chiefEngineerList"
// 搜索负责人列表
#define URL_SEARCH_PROJECT_LEADER @"%@/project/searchProjectLeader"

//获取关于
#define INTERFACE_FETCH_ABOUT       @"%@/settings/about"
#define INTERFACE_FETCH_VERSION     @"%@/settings/checkVersion?clientType=%d"


#define INTERFACE_SAVE_PUSH         @"%@/settings/push?udid=%@&messageType=%@&pushSwitch=%d"

#define FETCH_TIME_OUT              30

#define UPDATE_URL                  @"itms-services://?action=download-manifest&url=%@"

//==============================目录函数宏定义==========================
#define APP_DOC_DIR     NSTemporaryDirectory()

#define APP_DIR         [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]


//////////////////////////////////////////////////////////////////////////////////////////////////
//cache file

#define USER_LOGIN_CACHE_FILE       [NSString stringWithFormat:@"%@/%@",APP_DOC_DIR,@"USER_LOGIN_CACHE_FILE"]

#define USER_REG_PHONE_CACHE_FILE   [NSString stringWithFormat:@"%@/%@",APP_DOC_DIR,@"USER_REG_PHONE_CACHE_FILE"]


#define iPhone5  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//==============================服务器端一些接口的通用参数====================================
#define SUCCESS_KEY @"success"

