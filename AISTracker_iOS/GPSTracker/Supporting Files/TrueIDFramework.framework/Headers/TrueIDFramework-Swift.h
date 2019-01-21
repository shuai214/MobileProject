// Generated by Apple Swift version 4.2 (swiftlang-1000.11.37.1 clang-1000.11.45.1)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgcc-compat"

#if !defined(__has_include)
# define __has_include(x) 0
#endif
#if !defined(__has_attribute)
# define __has_attribute(x) 0
#endif
#if !defined(__has_feature)
# define __has_feature(x) 0
#endif
#if !defined(__has_warning)
# define __has_warning(x) 0
#endif

#if __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus)
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...)
# endif
#endif

#if __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if __has_attribute(warn_unused_result)
# define SWIFT_WARN_UNUSED_RESULT __attribute__((warn_unused_result))
#else
# define SWIFT_WARN_UNUSED_RESULT
#endif
#if __has_attribute(noreturn)
# define SWIFT_NORETURN __attribute__((noreturn))
#else
# define SWIFT_NORETURN
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM_ATTR)
# if defined(__has_attribute) && __has_attribute(enum_extensibility)
#  define SWIFT_ENUM_ATTR(_extensibility) __attribute__((enum_extensibility(_extensibility)))
# else
#  define SWIFT_ENUM_ATTR(_extensibility)
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name, _extensibility) enum _name : _type _name; enum SWIFT_ENUM_ATTR(_extensibility) SWIFT_ENUM_EXTRA _name : _type
# if __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME, _extensibility) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_ATTR(_extensibility) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME, _extensibility) SWIFT_ENUM(_type, _name, _extensibility)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if !defined(SWIFT_UNAVAILABLE_MSG)
# define SWIFT_UNAVAILABLE_MSG(msg) __attribute__((unavailable(msg)))
#endif
#if !defined(SWIFT_AVAILABILITY)
# define SWIFT_AVAILABILITY(plat, ...) __attribute__((availability(plat, __VA_ARGS__)))
#endif
#if !defined(SWIFT_DEPRECATED)
# define SWIFT_DEPRECATED __attribute__((deprecated))
#endif
#if !defined(SWIFT_DEPRECATED_MSG)
# define SWIFT_DEPRECATED_MSG(...) __attribute__((deprecated(__VA_ARGS__)))
#endif
#if __has_feature(attribute_diagnose_if_objc)
# define SWIFT_DEPRECATED_OBJC(Msg) __attribute__((diagnose_if(1, Msg, "warning")))
#else
# define SWIFT_DEPRECATED_OBJC(Msg) SWIFT_DEPRECATED_MSG(Msg)
#endif
#if __has_feature(modules)
@import Foundation;
@import ObjectiveC;
@import Security;
@import UIKit;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
#if __has_warning("-Wpragma-clang-attribute")
# pragma clang diagnostic ignored "-Wpragma-clang-attribute"
#endif
#pragma clang diagnostic ignored "-Wunknown-pragmas"
#pragma clang diagnostic ignored "-Wnullability"

#if __has_attribute(external_source_symbol)
# pragma push_macro("any")
# undef any
# pragma clang attribute push(__attribute__((external_source_symbol(language="Swift", defined_in="TrueIDFramework",generated_declaration))), apply_to=any(function,enum,objc_interface,objc_category,objc_protocol))
# pragma pop_macro("any")
#endif

typedef SWIFT_ENUM(NSInteger, FLOW_TYPE, closed) {
  FLOW_TYPEA = 1,
  FLOW_TYPEB = 2,
  FLOW_TYPEC = 3,
  FLOW_TYPED = 4,
};

typedef SWIFT_ENUM(NSInteger, FLOW_TYPE_SDK, closed) {
  FLOW_TYPE_SDKA = 1,
  FLOW_TYPE_SDKB = 2,
  FLOW_TYPE_SDKC = 3,
  FLOW_TYPE_SDKD = 4,
};

