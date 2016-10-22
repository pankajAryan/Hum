//
//  FFurls.h
//
//


#define Mobile_Api_Version_Key        @"XINDFURMOBAPIVERSION"
#define Mobile_Api_Version            @"v4" //ce25302eed61a8a9f2aef604d4b0c11f
#define Mobile_Platform_Key           @"XFABMOBAPIPLATFORM"
#define Mobile_Platform               @"ios"
#define Mobile_lat                    @"lat"
#define Mobile_long                   @"long"
#define Mobile_city                   @"city"
#define Mobile_UserLocation           @"userLocation"


// ************ LIVE APP CONFIGURATION ************************************************************ //

//#define BASE_URL          @"http://www.fabfurnish.com/mobileapi/"


// ************ DEVELOPMENT ENVIRONMENT CONFIGURATION ********************************************* //


#define BASE_URL        @"http://128.199.129.241:8080/ShieldServer/rest/service"


// 2. *********************|| Prefix By BASE_URL ||**************************************************** //

#define GetStates                   @"/getStateList/"
#define GetDistricts                @"/getDistrictList/"
#define GetAlertsForCategory        @"/getAlertsForCategory/"
#define GetHighwayServices          @"/getHighwayFacilityListByType/"
#define GetEducationContentForType  @"/getEducationContentForType/"
#define GetAmbulanceList            @"/getAmbulanceList/"

#define departmentLogin    @"/login/"

#define RegisterUser    @"/registerUser/"
#define RegenerateOtp   @"/generateOtp/"
#define VerifyOtp       @"/verifyOtp/"

/*

 @Path("/service")
 public class ShieldServices
 {
 
	@Path("/registerUser/")
	@POST
	@Produces(MediaType.APPLICATION_JSON)
	public ResponseVO<String> registerUser(@FormParam("userName") String userName ,@FormParam("emailId") String emailId ,@FormParam("profileImageURL") String profileImageURL,@FormParam("mobileNumber") String mobileNumber,@FormParam("stateId") String stateId,@FormParam("defaultDistrictId") String defaultDistrictId,@FormParam("deviceOS") String deviceOS)
	{
 UserVO vo=new UserVO();
 vo.setEmailId(emailId);
 vo.setUserName(userName);
 vo.setProfileImageURL(profileImageURL);
 vo.setMobileNumber(mobileNumber);
 vo.setState(stateId);
 vo.setDeviceOS(deviceOS);
 vo.setDefaultDistrict(defaultDistrictId);
 return UserControllerImpl.getInstance().registerUser(vo);
	}
 
	@Path("/updateUserProfile/")
	@POST
	@Produces(MediaType.APPLICATION_JSON)
	public ResponseVO<String> updateUserProfile(@FormParam("userName") String userName ,@FormParam("emailId") String emailId ,@FormParam("profileImageURL") String profileImageURL,@FormParam("mobileNumber") String mobileNumber,@FormParam("stateId") String stateId,@FormParam("defaultDistrictId") String defaultDistrictId,@FormParam("userId") String userId)
	{
 UserVO vo=new UserVO();
 vo.setEmailId(emailId);
 vo.setUserName(userName);
 vo.setProfileImageURL(profileImageURL);
 vo.setMobileNumber(mobileNumber);
 vo.setState(stateId);
 vo.setDefaultDistrict(defaultDistrictId);
 vo.setUserId(userId);
 return UserControllerImpl.getInstance().updateUserProfile(vo);
	}
	
	
	@Path("/login/")
	@POST
	@Produces(MediaType.APPLICATION_JSON)
	public ResponseVO<DepartmentUserVO> login(@FormParam("userName") String userName ,@FormParam("password") String password,@FormParam("deviceOS") String deviceOS)
	{
 return DepartmentUserControllerImpl.getInstance().login(userName,password,deviceOS);
	}
*/



	/*@Path("/updateDepartmentUserProfile/")
	@POST
	@Produces(MediaType.APPLICATION_JSON)
	public ResponseVO<String> updateDepartmentUserProfile(@FormParam("userName") String userName ,@FormParam("password") String password)
	{
 return DepartmentUserControllerImpl.getInstance().updateDepartmentUserProfile(userName,password);
	}*/




