//
//  MasterTableViewController.m
//  Daily
//
//  Created by Фёдор Морев on 5/10/20.
//  Copyright © 2020 Фёдор Морев. All rights reserved.
//

#import "ArchiveMasterTableViewController.h"
#import "ArchiveDetailsViewController.h"

#import "Daily+CoreDataClass.h"
#import "Constants.h"

@interface ArchiveMasterTableViewController ()
@property (nonatomic, copy) NSArray<Daily *> *dataSource;
@property (nonatomic, strong) NSPersistentContainer *persistentContainer;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation ArchiveMasterTableViewController

- (instancetype)initWithPersistentContainer:(NSPersistentContainer *)persistentContainer {
    self = [super init];
    if (self) {
        _persistentContainer = persistentContainer;
        _dataSource = [self getDataSource];
    }
    return self;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationController.navigationBarHidden = YES;
    
    if (self.persistentContainer == nil) {
        NSException *exception = [[NSException alloc] initWithName:@"wrong-init"
                                                            reason:@"ArchiveMasterTableViewController should be initialized with initWithPersistentContainer method"
                                                          userInfo:nil];
        @throw exception;
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.navigationItem.hidesBackButton = YES;
    
    NSLocale *locale = [NSLocale currentLocale];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = locale;
    dateFormatter.dateFormat = @"EEEE, d MMMM";
    self.dateFormatter = dateFormatter;
    
    self.navigationItem.title = [dateFormatter stringFromDate:[NSDate date]];
    
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"UITableViewCell"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    Daily *daily = self.dataSource[indexPath.row];
    
    cell.textLabel.text = [self.dateFormatter stringFromDate:daily.date];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    ArchiveDetailsViewController *detailsVC = [[ArchiveDetailsViewController alloc] initWithDayData:self.dataSource[indexPath.row]];
    [self.splitViewController showDetailViewController:detailsVC sender:self];
}

#pragma mark - Helpers

- (NSArray<Daily *> *)getDataSource {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
        
    // Today's Daily request (if exists already)
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:CD_ENITY_NAME_DAILY inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSError *errorFetch = nil;
    NSArray *dailies = [context executeFetchRequest:request error:&errorFetch];
    
    if (errorFetch) {
        NSLog(@"Failed to fetch daily! %@", [errorFetch localizedDescription]);
    }
    
    return dailies;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
