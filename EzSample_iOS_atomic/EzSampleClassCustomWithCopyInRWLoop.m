//
//  EzSampleObject.m
//  EzSample_iOS_atomic
//
//  Created by 熊谷 友宏 on H.24/11/21.
//  Copyright (c) 平成24年 Tomohiro Kumagai. All rights reserved.
//

#import "EzSampleClassCustomWithCopyInRWLoop.h"

@interface EzSampleClassCustomWithCopyInRWLoop ()

@end

@implementation EzSampleClassCustomWithCopyInRWLoop

- (void)setValueForReplaceByAtomic:(__unsafe_unretained EzSampleObjectClassValue *)valueForReplaceByAtomic
{
	@synchronized (self)
	{
		if (_valueForReplaceByAtomic != valueForReplaceByAtomic)
		{
			_valueForReplaceByAtomic = valueForReplaceByAtomic;
		}
	}
}

- ( EzSampleObjectClassValue*)valueForReplaceByAtomic
{
	@synchronized (self)
	{
		return _valueForReplaceByAtomic;
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
	@synchronized (self)
	{
		return _valueForReplaceByAtomicReadAndNonAtomicWrite;
	}
}

@end