typedef SWIFT_ENUM(NSInteger, GetProfileStatus, closed) {
  GetProfileStatusGET_PROFILE_COMPLETE = 0,
  GetProfileStatusGET_PROFILE_FAILED = 1,
};

/// Language in your application.
/// <ul>
///   <li>
///     TH: thai language
///   </li>
///   <li>
///     EN: englist language
///   </li>
/// </ul>
typedef SWIFT_ENUM(NSInteger, LANGUAGE, closed) {
  LANGUAGETH = 22,
  LANGUAGEEN = 33,
};

/// Language in your application.
/// <ul>
///   <li>
///     TH: thai language
///   </li>
///   <li>
///     EN: englist language
///   </li>
/// </ul>
typedef SWIFT_ENUM(NSInteger, LANGUAGE_SDK, closed) {
  LANGUAGE_SDKTH = 22,
  LANGUAGE_SDKEN = 33,
};

typedef SWIFT_ENUM(NSInteger, LoginQrCodeStatus, closed) {
  LoginQrCodeStatusLoginQrCode_COMPLETE = 0,
  LoginQrCodeStatusLoginQrCode_FAILED = 1,
};

typedef SWIFT_ENUM(NSInteger, LoginStatus, closed) {
  LoginStatusLOGIN_COMPLETE = 0,
  LoginStatusLOGIN_FAILED = 1,
};





typedef SWIFT_ENUM(NSInteger, RefreshTokenStatus, closed) {
  RefreshTokenStatusREFRESH_COMPLETE = 0,
  RefreshTokenStatusREFRESH_FAILED = 1,
  RefreshTokenStatusVALID = 2,
  RefreshTokenStatusREFRESH_FAILED_AND_LOGOUT = 3,
};

typedef SWIFT_ENUM(NSInteger, SDKFor, closed) {
  SDKForStaging = 101,
  SDKForProduction = 102,
  SDKForAlpha = 103,
};

@protocol TrueSDKEventLogDelegate;

SWIFT_CLASS("_TtC15TrueIDFramework8SDKGALog")
@interface SDKGALog : NSObject
@property (nonatomic, strong) id <TrueSDKEventLogDelegate> _Nullable logDelegate;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) SDKGALog * _Nonnull eventLog;)
+ (SDKGALog * _Nonnull)eventLog SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

@class TrueSDKEventModel;
@class TrueAuthenScreenModel;

SWIFT_PROTOCOL("_TtP15TrueIDFramework26TrueAuthenEventLogDelegate_")
@protocol TrueAuthenEventLogDelegate
@optional
- (void)onReceivedEventWithEvent:(TrueSDKEventModel * _Nonnull)event;
- (void)onReceivedScreenWithScreenModel:(TrueAuthenScreenModel * _Nonnull)screenModel;
@end


@interface SDKGALog (SWIFT_EXTENSION(TrueIDFramework)) <TrueAuthenEventLogDelegate>
- (void)onReceivedEventWithEvent:(TrueSDKEventModel * _Nonnull)event;
- (void)onReceivedScreenWithScreenModel:(TrueAuthenScreenModel * _Nonnull)screenModel;
@end


SWIFT_CLASS("_TtC15TrueIDFramework18TrueAuthenEventLog")
@interface TrueAuthenEventLog : NSObject
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) TrueAuthenEventLog * _Nonnull eventLog;)
+ (TrueAuthenEventLog * _Nonnull)eventLog SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_PROTOCOL("_TtP15TrueIDFramework31TrueAuthenEventLogModelDelegate_")
@protocol TrueAuthenEventLogModelDelegate
@optional
- (void)onLoadDataSuccess;
@end


@interface TrueAuthenEventLog (SWIFT_EXTENSION(TrueIDFramework)) <TrueAuthenEventLogModelDelegate>
- (void)onLoadDataSuccess;
@end



SWIFT_CLASS("_TtC15TrueIDFramework23TrueAuthenEventLogModel")
@interface TrueAuthenEventLogModel : NSObject
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end



