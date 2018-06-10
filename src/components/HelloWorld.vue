<template>
  <div class="hello">
    <div class="nav">
      <div class="logo">引火链</div>
      <ul>
        <li>首页</li>
        <li><a href="#actitiy">项目广场</a></li>
        <li><a href="#center">用户中心</a></li>
        <li @click="dialogloginVisible = true">注册</li>
        <li @click="dialogFormVisible = true">登录</li>
      </ul>
    </div>
<el-dialog :visible.sync="dialogloginVisible">
  <el-tabs v-model="activeName" type="card" >
    <el-tab-pane label="个人注册" name="first">
    <el-form :model="loginform">
    <el-form-item label="手机号" :label-width="formLabelWidth">
      <el-input v-model="loginform.phone" auto-complete="off"></el-input>
    </el-form-item>
    <el-form-item v-model="loginform.password" label="密码" :label-width="formLabelWidth">
      <el-input type="password" auto-complete="off"></el-input>
    </el-form-item>
     <el-form-item label="确认密码" :label-width="formLabelWidth">
      <el-input type="password" auto-complete="off"></el-input>
    </el-form-item>
     <el-form-item label="昵称" :label-width="formLabelWidth">
      <el-input auto-complete="off" v-model="loginform.name"></el-input>
    </el-form-item>
    <el-button type="primary" @click="dialogloginVisible= false" v-on:click = "createUser(loginform.name,loginform.phone,loginform.password)">个人注册</el-button>
    </el-form>
  </el-tab-pane>
    <el-tab-pane label="学校注册" name="second">
      <!--学校注册 -->
    <el-form :model="schoolreg">
     <el-form-item
    prop="email"
    label="邮箱"
    :label-width="formLabelWidth"
    :rules="[
      { required: true, message: '请输入邮箱地址', trigger: 'blur' },
      { type: 'email', message: '请输入正确的邮箱地址', trigger: ['blur', 'change'] }
    ]"
    >
    <el-input v-model="schoolreg.email"></el-input>
    </el-form-item>
    <el-form-item label="密码" :label-width="formLabelWidth">
      <el-input v-model="schoolreg.password" type="password" auto-complete="off"></el-input>
    </el-form-item>
     <el-form-item label="确认密码" :label-width="formLabelWidth">
      <el-input type="password" auto-complete="off"></el-input>
    </el-form-item>

     <el-form-item label="学校名称" :label-width="formLabelWidth">
      <el-input v-model="schoolreg.name" auto-complete="off"></el-input>
    </el-form-item>
    <el-form-item label="学校代表" :label-width="formLabelWidth">
      <el-input v-model="schoolreg.agent" auto-complete="off"></el-input>
    </el-form-item>
    <el-form-item label="所在省份" :label-width="formLabelWidth">
      <el-input v-model="schoolreg.province" auto-complete="off"></el-input>
    </el-form-item>
    <el-form-item label="地址" :label-width="formLabelWidth">
      <el-input v-model="schoolreg.address" auto-complete="off"></el-input>
    </el-form-item>
    <el-form-item label="直属单位" :label-width="formLabelWidth">
      <el-input v-model="schoolreg.governor" auto-complete="off"></el-input>
    </el-form-item>
    <el-button type="primary" @click="dialogloginVisible= false" v-on:click = "createSchool(schoolreg.email,schoolreg.name,schoolreg.password,schoolreg.province,schoolreg.address,schoolreg.governor,schoolreg.agent)">学校注册</el-button>
    </el-form>
    </el-tab-pane>
  </el-tabs>
</el-dialog>
<el-dialog :visible.sync="dialogFormVisible">
    <el-form :model="form">
    <el-form-item label="用户名" :label-width="formLabelWidth">
      <el-input v-model="form.name" auto-complete="off"></el-input>
    </el-form-item>
    <el-form-item label="密码" :label-width="formLabelWidth">
      <el-input v-model="form.password" type="password" auto-complete="off"></el-input>
    </el-form-item>
  </el-form>
  <div slot="footer" class="dialog-footer">
    <el-button type="primary" @click="dialogFormVisible = false" v-on:click = "userLogin(form.name,form.password)">登录</el-button>
  </div>