/*
@Path("/submitUserDrivingRecords/")
@POST
@Produces(MediaType.APPLICATION_JSON)
public ResponseVO<String> submitUserDrivingRecords(@FormParam("userId")String userId,@FormParam("lat")String lat, @FormParam("lon")String lon, @FormParam("speed") String speed)
{
    return UserControllerImpl.getInstance().submitUserDrivingRecords(userId, lat, lon, speed);
}

@Path("/uploadImage/")
@POST
@Consumes(MediaType.MULTIPART_FORM_DATA)
public Response uploadAttachment(@FormDataParam("file") InputStream uploadedInputStream,@FormDataParam("file") FormDataContentDisposition fileDetail)
{
    Calendar calendar = GregorianCalendar.getInstance();
    String fileName=FilenameUtils.getBaseName(fileDetail.getFileName());
    String extension=FilenameUtils.getExtension(fileDetail.getFileName());
    String uploadedFileLocation = "/var/www/html/shield/image_uploads/" + fileName+"_"+calendar.getTimeInMillis()+"."+extension;
    FileUtils.writeToFile(uploadedInputStream, uploadedFileLocation);
    String output = "http://128.199.129.241/shield/image_uploads/"+fileName+"_"+calendar.getTimeInMillis()+"."+extension;
    return Response.status(200).entity(output).build();
}

@Path("/registerPushNotificationId/")
@POST
@Produces(MediaType.APPLICATION_JSON)
public ResponseVO<String> registerPushNotificationId(@FormParam("userId") String agentId,@FormParam("pushNotificationId") String pushNotificationId)
{
    
    ResponseVO<String> responseObject = UserControllerImpl.getInstance().registerPushNotificationId(agentId,pushNotificationId);
    return responseObject;
}

@Path("/registerDepartmentUserPushNotificationId/")
@POST
@Produces(MediaType.APPLICATION_JSON)
public ResponseVO<String> registerDepartmentUserPushNotificationId(@FormParam("userId") String userId,@FormParam("pushNotificationId") String pushNotificationId)
{
    
    ResponseVO<String> responseObject = DepartmentUserControllerImpl.getInstance().registerDepartmentUserPushNotificationId(userId,pushNotificationId);
    return responseObject;
}


@Path("/generateOtp/")
@POST
@Produces(MediaType.APPLICATION_JSON)
public ResponseVO<String> generateOtp(@FormParam("mobileNumber")String mobileNumber)
{
    return UserControllerImpl.getInstance().generateOtp(mobileNumber);
}

@Path("/verifyOtp/")
@POST
@Produces(MediaType.APPLICATION_JSON)
public ResponseVO<String> verifyOtp(@FormParam("otp")String otp,@FormParam("mobileNumber")String mobileNumber)
{
    OtpVO o=new OtpVO();
    o.setMobileNumber(mobileNumber);
    o.setOtp(otp);
    return UserControllerImpl.getInstance().verifyOtp(o);
}

@Path("/getAlertsForCategory/")
@POST
@Produces(MediaType.APPLICATION_JSON)
public ResponseVO<List<AlertVO>> getAlertsForCategory(@FormParam("category")String category,@FormParam("stateId")String stateId,@FormParam("districtId")String districtId)
{
    return AlertControllerImpl.getInstance().getAlertsForCategory(category,stateId,districtId);
}

@Path("/getEducationContentForType/")
@POST
@Produces(MediaType.APPLICATION_JSON)
public ResponseVO<List<EducationalContentVO>> getEducationContentForType(@FormParam("type")String type)
{
    return EducationalContentControllerImpl.getInstance().getEducationContentForType(type);
}

@Path("/getEmergencyDirectoryForDepartment/")
@POST
@Produces(MediaType.APPLICATION_JSON)
public ResponseVO<List<EmergencyContactVO>> getEmergencyDirectoryForDepartment(@FormParam("department")String department,@FormParam("stateId")String stateId,@FormParam("districtId")String districtId)
{
    return EmergencyDirectoryControllerImpl.getInstance().getEmergencyDirectoryForDepartment(department,stateId,districtId);
}

@Path("/getHighwayFacilityListByType/")
@POST
@Produces(MediaType.APPLICATION_JSON)
public ResponseVO<List<HighwayFacilityVO>> getHighwayFacilityListByType(@FormParam("type")String type,@FormParam("stateId")String stateId,@FormParam("highwayId")String highwayId,@FormParam("lat")String lat,@FormParam("lon")String lon)
{
    return HighwayFacilityDirectoryControllerImpl.getInstance().getHighwayFacilityListByType(type,stateId,highwayId,lat,lon);
}

@Path("/getAmbulanceList/")
@POST
@Produces(MediaType.APPLICATION_JSON)
public ResponseVO<List<AmbulanceVO>> getAmbulanceList()
{
    return AmbulanceControllerImpl.getInstance().getAmbulanceList();
}

@Path("/reportIssue/")
@POST
@Produces(MediaType.APPLICATION_JSON)
public ResponseVO<String> reportIssue(@FormParam("category")String category,@FormParam("lat")String lat,@FormParam("lon")String lon,@FormParam("postedBy")String postedBy,@FormParam("description")String description,@FormParam("uploadedImageURL")String uploadedImageURL,@FormParam("stateId")String stateId)
{
    IssueVO vo = new IssueVO();
    vo.setCategory(category);
    vo.setDescription(description);
    vo.setLat(lat);
    vo.setLon(lon);
    vo.setStateId(stateId);
    vo.setPostedBy(postedBy);
    vo.setUploadedImageURL(uploadedImageURL);
    return ReportControllerImpl.getInstance().reportIssue(vo);
}

@Path("/reportEmergency/")
@POST
@Produces(MediaType.APPLICATION_JSON)
public ResponseVO<String> reportEmergency(@FormParam("lat")String lat,@FormParam("lon")String lon,@FormParam("postedBy")String postedBy,@FormParam("description")String description,@FormParam("uploadedImageURL")String uploadedImageURL,@FormParam("stateId")String stateId)
{
    EmergencyVO vo = new EmergencyVO();
    vo.setDescription(description);
    vo.setLat(lat);
    vo.setLon(lon);
    vo.setStateId(stateId);
    vo.setPostedBy(postedBy);
    vo.setUploadedImageURL(uploadedImageURL);
    return ReportControllerImpl.getInstance().reportEmergency(vo);
}

@Path("/getListOfReportedIssues/")
@POST
@Produces(MediaType.APPLICATION_JSON)
public ResponseVO<List<IssueVO>> getListOfOpenReportedIssues(@FormParam("stateId") String stateId)
{
    return ReportControllerImpl.getInstance().getListOfOpenReportedIssues(stateId);
}

@Path("/getListOfReportedEmergencies/")
@POST
@Produces(MediaType.APPLICATION_JSON)
public ResponseVO<List<EmergencyVO>> getListOfOpenReportedEmergencies(@FormParam("stateId") String stateId)
{
    return ReportControllerImpl.getInstance().getListOfOpenReportedEmergencies(stateId);
}



@Path("/getDistrictList/")
@POST
@Produces(MediaType.APPLICATION_JSON)
public ResponseVO<List<DistrictVO>> getDistrictList(@FormParam("stateId") String stateId)
{
    return LocationControllerImpl.getInstance().getDistrictList(stateId);
}

@Path("/getHighwayList/")
@POST
@Produces(MediaType.APPLICATION_JSON)
public ResponseVO<List<HighwayVO>> getHighwayList(@FormParam("stateId") String stateId)
{
    return LocationControllerImpl.getInstance().getHighwayList(stateId);
}

}

*/
