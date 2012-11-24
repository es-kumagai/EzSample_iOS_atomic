//
//  EzSampleObject.m
//  EzSample_iOS_atomic
//
//  Created by 熊谷 友宏 on H.24/11/21.
//  Copyright (c) 平成24年 Tomohiro Kumagai. All rights reserved.
//

#import "EzSampleClassCopy.h"

@interface EzSampleClassCopy ()

@end

@implementation EzSampleClassCopy

@synthesize valueForReplaceByAtomicReadAndNonAtomicWrite = _valueForReplaceByAtomicReadAndNonAtomicWrite;

- (id)init
{
	self = [super init];
	
	if (self)
	{
		_valueForReplaceByAtomic = [[EzSampleObjectClassValue alloc] initWithLabel:EzSampleClassLabelForAtomic];
		_valueForReplaceByNonAtomic = [[EzSampleObjectClassValue alloc] initWithLabel:EzSampleClassLabelForNonAtomic];
		_valueForReplaceByAtomicReadAndNonAtomicWrite = [[EzSampleObjectClassValue alloc] initWithLabel:EzSampleClassLabelForAtomicReadAndNonAtomicWrite];
		
		self.skipLogReplaceByNonAtomic = YES;
		self.skipLogReplaceByAtomicReadAndNonAtomicWrite = YES;
	}
	
	return self;
}

- (void)testForAtomicWithOutput:(BOOL)output outputFormat:(NSString*)outputFormat
{
	@autoreleasepool
	{
		// ローカルスコープを定義します。
		{
			if (output) NSLog(outputFormat, @"Property will read.");
			EzSampleObjectClassValue* value = self.valueForReplaceByAtomic;
			if (output) NSLog(outputFormat, @"Property did read.");
			
			// 同じポインタだと、プロパティ経由で代入したときに retain が省略されるため、複製を取ります。
			value = [value copy];
			
			int number = self.loopCountOfValueForReplaceByAtomic;
			
			value->a = number;
			value->b = number;
			
			if (output) NSLog(outputFormat, @"Property will write.");
			self.valueForReplaceByAtomic = value;
			if (output) NSLog(outputFormat, @"Property did write.");
			
			if (output) NSLog(outputFormat, @"Will End of local scope.");
		}
		
		if (output) NSLog(outputFormat, @"Did End of local scope.");
		if (output) NSLog(outputFormat, @"Will End of autorelease pool.");
	}
	
	if (output) NSLog(outputFormat, @"Did End of autorelease pool.");
}

- (void)testForNonAtomicWithOutput:(BOOL)output outputFormat:(NSString*)outputFormat
{
	@autoreleasepool
	{
		// ローカルスコープを定義します。
		{
			if (output) NSLog(outputFormat, @"Property will read.");
			EzSampleObjectClassValue* value = self.valueForReplaceByNonAtomic;
			if (output) NSLog(outputFormat, @"Property did read.");
			
			// 同じポインタだと、プロパティ経由で代入したときに retain が省略されるため、複製を取ります。
			value = [value copy];
			
			int number = self.loopCountOfValueForReplaceByNonAtomic;
			
			value->a = number;
			value->b = number;
			
			if (output) NSLog(outputFormat, @"Property will write.");
			self.valueForReplaceByNonAtomic = value;
			if (output) NSLog(outputFormat, @"Property did write.");
			
			if (output) NSLog(outputFormat, @"Will End of local scope.");
		}
		
		if (output) NSLog(outputFormat, @"Did End of local scope.");
		if (output) NSLog(outputFormat, @"Will End of autorelease pool.");
	}
	
	if (output) NSLog(outputFormat, @"Did End of autorelease pool.");
}

- (void)testForAtomicReadAndNonAtomicWriteWithOutput:(BOOL)output outputFormat:(NSString*)outputFormat
{
	@autoreleasepool
	{
		// ローカルスコープを定義します。
		{
			if (output) NSLog(outputFormat, @"Property will read.");
			EzSampleObjectClassValue* value = self.valueForReplaceByAtomicReadAndNonAtomicWrite;
			if (output) NSLog(outputFormat, @"Property did read.");
			
			// 同じポインタだと、プロパティ経由で代入したときに retain が省略されるため、複製を取ります。
			value = [value copy];
			
			int number = self.loopCountOfValueForReplaceByAtomicReadAndNonAtomicWrite;
			
			value->a = number;
			value->b = number;
			
			if (output) NSLog(outputFormat, @"Property will write.");
			_valueForReplaceByAtomicReadAndNonAtomicWrite = value;
			if (output) NSLog(outputFormat, @"Property did write.");
			
			if (output) NSLog(outputFormat, @"Will End of local scope.");
		}
		
		if (output) NSLog(outputFormat, @"Did End of local scope.");
		if (output) NSLog(outputFormat, @"Will End of autorelease pool.");
	}
	
	if (output) NSLog(outputFormat, @"Did End of autorelease pool.");
}

- (EzSampleClassResultState)outputValueForAtomic
{
	return [self outputStructState:self.valueForReplaceByAtomic withLabel:EzSampleClassCLabelForAtomic];
}

- (EzSampleClassResultState)outputValueForNonAtomic
{
	return [self outputStructState:self.valueForReplaceByNonAtomic withLabel:EzSampleClassCLabelForNonAtomic];
}

- (EzSampleClassResultState)outputValueForAtomicReadAndNonAtomicWrite
{
	return [self outputStructState:self.valueForReplaceByAtomicReadAndNonAtomicWrite withLabel:EzSampleClassCLabelForAtomicReadAndNonAtomicWrite];
}

@end
