pragma solidity ^0.4.16;

contract Main {

    struct Admin {
        uint256 adminId;
        string adminAccount;
        string admingPassword;
    }

    struct User {
        uint256 userId;
        string userName;
        string userPhone;
        string userPassword;
    }

    struct Endorsor {
        uint256 endorsorId;
        string endorsorOrg;//背书节点所属机构
        string endorsorProvince;
        string endorsorEmail;
        string endorsorPassword;

    }

    struct School {
        uint256 schoolId;
        string schoolName;
        string schoolEmail;
        string schoolPassword;
        string schoolProvince;
        
        string schoolAddress;
        string schoolGovernor;//主管部门
        string schoolAgent;//代理人负责人
        bool schoolState;//是否可以发起项目
    }

    struct Project {
        uint256 projectId;
        uint256 schoolId;
        string projectName;
        uint256 projectCreateTime;
        string projectTarget;//项目用途
        uint256 projectTargetMoney;
        uint256 projectCurrentMoney;
        uint256 projectEndorseState;//0 通过 1 未通过 2 pending
        bool projectFinishState;
        uint256 projectFinishTime;
        uint256 projectPlanUpNoteTime;//计划上传票据时间
        uint256 projectActualUpNoteTime;//实际计划上传票据时间
        int256 totalScore;// 总分
        uint256 totalEndorsor;//背书节点数量
        uint256 finishEndorsor;//参与的背书节点数量
    }

    struct Denote {
        uint256 denoteId;//捐赠id
        uint256 userId;//捐赠人id
        uint256 projectId;//捐赠项目id
        uint256 denoteMoney;//捐了多少钱
        uint256 denoteTime;//捐赠时间
    }

    struct EndorseItem {
        uint256 endorseItemId;
        uint256 projectId;
        uint256 endorsorId;
        int256 score;//不能是0分
    }


    User[] userList;
    mapping(string=>uint256) userMap;//key是手机号

    Endorsor[] endorsorList;
    mapping(string=>uint256) endorsorMap;//key是邮箱 value是projectId

    School[] schoolList;
    mapping(string=>uint256) schoolMap;//key是邮箱

    Project[] projectList;
    Denote[] denoteList;
    EndorseItem[] endorseItemList;
    mapping(uint256=>Denote[]) userDenoteMap;//用户捐赠记录
    mapping(uint256=>Denote[]) projectDenoteMap;//项目获捐记录。
    mapping(uint256=>uint256[]) endorseItemMap;//背书节点背书记录
    mapping(uint256=>uint256[]) schoolProjectMap;
    mapping(uint256=>string[]) projectNoteUrlMap;
    mapping(string=>uint256[]) provinceToEndorsorMap;
    mapping(uint256=>uint256[]) projectEnodrsorListMap;//给该项目背书的节点
    uint256 public test = 0;
    function getUserDenoteCount(uint256 userId) public view returns(uint256) {
        require(userId < userList.length);
        return userDenoteMap[userId].length;
    } 
 
    function getProjectDenoteCount(uint256 projectId) public view returns(uint256) {
        require(projectId < projectList.length);
        return projectDenoteMap[projectId].length;
    }

    function getEndorseItemRecord(uint256 endorseId) public view returns(uint256) {
        require(endorseId < endorsorList.length);
        return endorseItemMap[endorseId].length;
    }

    function getSchoolProjectCount(uint256 schoolId) public view returns(uint256) {
        require(schoolId < schoolList.length);
        return schoolProjectMap[schoolId].length;
    }
    
    function projectEnodrsorListCount(uint256 projectId) public view returns(uint256) {
        return projectEnodrsorListMap[projectId].length;
    }

    function getProvinceToEndorsorCount(uint256 schoolId) public view returns(uint256) {
        School school = schoolList[schoolId];
        return provinceToEndorsorMap[school.schoolProvince].length;
    }

    function Main() {
        createUser("0", "0", "0");
        createSchool("0", "0", "0", "0", "0", "0", "0"); 
        createProject(0, "0", "0", 0, 0);
        createEndorsor("0", "0", "0", "0");
    }

    function createUser(string _userName, string _userPhone, string _userPassword) {
        require(!checkUserByPhone(_userPhone));
        uint256 _userId = userCount();
        User memory user = User({userId:_userId, userName:_userName, userPhone:_userPhone, userPassword:_userPassword});
        userList.push(user);
        userMap[_userPhone] = _userId;
    }

    function getBytes32() view returns(string) {
        string memory str = "abc";
        return str;
    }
    function userCount() view returns(uint256) {
        return userList.length;
    }

    function checkUserByPhone(string _userPhone) view returns(bool) {
        return userMap[_userPhone] != 0;
    }

    function getUserIdByPhone(string _userPhone) view returns(uint256) {
        return userMap[_userPhone];
    }

    function getUserByUserId(uint256 _userId) view returns(uint256, string, string) {
        require(_userId < userList.length);
        User user = userList[_userId];
        return(user.userId, user.userName, user.userPhone);
    }

    function login(string _userAccount, string _userPassword) view returns(uint256, uint256) {
        uint256 _userType = 0;
        uint256 _userId = 0;
        uint256 _userIdA = getUserIdByPhone(_userAccount);
        User memory user = userList[_userIdA];
        uint256 _userIdB = getSchoolIdByEmail(_userAccount);
        School memory school = schoolList[_userIdB];
        uint256 _userIdC = getEndorsorIdByEmail(_userAccount);
        Endorsor memory endorsor = endorsorList[_userIdC];
        _userId = _userIdA ^ _userIdB ^ _userIdC;

        if (_userIdA != 0 && strEqual(user.userPassword, _userPassword)) {
            _userType = 1;
        }else if (_userIdB != 0 && strEqual(school.schoolPassword, _userPassword)) {
            _userType = 2;
        }else if (_userIdC != 0 && strEqual(endorsor.endorsorPassword, _userPassword)) {
            _userType = 3;
        }else if (strEqual(_userAccount, "admin") && strEqual(_userPassword, "admin") ) {
            _userType = 4;
        }
        return (_userType, _userId);
    }

    function userDenote(uint256 _userId, uint256 _projectId, uint256 _denoteMoney) returns(uint256) {
        require(_userId < userList.length && _projectId < projectList.length);
        Project project = projectList[_projectId];
        uint256 _denoteId = denoteCount();
        Denote memory denote = Denote({denoteId:_denoteId, userId:_userId, projectId:_projectId, denoteMoney:_denoteMoney, denoteTime:now});
        denoteList.push(denote);
        userDenoteMap[_userId].push(denote);
        projectDenoteMap[_projectId].push(denote);
        project.projectCurrentMoney = add(project.projectCurrentMoney, _denoteMoney);
    }

    function denoteCount() view returns(uint256) {
        return denoteList.length;
    }

    function getDenoteByUserId(uint256 _userId, uint _userDenoteId) view returns(uint256, uint256, uint256, uint256) {
        require(_userId < userList.length && _userDenoteId < userDenoteMap[_userId].length);
        Denote denote = userDenoteMap[_userId][_userDenoteId];
        return (denote.denoteId, denote.projectId, denote.denoteMoney, denote.denoteTime);
    }
  // ///////////////////////////////////////////////////////////////////////////////////////////////////

    function createEndorsor(string _endorsorOrg, string _endorsorProvince, string _endorsorEmail, string _endorsorPassword) {
        require(!checkEndorsorByEmail(_endorsorEmail));
        uint256 _endorsorId = endorsorCount();
        Endorsor memory endorsor = Endorsor({endorsorId:_endorsorId, endorsorOrg:_endorsorOrg, endorsorProvince:_endorsorProvince, endorsorEmail:_endorsorEmail, endorsorPassword:_endorsorPassword});
        endorsorList.push(endorsor);
        endorsorMap[_endorsorEmail] = _endorsorId;
        provinceToEndorsorMap[_endorsorProvince].push(_endorsorId);
    }

    function endorsorCount() view returns(uint256) {
        return endorsorList.length;
    }

    function checkEndorsorByEmail(string _endorsorEmail) view returns(bool) {
        return endorsorMap[_endorsorEmail] != 0;
    }

    function getEndorsorIdByEmail(string _endorsorEmail) view returns(uint256) {
        return endorsorMap[_endorsorEmail];
    }

    function getEndorsorByEndorsorId(uint256 _endorsorId) view returns(uint256, string, string, string) {
        require(_endorsorId < endorsorList.length);
        Endorsor _endorsor =  endorsorList[_endorsorId];
        return (_endorsor.endorsorId, _endorsor.endorsorOrg, _endorsor.endorsorProvince, _endorsor.endorsorEmail);
    }

    function getEndorseByEndorsorId(uint256 _endorsorId, uint256 _endorseItemIndex) view returns (uint256, uint256, int256) {
         require(_endorsorId < endorsorList.length && _endorseItemIndex < endorseItemMap[_endorsorId].length);
        uint256 endorseItemId = endorseItemMap[_endorsorId][_endorseItemIndex];
        EndorseItem _endorseItem = endorseItemList[endorseItemId];
        return (_endorseItem.endorsorId, _endorseItem.projectId, _endorseItem.score);
    }

    function createEndorseItem(uint256 _projectId, uint256 _endorsorId, int256 _score) {
        require(_projectId < projectList.length);
        uint256 _endorseItemId = endorseItemMap[_endorsorId].length;
        EndorseItem memory endorseItem = EndorseItem({endorseItemId:_endorseItemId, projectId:_projectId, endorsorId:_endorsorId, score:_score});
        endorseItemMap[_endorsorId].push(_endorseItemId);
        endorseItemList.push(endorseItem);
        Project project = projectList[_projectId];
        project.totalScore += _score;
        project.finishEndorsor=add(project.finishEndorsor,1);
        if(project.finishEndorsor == project.totalEndorsor){
            if(project.totalScore>0){
                project.projectEndorseState = 0;
            }else{
                project.projectEndorseState = 1;
            }
        }
    }

    function getEndorseItemCountOfEndorsor(uint256 _endorsorId) view returns(uint256) {
        return endorseItemMap[_endorsorId].length;
    }

  // ///////////////////////////////////////////////////////////////////////////////////////////////////////
    
    function createSchool(string _schoolEmail, string _schoolName, string _schoolPassword, string _schoolProvince, string _schoolAddress, string _schoolGovernor, string _schoolAgent) {
        require(!checkSchoolByEmail(_schoolEmail));
        uint256 _schoolId = schoolCount();
        School memory school = School({schoolId:_schoolId, schoolName:_schoolName, schoolEmail:_schoolEmail, schoolPassword:_schoolPassword, schoolProvince:_schoolProvince, schoolAddress:_schoolAddress, schoolGovernor:_schoolGovernor, schoolAgent:_schoolAgent, schoolState:true});
        schoolList.push(school);
        schoolMap[_schoolEmail] = _schoolId;
    }

    function schoolCount() view returns(uint256) {
        return schoolList.length;
    }

    function checkSchoolByEmail(string _schoolEmail) view returns(bool) {
      return schoolMap[_schoolEmail] != 0;
    }

    function getSchoolIdByEmail(string _schoolEmail) view returns(uint256) {
      return schoolMap[_schoolEmail];
    }

    function getSchoolBySchoolId(uint256 _schoolId) view returns(string, string, string, string, string, string, bool) {
        require(_schoolId < schoolList.length);
        School school = schoolList[_schoolId];
        return (school.schoolName, school.schoolEmail, school.schoolProvince, school.schoolAddress, school.schoolGovernor, school.schoolAgent, school.schoolState);
    }

    function createProject(uint256 _schoolId, string _projectName, string _projectTarget, uint256 _projectTargetMoney, uint256 _projectFinishTime) {
        require(_schoolId < schoolList.length);
        uint256 _projectId = projectCount();
        Project memory project = Project({projectId:_projectId, schoolId:_schoolId, projectName:_projectName, projectCreateTime:now, projectTarget:_projectTarget, projectTargetMoney:_projectTargetMoney, projectCurrentMoney:0, projectEndorseState:2, projectFinishState:false, projectFinishTime:_projectFinishTime, projectPlanUpNoteTime:0, projectActualUpNoteTime:0, totalScore:0, totalEndorsor:0, finishEndorsor:0});
        projectList.push(project);
        schoolProjectMap[_schoolId].push(_projectId);
        if (_schoolId != 0) {
            emitEndorse(_projectId);
        }
    }
    function getSchoolProvince(uint256 schoolId) returns(string){
        School school = schoolList[schoolId];
        return school.schoolProvince;
    }
    function emitEndorse(uint256 _projectId) {
        require(_projectId < projectList.length && _projectId > 0);
        Project project = projectList[_projectId];
        School school = schoolList[project.schoolId];
        uint256[] endorsorList;
        for(uint a = 0; a < provinceToEndorsorMap[school.schoolProvince].length;a++){
            endorsorList.push(provinceToEndorsorMap[school.schoolProvince][a]);
        }
        uint256[] emitEndorsorList;
        if (endorsorList.length < 3) {
            for (uint256 i=0; i < endorsorList.length; i++) {
                emitEndorsorList.push(endorsorList[i]);
                createEndorseItem(_projectId, endorsorList[i], 0);
                endorseItemMap[endorsorList[i]].length++;
                endorseItemMap[endorsorList[i]][endorseItemMap[endorsorList[i]].length-1] = endorseItemList[endorseItemList.length-1].endorsorId;
            }
        }else {
            uint256 targetEndorsorCount = endorsorList.length*2/3;
            uint256 len = endorsorList.length;
            for (uint256 j=0; j < targetEndorsorCount; j++) {
                uint256 t = random(len);
                createEndorseItem(_projectId, endorsorList[j], 0);
                endorseItemMap[endorsorList[j]].length++;
                endorseItemMap[endorsorList[j]][endorseItemMap[endorsorList[j]].length-1] = endorseItemList[endorseItemList.length-1].endorsorId;
                emitEndorsorList.push(endorsorList[j]);
                for (uint256 k=t; k < endorsorList.length-1; k++) {
                    endorsorList[k] = endorsorList[k+1];
                }
                len--;
            }
        }
        projectEnodrsorListMap[_projectId] = emitEndorsorList;
        project.totalEndorsor = emitEndorsorList.length;
        project.totalScore = 0;
        project.finishEndorsor = 0;
    }

    function projectCount() view returns(uint256) {
        return projectList.length;
    }

    function getProjectByProjectId(uint256 _projectId) view returns(uint256, uint256, string, uint256, string, uint256, uint256, uint256, bool, uint256, uint256, uint256) {
        require(_projectId > 0 && _projectId < projectList.length);
        Project project = projectList[_projectId];
        return (project.projectId, project.schoolId, project.projectName, project.projectCreateTime, project.projectTarget, project.projectTargetMoney, project.projectCurrentMoney, project.projectEndorseState, project.projectFinishState, project.projectFinishTime, project.projectPlanUpNoteTime, project.projectActualUpNoteTime);
    }

    function getSchoolProjectCounts(uint256 _schoolId) view returns(uint256) {
        return schoolProjectMap[_schoolId].length;
    }

    function getSchoolProjectidByNum(uint256 _schoolId ,uint256 _num) view returns(uint256) {
        return schoolProjectMap[_schoolId][_num];
    }

    function getProjectIdBySchoolId(uint256 _schoolId, uint256 _schoolProjectId) view returns(uint256) {
        require(_schoolId < schoolList.length && _schoolProjectId < schoolProjectMap[_schoolProjectId].length);
        return schoolProjectMap[_schoolId][_schoolProjectId];
    }
  
    // return random[0,n)
    function random(uint256 n) view returns(uint256) {
        return uint(sha256(now, msg.sender))%n;
    }

    function strEqual(string strA, string strB) returns(bool) {
        bytes memory byteA = bytes(strA);
        bytes memory byteB = bytes(strB);
        if (byteA.length != byteB.length) {
            return false;
        }else {
            for (uint256 i=0; i < byteA.length; i++){
                if (byteA[i] != byteB[i]) {
                    return false;
                }
            }
        }
        return true;
    }

  // from safemath.sol
  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
    if (a == 0) {
      return 0;
    }

    c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return a / b;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
    c = a + b;
    assert(c >= a);
    return c;
  }
}
