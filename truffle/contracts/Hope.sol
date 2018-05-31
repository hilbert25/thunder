pragma solidity ^0.4.16;

contract Hope{

  struct User{
    uint256 userId;
    string userName;
    uint256 userPhone;
    string userPassword;
  }


  struct Endorsor{
    uint256 endorsorId;
    string endorsorOrg;//背书节点所属机构
    string endorsorProvince;
    string endorsorEmail;
    string endorsorPassword;
    EndorseItem[] endorseRecord;
  }

  struct School{
    uint256 schoolId;
    string schoolName;
    string schoolEmail;
    string schoolPassword;
    string schoolProvince;
    string schoolAddress;
    string schoolGovernor;//主管部门
    string schoolAgent;//代理人负责人
    Project[] projectRecord;
    string schoolState;//是否可以发起项目
  }

  struct Project{
    uint256 projectId;
    uint256 projectCreator;
    string projectName;
    string projectCreateTime;
    string projectTarget;//项目用途
    uint256 projectTargetMoney;
    uint256 projectCurrentMoney;
    string projectEndorseState;
    bool projectFinishState;
    string projectFinishTime;
    string[] projectNoteUrl;//票据图片地址
    string projectPlanUpNoteTime;//计划上传票据时间
    string projectActualUpNoteTime;//实际计划上传票据时间
    uint256 totalEndorsor;
    uint256 passEndorsor;
  }

  struct Denote {
    uint256 denoteId;
    uint256 userId;
    uint256 projectId;
    uint256 denoteMoney;
    string denoteTime;
  }


  struct EndorseItem{
    uint256 endorseItemIt;
    uint256 projectId;
    uint256 endorsorId;
    string operate;//pass or reject or undeal
  }
  User[] userList;
  mapping(string=>uint256) userMap;//key是手机号

  Endorsor[] endorsorList;
  mapping(string=>uint256) endorsorMap;//key是邮箱

  School[] schoolList;
  mapping(string=>uint256)schoolMap;//key是邮箱

  Project[] projectList;

  Denote[] denoteList;
  mapping(uint256=>Denote[]) userDenoteMap;//用户捐赠记录
  mapping(uint256=>Denote[]) projectDenoteMap;//项目获捐记录。

  function Hope(){
    createUser("0",0,"0");
  }
  //////////////////////////////////////////////////////////////////////////////////////////////////////
  /**
  * @parm:string _userName, uint256 _userPhone, string _userPassword
  * @return:uint256 {0:success,1:userPhone has been registered}
  **/
  function createUser(string _userName, uint256 _userPhone, string _userPassword) returns(uint256){
    if(checkUserByPhone(_userPhone)){
      return 1;
    }
    uint256 _userId = userCount();
    User memory user = User({userId:_userId,userName:userName,userPassword:_userPassword});
    userList.push(user);
    userMap[_userPhone] = userId;
    return 0;
  }

  /**
  * @return:uint256
  **/
  function userCount() returns(uint256){
    return userList.length;
  }

  /**
  * @parm:uint256 _userPhone
  * @return: {true:existed false:not exist}
  **/
  function checkUserByPhone(uint256 _userPhone) returns(bool){
    return userMap[_userPhone].userId != 0;
  }

  function getUserIdByPhone(uint256 _userPhone) returns(uint256){
    return userMap[_userPhone].userId;
  }

  function getUserByUserId(uint256 _userId) returns(uint256,string,uint256){
    User user = userList[_userId];
    return(user.userId,user.userName,user.userPhone,userDenoteRecord);
  }

  function userLogin(string _userPhone,string _userPassword) returns(bool){
    uint256 _userId = getUserIdByPhone(_userPhone);
    User user = userList[_userId];
    return _userId!=0 && user.userPassword == _userPassword;
  }
  /**
  * returns {1:捐多了 0:success}
  **/
  function userDenote(uint256 _userId,uint256 _projectId,uint256 _denoteMoney) returns(uint256){
    Project project = projectList[_projectId];
    if(project.projectCurrentMoney +_denoteMoney > project.projectTargetMoney){
      return 1;
    }
    uint256 _denoteId = denoteCount();
    Denote memory denote = Denote({denoteId:_denoteId,userId:_userId,projectId:_projectId,denoteMoney:_denoteMoney,denoteTime:now});
    denoteList.push(denote);
    userDenoteMap[_userId].push(denote);
    projectDenoteMap[_projectId].push(denote);
    project.projectCurrentMoney += _denoteMoney;
    return 0;
  }

  function getUserList(uint256 _beginUserId,uint256 _endUserId)returns(uint256[] userIdList,string[] userNameList,string[]userPhoneList){
    uint256 _userCount = userCount();
    if(_userCount<_beginUserId){
      _beginUserId=_userCount;
    }
    if(_userCount<_endUserId){
      _endUserId=_userCount;
    }
    uint256[] userIdList;
    string[] userNameList;
    string[] userPhoneList;
    for(uint256 i=_beginUserId;i<=_endUserId;i++){
      User memory user = userList[i];
      userIdList.push(user.userId);
      userNameList.push(user.userName);
      userPhoneList.push(user.userPhone);
    }
    return (userIdList,userNameList,userPhoneList);
  }

  function getDenoteListByUserId(uint256 _userId,uint _beginId,uint _endId) returns(uint256[],uint256[],uint256[],uint256[]){
    Denote[] denoteList = userDenoteMap[_userId];
    uint256[] denoteIdList;
    uint256[] projectIdList;
    uint256[] denoteMoneyList;
    uint256[] denoteTimeList;
    if(denoteList.length<=_beginId){
      _beginId = denoteList.length-1;
    }
    if(denoteList.length<=_endId){
      _endId = denoteList.length-1;
    }
    for(uint2256 i=_beginId;i<=_endId;i++){
      Denote denote = denoteList[i];
      denoteIdList.push(denote.denoteId);
      projectIdList.push(denote.projectId);
      denoteMoneyList.push(denote.denoteMoney);
      denoteTimeList.push(denote.denoteTime);
    }
    return (denoteIdList,projectIdList,denote.projectId,denoteMoneyList,denoteTimeList);
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////
  /**
  * @parm:string _endorsorOrg, string _endorsorProvince, string _endorsorEmail, string _endorsorPassword
  * @return:uint256 {0:success,1:userPhone has been registered}
  **/
  function createEndorsor(string _endorsorOrg, string _endorsorProvince, string _endorsorEmail, string _endorsorPassword ){
    if(checkEndorsorByEmail(_endorsorEmail)){
      return 1;
    }
    uint256 _endorsorId = endorsorCount();
    User memory user = User({userId:_userId,userName:userName,userPassword:_userPassword});
    userList.push(user);
    userMap[_userPhone] = user;
    return 0;
  }


  function endorsorCount() returns(uint256){
    return endorsorList.length;
  }


  function checkEndorsorByEmail(uint256 _endorsorEmail) returns(bool){
    return endorsorMap[_endorsorEmail].endorsorId != 0;
  }

  function getEndorsorIdByEmail(string _endorsorEmail) returns(){
    return endorsorMap[_endorsorEmail].endorsorId;

  }

  function getEndorsorByEndorsorId(uint256 _endorsorId) returns(uint256,string,string,string){
    Endorsor _endorsor =  endorsorList[_endorsorId];
    return (_endorsor.endorsorId,_endorsor.endorsorOrg,_endorsor.endorsorProvince,_endorsor.endorsorEmail);
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////////////
  function createSchool(string _schoolname, string _schoolEmail, string _schoolPassword, string _schoolProvince, string _schoolAddress, string _schoolGovernor, string _schoolAgent) returns(bool){
    if(checkSchoolByEmail(_schoolEmail)){
      return 1;
    }
    uint26 _schoolId = schoolCount();
    School memory school = School({schoolId:_schoolId,schoolName:schoolName,schoolEmail:_schoolEmail,schoolPassword:_schoolPassword,schoolProvince:_schoolProvince,schoolAddress:_schoolAddress,schoolGovernor:_schoolGovernor,schoolAgent:_schoolAgent});
    schoolList.push(school);
    schoolMap[_schoolemail] = schoolId;
    return 0;
  }

  function schoolCount() view returns(uint256){
    return schoolList.length;
  }

  function checkSchoolByEmail(string _schoolEmail) view returns(bool){
    return schoolMap[_schoolEmail].schoolId != 0;
  }

  function getSchoolIdByEmail() returns() view{
    return schoolMap[_schoolEmail].schoolId;
  }

  function getSchoolBySchoolId(uint 256 _schoolId) returns(string, string, string, string, string, string, uint256[]) view{
    School school = schoolList[_schoolId];
    return (school.schoolname, school.schoolEmail, school.Province, school.schoolAddress, school.schoolGovernor, school.schoolAgent,school.projectRecord);
  }

  function getProjectsBySchoolId(uint256 _schoolId) returns(Project[]) view {
    School school = schoolList[_schoolId];
    Project[] projects;
    for(i = 0 ; i < school.project.length ; i ++){
      Project project = projectList[school.project[i]];
      projects.push(project);
    }
    return projects;
  }

  function createProject(uint256 _schoolId,string _projectName,string _projectTarget,uint256 _projectTargetMoney,string _projectFinishTime) returns(uint256){
    Project memorey project = Project({projectCreator:_schoolId, projectName:_projectName, projectCreateTime:now, projectTarget:_projectTarget, projectTargetMoney:_projectTargetMoney, projectFinishTime:_projectFinishTime})
    projectList.push(school);
    return 0;
  }

  function getProjectByprojectId(uint256 _projectId) view returns(uint256,uint256,string,string,string,uint256,uint256,string,bool,string,string[],string,string,uint256,uint256){
    Project project = projectList[_projectId];
    return (projectId,projectCreator,projectName,projectCreateTime,projectTarget,projectTargetMoney,projectCurrentMoney,projectEndorseState,projectFinishState,projectFinishTime,projectNoteUrl,projectPlanUpNoteTime,projectActualUpNoteTime,totalEndorsor,passEndorsor)
    }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////

  ///////////////////////////////////////////////
  function denoteCount() returns(uint256){
    return denoteList.length;
  }
}