SWIFT_CLASS("_TtC15TrueIDFramework21TrueAuthenScreenModel")
@interface TrueAuthenScreenModel : NSObject
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_DEPRECATED_MSG("-init is unavailable");
@end


SWIFT_CLASS("_TtC15TrueIDFramework14TrueEventModel")
@interface TrueEventModel : NSObject
@property (nonatomic, copy) NSString * _Null_unspecified category;
@property (nonatomic, copy) NSString * _Null_unspecified action;
@property (nonatomic, copy) NSString * _Null_unspecified label;
- (nonnull instancetype)initWithCategory:(NSString * _Nonnull)category action:(NSString * _Nonnull)action label:(NSString * _Nonnull)label OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_DEPRECATED_MSG("-init is unavailable");
@end


SWIFT_PROTOCOL("_TtP15TrueIDFramework34TrueIDAuthenticationQrCodeDelegate_")
@protocol TrueIDAuthenticationQrCodeDelegate
@optional
- (void)onLoginQrCodeSuccess:(NSDictionary * _Nonnull)loginQrCodeData;
- (void)onLoginQrCodeError:(NSDictionary * _Nonnull)errorMessage;
- (void)cancelLoginQrcodeView;
@end

@protocol TrueSDKActiveAppDelegate;
@protocol TrueSDKLoginDelegate;
@protocol TrueSDKQrCodeDelegate;
@protocol TrueSDKRegisterDelegate;
@protocol TrueSDKRefreshTokenDelegate;
@protocol TrueSDKMappingDelegate;
enum TrueSDKFor : NSInteger;
@class CLLocation;

