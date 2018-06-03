pragma solidity ^0.4.16;
import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Main.sol";


contract TestMain {
    Main main = Main(DeployedAddresses.Main());   

    function testUserCount() {      
        uint256 _userCount = main.userCount();       
        uint256 expected = 1;
        Assert.equal(_userCount, expected, "userCount not pass");
    }  

    function testCreateUser() {      
        bool userExist = main.checkUserByPhone("18801125279");
        Assert.equal(userExist, false, "userExist not pass");
        main.createUser("hht", "18801125279", "123456");
        var (userId, userName, userPhone) = main.getUserByUserId(1);
        bytes32 expectedUserName = "hht";
        bytes32 expectedUserPhone = "18801125279";
        Assert.equal(userId, 1, "userId not pass");
        Assert.equal(userName, expectedUserName, "userName not pass");
        Assert.equal(userPhone, expectedUserPhone, "userPhone not pass");
        bool userExist2 = main.checkUserByPhone("18801125279");
        Assert.equal(userExist2, true, "userExist2 not pass");
    }   

    function testGetUserByPhone() {
        bytes32 userPhone = "18801125279";
        uint256 expectedUserId = 1;
        uint256 userId = main.getUserIdByPhone(userPhone);
        Assert.equal(userId, expectedUserId, "getUserByPhone not pass");
    }

    function testLogin() {
        bytes32 userAccount = "18801125279";
        bytes32 userPassword = "123456";
        var(userType, userId) = main.login(userAccount, userPassword);
        uint256 expectedUserType = 1;
        uint256 expectedUserId = 1;
        Assert.equal(userType, expectedUserType, "userType not  pass");
        Assert.equal(userId, expectedUserId, "userType not  pass");
    }

    function testCreateSchool() {
        bytes32 schoolEmail = "pku@pku.edu.cn";
        bytes32 schoolName = "pku";
        bytes32 schoolPassword = "pku";
        bytes32 schoolProvince = "beijing";
        bytes32 schoolAddress = "颐和园路5号";
        bytes32 schoolGovernor = "教育部";
        bytes32 schoolAgent = "linjianhua";
        main.createSchool(schoolEmail, schoolName, schoolPassword, schoolProvince, schoolAddress, schoolGovernor,schoolAgent);
        uint256 eSchoolCount = 2;
        uint256 schoolCount = main.schoolCount();
        Assert.equal(schoolCount, eSchoolCount, "schoolCount not pass");
        bool exist = main.checkSchoolByEmail(schoolEmail);
        Assert.equal(exist, true, "checkSchoolByEmail not pass");
        uint256 testId = main.getSchoolIdByEmail(schoolEmail);
        Assert.equal(testId, 1, "getSchoolIdByEmail not pass");
    }

    function testGetSchoolById() {
        uint256 schoolId = 1;
        var (schoolName, schoolEmail, schoolProvince, schoolAddress, schoolGovernor, schoolAgent, schoolState) = main.getSchoolBySchoolId(schoolId);
        bytes32 eSchoolName = "pku";
        bytes32 eSchoolEmail = "pku@pku.edu.cn";
        bytes32 eSchoolProvince = "beijing";
        bytes32 eSchoolAddress = "颐和园路5号";
        bytes32 eSchoolGovernor = "教育部";
        bytes32 eSchoolAgent = "linjianhua";
        Assert.equal(schoolName, eSchoolName, "getSchoolById not pass");
        Assert.equal(eSchoolEmail, schoolEmail, "getSchoolById not pass");
        Assert.equal(schoolProvince, eSchoolProvince, "getSchoolById not pass");
        Assert.equal(schoolAddress, eSchoolAddress, "getSchoolById not pass");
        Assert.equal(schoolGovernor, eSchoolGovernor, "getSchoolById not pass");
        Assert.equal(schoolAgent, eSchoolAgent, "getSchoolById not pass");
        Assert.equal(schoolState, true, "getSchoolById not pass");
    }

    function testProject() {
        uint256 eProjectCount = 1;
        Assert.equal(eProjectCount, main.projectCount(), "projectCount not pass");
        bytes32 projectName = "建图书馆";
        bytes32 projectTarget = "没钱发工资了";

        main.createProject(1, projectName, projectTarget, 100, 123);
        var(projectId, , , , , , , , , , , ) = main.getProjectByprojectId(1);
        Assert.equal(projectId, 1, "getProjectById not pass");
    }
}