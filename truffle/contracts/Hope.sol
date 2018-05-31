pragma solidity ^0.4.16;

contract Hope{

  struct User{
    uint256 userId;
    string userName;
    uint256 userPhone;
    string userPassword;
    uint256[] denoteRecord;
  }

  struct Endorsor{
    uint256 endorsorId;
    string endorsorOrg;//背书节点所属机构,教育民政财务……
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
    string projectId;
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

  User[] userList;
  mapping(string=>uint256) userMap;//key是手机号
  Endorsor[] endorsorList;
  mapping(string=>uint256) endorsorMap;//key是邮箱
  School[] schoolList;
  mapping(string=>uint256)schoolMap;//key是邮箱
  Project[] projectList;

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

  }

  function getUserByUserId(uint256 _userId) returns(){

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
}
