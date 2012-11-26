//
//  EzSampleObject.m
//  EzSample_iOS_atomic
//
//  Created by 熊谷 友宏 on H.24/11/21.
//  Copyright (c) 平成24年 Tomohiro Kumagai. All rights reserved.
//

#import "EzSampleClassWeakCustom.h"

@interface EzSampleClassWeakCustom ()

@end

@implementation EzSampleClassWeakCustom

- (id)init
{
	self = [super init];
	
	if (self)
	{
		_lock = [[NSLock alloc] init];
	}
	
	return self;
}

- (void)setValueForReplaceByAtomic:(__unsafe_unretained EzSampleObjectClassValue *)valueForReplaceByAtomic
{
	[_lock lock];
	
	_valueForReplaceByAtomic = valueForReplaceByAtomic;
	
	[_lock unlock];
}

- (EzSampleObjectClassValue*)valueForReplaceByAtomic
{
	@try
	{
		[_lock lock];

		return _valueForReplaceByAtomic;
	}
	@finally
	{
		[_lock unlock];
	}
}

- (void)setValueForReplaceByNonAtomic:(__unsafe_unretained EzSampleObjectClassValue *)valueForReplaceByNonAtomic
{
	_valueForReplaceByNonAtomic = valueForReplaceByNonAtomic;
}

- (EzSampleObjectClassValue*)valueForReplaceByNonAtomic
{
	return _valueForReplaceByNonAtomic;
}

- (EzSampleObjectClassValue*)valueForReplaceByAtomicReadAndNonAtomicWrite
{
	@try
	{
		[_lock lock];
		
		return _valueForReplaceByAtomicReadAndNonAtomicWrite;
	}
	@finally
	{
		[_lock unlock];
	}
}

@end
