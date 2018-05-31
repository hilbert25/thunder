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
    string endorsorOrgType;//教育 财务 审计 司法……
    string endorsorProvince;
    string endorsorEmail;
    string endorsorPassword;
    uint256[] endorseRecord;
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
    uint256[] projectRecord;
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
  }

  struct Denote {
    uint256 denoteId;
    uint256 userId;
    uint256 projectId;
    uint256 denoteMoney;
    string denoteTime;
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

  function getUserByUserId(uint256 _userId) returns(uint256,string,uint256,uint256[]){
    User user = userList[_userId];
    return(user.userId,user.userName,user.userPhone,userDenoteRecord,userDenoteMap[_userId]);
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

  function getEndorsorIdByEmail() returns(){

  }
  function getEndorsorByEndorsorId() returns(){

  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////
  function createSchool() returns(bool){

  }


  function schoolCount() returns(uint256){
    return schoolList.length;
  }


  function checkSchoolByEmail(uint256 _schoolEmail) returns(bool){
    return schoolMap[_schoolEmail].schoolId != 0;
  }

  function getSchoolIdByEmail() returns(){

  }
  function getSchoolByEndorsorId() returns(){

  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////
  function createProject(){

  }

  ///////////////////////////////////////////////
  function denoteCount() returns(uint256){
    return denoteList.length;
  }
}