SWIFT_CLASS("_TtC15TrueIDFramework18TrueIdPlatformAuth")
@interface TrueIdPlatformAuth : NSObject
/// Response from Active App Succcess
@property (nonatomic, strong) id <TrueSDKActiveAppDelegate> _Nullable activeAppDelegate;
/// Response from login delegate.
@property (nonatomic, strong) id <TrueSDKLoginDelegate> _Nullable loginDelegate;
/// Response from login delegate.
@property (nonatomic, strong) id <TrueSDKQrCodeDelegate> _Nullable loginQrCodeDelegate;
/// Response From register.
@property (nonatomic, strong) id <TrueSDKRegisterDelegate> _Nullable registerDelegate;
/// Response From register.
@property (nonatomic) BOOL isSelfLogin;
/// Response From refresh token.
@property (nonatomic, strong) id <TrueSDKRefreshTokenDelegate> _Nullable refreshTokenDelegate;
/// Response From verify by thai id.
@property (nonatomic, strong) id <TrueSDKMappingDelegate> _Nullable mappingDelegate;
/// Application is get or set automatic login after forget password success.
@property (nonatomic) BOOL isLoginAutoAfterForget;
@property (nonatomic) BOOL isAutoGenTokenUrlForTrueID;
/// Application is get or set automatic login after register success.
@property (nonatomic) BOOL isLoginAutoAfterRegister;
- (void)setScopeWithPermissions:(NSArray<NSString *> * _Nonnull)permissions;
SWIFT_CLASS_PROPERTY(@property (nonatomic, class, readonly, strong) TrueIdPlatformAuth * _Nonnull shareInstance;)
+ (TrueIdPlatformAuth * _Nonnull)shareInstance SWIFT_WARN_UNUSED_RESULT;
- (void)setClientIDWithClientId:(NSString * _Nonnull)clientId;
- (void)setReDirectUrlWithUrlStr:(NSString * _Nonnull)urlStr;
- (void)setSDKforWithSdkFor:(enum TrueSDKFor)sdkFor;
- (BOOL)findTrueIDApp SWIFT_WARN_UNUSED_RESULT;
- (void)callTrueIDApp;
- (void)onCanceled;
- (void)scanQrCode;
/// Check is logged in
///
/// returns:
/// boolean true is login, false not login
+ (BOOL)isLogin SWIFT_WARN_UNUSED_RESULT;
- (NSString * _Nonnull)getDeviceId SWIFT_WARN_UNUSED_RESULT;
- (void)selfVerify:(void (^ _Nonnull)(NSString * _Nonnull))onVerifySuccess onVerifyFailed:(void (^ _Nonnull)(NSDictionary * _Nonnull))onVerifyFailed;
- (void)bindingTrueMoneyWithEncrypted:(NSString * _Nonnull)encrypted onBindingSuccess:(void (^ _Nonnull)(NSString * _Nonnull))onBindingSuccess onBindingFailed:(void (^ _Nonnull)(NSDictionary * _Nonnull))onBindingFailed;
- (void)getLoginInfo:(void (^ _Nonnull)(NSDictionary * _Nonnull))completed failed:(void (^ _Nonnull)(NSDictionary * _Nonnull))failed;
- (void)reinstallService;
- (void)forgetPasswordWithIsAutoLogin:(BOOL)autoLogin;
- (void)recoveryWithIsAutoLogin:(BOOL)isAutoLogin;
/// Get Profile from api
/// \param onGetProfileSuccess Get Profile Success
///
/// \param onGetProfileError Get Profile Failed
///
- (void)getProfileMoreOnGetProfileSuccess:(void (^ _Nonnull)(NSDictionary * _Nonnull, NSInteger))onGetProfileSuccess onGetProfileError:(void (^ _Nonnull)(NSDictionary * _Nonnull))onGetProfileError;
/// login function
- (void)login;
/// start service refresh token auto
- (void)startService;
/// stop service refresh token auto
- (void)stopService;
/// check for background service work
///
/// returns:
/// true is run, false is not run
- (BOOL)isRunBackgroundService SWIFT_WARN_UNUSED_RESULT;
/// init TrueId SDK for start using.
/// \param clientID Id of client with use this sdk.
///
/// \param clientSecret ClientSecret of client with use this sdk.
///
/// \param permissions Permission to known application data.
///
- (void)initWithScopes:(NSArray<NSString *> * _Nonnull)scopes SWIFT_METHOD_FAMILY(none);
/// Set langauge for this sdk
/// \param language language type enum of sdk
///
- (void)setLanguageWithLanguage:(enum LANGUAGE_SDK)language;
/// go to app TrueID or App Stroe of TrueId.
- (void)gotoTrueIDApp;
/// Call refresh access token when become active application or
/// Developer will refresh by target life cycle of application
/// \param completeBlock reponse of refresh token
///
+ (void)activeApp;
/// Save Refresh Token Process of SDK V.3
/// Developer will refresh by target life cycle of application
/// \param completeBlock reponse of refresh token
///
- (void)setTokenForLoginFromTempServiceWithRefreshToken:(NSString * _Nonnull)refreshToken accessToken:(NSString * _Nonnull)accessToken;
- (NSString * _Nonnull)getVersionBuildOfSDK SWIFT_WARN_UNUSED_RESULT;
/// Set current location
/// \param lat latitude
///
/// \param lng longitude
///
- (void)setCurrentLocationWithLat:(double)lat lng:(double)lng;
- (NSString * _Nullable)getAccessToken SWIFT_WARN_UNUSED_RESULT;
/// Get refresh token when loged in
/// <ul>
///   <li>
///     Returns refresh_token
///   </li>
/// </ul>
- (NSString * _Nullable)getRefreshToken SWIFT_WARN_UNUSED_RESULT;
/// Location of your device.
///
/// returns:
/// lat,long ex 13.431847,170.3203787
- (CLLocation * _Nonnull)getlocation SWIFT_WARN_UNUSED_RESULT;
- (enum LANGUAGE_SDK)getLanguageByType SWIFT_WARN_UNUSED_RESULT;
- (NSString * _Nonnull)getLanguageStr SWIFT_WARN_UNUSED_RESULT;
/// Register
/// \param flow _type: type of register A or D
///
/// \param isAutoLogin is auto login after register success.
///
- (void)registerWithIsAutoLogin:(BOOL)isAutoLogin;
/// Logout user logged in.
/// If logout from api success or failed. that SDK will removen all token.
/// \param onLogoutRespond response of logout.
///
- (void)logoutWithResponseComplete:(void (^ _Nonnull)(NSDictionary * _Nonnull))responseComplete responseFailed:(void (^ _Nonnull)(NSDictionary * _Nonnull))responseFailed;
/// Expire date for accesst token
///
/// returns:
/// time in seconds.
- (NSInteger)refreshToken_expired SWIFT_WARN_UNUSED_RESULT;
/// verify number from thai id.
- (void)verifyThaiId;
- (BOOL)handleOpenURLWithUrl:(NSURL * _Nonnull)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> * _Nonnull)options SWIFT_WARN_UNUSED_RESULT SWIFT_AVAILABILITY(ios,introduced=9.0);
- (BOOL)handleOpenURLWithUrl:(NSURL * _Nonnull)url sourceApplication:(NSString * _Nullable)sourceApplication SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


