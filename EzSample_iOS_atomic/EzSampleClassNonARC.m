//
//  EzSampleObject.m
//  EzSample_iOS_atomic
//
//  Created by 熊谷 友宏 on H.24/11/21.
//  Copyright (c) 平成24年 Tomohiro Kumagai. All rights reserved.
//

#import "EzSampleClassNonARC.h"

#define EzSampleClassNonARCLoggingCount 10

@interface EzSampleClassNonARC ()

- (void)EzThreadLoopForValueForReplaceByNonAtomic:(id)object;
- (void)EzThreadLoopForValueForReplaceByAtomic:(id)object;
- (void)EzThreadLoopForValueForReplaceByAtomicReadAndNonAtomicWrite:(id)object;

@end

@implementation EzSampleClassNonARC

- (id)init
{
	self = [super init];
	
	if (self)
	{
		_valueForReplaceByAtomic = [[[EzSampleObjectClassValue alloc] initWithLabel:@"ATOMIC"] retain];
		_valueForReplaceByNonAtomic = [[[EzSampleObjectClassValue alloc] initWithLabel:@"NONATOMIC"] retain];
		_valueForReplaceByAtomicReadAndNonAtomicWrite = [[[EzSampleObjectClassValue alloc] initWithLabel:@"(R)ATOMIC-(W)NONATOMIC"] retain];
	}
	
	return self;
}

- (BOOL)outputStructState:(EzSampleObjectClassValue*)value withLabel:(NSString*)label
{
	BOOL threadSafe;
	
	if (value->valid == 0)
	{
		threadSafe = (value->a == value->b);
		EzPostLog(@"%-15s : %2s (%d,%d)", label.UTF8String, (threadSafe ? "OK" : "NG"), value->a, value->b);
	}
	else
	{
		threadSafe = NO;
		EzPostLog(@"%-15s : DEALLOC", label.UTF8String);
	}
	
	return threadSafe;
}

- (void)outputLoopCount
{
	NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
	
	formatter.numberStyle = NSNumberFormatterDecimalStyle;
	formatter.groupingSeparator = @",";
	formatter.groupingSize = 3;
	
	
	if (self.errorMessageForReplaceByAtomic)
	{
		EzPostReport(@"ATOMIC : %@", self.errorMessageForReplaceByAtomic);
	}
	else
	{
		EzPostReport(@"ATOMIC          : %12s times (%@)", [formatter stringFromNumber:[NSNumber numberWithInt:self.loopCountOfValueForReplaceByAtomic]].UTF8String, (self.inconsistentReplaceByAtomic ? @"UNSAFE" : @"SAFE ?"));
	}
	
	if (self.errorMessageForReplaceByNonAtomic)
	{
		EzPostReport(@"NONATOMIC : %@", self.errorMessageForReplaceByNonAtomic);
	}
	else
	{
		EzPostReport(@"NONATOMIC       : %12s times (%@)", [formatter stringFromNumber:[NSNumber numberWithInt:self.loopCountOfValueForReplaceByNonAtomic]].UTF8String, (self.inconsistentReplaceByNonAtomic ? @"UNSAFE" : @"SAFE ?"));
	}
	
	if (self.errorMessageForReplaceByAtomicReadAndNonAtomicWrite)
	{
		EzPostReport(@"R:ATOM-W:DIRECT : %@", self.errorMessageForReplaceByAtomicReadAndNonAtomicWrite);
	}
	else
	{
		EzPostReport(@"R:ATOM-W:DIRECT : %12s times (%@)", [formatter stringFromNumber:[NSNumber numberWithInt:self.loopCountOfValueForReplaceByAtomicReadAndNonAtomicWrite]].UTF8String, (self.inconsistentReplaceByAtomicReadAndNonAtomicWrite ? @"UNSAFE" : @"SAFE ?"));
	}
	
	[formatter release];
}

- (void)start
{
	_threadForValueForReplaceByNonAtomic = [[[NSThread alloc] initWithTarget:self selector:@selector(EzThreadLoopForValueForReplaceByNonAtomic:) object:nil] retain];
	_threadForValueForReplaceByAtomic = [[[NSThread alloc] initWithTarget:self selector:@selector(EzThreadLoopForValueForReplaceByAtomic:) object:nil] retain];
	_threadForValueForReplaceByAtomicReadAndNonAtomicWrite = [[[NSThread alloc] initWithTarget:self selector:@selector(EzThreadLoopForValueForReplaceByAtomicReadAndNonAtomicWrite:) object:nil] retain];
	
	[EzSampleObjectClassValue setLogTargetThread:_threadForValueForReplaceByAtomic];
	
//	[_threadForValueForReplaceByNonAtomic start];
	[_threadForValueForReplaceByAtomic start];
	[_threadForValueForReplaceByAtomicReadAndNonAtomicWrite start];
	
	self.errorMessageForReplaceByNonAtomic = @"Cannot test because hungup causes EXC_BAD_ACCESS.";
}

