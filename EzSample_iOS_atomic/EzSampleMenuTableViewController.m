//
//  EzSampleMenuTableViewController.m
//  EzSample_iOS_atomic
//
//  Created by 熊谷 友宏 on H.24/11/22.
//  Copyright (c) 平成24年 Tomohiro Kumagai. All rights reserved.
//

#import "EzSampleMenuTableViewController.h"

#import "EzSampleMenuTableItem.h"
#import "EzSampleMenuTableViewCell.h"

@interface EzSampleMenuTableViewController ()

@end

@implementation EzSampleMenuTableViewController
{
	__strong NSArray* _items;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	NSMutableArray* items = [[NSMutableArray alloc] init];
	
	[items addObject:[[EzSampleMenuTableItem alloc] initWithTestClassName:@"EzSampleObject" description:@"Test Struct with Property Atomicity with Auto implements by @synthesize."]];
	[items addObject:[[EzSampleMenuTableItem alloc] initWithTestClassName:@"EzSampleObjectCustomProperties" description:@"Test Struct with Property Atomicity by Custom Implements without @synchronized."]];
	[items addObject:[[EzSampleMenuTableItem alloc] initWithTestClassName:@"EzSampleObjectCustomPropertiesWithSynchronized" description:@"Test Struct with Property Atomicity with Custom Implements with @synchronized (self)."]];
	[items addObject:[[EzSampleMenuTableItem alloc] initWithTestClassName:@"EzSampleObjectCustomPropertiesWithAtomicAndSynchronized" description:@"Test Struct with Property Atomicity in Setter and @synchronized (self) in Getter."]];
	[items addObject:[[EzSampleMenuTableItem alloc] initWithTestClassName:@"EzSampleLongLong" description:@"Test Long Long with Property Atomicity with Auto implements by @synthesize."]];
	[items addObject:[[EzSampleMenuTableItem alloc] initWithTestClassName:@"EzSampleLongLongOverrideAtomicGetter" description:@"Test Long Long with Property Atomicity with setter auto implements and getter custom was without lock."]];
	[items addObject:[[EzSampleMenuTableItem alloc] initWithTestClassName:@"EzSampleLong" description:@"Test Long with Property Atomicity with Auto implements by @synthesize."]];
	[items addObject:[[EzSampleMenuTableItem alloc] initWithTestClassName:@"EzSampleClass" description:@"Test Instance variables of Objective-C Class with Strong Property Atomicity with Auto implements by @synthesize."]];
	[items addObject:[[EzSampleMenuTableItem alloc] initWithTestClassName:@"EzSampleClassCopy" description:@"Test Instance variables of Objective-C Class with Copy Property Atomicity with Auto implements by @synthesize."]];
	
	_items = [items copy];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MenuCell";
    EzSampleMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
	[cell setNumber:indexPath.row + 1];
	[cell setItem:_items[indexPath.row]];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	EzSampleMenuTableViewCell* cell = (EzSampleMenuTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath];
	
	EzPostClear;
	
	EzPostReport([[NSString alloc] initWithFormat:@"%@. %@", cell.numberLabel.text, cell.descriptionLabel.text]);
	EzPostReport(@"");
	
	id<EzSampleObjectProtocol> instance = [[NSClassFromString(cell.testClassNameLabel.text) alloc] init];
	
	[self.delegate EzSampleMenuTableViewController:self testButtonForTestInstancePushed:instance];
}

@end