@interface TrueIdPlatformAuth (SWIFT_EXTENSION(TrueIDFramework)) <TrueIDAuthenticationQrCodeDelegate>
- (void)onActiveAppCompletionWithIsSuccess:(BOOL)isSuccess;
- (void)onRegisterSuccessWithUserProfileData:(NSDictionary * _Nullable)userProfileData;
- (void)onRegisterErrorWithErrorMessage:(NSString * _Nullable)errorMessage;
- (void)onLoginSuccess:(NSDictionary * _Nonnull)userProfileData expiredTimeInSecond:(NSInteger)expiredTimeInSecond;
- (void)onLoginError:(NSDictionary * _Nonnull)errorMessage;
- (void)onRevokeAlready;
- (void)onLoginQrCodeSuccess:(NSDictionary * _Nonnull)loginQrCodeData;
- (void)onLoginQrCodeError:(NSDictionary * _Nonnull)errorMessage;
- (void)cancelLoginQrcodeView;
- (void)onForgetPasswordSuccess:(NSDictionary * _Nonnull)response;
- (void)cancelLoginTrueIDView;
- (void)onMappingAlready:(NSDictionary * _Nonnull)response;
- (void)onMappingSuccess:(NSDictionary * _Nonnull)response;
- (void)onMappingFailed:(NSDictionary * _Nonnull)errorMessage;
- (void)onRefreshTokenSuccess;
- (void)onRefreshTokenFailedWithErrorMessage:(NSDictionary * _Nonnull)errorMessage;
@end

@class TrueScreenModel;

SWIFT_PROTOCOL("_TtP15TrueIDFramework24TrueSDK4EventLogDelegate_")
@protocol TrueSDK4EventLogDelegate
@optional
- (void)onReceivedEventWithEvent:(TrueEventModel * _Nonnull)event;
- (void)onReceivedScreenWithScreenModel:(TrueScreenModel * _Nonnull)screenModel;
@end


SWIFT_PROTOCOL("_TtP15TrueIDFramework24TrueSDKActiveAppDelegate_")
@protocol TrueSDKActiveAppDelegate
@optional
- (void)onActiveAppCompletionWithIsSuccess:(BOOL)isSuccess;
@end


SWIFT_PROTOCOL("_TtP15TrueIDFramework23TrueSDKEventLogDelegate_")
@protocol TrueSDKEventLogDelegate
@optional
- (void)onReceivedEventWithEvent:(TrueEventModel * _Nonnull)event;
- (void)onReceivedScreenWithScreenModel:(TrueScreenModel * _Nonnull)screenModel;
@end


SWIFT_CLASS("_TtC15TrueIDFramework17TrueSDKEventModel")
@interface TrueSDKEventModel : NSObject
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_DEPRECATED_MSG("-init is unavailable");
@end

