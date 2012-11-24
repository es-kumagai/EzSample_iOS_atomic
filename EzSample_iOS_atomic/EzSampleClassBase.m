//
//  EzSampleObject.m
//  EzSample_iOS_atomic
//
//  Created by 熊谷 友宏 on H.24/11/21.
//  Copyright (c) 平成24年 Tomohiro Kumagai. All rights reserved.
//

#import "EzSampleClassBase.h"

#define EzSampleClassBaseLoggingCount 10

@interface EzSampleClassBase ()

- (void)EzThreadLoopForValueForReplaceByNonAtomic:(id)object;
- (void)EzThreadLoopForValueForReplaceByAtomic:(id)object;
- (void)EzThreadLoopForValueForReplaceByAtomicReadAndNonAtomicWrite:(id)object;

@end

@implementation EzSampleClassBase

- (id)init
{
	self = [super init];
	
	if (self)
	{
		_formatter = [[NSNumberFormatter alloc] init];
		
		_formatter.numberStyle = NSNumberFormatterDecimalStyle;
		_formatter.groupingSeparator = @",";
		_formatter.groupingSize = 3;
		
		self.stateStringForNil = @"NG";
	}
	
	return self;
}

- (EzSampleClassResultState)outputStructState:(__unsafe_unretained EzSampleObjectClassValue*)value withLabel:(const char*)label
{
	EzSampleClassResultState state;
	
	if (value)
	{
		if (value->valid == 0)
		{
			state = (value->a == value->b ? EzSampleClassResultStateOK : EzSampleClassResultStateInconsistent);
			EzPostLog(@"%-15s : %2s (%d,%d)", label, (state == EzSampleClassResultStateOK ? "OK" : "NG"), value->a, value->b);
		}
		else
		{
			state = EzSampleClassResultStateInconsistent;
			EzPostLog(@"%-15s : DEALLOC", label);
		}
	}
	else
	{
		state = EzSampleClassResultStateWeakNil;
		EzPostLog(@"%-15s : %@ (null)", label, (self.stateStringForNil == nil ? @"OK" : self.stateStringForNil));
	}
	
	return state;
}

- (void)outputLoopCount
{
	[self outputLoopCountForState:EzSampleClassTestCaseAtomic];
	[self outputLoopCountForState:EzSampleClassTestCaseNonAtomic];
	[self outputLoopCountForState:EzSampleClassTestCaseAtomicReadAndNonAtomicWrite];
}

- (struct EzSampleClassOutputStruct)getCreatedOutputStructForState:(EzSampleClassTestCase)state
{
	struct EzSampleClassOutputStruct result;
	
	NSString* errorMessage;
	
	switch (state)
	{
		case EzSampleClassTestCaseAtomic:
			result.label = EzSampleClassCLabelForAtomic;
			result.loopCount = self.loopCountOfValueForReplaceByAtomic;
			result.inconsistent = self.inconsistentReplaceByAtomic;
			result.weakNil = self.weakNilReplaceByAtomic;
			result.skip = self.skipLogReplaceByAtomic;
			errorMessage = self.errorMessageForReplaceByAtomic;
			break;
			
		case EzSampleClassTestCaseNonAtomic:
			result.label = EzSampleClassCLabelForNonAtomic;
			result.loopCount = self.loopCountOfValueForReplaceByNonAtomic;
			result.inconsistent = self.inconsistentReplaceByNonAtomic;
			result.weakNil = self.weakNilReplaceByNonAtomic;
			errorMessage = self.errorMessageForReplaceByNonAtomic;
			result.skip = self.skipLogReplaceByNonAtomic;
			break;
			
		case EzSampleClassTestCaseAtomicReadAndNonAtomicWrite:
			result.label = EzSampleClassCLabelForAtomicReadAndNonAtomicWrite;
			result.loopCount = self.loopCountOfValueForReplaceByAtomicReadAndNonAtomicWrite;
			result.inconsistent = self.inconsistentReplaceByAtomicReadAndNonAtomicWrite;
			result.weakNil = self.weakNilReplaceByAtomicReadAndNonAtomicWrite;
			result.skip = self.skipLogReplaceByAtomicReadAndNonAtomicWrite;
			errorMessage = self.errorMessageForReplaceByAtomicReadAndNonAtomicWrite;
			break;
	}

	if (errorMessage)
	{
		const char* message = errorMessage.UTF8String;
		size_t length = strlen(message);
		
		result.errorMessage = malloc(sizeof(char) * length + 1);
		
		memcpy(result.errorMessage, message, length);
	}
	else
	{
		result.errorMessage = NULL;
	}
	
	return result;
}

- (void)releaseOutputStruct:(const struct EzSampleClassOutputStruct*)structData
{
	if (structData->errorMessage != NULL) free(structData->errorMessage);
}