</el-dialog>


    <div class="block">
    <el-carousel height="650px">
      <el-carousel-item v-for="item in 4" :key="item">
        <h3>{{ item }}</h3>
      </el-carousel-item>
    </el-carousel>
  </div>
  <div id="actitiy" class="actitiy">
    <div class="activity-name">项目广场</div> 
    <div id = "projecttest">
      <!-- <ol v-for = "project in projects">
        <li >
          {{project.projectId}}
          </li>
          <li >
          {{project.schoolId}}
          </li>
          <li >
          {{project.projectName}}
          </li>
          <li>
          {{project.projectCreateTime}}
          </li>
          <li>
          {{project.projectTarget}}
          </li>
          <li >
          {{project.projectTargetMoney}}
          </li>
          <li >
          {{project.projectCurrentMoney}}
          </li>
          <li >
          {{project.projectEndorseState}}
          </li>
          <li>
          {{project.projectFinishState}}
          </li>
      </ol> -->
    </div>
  <div class="project-square"> 
  <el-table
    :data="activeDetail"
    style="width: 100%">
    <el-table-column
      label="项目编号"
      >
      <template slot-scope="scope">
        <!-- <i class="el-icon-time"></i> -->
        <span style="margin-left: 10px">{{scope.row.projectId}}</span>
      </template>
    </el-table-column>
    <el-table-column
      label="项目名称"
    >
      <template slot-scope="scope">
       <span style="margin-left: 10px">{{scope.row.projectName}}</span>
      </template> 
    </el-table-column>
     <el-table-column
      label="项目发起时间">
      <template slot-scope="scope">
        <span style="margin-left: 10px">{{scope.row.projectCreateTime | formatTime}}</span>
      </template>
    </el-table-column>
     <el-table-column
      label="发起方">
      <template slot-scope="scope">
        <span style="margin-left: 10px">{{scope.row.schoolId}}</span>
      </template>
    </el-table-column>
     <el-table-column
      label="用途"
>
  <template slot-scope="scope">
    <span style="margin-left: 10px">{{scope.row.projectTarget}}</span>
  </template>
  </el-table-column>
     <el-table-column
      label="目标金额">
      <template slot-scope="scope">
        <span style="margin-left: 10px">{{scope.row.projectTargetMoney}}</span>
      </template>
    </el-table-column>
     <el-table-column
      label="当前金额">
      <template slot-scope="scope">
        <span style="margin-left: 10px">{{scope.row.projectCurrentMoney}}</span>
      </template>
    </el-table-column>
    <el-table-column label="操作">
      <template slot-scope="scope">
        <el-button
          size="mini"
          @click="handleEdit(scope.$index, scope.row)">捐赠</el-button>
      </template>
    </el-table-column>
  </el-table>
  <el-dialog title="捐赠" :visible.sync="juanzeng">
  <el-form :model="form">
    <el-form-item label="捐赠金额" :label-width="formLabelWidth">
      <el-input v-model="donatemoney" auto-complete="off"></el-input>
    </el-form-item>
  </el-form>
  <div slot="footer" class="dialog-footer">
    <el-button @click="juanzeng = false">取 消</el-button>
    <el-button type="primary" @click="juanzeng = false">确 定</el-button>
  </div>
</el-dialog>
  </div>
