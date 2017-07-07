//
//  DBManager.m
//  Pop Daily
//
//  Created by qianfeng on 15/7/6.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "DBManager.h"
#import "FMDatabase.h"

@implementation DBManager
{
    FMDatabase *_dataBase;
}

+ (DBManager *)sharedInstance
{
    static DBManager *manager = nil;
    @synchronized(self){
        if (nil == manager) {
            manager = [[DBManager alloc] init];
        }
    }
    return manager;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        [self createDataBase];
    }
    return self;
}

- (void)createDataBase
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/searchModle.db"];
    
    _dataBase = [[FMDatabase alloc] initWithPath:path];
    
    BOOL ret = [_dataBase open];
    if (!ret) {
        MyLog(@"打开数据库失败");
    }else{
        
        NSString *createSpl = @"create table if not exists searchModle(modelId integer primary key autoincrement,title varchar(255))";
        BOOL flag = [_dataBase executeUpdate:createSpl];
        if (!flag) {
            MyLog(@"创建表失败:%@",_dataBase.lastErrorMessage);
        }
    }
}

- (void)addSearchtModel:(SearchModel *)model
{
    NSString *insertSql = @"insert into searchModle (title) values (?)";
    BOOL ret = [_dataBase executeUpdate:insertSql,model.searchTitle];
    if (!ret) {
        MyLog(@"添加失败%@",_dataBase.lastErrorMessage);
    }
}

- (NSArray *)searchAllModel
{
    NSString *selectSql = @"select * from searchModle";
//    执行查询操作
    FMResultSet *rs = [_dataBase executeQuery:selectSql];
    
    NSMutableArray *array = [NSMutableArray array];
    while ([rs next]) {
        
        SearchModel *model = [[SearchModel alloc] init];
        model.searchTitle = [rs stringForColumn:@"title"];
        
        [array addObject:model];
    }
    return array;
}

- (void)deleteModel:(SearchModel *)model
{
    NSString *deleteSql = @"delete from searchModle where title = ?";
    
    BOOL ret = [_dataBase executeUpdate:deleteSql,model.searchTitle];
    if (!ret) {
        MyLog(@"删除失败:%@",_dataBase.lastErrorMessage);
    }
}

//判断一条记录是否存在
- (BOOL)isModelExists:(SearchModel *)model
{
    //sql
    NSString *sql = @"select * from searchModle where title=?";
    
    FMResultSet *rs = [_dataBase executeQuery:sql,model.searchTitle];
    
    if ([rs next]) {
        return YES;
    }
    return NO;
}

- (void)deleteAllModel
{
    NSString *deleteSql = @"delete from searchModle";
    
    BOOL ret = [_dataBase executeUpdate:deleteSql];
    if (!ret) {
        MyLog(@"删除失败:%@",_dataBase.lastErrorMessage);
    }
}

@end




