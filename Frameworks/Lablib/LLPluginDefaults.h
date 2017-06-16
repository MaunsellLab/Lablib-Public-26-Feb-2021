//
//  LLPluginDefaults.h
//  Lablib
//
//  Created by John Maunsell on June 9, 2017.
//  Copyright 2017. All rights reserved.
//

@interface LLPluginDefaults : NSObject {

    NSString *domainName;
}

- (id)initWithPluginName:(NSString *)name;
- (void)registerDefaults:(NSDictionary *)dictionary;

@end