</div>
<!--个人中心0  学校中心1  背书页面2  管理元页面3-->
<div id="center">
  <div class="activity-name">用户中心</div>  
  <!--个人中心 -->
  <div class="person-center" v-if="status === 1">
    <div class="left-people">
      <div class="headpic">
        <img class="headpic" src="../assets/head.jpeg"/>
      </div>
      <div>
      <p class="people-phone" >{{loginid}}</p>
      <p class="people-phone" >{{userdata[1]}}</p>
      <p class="people-phone" >{{userdata[2]}}</p>
      <p>我参与的项目</p>
      </div>
    </div>
    <div class="right-people">
       <el-table
      :data="peopleList"
      style="width: 100%">
      <el-table-column
        prop="date"
        label="项目名称"
       >
      </el-table-column>
      <el-table-column
        prop="name"
        label="项目发起方"
      >
      </el-table-column>
      <el-table-column
        prop="address"
        label="用途">
      </el-table-column>
       <el-table-column
        prop="address"
        label="目标金额">
      </el-table-column>
       <el-table-column
        prop="address"
        label="项目状态">
      </el-table-column>
      <el-table-column
        prop="address"
        label="自己捐赠">
      </el-table-column>
    </el-table>
  </div>
  </div>
   <!--学校中心 -->
  <div class="school-center" v-if="status===2">
    <div class="left-people">
      <div class="headpic">
        <img class="headpic" src="../assets/head.jpeg"/>
      </div>
      <p class="people-phone" >学校编号：{{loginid}}</p>
      <p class="people-phone" >学校名称：{{schooldata[0]}}</p>
      <p class="people-phone" >联系方式：{{schooldata[1]}}</p>
      <p class="people-phone" >所在省份：{{schooldata[2]}}</p>
      <p class="people-phone" >详细地址：{{schooldata[3]}}</p>
      <p class="people-phone" >主管单位：{{schooldata[4]}}</p>
      <p class="people-phone" >学校代理人：{{schooldata[5]}}</p>
      <p class="people-phone" >学校状态：北京大学</p>
      <p class="people-phone" >已完成的项目：粉笔擦项目</p>
      <p class="people-phone" >筹款总金额：11100</p>

      <p>学校项目</p>
      <div><el-button  type="primary" @click="addProject = true">新增项目</el-button></div>
    </div>
    <div class="right-people">
      <el-table
      :data="peopleList"
      style="width: 100%">
      <el-table-column
        prop="date"
        label="项目编号"
        >
      </el-table-column>
      <el-table-column
        prop="name"
        label="项目名称"
    >
      </el-table-column>
      <el-table-column
        prop="address"
        label="计划用途">
      </el-table-column>
       <el-table-column
        prop="address"
        label="目标金额">
      </el-table-column>
       <el-table-column
        prop="address"
        label="实筹金额">
      </el-table-column>
      <el-table-column
        prop="address"
        label="开始时间">
      </el-table-column>
       <el-table-column
        prop="address"
        label="结束时间">
      </el-table-column>
       <el-table-column
        prop="address"
        label="状态">
      </el-table-column>
    </el-table>
    <el-dialog :visible.sync="addProject">
    <el-form :model="form">
    <el-form-item label="项目名" :label-width="formLabelWidth">
      <el-input v-model="form.name" auto-complete="off"></el-input>
    </el-form-item>
    <el-form-item label="项目标签" :label-width="formLabelWidth">
      <el-input v-model="form.tag" auto-complete="off"></el-input>
    </el-form-item>
    <el-form-item label="目标金额" :label-width="formLabelWidth">
      <el-input v-model="form.money" auto-complete="off"></el-input>
    </el-form-item>
    <el-form-item label="结束时间" :label-width="formLabelWidth">
       <el-date-picker
      v-model="datavalue1"
      type="date"
      placeholder="选择日期">
    </el-date-picker>
    </el-form-item>
  </el-form>
  <div slot="footer" class="dialog-footer">
    <el-button type="primary" @click="dialogFormVisible = false" v-on:click = "createProject(form.name,form.tag,form.money,form.time)">申请</el-button>
  </div>
