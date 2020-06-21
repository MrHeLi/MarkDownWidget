#import "MarkdownwidgetPlugin.h"
#if __has_include(<markdownwidget/markdownwidget-Swift.h>)
#import <markdownwidget/markdownwidget-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "markdownwidget-Swift.h"
#endif

@implementation MarkdownwidgetPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftMarkdownwidgetPlugin registerWithRegistrar:registrar];
}
@end