- (void)outputLoopCountForState:(EzSampleClassTestCase)state
{
	struct EzSampleClassOutputStruct output = [self getCreatedOutputStructForState:state];
	
	if (output.errorMessage)
	{
		EzPostReport(@"%s : %s", output.label, output.errorMessage);
	}
	else
	{
		__unsafe_unretained NSString* times = [_formatter stringFromNumber:[[NSNumber alloc] initWithInt:output.loopCount]];
		NSString* stateString;
		
		if (output.inconsistent)
		{
			stateString = @"UNSAFE";
		}
		else if (output.weakNil)
		{
			if (self.stateStringForNil)
			{
				stateString = @"DEALOC";
			}
			else
			{
				stateString = @"wSAFE?";
			}
		}
		else
		{
			if (output.skip)
			{
				stateString = @"*SKIP*";
			}
			else
			{
				stateString = @"SAFE ?";
			}
		}
		
		EzPostReport(@"%-15s : %12s times (%@)", output.label, times.UTF8String, stateString);
	}
	
	[self releaseOutputStruct:&output];
}

- (void)start
{
	_threadForValueForReplaceByNonAtomic = [[NSThread alloc] initWithTarget:self selector:@selector(EzThreadLoopForValueForReplaceByNonAtomic:) object:nil];
	_threadForValueForReplaceByAtomic = [[NSThread alloc] initWithTarget:self selector:@selector(EzThreadLoopForValueForReplaceByAtomic:) object:nil];
	_threadForValueForReplaceByAtomicReadAndNonAtomicWrite = [[NSThread alloc] initWithTarget:self selector:@selector(EzThreadLoopForValueForReplaceByAtomicReadAndNonAtomicWrite:) object:nil];
	
	[EzSampleObjectClassValue setLogTargetThread:_threadForValueForReplaceByAtomic];
	
	if (self.errorMessageForReplaceByNonAtomic == nil) [_threadForValueForReplaceByNonAtomic start];
	if (self.errorMessageForReplaceByAtomic == nil) [_threadForValueForReplaceByAtomic start];
	if (self.errorMessageForReplaceByAtomicReadAndNonAtomicWrite == nil) [_threadForValueForReplaceByAtomicReadAndNonAtomicWrite start];
}

- (void)stop
{
	[_threadForValueForReplaceByNonAtomic cancel];
	[_threadForValueForReplaceByAtomic cancel];
	[_threadForValueForReplaceByAtomicReadAndNonAtomicWrite cancel];
}

- (EzSampleClassResultState)outputValueForAtomic
{
	EzPostLog(EzSampleClassOutputHeaderFormat, EzSampleClassCLabelForAtomic, @"NOT IMPLEMENTED");
	
	return EzSampleClassResultStateInconsistent;
}

- (EzSampleClassResultState)outputValueForNonAtomic
{
	EzPostLog(EzSampleClassOutputHeaderFormat, EzSampleClassCLabelForNonAtomic, @"NOT IMPLEMENTED");
	
	return EzSampleClassResultStateInconsistent;
}

- (EzSampleClassResultState)outputValueForAtomicReadAndNonAtomicWrite
{
	EzPostLog(EzSampleClassOutputHeaderFormat, EzSampleClassCLabelForAtomicReadAndNonAtomicWrite, @"NOT IMPLEMENTED");
	
	return EzSampleClassResultStateInconsistent;	
}

- (void)outputWithLabel:(NSString *)label
{
	EzPostLog(@"");
	
	if (!_skipLogReplaceByAtomic)
	{
		switch ([self outputValueForAtomic])
		{
			case EzSampleClassResultStateInconsistent:
				self.inconsistentReplaceByAtomic = YES;
				break;
				
			case EzSampleClassResultStateWeakNil:
				self.weakNilReplaceByAtomic = YES;
				break;
				
			case EzSampleClassResultStateOK:
				break;
		}
	}
	else
	{
		EzPostLog(EzSampleClassOutputHeaderFormat, EzSampleClassCLabelForAtomic, @"SKIP");
	}
	
	if (!_skipLogReplaceByNonAtomic)
	{
		switch ([self outputValueForNonAtomic])
		{
			case EzSampleClassResultStateInconsistent:
				self.inconsistentReplaceByNonAtomic = YES;
				break;
				
			case EzSampleClassResultStateWeakNil:
				self.weakNilReplaceByNonAtomic = YES;
				break;
				
			case EzSampleClassResultStateOK:
				break;
		}
	}
	else
	{
		EzPostLog(EzSampleClassOutputHeaderFormat, EzSampleClassCLabelForNonAtomic, @"SKIP");
	}
	
	if (!_skipLogReplaceByAtomicReadAndNonAtomicWrite)
	{
		switch ([self outputValueForAtomicReadAndNonAtomicWrite])
		{
			case EzSampleClassResultStateInconsistent:
				self.inconsistentReplaceByAtomicReadAndNonAtomicWrite = YES;
				break;
				
			case EzSampleClassResultStateWeakNil:
				self.weakNilReplaceByAtomicReadAndNonAtomicWrite = YES;
				break;
				
			case EzSampleClassResultStateOK:
				break;
		}
	}
	else
	{
		EzPostLog(EzSampleClassOutputHeaderFormat, EzSampleClassCLabelForAtomicReadAndNonAtomicWrite, @"SKIP");
	}
}