typedef SWIFT_ENUM(NSInteger, TrueSDKFor, closed) {
  TrueSDKForStaging = 0,
  TrueSDKForProduction = 1,
  TrueSDKForAlpha = 2,
};


SWIFT_PROTOCOL("_TtP15TrueIDFramework20TrueSDKLoginDelegate_")
@protocol TrueSDKLoginDelegate
@optional
- (void)onLoginSuccess:(NSDictionary * _Nonnull)userProfileData expiredTimeInSecond:(NSInteger)expiredTimeInSecond;
- (void)onLoginError:(NSDictionary * _Nonnull)errorMessage;
- (void)onForgetPasswordSuccess:(NSDictionary * _Nonnull)response;
- (void)cancelLoginTrueIDView;
- (void)onRevokeAlready;
@end


SWIFT_PROTOCOL("_TtP15TrueIDFramework22TrueSDKMappingDelegate_")
@protocol TrueSDKMappingDelegate
@optional
- (void)onMappingAlready:(NSDictionary * _Nonnull)response;
- (void)onMappingSuccess:(NSDictionary * _Nonnull)response;
- (void)onMappingFailed:(NSDictionary * _Nonnull)errorMessage;
@end


SWIFT_PROTOCOL("_TtP15TrueIDFramework21TrueSDKQrCodeDelegate_")
@protocol TrueSDKQrCodeDelegate
@optional
- (void)onLoginQrCodeSuccess:(NSDictionary * _Nonnull)loginQrCodeData;
- (void)onLoginQrCodeError:(NSDictionary * _Nonnull)errorMessage;
- (void)cancelLoginQrcodeView;
@end


SWIFT_PROTOCOL("_TtP15TrueIDFramework27TrueSDKRefreshTokenDelegate_")
@protocol TrueSDKRefreshTokenDelegate
@optional
- (void)onRefreshTokenSuccess;
- (void)onRefreshTokenFailedWithErrorMessage:(NSDictionary * _Nonnull)errorMessage;
@end


SWIFT_PROTOCOL("_TtP15TrueIDFramework23TrueSDKRegisterDelegate_")
@protocol TrueSDKRegisterDelegate
@optional
- (void)onRegisterSuccessWithUserProfileData:(NSDictionary * _Nullable)userProfileData;
- (void)onRegisterErrorWithErrorMessage:(NSString * _Nullable)errorMessage;
@end


SWIFT_CLASS("_TtC15TrueIDFramework15TrueScreenModel")
@interface TrueScreenModel : NSObject
@property (nonatomic, copy) NSString * _Nonnull screenName;
- (nonnull instancetype)initWithScreenName:(NSString * _Nonnull)screenName OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_DEPRECATED_MSG("-init is unavailable");
@end






@interface UINavigationController (SWIFT_EXTENSION(TrueIDFramework))
@property (nonatomic, readonly) BOOL shouldAutorotate;
@property (nonatomic, readonly) UIInterfaceOrientation preferredInterfaceOrientationForPresentation;
@property (nonatomic, readonly) UIInterfaceOrientationMask supportedInterfaceOrientations;
@end





typedef SWIFT_ENUM(NSInteger, VerifyWithTokenStatus, closed) {
  VerifyWithTokenStatusVERIFY_COMPLETE = 0,
  VerifyWithTokenStatusVERIFY_FAILED = 1,
};


/// Decodes a JWT
SWIFT_CLASS_NAMED("_JWT")
@interface A0JWT : NSObject
/// token header part
@property (nonatomic, readonly, copy) NSDictionary<NSString *, id> * _Nonnull header;
/// token body part or claims
@property (nonatomic, readonly, copy) NSDictionary<NSString *, id> * _Nonnull body;
/// token signature part
@property (nonatomic, readonly, copy) NSString * _Nullable signature;
/// value of the <code>exp</code> claim
@property (nonatomic, readonly, copy) NSDate * _Nullable expiresAt;
/// value of the <code>expired</code> field
@property (nonatomic, readonly) BOOL expired;
/// Creates a new instance of <code>A0JWT</code> and decodes the given jwt token.
/// :param: jwtValue of the token to decode
/// :returns: a new instance of <code>A0JWT</code> that holds the decode token
+ (A0JWT * _Nullable)decodeWithJwt:(NSString * _Nonnull)jwtValue error:(NSError * _Nullable * _Nullable)error SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_DEPRECATED_MSG("-init is unavailable");
@end

