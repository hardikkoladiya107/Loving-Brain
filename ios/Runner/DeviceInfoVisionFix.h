#if defined(__OBJC__)
#import <Foundation/Foundation.h>

#ifndef isiOSAppOnVision_defined
#define isiOSAppOnVision_defined
@interface NSProcessInfo (VisionFix)
@property (readonly) BOOL isiOSAppOnVision;
@end
#endif
#endif
