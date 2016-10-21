//
//  WebserviceHelper.h



#import "AFNetworking.h"

@interface FFWebServiceHelper : NSObject

#pragma mark- Singleton
+(FFWebServiceHelper*)sharedManager;

@property(nonatomic,strong)AFHTTPRequestOperation *reqOperation;

-(void) callWebServiceWithUrl:(NSString *)serviceUrl withParameter:(NSDictionary *)dictionary onCompletion:(void(^)(eResponseType responseType, id response))completionBlock;

//-(void) updateSessionWithDictionary:(NSDictionary*)dictionary;

//+ (NSMutableURLRequest*)appendCommonHeaderFieldsToRequest:(NSMutableURLRequest*)request;

+ (NSURL *)urlWithString:(NSString *)serviceURL;

@end