@class PublicKeyTrueSDK;
@class EncryptedMessage;
@class PrivateKey;
enum DigestType : NSInteger;
@class SignatureTrueSDK;
@class VerificationResult;

SWIFT_CLASS_NAMED("_objc_ClearMessageTrueSDK")
@interface ClearMessageTrueSDK : NSObject
@property (nonatomic, readonly, copy) NSString * _Nonnull base64String;
@property (nonatomic, readonly, copy) NSData * _Nonnull data;
- (nonnull instancetype)initWithData:(NSData * _Nonnull)data OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithString:(NSString * _Nonnull)string using:(NSUInteger)rawEncoding error:(NSError * _Nullable * _Nullable)error OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithBase64Encoded:(NSString * _Nonnull)base64String error:(NSError * _Nullable * _Nullable)error OBJC_DESIGNATED_INITIALIZER;
- (NSString * _Nullable)stringWithEncoding:(NSUInteger)rawEncoding error:(NSError * _Nullable * _Nullable)error SWIFT_WARN_UNUSED_RESULT;
- (EncryptedMessage * _Nullable)encryptedWith:(PublicKeyTrueSDK * _Nonnull)key padding:(SecPadding)padding error:(NSError * _Nullable * _Nullable)error SWIFT_WARN_UNUSED_RESULT;
- (SignatureTrueSDK * _Nullable)signedWith:(PrivateKey * _Nonnull)key digestType:(enum DigestType)digestType error:(NSError * _Nullable * _Nullable)error SWIFT_WARN_UNUSED_RESULT;
- (VerificationResult * _Nullable)verifyWith:(PublicKeyTrueSDK * _Nonnull)key SignatureTrueSDK:(SignatureTrueSDK * _Nonnull)SignatureTrueSDK digestType:(enum DigestType)digestType error:(NSError * _Nullable * _Nullable)error SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_DEPRECATED_MSG("-init is unavailable");
@end


SWIFT_CLASS_NAMED("_objc_EncryptedMessage")
@interface EncryptedMessage : NSObject
@property (nonatomic, readonly, copy) NSString * _Nonnull base64String;
@property (nonatomic, readonly, copy) NSData * _Nonnull data;
- (nonnull instancetype)initWithData:(NSData * _Nonnull)data OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithBase64Encoded:(NSString * _Nonnull)base64String error:(NSError * _Nullable * _Nullable)error OBJC_DESIGNATED_INITIALIZER;
- (ClearMessageTrueSDK * _Nullable)decryptedWith:(PrivateKey * _Nonnull)key padding:(SecPadding)padding error:(NSError * _Nullable * _Nullable)error SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_DEPRECATED_MSG("-init is unavailable");
@end

@class NSBundle;