- (void)stop
{
	[_threadForValueForReplaceByNonAtomic cancel];
	[_threadForValueForReplaceByAtomic cancel];
	[_threadForValueForReplaceByAtomicReadAndNonAtomicWrite cancel];
}

- (void)outputWithLabel:(NSString *)label
{
	NSString* labelForAtomic = [[[NSString alloc] initWithFormat:@"%@ATOMIC", label] retain];
	NSString* labelForNonAtomic = [[[NSString alloc] initWithFormat:@"%@NONATOMIC", label] retain];
	NSString* labelForAtomicReadAndNonAtomicWrite = [[[NSString alloc] initWithFormat:@"%@R:ATOM-W:DIRECT", label] retain];
	
	@try
	{
		EzPostLog(@"");
		
		if (_threadForValueForReplaceByAtomic.isExecuting)
		{
			if (![self outputStructState:self.valueForReplaceByAtomic withLabel:labelForAtomic]) self.inconsistentReplaceByAtomic = YES;
		}
		else
		{
			EzPostLog(@"%-15s : SKIP", labelForAtomic.UTF8String);
		}
		
		if (_threadForValueForReplaceByNonAtomic.isExecuting)
		{
			if (![self outputStructState:self.valueForReplaceByNonAtomic withLabel:labelForNonAtomic]) self.inconsistentReplaceByNonAtomic = YES;
		}
		else
		{
			EzPostLog(@"%-15s : SKIP", labelForNonAtomic.UTF8String);
		}
		
		if (_threadForValueForReplaceByAtomicReadAndNonAtomicWrite.isExecuting)
		{
			if (![self outputStructState:self.valueForReplaceByAtomicReadAndNonAtomicWrite withLabel:labelForAtomicReadAndNonAtomicWrite]) self.inconsistentReplaceByAtomicReadAndNonAtomicWrite = YES;
		}
		else
		{
			EzPostLog(@"%-15s : SKIP", labelForAtomicReadAndNonAtomicWrite.UTF8String);
		}
	}
	@finally
	{
		[labelForAtomic release];
		[labelForNonAtomic release];
		[labelForAtomicReadAndNonAtomicWrite release];
	}
}

- (void)EzThreadLoopForValueForReplaceByNonAtomic:(id)object
{
	NSThread* currentThread = [NSThread currentThread];
	
	@try
	{
		while (!currentThread.isCancelled)
		{
			_loopCountOfValueForReplaceByNonAtomic++;
			
			// ログ出力すべきタイミングかを調べます。
			if (_loggingCountForReplaceByNonAtomic == 0)
			{
				if ([EzSampleObjectClassValue logTargetThread] == currentThread)
				{
					_loggingCountForReplaceByNonAtomic = 1;
				}
			}
			else
			{
				_loggingCountForReplaceByNonAtomic++;
			}
			
			BOOL logging = (_loggingCountForReplaceByNonAtomic > 0 && _loggingCountForReplaceByNonAtomic <= EzSampleClassNonARCLoggingCount);
			
			NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];

			// ローカルスコープを定義します。
			{
				if (logging) NSLog(@"NONATOMIC: Property will read.");
				EzSampleObjectClassValue* value = self.valueForReplaceByNonAtomic;
				if (logging) NSLog(@"NONATOMIC: Property did read.");
				
				// 同じポインタだと、プロパティ経由で代入したときに retain が省略されるため、複製を取ります。
				value = [value copy];
				
				value->a = _loopCountOfValueForReplaceByNonAtomic;
				value->b = _loopCountOfValueForReplaceByNonAtomic;
				
				if (logging) NSLog(@"NONATOMIC: Property will write.");
				self.valueForReplaceByNonAtomic = value;
				if (logging) NSLog(@"NONATOMIC: Property did write.");
				
				[value release];

				if (logging) NSLog(@"NONATOMIC: Will End of local scope.");
			}
			
			if (logging) NSLog(@"NONATOMIC: Did End of local scope.");
			if (logging) NSLog(@"NONATOMIC: Will End of autorelease pool.");
			
			[pool release];
			
			if (logging) NSLog(@"NONATOMIC: Did End of autorelease pool.");
			
			if (_loggingCountForReplaceByNonAtomic == EzSampleClassNonARCLoggingCount)
			{
				[EzSampleObjectClassValue setLogTargetThread:nil];
			}
		}
	}
	@catch (NSException* exception)
	{
		self.errorMessageForReplaceByNonAtomic = [NSString stringWithFormat:@"The writting thread was aborted because %@", exception.reason];
		EzPostLog(self.errorMessageForReplaceByNonAtomic);
	}

	[_threadForValueForReplaceByNonAtomic release];
	
	_threadForValueForReplaceByNonAtomic = nil;
	
	[NSThread exit];
}

