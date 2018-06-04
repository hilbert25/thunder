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
        var(projectId, , , , , , , , , , , ) = main.getProjectByProjectId(1);
        Assert.equal(projectId, 1, "getProjectById not pass");
        var(getProjectId) = main.getProjectIdBySchoolId(1, 0);
        Assert.equal(getProjectId, 1, "getProjectBySchoolId not pass");
    }

    function testEndorsor() {
        uint256 eEndorsorCount = 1;
        Assert.equal(eEndorsorCount, main.endorsorCount(), "endorosrCount not pass");
        main.createEndorsor("org", "bj", "org@org", "123");
        Assert.equal(2, main.endorsorCount(), "endorosrCount not pass");
        Assert.equal(true, main.checkEndorsorByEmail("org@org"), "checkEndorsor1 not pass");
        Assert.equal(false, main.checkEndorsorByEmail("org"), "checkEndorsor1 not pass");
        Assert.equal(1, main.getEndorsorIdByEmail("org@org"), "checkEndorsor1 not pass");
        var(, org, province, email) = main.getEndorsorByEndorsorId(1);
        Assert.equal(org, "org", "getEndorsorOrg not pass");
        Assert.equal(province, "bj", "getEndorsorBj not pass");
        Assert.equal(email, "org@org", "getEndorsorEmail not pass");
        main.createEndorseItem(1, 1, 1);
        Assert.equal(main.getEndorseItemCountOfEndorsor(1), 1, "getEndorseItemCountOfEndorsor not pass");
        var(_projectId, _endorsorId, _operate) = main.getEndorseByEndorsorId(1, 0);
        Assert.equal(_projectId, 1, "_projectId not pass");
        Assert.equal(_endorsorId, 1, "_endorsorId not pass");
        Assert.equal(_operate, 1, "_operate not pass");
    }

    function testDenote() {
        main.userDenote(1, 1, 50);
        var( , , , , , ,curMoney , , , , , ) = main.getProjectByProjectId(1);
        Assert.equal(curMoney, 50, "donote not pass");
        var(,,money,time) = main.getDenoteByUserId(1, 0);
        Assert.equal(money, 50, "getDenoteByUserId not pass");
        Assert.equal(time, 0, "time not pass");
    }
    // function testRandom() {
    //     uint256 eRan = 0;
    //     uint256 random = main.random();
    //     Assert.equal(random, eRan, "random");
    // }
}