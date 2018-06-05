pragma solidity ^0.4.16;
import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
// import "../contracts/ItemFactory.sol";


contract Test {
    //ItemFactory itemFactory = ItemFactory(DeployedAddresses.ItemFactory());

    function test() public {
        address a = address(2);
        address b = address(3);
        bool r = a == b;
        Assert.equal(r, true, "pass");
    //Assert.equal(j, 2, "pass");
        // data.addUser(msg.sender);
        // data.uploadData(msg.sender, "西方的数据", 20);
        // data.downloadData(msg.sender, 1);
        // uint dataItemId;//编号
        // address providerAddress;//提供者地址
        // bytes32 dataKey;//
        // uint downLoadCount;//下载数据的数量
        // uint upLoadTime;//发布时间
        // uint price;//价格
        // bool soldOut;//是否下架
        // (dataItemId, providerAddress, dataKey, downLoadCount, upLoadTime, price, soldOut) = data.getDataDetailById(1);
        // Assert.equal(upLoadTime, now, "success");
    }      
      // 字符串拼接
    function concatStr(string strA, string strB) pure returns(string) {
        bytes memory bytesA = bytes(strA);
        bytes memory bytesB = bytes(strB);
        bytes memory tempBytes = new bytes(bytesA.length + bytesB.length);
        uint index = 0;
        for (; index < bytesA.length; index++) {
            tempBytes[index] = bytesA[index];
        }
        for (; index < bytesB.length+bytesA.length; index++) {
            tempBytes[index] = bytesB[index-bytesA.length];
        }
        return string(tempBytes);
    } 
}