SWIFT_CLASS_NAMED("_objc_PrivateKey")
@interface PrivateKey : NSObject
@property (nonatomic, readonly) SecKeyRef _Nonnull reference;
@property (nonatomic, readonly, copy) NSData * _Nullable originalData;
- (NSString * _Nullable)pemStringAndReturnError:(NSError * _Nullable * _Nullable)error SWIFT_WARN_UNUSED_RESULT;
- (NSData * _Nullable)dataAndReturnError:(NSError * _Nullable * _Nullable)error SWIFT_WARN_UNUSED_RESULT;
- (NSString * _Nullable)base64StringAndReturnError:(NSError * _Nullable * _Nullable)error SWIFT_WARN_UNUSED_RESULT;
- (nullable instancetype)initWithData:(NSData * _Nonnull)data error:(NSError * _Nullable * _Nullable)error OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithReference:(SecKeyRef _Nonnull)reference error:(NSError * _Nullable * _Nullable)error OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithBase64Encoded:(NSString * _Nonnull)base64String error:(NSError * _Nullable * _Nullable)error OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithPemEncoded:(NSString * _Nonnull)pemString error:(NSError * _Nullable * _Nullable)error OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithPemNamed:(NSString * _Nonnull)pemName in:(NSBundle * _Nonnull)bundle error:(NSError * _Nullable * _Nullable)error OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithDerNamed:(NSString * _Nonnull)derName in:(NSBundle * _Nonnull)bundle error:(NSError * _Nullable * _Nullable)error OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_DEPRECATED_MSG("-init is unavailable");
@end


SWIFT_CLASS_NAMED("_objc_PublicKeyTrueSDK")
@interface PublicKeyTrueSDK : NSObject
@property (nonatomic, readonly) SecKeyRef _Nonnull reference;
@property (nonatomic, readonly, copy) NSData * _Nullable originalData;
- (NSString * _Nullable)pemStringAndReturnError:(NSError * _Nullable * _Nullable)error SWIFT_WARN_UNUSED_RESULT;
- (NSData * _Nullable)dataAndReturnError:(NSError * _Nullable * _Nullable)error SWIFT_WARN_UNUSED_RESULT;
- (NSString * _Nullable)base64StringAndReturnError:(NSError * _Nullable * _Nullable)error SWIFT_WARN_UNUSED_RESULT;
- (nullable instancetype)initWithData:(NSData * _Nonnull)data error:(NSError * _Nullable * _Nullable)error OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithReference:(SecKeyRef _Nonnull)reference error:(NSError * _Nullable * _Nullable)error OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithBase64Encoded:(NSString * _Nonnull)base64String error:(NSError * _Nullable * _Nullable)error OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithPemEncoded:(NSString * _Nonnull)pemString error:(NSError * _Nullable * _Nullable)error OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithPemNamed:(NSString * _Nonnull)pemName in:(NSBundle * _Nonnull)bundle error:(NSError * _Nullable * _Nullable)error OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithDerNamed:(NSString * _Nonnull)derName in:(NSBundle * _Nonnull)bundle error:(NSError * _Nullable * _Nullable)error OBJC_DESIGNATED_INITIALIZER;
+ (NSArray<PublicKeyTrueSDK *> * _Nonnull)PublicKeyTrueSDKsWithPemEncoded:(NSString * _Nonnull)pemString SWIFT_WARN_UNUSED_RESULT;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_DEPRECATED_MSG("-init is unavailable");
@end


SWIFT_CLASS_NAMED("_objc_SignatureTrueSDK")
@interface SignatureTrueSDK : NSObject
@property (nonatomic, readonly, copy) NSString * _Nonnull base64String;
@property (nonatomic, readonly, copy) NSData * _Nonnull data;
- (nonnull instancetype)initWithData:(NSData * _Nonnull)data OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithBase64Encoded:(NSString * _Nonnull)base64String error:(NSError * _Nullable * _Nullable)error OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_DEPRECATED_MSG("-init is unavailable");
@end

typedef SWIFT_ENUM(NSInteger, DigestType, closed) {
  DigestTypeSha1 = 0,
  DigestTypeSha224 = 1,
  DigestTypeSha256 = 2,
  DigestTypeSha384 = 3,
  DigestTypeSha512 = 4,
};


SWIFT_CLASS_NAMED("_objc_VerificationResult")
@interface VerificationResult : NSObject
@property (nonatomic, readonly) BOOL isSuccessful;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
+ (nonnull instancetype)new SWIFT_DEPRECATED_MSG("-init is unavailable");
@end

#if __has_attribute(external_source_symbol)
# pragma clang attribute pop
#endif
#pragma clang diagnostic pop