- (void)testForAtomicWithOutput:(BOOL)output outputFormat:(NSString *)outputFormat
{
	
}

- (void)testForNonAtomicWithOutput:(BOOL)output outputFormat:(NSString *)outputFormat
{
	
}

- (void)testForAtomicReadAndNonAtomicWriteWithOutput:(BOOL)output outputFormat:(NSString *)outputFormat
{
	
}

- (void)EzThreadLoopForValueForReplaceByNonAtomic:(id)object
{
	NSThread* currentThread = [NSThread currentThread];
	
	@try
	{
		NSString* outputFormat = @"NONATOMIC: %@";
		
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
			
			BOOL logging = (_loggingCountForReplaceByNonAtomic > 0 && _loggingCountForReplaceByNonAtomic <= EzSampleClassBaseLoggingCount);
			
			[self testForNonAtomicWithOutput:logging outputFormat:outputFormat];
			
			if (_loggingCountForReplaceByNonAtomic == EzSampleClassBaseLoggingCount)
			{
				[EzSampleObjectClassValue setLogTargetThread:nil];
			}
		}
	}
	@catch (NSException* exception)
	{
		self.errorMessageForReplaceByNonAtomic = [[NSString alloc] initWithFormat:@"The writting thread was aborted because %@", exception.reason];
		EzPostLog(self.errorMessageForReplaceByNonAtomic);
	}
	
	_threadForValueForReplaceByNonAtomic = nil;
	
	[NSThread exit];
}

- (void)EzThreadLoopForValueForReplaceByAtomic:(id)object
{
	NSThread* currentThread = [NSThread currentThread];
	
	@try
	{
		NSString* outputFormat = @"ATOMIC: %@";
		
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
			
			BOOL logging = (_loggingCountForReplaceByAtomic > 0 && _loggingCountForReplaceByAtomic <= EzSampleClassBaseLoggingCount);
			
			[self testForAtomicWithOutput:logging outputFormat:outputFormat];
			
			if (_loggingCountForReplaceByAtomic == EzSampleClassBaseLoggingCount)
			{
				[EzSampleObjectClassValue setLogTargetThread:_threadForValueForReplaceByNonAtomic];
			}
		}
	}
	@catch (NSException* exception)
	{
		self.errorMessageForReplaceByAtomic = [[NSString alloc] initWithFormat:@"The writting thread was aborted because %@", exception.reason];
		EzPostLog(self.errorMessageForReplaceByAtomic);
	}

	_threadForValueForReplaceByAtomic = nil;
	
	[NSThread exit];
}

- (void)EzThreadLoopForValueForReplaceByAtomicReadAndNonAtomicWrite:(id)object
{
	NSThread* currentThread = [NSThread currentThread];
	
	@try
	{
		NSString* outputFormat = @"R:ATOM-W:DIRECT: %@";
		
		while (!currentThread.isCancelled)
		{
			_loopCountOfValueForReplaceByAtomicReadAndNonAtomicWrite++;
			
			// ログ出力すべきタイミングかを調べます。
			if (_loggingCountForReplaceByAtomicReadAndNonAtomicWrite == 0)
			{
				if ([EzSampleObjectClassValue logTargetThread] == currentThread)
				{
					_loggingCountForReplaceByAtomicReadAndNonAtomicWrite = 1;
				}
			}
			else
			{
				_loggingCountForReplaceByAtomicReadAndNonAtomicWrite++;
			}
			
			BOOL logging = (_loggingCountForReplaceByAtomicReadAndNonAtomicWrite > 0 && _loggingCountForReplaceByAtomicReadAndNonAtomicWrite <= EzSampleClassBaseLoggingCount);
			
			[self testForAtomicReadAndNonAtomicWriteWithOutput:logging outputFormat:outputFormat];
			
			if (_loggingCountForReplaceByAtomicReadAndNonAtomicWrite == EzSampleClassBaseLoggingCount)
			{
				[EzSampleObjectClassValue setLogTargetThread:nil];
			}
		}
	}
	@catch (NSException* exception)
	{
		self.errorMessageForReplaceByAtomicReadAndNonAtomicWrite = [[NSString alloc] initWithFormat:@"The writting thread was aborted because %@", exception.reason];
		EzPostLog(self.errorMessageForReplaceByAtomicReadAndNonAtomicWrite);
	}
	
	_threadForValueForReplaceByAtomicReadAndNonAtomicWrite = nil;
	
	[NSThread exit];
}

@end
