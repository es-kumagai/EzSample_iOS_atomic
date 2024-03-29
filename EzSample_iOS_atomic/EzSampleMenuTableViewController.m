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
	[items addObject:[[EzSampleMenuTableItem alloc] initWithTestClassName:@"EzSampleObjectDirectReadWrite" description:@"Test Struct with Property Atomicity with Auto implements by @synthesize, and access ivar directly in the read/write thread."]];
	[items addObject:[[EzSampleMenuTableItem alloc] initWithTestClassName:@"EzSampleObjectCustomPropertiesWithAtomicAndSynchronized" description:@"Test Struct with Property Atomicity in read only property, and method as setter with @synchronized (self)."]];
	[items addObject:[[EzSampleMenuTableItem alloc] initWithTestClassName:@"EzSampleObjectCustomPropertiesWithSynchronized" description:@"Test Struct with Property Atomicity with Custom Implements with @synchronized (self)."]];
	[items addObject:[[EzSampleMenuTableItem alloc] initWithTestClassName:@"EzSampleObjectCustomPropertiesWithIVarNSLock" description:@"Test Struct with Property Atomicity with Custom Implements with common NSLock in ivar."]];
	[items addObject:[[EzSampleMenuTableItem alloc] initWithTestClassName:@"EzSampleObjectCustomPropertiesWithIVarNSLockForEach" description:@"Test Struct with Property Atomicity with Custom Implements with NSLocks for each properties."]];
	[items addObject:[[EzSampleMenuTableItem alloc] initWithTestClassName:@"EzSampleObjectCustomPropertiesWithIVarSynchronizedForEach" description:@"Test Struct with Property Atomicity with Custom Implements with @synchronized (object) for each properties."]];
	[items addObject:[[EzSampleMenuTableItem alloc] initWithTestClassName:@"EzSampleObjectCustomPropertiesWithIVarNSLockForEachWithSleep" description:@"Test Struct with Property Atomicity with Custom Implements with sleep in loop with NSLocks for each properties."]];
	[items addObject:[[EzSampleMenuTableItem alloc] initWithTestClassName:@"EzSampleObjectCustomPropertiesWithIVarSynchronizedForEachWithSleep" description:@"Test Struct with Property Atomicity with Custom Implements with sleep in loop with @synchronized (object) for each properties."]];
	[items addObject:[[EzSampleMenuTableItem alloc] initWithTestClassName:@"EzSampleObjectCustomPropertiesWithIVarSemaphoreForEachWithoutSleep" description:@"Test Struct with Property Atomicity with Custom Implements without sleep in loop with semaphore for each properties."]];
	[items addObject:[[EzSampleMenuTableItem alloc] initWithTestClassName:@"EzSampleObjectCustomPropertiesWithIVarSemaphoreForEachWithSleep" description:@"Test Struct with Property Atomicity with Custom Implements with sleep in loop with semaphore for each properties."]];
	[items addObject:[[EzSampleMenuTableItem alloc] initWithTestClassName:@"EzSampleObjectCustomPropertiesWithIVarSingleSemaphoreWithoutSleep" description:@"Test Struct with Property Atomicity with Custom Implements without sleep in loop with a single semaphore."]];

	[items addObject:[[EzSampleMenuTableItem alloc] initWithTestClassName:@"EzSampleLongLong" description:@"Test Long Long with Property Atomicity with Auto implements by @synthesize."]];
	[items addObject:[[EzSampleMenuTableItem alloc] initWithTestClassName:@"EzSampleLongLongOverrideAtomicGetter" description:@"Test Long Long with Property Atomicity with setter auto implements and getter custom was without lock."]];
	[items addObject:[[EzSampleMenuTableItem alloc] initWithTestClassName:@"EzSampleLong" description:@"Test Long with Property Atomicity with Auto implements by @synthesize."]];
	[items addObject:[[EzSampleMenuTableItem alloc] initWithTestClassName:@"EzSampleClassWithoutCopyInRWLoop" description:@"Test Instance variables of Objective-C Class with Strong Property Atomicity with Auto implements by @synthesize, This case use ivar instance turn."]];
	[items addObject:[[EzSampleMenuTableItem alloc] initWithTestClassName:@"EzSampleClassCustomWithoutCopyInRWLoop" description:@"Test Instance variables of Objective-C Class with Strong Property Atomicity with Custom implements with @synchronized (self), This case use ivar turn."]];
	[items addObject:[[EzSampleMenuTableItem alloc] initWithTestClassName:@"EzSampleClassCustomWithCopyInRWLoop" description:@"Test Instance variables of Objective-C Class with Strong Property Atomicity with Custom implements with @synchronized (self), use ivar once."]];
	[items addObject:[[EzSampleMenuTableItem alloc] initWithTestClassName:@"EzSampleClass" description:@"Test Instance variables of Objective-C Class with Strong Property Atomicity with Auto implements by @synthesize."]];
	[items addObject:[[EzSampleMenuTableItem alloc] initWithTestClassName:@"EzSampleClassNonARC" description:@"Test Instance variables of Objective-C Class with Non-ARC with Strong Property Atomicity with Auto implements by @synthesize."]];
	[items addObject:[[EzSampleMenuTableItem alloc] initWithTestClassName:@"EzSampleClassCopy" description:@"Test Instance variables of Objective-C Class with Copy Property Atomicity with Auto implements by @synthesize."]];
	[items addObject:[[EzSampleMenuTableItem alloc] initWithTestClassName:@"EzSampleClassWeak" description:@"Test Instance variables of Objective-C Class with Weak Property Atomicity with Auto implements by @synthesize."]];
	[items addObject:[[EzSampleMenuTableItem alloc] initWithTestClassName:@"EzSampleClassAssign" description:@"Test Instance variables of Objective-C Class with Non-ARC with Assign Property Atomicity with Auto implements by @synthesize."]];
	[items addObject:[[EzSampleMenuTableItem alloc] initWithTestClassName:@"EzSampleClassAssignCustomWithARC" description:@"Test Instance variables of Objective-C Class with ARC with Assign Property Atomicity with Custom implements with @synchronized (self)."]];
	[items addObject:[[EzSampleMenuTableItem alloc] initWithTestClassName:@"EzSampleClassWeakCustom" description:@"Test Instance variables of Objective-C Class with Weak Property Atomicity with Custom implements with common NSLock."]];

	[items addObject:[[EzSampleMenuTableItem alloc] initWithTestClassName:@"EzSampleObjectCustomPropertiesWithIVarSingleMutexWithoutSleep" description:@"Test Struct with Property Atomicity with Custom Implements without sleep in loop with a single pthread mutex."]];
	[items addObject:[[EzSampleMenuTableItem alloc] initWithTestClassName:@"EzSampleObjectCustomPropertiesWithIVarSingleMutexWithoutSleepWithTryFinally" description:@"Test Struct with Property Atomicity with Custom Implements without sleep in loop with a single pthread mutex and try-finally."]];
	[items addObject:[[EzSampleMenuTableItem alloc] initWithTestClassName:@"EzSampleObjectCustomPropertiesWithIVarNSRecursiveLock" description:@"Test Struct with Property Atomicity with Custom Implements with common NSRecursiveLock in ivar."]];

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

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"Thread-Safe Test";
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
