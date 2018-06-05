pragma solidity ^0.4.16;


contract Data {
    DataItem[] dataItemList;
    Deal[] dealList;
    User[] userList;
    mapping(address => uint) userMap;// address => userId
    //所有Id从1开始编码。也就是id=数组索引+1

    struct DataItem {
        uint dataItemId;//编号
        address providerAddress;//提供者地址
        bytes32 name;//
        uint downLoadCount;//下载数据的数量
        uint upLoadTime;//发布时间
        uint price;//价格
        bool soldOut;//是否下架
        bytes32 format;
        bytes32 description;
    }

    struct Deal {
        uint dealId;//交易Id
        uint dataItemId;//data 编号
        address buyerAddress;//购买者
        uint expiredTime;//有效期，ddl的时间戳
    }

    struct User {
        uint userId;
        address userAddress;//地址
        uint upLoadCount;//上传数据的数量
        uint downLoadCount;//下载数据的数量
        uint balance;//账户余额
        uint[] userDownloadRecord;//下载记录
        uint[] userUploadRecord;//上传记录
        bytes32 userName;
        bytes32 iconUrl;
    }

    function Data() {
        dataItemList.push(DataItem(dataItemList.length+1, address(0xDD194F8ff51ac9CC39fBA4fc0E0a0c336fDD2426), "淘宝交易记录", 0, now, 100, false, "JSON", "data"));
        dataItemList.push(DataItem(dataItemList.length+1, address(0xDD194F8ff51ac9CC39fBA4fc0E0a0c336fDD2426), "微信个人资料", 0, now, 50, false, "JSON", "data"));
        dataItemList.push(DataItem(dataItemList.length+1, address(0xDD194F8ff51ac9CC39fBA4fc0E0a0c336fDD2426), "微信聊天关键词", 0, now, 500, false, "SQLite", "data"));
        dataItemList.push(DataItem(dataItemList.length+1, address(0xDD194F8ff51ac9CC39fBA4fc0E0a0c336fDD2426), "微博关注列表", 0, now, 120, false, "txt", "data"));
        dataItemList.push(DataItem(dataItemList.length+1, address(0xDD194F8ff51ac9CC39fBA4fc0E0a0c336fDD2426), "LinkedIn职业", 0, now, 88, false, "JSON", "data"));
        dataItemList.push(DataItem(dataItemList.length+1, address(0xDD194F8ff51ac9CC39fBA4fc0E0a0c336fDD2426), "头条浏览记录", 0, now, 5, false, "SQLite", "data")); 
    }
    // 获取数据条数
    function getDataItemCount() view returns(uint) {
        return dataItemList.length;
    }

    //根据数据Id获取数据，每次获取一条
    function getDataDetailById(uint _dataItemId) view returns(uint, address, bytes32, uint, uint, uint, bool, bytes32, bytes32) {
        require(_dataItemId <= dataItemList.length&&_dataItemId > 0);
        DataItem dataItem = dataItemList[_dataItemId-1];
        return (dataItem.dataItemId, dataItem.providerAddress, 
        dataItem.name, dataItem.downLoadCount, dataItem.upLoadTime, dataItem.price, dataItem.soldOut, dataItem.format, dataItem.description);
    }

    //获取交易记录条数
    function getDataRecordCount() view returns(uint) {
        return dealList.length;
    }

    //根据交易Id获取交易记录，每次获取一条
    function getDataRecordById(uint _dataRecordId) view returns(uint, uint, address, uint) {
        Deal deal = dealList[_dataRecordId-1];
        return (deal.dealId, deal.dataItemId, deal.buyerAddress, deal.expiredTime);
    }

    //添加用户
    function addUser(address _userAddress, bytes32 _userName, bytes32 _iconUrl) {
      
        if (userMap[_userAddress] == 0) {

            uint[] myDownloadRecord;
            uint[] myUploadRecord;
            uint userId = userList.length+1;
            userList.push(User(userId, _userAddress, 0, 0, 100000, myDownloadRecord, myUploadRecord, _userName, _iconUrl));
            userMap[_userAddress] = userId;
        }
    }

    //获取用户数量
    function getUserCount() view returns(uint) {
        return userList.length;
    }

    //根据用户Id获取用户数据，每次获取一条
    function getUserById(uint _userId) view returns(uint, address, uint, uint, uint, bytes32, bytes32) {
        require(_userId <= userList.length&&_userId > 0);
        User user = userList[_userId-1];
        return (user.userId, user.userAddress, user.upLoadCount, user.downLoadCount, user.balance, user.userName, user.iconUrl);
    }

    //根据用户address获取用户数据，每次获取一条
    function getUserByAddress(address _userAddress) view returns(uint, address, uint, uint, uint, bytes32, bytes32) {
        require(userMap[_userAddress] != 0);
        return getUserById(userMap[_userAddress]);
    }

    //获取用户下载数量
    function getUserDownloadCount(uint _userId) view returns(uint) {
        require(_userId <= userList.length&&_userId > 0);
        return userList[_userId].userDownloadRecord.length;  
    }

    //根据用户Id获取下载记录
    function getUserDownloadRecord(uint _userId, uint _recordIndex) view returns(uint, uint, address, uint) {
        require((_userId <= userList.length&&_userId > 0)&&
        (_recordIndex <= userList[_userId].userDownloadRecord.length));
        uint recordId = userList[_userId].userDownloadRecord[_recordIndex-1];
        Deal record = dealList[recordId];
        return (record.dealId, record.dataItemId, record.buyerAddress, record.expiredTime);
    }

    //获取用户上传数量
    function getUserUploadCount(uint _userId) view returns(uint) {
        require(_userId <= userList.length&&_userId > 0);
        return userList[_userId].userUploadRecord.length;  
         
    }

    //根据用户Id获取上传记录
    function getUserUploadRecord(uint _userId, uint _recordIndex) view returns(uint, address, bytes32, uint, uint, uint, bool) {
        require((_userId <= userList.length&&_userId > 0)&&
        (_recordIndex <= userList[_userId].userUploadRecord.length));
        uint dataItemId = userList[_userId].userUploadRecord[_recordIndex-1];
        DataItem dataItem = dataItemList[dataItemId];
        return (dataItem.dataItemId, dataItem.providerAddress, dataItem.name, 
        dataItem.downLoadCount
        , dataItem.upLoadTime, dataItem.price, dataItem.soldOut);
    }

    //令数据下架
    function soldOutData(uint _dataItemId) {
        address _providerAddress = msg.sender;
        require(dataItemList[_dataItemId-1].providerAddress == _providerAddress);
        dataItemList[_dataItemId-1].soldOut = true;
    }

    //上传数据
    function uploadData(address _providerAddress, uint _price, bytes32 _name, bytes32 _format, bytes32 _description) {
        uint dataItemId = dataItemList.length+1;
        dataItemList.push(DataItem(dataItemId, _providerAddress, _name, 0, now, _price, false, _format, _description));
        uint userId = userMap[_providerAddress];
        userList[userId-1].upLoadCount += 1;
        userList[userId-1].userUploadRecord.push(dataItemId);
    }

    //下载数据
    function downloadData( uint _dataItemId, address _userAddress) {
        uint userId = userMap[_userAddress];
        userList[userId-1].downLoadCount += 1;
        userList[userId-1].balance -= dataItemList[_dataItemId-1].price;
        userList[userId-1].userDownloadRecord.push(_dataItemId);
        dataItemList[_dataItemId-1].downLoadCount += 1;
        dealList.push(Deal(dealList.length+1, _dataItemId, _userAddress, now+31536000));
    }

    //检查是否授权
    function hasAuthorization( uint _dataItemId, address _userAddress) view returns(uint) {
        uint res;
        uint userId = userMap[_userAddress];
        if (_dataItemId > dataItemList.length) {
            res = 0;//数据不存在
        }else {
            for (uint i =0; i < dealList.length; i++) {
                if (dealList[i].buyerAddress == _userAddress &&
                    dealList[i].dataItemId == _dataItemId && dealList[i].expiredTime > now) {
                    res = 2;//已经买了,已授权
                }
            }
            res = 3;//未授权
        }
        if (userList[userId-1].balance < dataItemList[_dataItemId-1].price) {
            res = 1;// "余额不足";
        }
        return res;
    }

    // //初始化数据
    // function createData() {
    //     string[6] memory nameArr = ["淘宝交易记录", "微信个人资料", "微信聊天关键词", "微博关注列表", "LinkedIn职业", "头条浏览记录"];
    //     uint256[6] memory priceArr = [uint256(15), uint256(20), uint256(43), uint256(67), uint256(87), uint256(34)];
    //     string[6] memory formatArr = ["rar", "rar", "rar", "rar", "rar", "rar"];
    //     string[6] memory descriptionArr = ["data", "data", "data", "data", "data", "data"];
    //     for (uint i = 0; i < 6; i++) {
    //         uploadData(address(0xDD194F8ff51ac9CC39fBA4fc0E0a0c336fDD2426), priceArr[i], str2Bytes32(nameArr[i]), str2Bytes32(formatArr[i]), str2Bytes32(descriptionArr[i]));
    //     }
    // }

    // function str2Bytes32(string memory source) returns (bytes32 result) {
    //     assembly {
    //         result := mload(add(result, 32))
    //     }
    // }
    

} 