- (void)EzThreadLoopForValueForReplaceByAtomic:(id)object
{
	NSThread* currentThread = [NSThread currentThread];
	
	@try
	{
		while (!currentThread.isCancelled)
		{
			_loopCountOfValueForReplaceByAtomic++;
			
			// ログ出力すべきタイミングかを調べます。
			if (_loggingCountForReplaceByAtomic == 0)
			{
				if ([EzSampleObjectClassValue logTargetThread] == currentThread)
				{
					_loggingCountForReplaceByAtomic = 1;
				}
			}
			else
			{
				_loggingCountForReplaceByAtomic++;
			}
			
			BOOL logging = (_loggingCountForReplaceByAtomic > 0 && _loggingCountForReplaceByAtomic <= EzSampleClassNonARCLoggingCount);
			
			NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
			
			// ローカルスコープを定義します。
			{
				if (logging) NSLog(@"ATOMIC: Property will read.");
				EzSampleObjectClassValue* value = self.valueForReplaceByAtomic;
				if (logging) NSLog(@"ATOMIC: Property did read.");
				
				// 同じポインタだと、プロパティ経由で代入したときに retain が省略されるため、複製を取ります。
				value = [value copy];
				
				value->a = _loopCountOfValueForReplaceByAtomic;
				value->b = _loopCountOfValueForReplaceByAtomic;
				
				if (logging) NSLog(@"ATOMIC: Property will write.");
				self.valueForReplaceByAtomic = value;
				if (logging) NSLog(@"ATOMIC: Property did write.");
				
				[value release];
				
				if (logging) NSLog(@"ATOMIC: Will End of local scope.");
			}

			if (logging) NSLog(@"ATOMIC: Did End of local scope.");
			if (logging) NSLog(@"ATOMIC: Will End of autorelease pool.");
			
			[pool release];
			
			if (logging) NSLog(@"ATOMIC: Did End of autorelease pool.");
			
			if (_loggingCountForReplaceByAtomic == EzSampleClassNonARCLoggingCount)
			{
				[EzSampleObjectClassValue setLogTargetThread:_threadForValueForReplaceByNonAtomic];
			}
		}
	}
	@catch (NSException* exception)
	{
		self.errorMessageForReplaceByAtomic = [NSString stringWithFormat:@"The writting thread was aborted because %@", exception.reason];
		EzPostLog(self.errorMessageForReplaceByAtomic);
	}

	[_threadForValueForReplaceByAtomic release];
	
	_threadForValueForReplaceByAtomic = nil;
	
	[NSThread exit];
}

- (void)EzThreadLoopForValueForReplaceByAtomicReadAndNonAtomicWrite:(id)object
{
	NSThread* currentThread = [NSThread currentThread];
	
	@try
	{
		while (!currentThread.isCancelled)
		{
			_loopCountOfValueForReplaceByAtomicReadAndNonAtomicWrite++;
			
			EzSampleObjectClassValue* value = [self.valueForReplaceByAtomicReadAndNonAtomicWrite copy];
			
			value->a = _loopCountOfValueForReplaceByAtomicReadAndNonAtomicWrite;
			value->b = _loopCountOfValueForReplaceByAtomicReadAndNonAtomicWrite;
			
			if (_valueForReplaceByAtomicReadAndNonAtomicWrite != nil)
			{
				[_valueForReplaceByAtomicReadAndNonAtomicWrite release];
			}
			
			_valueForReplaceByAtomicReadAndNonAtomicWrite = value;
		}
	}
	@catch (NSException* exception)
	{
		self.errorMessageForReplaceByAtomicReadAndNonAtomicWrite = [NSString stringWithFormat:@"The writting thread was aborted because %@", exception.reason];
		EzPostLog(self.errorMessageForReplaceByAtomicReadAndNonAtomicWrite);
	}
	
	[_threadForValueForReplaceByAtomicReadAndNonAtomicWrite release];
	
	_threadForValueForReplaceByAtomicReadAndNonAtomicWrite = nil;
	
	[NSThread exit];
}


@end