</el-dialog>
</div>

  </div>
   <!--背书页面 -->
  <div class="supervise-center" v-if="status===3">
    <div class="left-people">
      <div class="headpic">
        <img class="headpic" src="../assets/head.jpeg"/>
      </div>
      <p class="people-phone">教育部</p>
      <p class="people-phone">电话：18966788909</p>
      
    </div>
    <div class="right-people">
      <el-tabs :tab-position="tabPosition">
        <el-tab-pane label="已背书的项目">
          <!--已经背书的项目 -->
           <el-table
      :data="peopleList"
      style="width: 100%">
      <el-table-column
        prop="date"
        label="项目编号"
        >
      </el-table-column>
      <el-table-column
        prop="name"
        label="项目名称"
       >
      </el-table-column>
      <el-table-column
        prop="address"
        label="计划用途">
      </el-table-column>
       <el-table-column
        prop="address"
        label="目标金额">
      </el-table-column>
       <el-table-column
        prop="address"
        label="实筹金额">
      </el-table-column>
      <el-table-column
        prop="address"
        label="开始时间">
      </el-table-column>
       <el-table-column
        prop="address"
        label="结束时间">
      </el-table-column>
       <el-table-column
        prop="address"
        label="状态">
      </el-table-column>
    </el-table>
  </el-tab-pane>
   <el-tab-pane label="已拒绝的项目">
          <!-- a -->
      <el-table
      :data="peopleList"
      style="width: 100%">
      <el-table-column
        prop="date"
        label="项目编号"
        >
      </el-table-column>
      <el-table-column
        prop="name"
        label="项目名称"
    >
      </el-table-column>
      <el-table-column
        prop="address"
        label="计划用途">
      </el-table-column>
       <el-table-column
        prop="address"
        label="目标金额">
      </el-table-column>
       <el-table-column
        prop="address"
        label="实筹金额">
      </el-table-column>
      <el-table-column
        prop="address"
        label="开始时间">
      </el-table-column>
       <el-table-column
        prop="address"
        label="结束时间">
      </el-table-column>
       <el-table-column
        prop="address"
        label="状态">
      </el-table-column>
    </el-table>
        </el-tab-pane>
        <el-tab-pane label="待处理的项目">
            <el-table
    :data="tableData"
   >
    <el-table-column
      label="日期"
     >
    </el-table-column>
    <el-table-column
      label="姓名"
      >
    </el-table-column>
     <el-table-column
      label="姓名"
      >
    </el-table-column>
     <el-table-column
      label="姓名"
      >
    </el-table-column>
    <el-table-column label="操作"  style="width: 200px">
      <template slot-scope="scope">
        <!-- <el-button
          size="mini"
          @click="handleEdit(scope.$index, scope.row)">通过</el-button>
        <el-button
          size="mini"
          type="danger"
          @click="handleDelete(scope.$index, scope.row)">拒绝</el-button> -->
      </template>
    </el-table-column>
  </el-table>
        </el-tab-pane>
       </el-tabs>   
  </div>
  </div>
   <!--管理员页面 -->
  <div class="manage-center">
    
  </div>
  
</div>
</div>
</div>
</template>

