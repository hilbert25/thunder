pragma solidity ^0.4.16;

contract Main{

  struct User{
    uint256 userId;
    bytes32 userName;
    bytes32 userPhone;
    bytes32 userPassword;
  }


  struct Endorsor{
    uint256 endorsorId;
    bytes32 endorsorOrg;//背书节点所属机构
    bytes32 endorsorProvince;
    bytes32 endorsorEmail;
    bytes32 endorsorPassword;
    EndorseItem[] endorseRecord;
  }

  struct School{
    uint256 schoolId;
    bytes32 schoolName;
    bytes32 schoolEmail;
    bytes32 schoolPassword;
    bytes32 schoolProvince;
    bytes32 schoolAddress;
    bytes32 schoolGovernor;//主管部门
    bytes32 schoolAgent;//代理人负责人
    bool schoolState;//是否可以发起项目
  }

  struct Project{
    uint256 projectId;
    uint256 projectCreator;
    bytes32 projectName;
    bytes32 projectCreateTime;
    bytes32 projectTarget;//项目用途
    uint256 projectTargetMoney;
    uint256 projectCurrentMoney;
    bytes32 projectEndorseState;
    bool projectFinishState;
    bytes32 projectFinishTime;
    bytes32[] projectNoteUrl;//票据图片地址
    bytes32 projectPlanUpNoteTime;//计划上传票据时间
    bytes32 projectActualUpNoteTime;//实际计划上传票据时间
    uint256 totalEndorsor;
    uint256 passEndorsor;
  }

  struct Denote {
    uint256 denoteId;
    uint256 userId;
    uint256 projectId;
    uint256 denoteMoney;
    bytes32 denoteTime;
  }


  struct EndorseItem{
    uint256 endorseItemId;
    uint256 projectId;
    uint256 endorsorId;
    uint256 operate;//{0:未处理 1：通过 2：拒绝}
  }


  User[] userList;
  mapping(bytes32=>uint256) userMap;//key是手机号

  Endorsor[] endorsorList;
  mapping(bytes32=>uint256) endorsorMap;//key是邮箱 value是projectId

  School[] schoolList;
  mapping(bytes32=>uint256)schoolMap;//key是邮箱

  Project[] projectList;

  Denote[] denoteList;
  mapping(uint256=>Denote[]) userDenoteMap;//用户捐赠记录
  mapping(uint256=>Denote[]) projectDenoteMap;//项目获捐记录。
  mapping(uint256=>EndorseItem[]) endorseItemMap;//背书节点背书记录
  mapping(uint256=>Project[]) schoolProjectMap;

    function Main() {
        createUser("0", 0, "0");
        createSchool("0", "0", "0", "0", "0", "0", "0"); 
    }

    function createUser(bytes32 _userName, bytes32 _userPhone, bytes32 _userPassword) {
        uint256 _userId = userCount();
        User memory user = User({userId:_userId, userName:_userName, userPhone:_userPhone, userPassword:_userPassword});
        userList.push(user);
        userMap[_userPhone] = _userId;
    }

    function userCount() view returns(uint256) {
        return userList.length;
    }

    function checkUserByPhone(bytes32 _userPhone) view returns(bool) {
        return userMap[_userPhone] != 0;
    }

    function getUserIdByPhone(bytes32 _userPhone) view returns(uint256){
        return userMap[_userPhone];
    }

    function getUserByUserId(uint256 _userId) returns(uint256, bytes32, bytes32){
        User user = userList[_userId];
        return(user.userId, user.userName, user.userPhone);
    }

    function login(bytes32 _userAccount, bytes32 _userPassword) returns(uint256 userType, uint256 userId){
        uint256 _userType = 0;
        uint256 _userId = 0;
        _userId = getUserIdByPhone(_userAccount);
        if (_userId != 0) {
            _userType = 1;
            return (_userType, _userId);
        }
        return (0, 0);
    }
  // /**
  // * returns {1:捐多了 0:success}
  // **/
  // function userDenote(uint256 _userId,uint256 _projectId,uint256 _denoteMoney) returns(uint256){
  //   Project project = projectList[_projectId];
  //   if(project.projectCurrentMoney +_denoteMoney > project.projectTargetMoney){
  //     return 1;
  //   }
  //   uint256 _denoteId = denoteCount();
  //   Denote memory denote = Denote({denoteId:_denoteId,userId:_userId,projectId:_projectId,denoteMoney:_denoteMoney,denoteTime:now});
  //   denoteList.push(denote);
  //   userDenoteMap[_userId].push(denote);
  //   projectDenoteMap[_projectId].push(denote);
  //   project.projectCurrentMoney += _denoteMoney;
  //   return 0;
  // }

  // function getDenoteListByUserId(uint256 _userId,uint _beginId,uint _endId) returns(uint256[],uint256[],uint256[],uint256[]){
  //   Denote[] denoteList = userDenoteMap[_userId];
  //   uint256[] denoteIdList;
  //   uint256[] projectIdList;
  //   uint256[] denoteMoneyList;
  //   uint256[] denoteTimeList;
  //   if(denoteList.length<=_beginId){
  //     _beginId = denoteList.length-1;
  //   }
  //   if(denoteList.length<=_endId){
  //     _endId = denoteList.length-1;
  //   }
  //   for(uint256 i=_beginId;i<=_endId;i++){
  //     Denote denote = denoteList[i];
  //     denoteIdList.push(denote.denoteId);
  //     projectIdList.push(denote.projectId);
  //     denoteMoneyList.push(denote.denoteMoney);
  //     denoteTimeList.push(denote.denoteTime);
  //   }
  //   return (denoteIdList,projectIdList,denote.projectId,denoteMoneyList,denoteTimeList);
  // }
  // ///////////////////////////////////////////////////////////////////////////////////////////////////
  // /**
  // * @parm:bytes32 _endorsorOrg, bytes32 _endorsorProvince, bytes32 _endorsorEmail, bytes32 _endorsorPassword
  // * @return:uint256 {0:success,1:userPhone has been registered}
  // **/
  // function createEndorsor(bytes32 _endorsorOrg, bytes32 _endorsorProvince, bytes32 _endorsorEmail, bytes32 _endorsorPassword ){
  //   if(checkEndorsorByEmail(_endorsorEmail)){
  //     return 1;
  //   }
  //   uint256 _endorsorId = endorsorCount();
  //   User memory user = User({userId:_userId,userName:userName,userPassword:_userPassword});
  //   userList.push(user);
  //   userMap[_userPhone] = user;
  //   return 0;
  // }


  // function endorsorCount() view returns(uint256){
  //   return endorsorList.length;
  // }


  // function checkEndorsorByEmail(uint256 _endorsorEmail) view returns(bool){
  //   return endorsorMap[_endorsorEmail].endorsorId != 0;
  // }

  // function getEndorsorIdByEmail(bytes32 _endorsorEmail) view returns(){
  //   return endorsorMap[_endorsorEmail].endorsorId;

  // }

  // function getEndorsorByEndorsorId(uint256 _endorsorId) view returns(uint256,bytes32,bytes32,bytes32){
  //   Endorsor _endorsor =  endorsorList[_endorsorId];
  //   return (_endorsor.endorsorId,_endorsor.endorsorOrg,_endorsor.endorsorProvince,_endorsor.endorsorEmail);
  // }

  // function dealEndorse(uint256 _projectId,uint256 _endorsorId, uint256 _operate){
  //   createEndorseItem(_projectId,_endorsorId,_operate);
  // }

  // function getEndorseListByEndorsorId(uint256 _endorsorId) view returns (uint256[],uint256[],uint256[]){
  //   EndorseItem[] _endorseItemList = endorseItemMap[_endorsorId];
  //   uint256[] _projectIdList;
  //   uint256[] _endorseIdList;
  //   uint256[] _operateList;
  //   for(uint256 i=0;i<_endorseItemList.list;i++){
  //     _projectIdList.push(_endorseItemList[i].projectId);
  //     _endorseIdList.push(_endorseItemList[i].endorseId);
  //     _operateList.push(_endorseItemList[i].operate);
  //   }
  //   return (_projectIdList,_endorseIdList,_operateList);
  // }
  // function createEndorseItem(uint256 _projectId, uint256 _endorsorId,uint256 _operate){
  //   Endorsor _endorsor =  endorsorList[_endorsorId];
  //   uint256 _endorseItemCount = _endorsor.endorseRecord.length;
  //   EndorseItem endorseItem = EndorseItem({endorseItemId:_endorseItemCount,projectId:_projectId,endorsorId:_endorsorId,operate:_operate});
  //   endorseItemMap[_endorsorId].push(endorseItem);
  // }
  // ///////////////////////////////////////////////////////////////////////////////////////////////////////
    
    function createSchool(bytes32 _schoolEmail, bytes32 _schoolName, bytes32 _schoolPassword, bytes32 _schoolProvince, bytes32 _schoolAddress, bytes32 _schoolGovernor, bytes32 _schoolAgent) {
        uint256 _schoolId = schoolCount();
        School memory school = School({schoolId:_schoolId, schoolName:_schoolName, schoolEmail:_schoolEmail, schoolPassword:_schoolPassword, schoolProvince:_schoolProvince, schoolAddress:_schoolAddress, schoolGovernor:_schoolGovernor, schoolAgent:_schoolAgent, schoolState:true});
        schoolList.push(school);
        schoolMap[_schoolEmail] = _schoolId;
    }

    function schoolCount() view returns(uint256) {
        return schoolList.length;
    }

    function checkSchoolByEmail(bytes32 _schoolEmail) view returns(bool){
      return schoolMap[_schoolEmail] != 0;
    }

    function getSchoolIdByEmail(bytes32 _schoolEmail) view returns(uint256) {
      return schoolMap[_schoolEmail];
    }

    function getSchoolBySchoolId(uint256 _schoolId) view returns(bytes32, bytes32, bytes32, bytes32, bytes32, bytes32, bool) {
        School school = schoolList[_schoolId];
        return (school.schoolName, school.schoolEmail, school.schoolProvince, school.schoolAddress, school.schoolGovernor, school.schoolAgent, school.schoolState);
    }

  // function getProjectsBySchoolId(uint256 _schoolId) returns(Project[]) view {
  //   School school = schoolList[_schoolId];
  //   Project[] projects;
  //   for(i = 0 ; i < school.project.length ; i ++){
  //     Project project = projectList[school.project[i]];
  //     projects.push(project);
  //   }
  //   return projects;
  // }

  // function createProject(uint256 _schoolId,bytes32 _projectName,bytes32 _projectTarget,uint256 _projectTargetMoney,bytes32 _projectFinishTime) returns(uint256){
  //   Project memorey project = Project({projectCreator:_schoolId, projectName:_projectName, projectCreateTime:now, projectTarget:_projectTarget, projectTargetMoney:_projectTargetMoney, projectFinishTime:_projectFinishTime})
  //   projectList.push(school);
  //   return 0;
  // }

  // function getProjectByprojectId(uint256 _projectId) view returns(uint256,uint256,bytes32,bytes32,bytes32,uint256,uint256,bytes32,bool,bytes32,bytes32[],bytes32,bytes32,uint256,uint256){
  //   Project project = projectList[_projectId];
  //   return (projectId,projectCreator,projectName,projectCreateTime,projectTarget,projectTargetMoney,projectCurrentMoney,projectEndorseState,projectFinishState,projectFinishTime,projectNoteUrl,projectPlanUpNoteTime,projectActualUpNoteTime,totalEndorsor,passEndorsor)
  //   }
  // ///////////////////////////////////////////////////////////////////////////////////////////////////////

  // ///////////////////////////////////////////////
  // function denoteCount() returns(uint256){
  //   return denoteList.length;
  // }
}