<script>
import vis from "vis";
import { web3 } from "wallet";
import "../util/cookie";
const cookie = require("../util/cookie.js");
const abi = require("../../truffle/build/contracts/Main").abi;
const main = web3.loadContract(
  abi,
  "0x345ca3e014aaf5dca488057592ee47305d9b3e10"
);
export default {
  async beforeMount() {
    let projectdata = [];
    let projectcount = await main.projectCount();
    let userCount = await main.userCount();
    console.log("userCount", userCount.toString());
    for (let i = 1; i < projectcount; i++) {
      let project = await main.getProjectByProjectId(i);
      projectdata.push({
        projectId: project[0],
        schoolId: project[1],
        projectName: project[2],
        projectCreateTime: project[3],
        projectTarget: project[4],
        projectTargetMoney: project[5],
        projectCurrentMoney: project[6],
        projectEndorseState: project[7],
        projectFinishState: project[8]
      });
      //console.log(project[0].toString()+"\t"+project[1].toString()+"\t"+project[2].toString()+"\t"+project[3].toString()+"\t"+project[4].toString())
      //console.log(this.tableData.projectId.toString()+"\t"+this.tableData.projectName.toString()+"\t"+this.tableData.projectCreateTime.toString()+"\t"+this.tableData.projectTarget.toString())
      // console.log(project.toString() + "------------------");
    }
    this.$data.projects = projectdata;
    // this.projectdata = projectdata
    console.log("=====projectdata=======", projectdata[0]);
    // let arr = [];
    // for (let key in projectdata) {
    //   if (!projectdata.hasOwnProperty(key)) {
    //     continue;
    //   }
    //   let item = {};
    //   item[key] = projectdata[key];
    //   arr.push(item);
    // }
    this.activeDetail = projectdata;
    // console.log("=====arr======", arr);
    // [{a: 1}, {b: 2}, {c: 3}]

    //this.tableData.projectId = project[0]
    //this.tableData.schoolId = project[1]
    //this.tableData.projectName = project[2]
    //this.tableData.projectCreateTime = project[3]
    //this.tableData.projectTarget = project[4]
    //this.tableData.projectTargetMoney = project[5]
    //this.tableData.projectCurrentMoney = project[6]
    //this.tableData.projectEndorseState = project[7]
    //this.tableData.projectFinishState = project[8]
  },
  async mounted() {},
  name: "HelloWorld",
  filters: {
    formatTime(str) {
      console.log("===str==", str.c[0]);
      var date = new Date(str.c[0] * 1000); //时间戳为10位需*1000，时间戳为13位的话不需乘1000
      let Y = date.getFullYear() + "-";
      let M =
        (date.getMonth() + 1 < 10
          ? "0" + (date.getMonth() + 1)
          : date.getMonth() + 1) + "-";
      let D = date.getDate() + " ";
      let h = date.getHours() + ":";
      let m = date.getMinutes() + ":";
      let s = date.getSeconds();
      return Y + M + D + h + m + s;
    }
  },
  methods: {
    test() {
      var _this = this;
      var url = "/aaa/asss/cc/vv1";
      var body = {};
      function successCallback(res) {
        console.log(res);
        // 这里的this不是指向Vue本身，访问Vue变量请使用_this
      }
      this.$post(url, body, successCallback);
    },
    handleEdit(index, row) {
      console.log(index, row);
      this.juanzeng = true;
    },
    infoopenCenter() {
      this.$message({
        message: "王凯同学紧急开发中",
        center: true
      });
    },
    createUser: async function(name, phone, password) {
      var phoneReg = /(^1[3|4|5|7|8]\d{9}$)|(^09\d{8}$)/;  
      if(!phoneReg.test(phone)) {
        alert("手机号不符合规则");
      }else{
        await main.createUser(name, phone, password);
        alert("register success");
      }
      //console.log("userId",userId.toString());

    },
    createSchool: async function(
      email,
      name,
      password,
      province,
      address,
      governor,
      agent
    ) {
      await main.createSchool(
        email,
        name,
        password,
        province,
        address,
        governor,
        agent
      );
      //console.log("userId",userId.toString());
      alert("success");
    },
    createProject: async function(name, tag, money, time) {
      await main.createProject(this.loginid, name, tag, money, time);
      //console.log("userId",userId.toString());
      alert("success");
    },
    userLogin: async function(account, password) {
      var res = await main.login(account, password);
      this.loginid = res[1];
      var loginstatus = parseInt(res[0]);
      if (loginstatus === 1) {
        this.userdata = await main.getUserByUserId(this.loginid);
        console.log("userdata----" + this.userdata.toString());
        //document.getElementById("userid").innerHTML = userdata[0];
        //document.getElementById("username").innerHTML = userdata[1];
        //document.getElementById("userphone2").innerHTML = userdata[2];
        //console.log("userId",userId.toString());
      } else if (loginstatus === 2) {
        this.schooldata = await main.getSchoolBySchoolId(this.loginid);
        console.log("schooldata" + this.schooldata.toString());
        let schoolprojectcount = await main.getSchoolProjectCounts(
          this.loginid
        );
        console.log("projectcount" + schoolprojectcount.toString());
        for (let i = 0; i < schoolprojectcount; i++) {
          console.log("for------");
          let projectid = await main.getSchoolProjectidByNum(this.loginid, i);
          console.log("projectid------" + projectid.toString());
          let tmpproject = await main.getProjectByProjectId(projectid);
          console.log("tmpproject-----" + tmpproject.toString());
        }
        //document.getElementById("schoolid").innerHTML = "学校编码："+ loginid;
        //document.getElementById("schoolname").innerHTML = "学校名称："+ schooldata[0];
        //document.getElementById("schoolemail").innerHTML = "联系方式："+ schooldata[1];
        //document.getElementById("schoolprovince").innerHTML = "所在省份"+ schooldata[2];
        //document.getElementById("schooladdress").innerHTML = "详细地址："+ schooldata[3];
        //document.getElementById("schoolgovernor").innerHTML = "主管单位："+ schooldata[4];
        //document.getElementById("schoolagent").innerHTML = "学校代理人："+ schooldata[5];
        //console.log("userId",userId.toString());
      }
      this.status = loginstatus;
      alert("loginsuccess");
    }
  },
  data() {
    return {
      status: 999,
      list: ["首页", "关于", "公示", "联系"],
      dialogFormVisible: false,
      schooldata: [],
      loginid: 0,
      userdata: [],
      projects: null,
      datavalue1: "",
      activeName: "first",
      eopleList: [],
      activeDetail: [],
      juanzeng: false,
      form: {
        name: "",
        region: "",
        date1: "",
        date2: "",
        delivery: false,
        type: [],
        resource: "",
        desc: ""
      },
      donatemoney: "",
      loginform: {
        phone: "",
        password: "",
        confirmpass: "",
        name: ""
      },
      schoolreg: {
        email: "",
        password: "",
        confirmpass: "",
        schoolname: "",
        schoolpeople: "",
        province: "",
        address: "",
        danwei: ""
      },
      addProject: false,
      dialogloginVisible: false,
      formLabelWidth: "120px",
      tableData: [
        {
          projectId: "0987667",
          projectCreator: "北京大学",
          projectName: "粉笔擦项目",
          projectCreateTime: "2018-05-19",
          projectTarget: "粉笔",
          projectTargetMoney: "12455",
          projectCurrentMoney: "23456",
          projectEndorseState: "0",
          projectFinishState: "1"
        },
        {
          projectId: "0987667",
          projectCreator: "北京大学",
          projectName: "粉笔擦项目",
          projectCreateTime: "2018-05-19",
          projectTarget: "粉笔",
          projectTargetMoney: "12455",
          projectCurrentMoney: "23456",
          projectEndorseState: "0",
          projectFinishState: "1"
        }
      ]
    };
  },
  components: {}
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped lang="less">
ul {
  list-style: none;
  margin-right: 20px;
  li {
    float: left;
    color: #646464;
    margin: 20px 20px 4px 20px;
  }
}
.nav {
  display: flex;
  justify-content: space-between;
}
.fr {
  float: right;
}
.title-box {
  width: 100%;
  height: 800px;
  background: url("../assets/bg.jpeg");
  background-size: cover;
  position: relative;
}
.center-box {
  position: absolute;
  left: 30%;
  top: 300px;
  z-index: 999;
}

.el-carousel__item h3 {
  color: #475669;
  font-size: 14px;
  opacity: 0.75;
  line-height: 150px;
  margin: 0;
}
.logo {
  // margin: 20px;
  font-weight: 800;
  // font-size: 36px;
  font-family: "Franklin Gothic Medium", "Arial Narrow", Arial, sans-serif;
  margin-left: 20px;
  height: 64px;
  line-height: 64px;
  font-size: 24px;
}

.el-carousel__item:nth-child(2n) {
  background-image: url("../assets/bg3.jpeg");
  background-size: cover;
}

.el-carousel__item:nth-child(2n + 1) {
  background-image: url("../assets/bg4.jpeg");
  background-size: cover;
}
// .el-carousel__item:nth-child(3n + 1) {
//   // background-image: url("../assets/bg.jpeg");
//   background-size: cover;
// }
.block {
  position: relative;
}
.actitiy {
  margin-top: 20px;
  margin-bottom: 30px;
}
.activity-name {
  text-align: center;
  font-size: 36px;
  margin: 20px;
  color: #646464;
  margin-top: 50px;
}
.project-square {
  width: 95%;
  margin: 0 auto;
  border: 1px solid #f4f4f4;
}
//个人中心页面
.person-center,
.supervise-center {
  display: flex;
  padding: 30px;
}
.school-center {
  display: flex;
  padding: 30px;
}
.left-people {
  flex: 0 0 20%;
  height: 700px;
  background-color: #f9f9f9;
  text-align: center;
  padding-top: 10px;
}
.headpic {
  // width: 30px;
  height: 30px;
  border-radius: 50%;
}
.people-phone {
  margin-top: 10px;
  font-size: 10px;
  color: #6c6d09;
}
.right-people {
  display: flex;
  flex-direction: row;
  padding: 30px;
  flex: 0 0 70%;
  margin-left: 30px;
  min-height: 200px;
  background-color: #f9f9f9;
}
.right-people-box {
  display: flex;
}
.rightpic {
  height: 50px;
  border-radius: 50%;
  // margin: 30px;
  margin-left: 30px;
  margin-top: 20px;
}
.people-info {
  margin-left: 40px;
  margin-top: 30px;
}
.people-info-phone {
  color: #6c6d09;
}
.change-info {
  color: #ffc800;
}
.people-money {
  margin-left: 200px;
  font-size: 12px;
  margin-top: 15px;
}
.table-info {
  display: flex;
  // flex: 0 0 70%;
}
</style>
