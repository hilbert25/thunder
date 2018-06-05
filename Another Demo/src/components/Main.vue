<template>
  <div>
    <!-- Page Contents -->
    <div class="pusher" id="top">
      <div class="ui inverted vertical masthead center aligned segment">
        <div class="ui container">
          <div class="ui large secondary inverted pointing menu">
            <a class="active item" href="#top">概览</a>
            <a class="item" href="#data_market">数据市场</a>
            <a class="item" href="#usage_example">余额{{userName}}米币</a>
          </div>
        </div>

        <div class="ui text container">
          <h1 class="ui inverted header">
            米仓
          </h1>
          <h2>手机上的数据共享仓库</h2>
        </div>
      </div>

      <div class="ui vertical stripe segment">
        <div class="ui middle aligned stackable grid container">
          <div class="row">
            <div class="eight wide column">
              <h3 class="ui header">我们帮助企业优化服务</h3>
              <p>用户手机上丰富的信息处于数据孤岛中，难以被利用。我们用区块链增加企业互信，提高流通效率，帮助企业利用数据优化服务。</p>
            </div>
            <div class="eight wide right floated column">
              <h3 class="ui header">我们保证用户隐私</h3>
              <p>隐私问题是数据共享的一大难题，我们使用本地沙箱技术，让数据处理发生在手机上，向用户提供透明、安全的隐私保证。</p>
            </div>
          </div>
        </div>
      </div>

      <div class="ui vertical stripe segment" id="chain_show">
        <div class="ui container">
          <h2 class="ui header">链上信息展示</h2>
          <div class="ui container" id="recordGraph"></div>
        </div>
      </div>

      <div class="ui vertical stripe segment" id="data_market">
        <div class="ui container">
          <h2 class="ui header">数据市场</h2>
          <div class="ui four column stackable doubling grid cards">
            <div class="ui card data-item" v-for="item in dataItems" :key="item.dataItemId">
              <div class="row header">
                <!-- <img :src="item.icon" class="icon left floated"> -->
                <img v-bind:src="item.iconUrl" class="icon left floated">
                <div class="right floated title">{{item.name}}</div>
              </div>
              <div class="content">
                <table class="ui very basic collapsing celled table">
                  <tbody>
                  <tr>
                    <td class="single line center">描述</td>
                    <td>{{item.description}}</td>
                  </tr>
                  <tr>
                    <td class="single line center">地址</td>
                    <td>{{item.dataUrl}}</td>
                  </tr>
                  <tr>
                    <td class="single line center">格式</td>
                    <td>{{item.format}}</td>
                  </tr>
                  </tbody>
                </table>
              </div>
              <button class="ui button" v-on:click ="buyDataItem(item.dataItemId)">订购（{{item.price}} 米币/年）</button>
            </div>
          </div>
        </div>
      </div>

      <div class="ui vertical stripe segment" id="usage_example">
        <h2 class="ui header">使用样例</h2>
        <div class="ui three column stackable doubling grid container">
          <div class="column">
            <p>您的应用可以使用丰富的本地用户数据，为用户提供个性化的服务。例如，您可以向程序猿们推送魔爪的广告，帮助他们在Hackathon决战到天亮！</p>
            <div class="ui segment device">
              <div class="device-ui">
                <div class="device-mi-ad">
                  <h4>小米广告</h4>
                  <img class="mi-ad-img" v-if="linkedin_purchased && linkedin_granted" src="/static/images/ad_programmer.jpeg">
                  <img class="mi-ad-img" v-else-if="wechat_purchased && wechat_granted" src="/static/images/ad_male.jpg">
                  <img class="mi-ad-img" v-else src="/static/images/ad_all.jpg">
                </div>
              </div>
              <h4 style="text-align:center;">本地个性化效果</h4>
            </div>
          </div>
          <div class="column">
            <p>您的用户在享受个性化服务的同时，不再需要为隐私担忧。我们的平台会保证数据只在本地完成计算，用户也可以根据喜好控制数据的共享。</p>
            <div class="ui segment device">
              <div class="device-ui">
                <div class="device-full-screen">
                  <div class="device-banner">
                    数据管理
                  </div>
                  <div class="device-body">
                    <p>您设备上的数据共享情况如下所示。所有数据都不会上传，只在您设备上安全地处理，为您提供个性化服务。</p>
                    <div class="device-listview" v-if="wechat_purchased">
                      <img class="device-appicon" style="float: left;" src="/static/images/wechat.png">
                      <div class="device-arrow" style="float: left;">
                        <p>基本资料 &rarr;</p>
                        <div class="data-disable" v-if="wechat_granted" v-on:click="wechat_granted = false">禁用</div>
                        <div class="data-enable" v-else v-on:click="wechat_granted = true">启用</div>
                      </div>
                      <img class="device-appicon" style="float: right;" src="/static/images/mi.jpg">
                    </div>
                    <div class="device-listview" v-if="linkedin_purchased">
                      <img class="device-appicon" style="float: left;" src="/static/images/linkedin.png">
                      <div class="device-arrow" style="float: left;">
                        <p>职业信息 &rarr;</p>
                        <div class="data-disable" v-if="linkedin_granted" v-on:click="linkedin_granted = false">禁用</div>
                        <div class="data-enable" v-else v-on:click="linkedin_granted = true">启用</div>
                      </div>
                      <img class="device-appicon" style="float: right;" src="/static/images/mi.jpg">
                    </div>
                  </div>
                </div>
              </div>
              <h4 style="text-align:center;">用户数据管理App</h4>
            </div>
          </div>
          <div class="column">
            <p>我们提供了简单易用的SDK，以便于您在用户设备上中使用丰富的数据。例如，您可以通过如下代码，使用微信和LinkedIn的数据展示广告。</p>
            <div class="ui segment device">
              <div class="device-code">
            <pre class="language-java"><code class="language-java">@SandBox  // 添加SandBox标记，确保数据安全
void showPersonalizedAd(AdView adView) {
  // 初始化PersonalDataHub实例
  PersonalDataHub pdh = PersonalDataHub.init("your address");
  // 向WeChat和LinkedIn请求数据
  wechatData = pdh.request("content://wechat/user_profile");
  linkedinData = pdh.request("content://linkedin/job_info");

  // 根据用户性别和职业，展示个性化广告
  gender = wechatData.get("gender"); // 如果数据未授权，返回null
  job = linkedinData.get("job");
  if (job == "程序员") {
    adView.show(魔爪);
  } else if (gender == "男") {
    adView.show(百威);
  } else { adView.show(乐事) };
}</code></pre>
              </div>
              <h4 style="text-align:center;">本地数据处理代码</h4>
            </div>
          </div>
        </div>
      </div>
      <div class="ui inverted vertical footer segment">
        <div class="ui container">
          <div class="ui stackable inverted divided equal height stackable grid">
            <div class="three wide column">
              <h4 class="ui inverted header">About</h4>
              <div class="ui inverted link list">
                <a href="#" class="item">Sitemap</a>
                <a href="#" class="item">Contact Us</a>
                <a href="#" class="item">Source</a>
                <a href="#" class="item">Documentation</a>
              </div>
            </div>
            <div class="three wide column">
              <h4 class="ui inverted header">Services</h4>
              <div class="ui inverted link list">
                <a href="#" class="item">Sell your data</a>
                <a href="#" class="item">Request assistance</a>
                <a href="#" class="item">Promote</a>
                <a href="#" class="item">Contribute</a>
              </div>
            </div>
            <div class="seven wide column">
              <h4 class="ui inverted header">致谢</h4>
              <p>感谢区块链黑客马拉松组委会的辛勤工作，感谢米链组大佬谭总，善禄，源堃以及安全组前端大佬任天赋同学的耐心答疑解惑。感谢举办方以及某饮料商的赞助预祝活动圆满成功！</p>
              <p>商业产品部个个都是人才，说话又好听，我超喜欢在里边的！</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
// import '/static/js/prism'
// import '/static/js/semantic.min'
import vis from 'vis'

import { web3 } from 'wallet'

const abi = require('../../truffle/build/contracts/Data').abi
const main = web3.loadContract(
  abi,
  '0x112232f2ec5df85350126b4c18a39a51593743c0'
)
var userId;


export default {
  name: 'Main',
  async beforeMount () {
    await main.addUser(web3.eth.defaultAccount,'a','b');
    var user = await main.getUserByAddress(web3.eth.defaultAccount);
    var userBalance = user[4].toNumber();
    this.$data.userName = userBalance;
  },

  async mounted () {
    this.drawRecordGraph()
  },

  methods: {
    test: function () {
      console.log('test')
    },
    downLoadData: async function () {
      // var data = await main.downloadData(1);
      // console.log("download",data);
    },
    getUserById: function (userId) {
      for (let i in this.users) {
        let user = this.users[i]
        if (user.userId === userId) {
          return user
        }
      }
    },
    getDataItemById: function (dataItemId) {
      for (let i in this.dataItems) {
        let dataItem = this.dataItems[i]
        if (dataItem.dataItemId === dataItemId) {
          return dataItem
        }
      }
    },
    // render the graph
    drawRecordGraph: async function () {
      let nodes = []
      let edges = []

      let involvedUserIds = new Set()

      const lv = this
      var dealCount = await main.getDataRecordCount();
      for (var i =0; i< dealCount.toNumber(); i++) {
          var deal = await main.getDataRecordById(i+1);
          let dataItem = lv.getDataItemById(deal[1].toNumber())
          involvedUserIds.add(6)//deal.buyerId
          involvedUserIds.add(dataItem.providerId)//provider.userId
          edges.push({
            from: dataItem.providerId,//provider.userId
            to: 6,//buyer.userId
            arrows: 'to',
            label: dataItem.name,
            font: { align: 'bottom' }
          })
      }

      involvedUserIds.forEach(function (userId) {
        var user = lv.getUserById(userId)
        nodes.push({
          id: userId,
          label: user.name,
          image: user.iconUrl,
          shape: 'image'
        })
      })

      let container = document.getElementById('recordGraph')
      let data = {
        nodes: new vis.DataSet(nodes),
        edges: new vis.DataSet(edges)
      }
      let options = {
        edges: {
          font: '14px arial'
        },
        nodes: {
          font: '14px arial'
        },
        interaction: {
          zoomView: false,
          dragView: false
        }
      }
      let network = new vis.Network(container, data, options)
      network.on('stabilizationIterationsDone', function () {
        network.setOptions({
        })
      })
    },
    // current user try to buy a dataItem
    buyDataItem: async function (dataItemId) {
      // TODO @hht implement this
      var authorization = await main.hasAuthorization(dataItemId, web3.eth.defaultAccount);
      switch(authorization.toNumber()){
        case 0:
          alert("无效数据");
          break;
        case 1:
          alert("余额不足");
          break;
        case 2:
          alert("购买过，可以直接下载");
          break;
        case 3:
          await main.downloadData(dataItemId,web3.eth.defaultAccount);
          var user = await main.getUserByAddress(web3.eth.defaultAccount);
          var userBalance = user[4].toNumber();
          this.$data.userName = userBalance;
          this.drawRecordGraph();
          alert("购买成功");
          break;
      }
      
    }
  },


  data () {
    // TODO @hht 目前users, dataItems, deals, userName为mock的值，需要替换为链上真实值
    return {
      users: [
        {
          userId: 1,
          name: '淘宝',
          balance: 100,
          iconUrl: '/static/images/taobao.jpg'
        },
        {
          userId: 2,
          name: '微信',
          balance: 50,
          iconUrl: '/static/images/wechat.png'
        },
        {
          userId: 3,
          name: '微博',
          balance: 120,
          iconUrl: '/static/images/weibo.jpg'
        },
        {
          userId: 4,
          name: 'LinkedIn',
          balance: 88,
          iconUrl: '/static/images/linkedin.png'
        },
        {
          userId: 5,
          name: '今日头条',
          balance: 5,
          iconUrl: '/static/images/toutiao.jpg'
        },
        {
          userId: 6,
          name: '小米',
          balance: 5,
          iconUrl: '/static/images/mi.jpg'
        }
      ],
      dataItems: [
        {
          dataItemId: 1,
          providerId: 1,
          name: '淘宝交易记录',
          price: 100,
          iconUrl: '/static/images/taobao.webp',
          description: '用户在淘宝的交易记录',
          dataUrl: 'content://taobao/shopping',
          format: 'JSON'
        },
        {
          dataItemId: 2,
          providerId: 2,
          name: '微信个人资料',
          price: 50,
          iconUrl: '/static/images/wechat.png',
          description: '用户在微信的基本资料',
          dataUrl: 'content://wechat/profile',
          format: 'JSON'
        },
        {
          dataItemId: 3,
          providerId: 2,
          name: '微信聊天关键词',
          price: 500,
          iconUrl: '/static/images/wechat.png',
          description: '用户在微信的聊天关键词',
          dataUrl: 'content://wechat/chat',
          format: 'SQLite'
        },
        {
          dataItemId: 4,
          providerId: 3,
          name: '微博关注列表',
          price: 120,
          iconUrl: '/static/images/weibo.webp',
          description: '用户在微博关注的用户',
          dataUrl: 'content://weibo/follow',
          format: 'TXT'
        },
        {
          dataItemId: 5,
          providerId: 4,
          name: 'LinkedIn职业',
          price: 88,
          iconUrl: '/static/images/linkedin.png',
          description: '用户在LinkedIn的职业信息',
          dataUrl: 'content://linkedin/career',
          format: 'JSON'
        },
        {
          dataItemId: 6,
          providerId: 5,
          name: '头条浏览记录',
          price: 5,
          iconUrl: '/static/images/toutiao.webp',
          description: '用户在今日头条的浏览记录',
          dataUrl: 'content://toutiao/history',
          format: 'SQLite'
        }
      ],
      deals:new Array(),
      // deals: [
      //   {
      //     buyerId: 5,
      //     dealId: 1,
      //     dataItemId: 1,
      //     expireTime: 10
      //   },
      //   {
      //     buyerId: 1,
      //     dealId: 2,
      //     dataItemId: 2,
      //     expireTime: 10
      //   },
      //   {
      //     buyerId: 5,
      //     dealId: 3,
      //     dataItemId: 3,
      //     expireTime: 10
      //   },
      //   {
      //     buyerId: 3,
      //     dealId: 4,
      //     dataItemId: 6,
      //     expireTime: 10
      //   }
      // ],
      userName: null,
      message: 'Hello Vue!',
      wechat_purchased: true,
      linkedin_purchased: true,
      wechat_granted: true,
      linkedin_granted: true
    }
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h1,
h2 {
  font-weight: normal;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  color: #42b983;
}
.last.container {
  margin-bottom: 300px !important;
}

h1.ui.center.header {
  margin-top: 3em;
}

h2.ui.center.header {
  margin: 4em 0em 2em;
}

h3.ui.center.header {
  margin-top: 2em;
  padding: 2em 0em;
}

#recordGraph {
  width: 100%;
  height: 500px;
  border: 1px solid lightgray;
}

.device {
  height: 480px;
  width: 360px;
}

.device-code {
  height: 89%;
  width: 100%;
  background-size: auto 100%;
}

.device-ui {
  height: 90%;
  width: 100%;
  padding: 5px 71px 22px 71px;
  cursor: pointer;
  background-image: url("/static/images/mi-mix-2.jpeg");
  background-repeat: no-repeat;
  background-size: auto 100%;
  background-position: center;
}

.device-mi-ad {
  padding: 10px 2px 2px 2px;
  margin: auto;
  margin-top: 10%;
  width: 95%;
  text-align: center;
  background-color: beige;
}

.mi-ad-img {
  width: 100%;
  height: 100%;
}

.device-full-screen {
  margin: auto;
  width: 100%;
  height: 100%;
  background-color: white;
}

.device-banner {
  margin: auto;
  width: 100%;
  height: 40px;
  line-height: 40px;
  font-size: 1em;
  background-color: darkgreen;
  color: white;
  padding-left: 10px;
}

.device-body {
  width: 100%;
  height: 100%;
  line-height: 40px;
  font-size: .8em;
  padding: 10px;
}

.device-listview {
  width: 100%;
  height: 40px;
  line-height: 40px;
  margin-bottom: 5px;
}

.device-appicon {
  width: 40px;
  height: 40px;
}

.device-arrow {
  width: 84px;
  height: 40px;
  text-align: center;
}

.device-arrow p {
  margin: auto;
  padding: 0px;
  width: 100%;
  height: 20px;
  line-height: 20px;
}

.device-arrow div {
  margin: auto;
  padding: 0px;
  height: 20px;
  line-height: 20px;
}

.data-disable {
  text-decoration: underline;
  color: red;
}

.data-enable {
  text-decoration: underline;
  color: green;
}

.data-item {
  width: 200px;
  height: 320px;
  background-color: rgba(0,0,0,0.2);
}

.data-item .header {
  width: 100%;
  height: 100px;
  padding: 10px;
}

.data-item .header .icon {
  width: 60px;
  height: 60px;
}

.data-item .header .title {
  width: 140px;
  height: 60px;
  font-size: 20px;
  line-height: 60px;
}

.data-item .content {
  width: 100%;
  height: 100%;
  overflow: hidden;
}

.data-item table {
  width: 100%;
  height: 100%;
}

.data-item button {
  width: 100%;
  height: 3em;
}

.hidden.menu {
  display: none;
}

.masthead.segment {
  min-height: 500px;
  padding: 1em 0em;
}
.masthead .logo.item img {
  margin-right: 1em;
}
.masthead .ui.menu .ui.button {
  margin-left: 0.5em;
}
.masthead h1.ui.header {
  margin-top: 2em;
  margin-bottom: 0em;
  font-size: 4em;
  font-weight: normal;
}
.masthead h2 {
  font-size: 1.7em;
  font-weight: normal;
}

.ui.vertical.stripe {
  padding: 8em 0em;
}
.ui.vertical.stripe h3 {
  font-size: 2em;
}
.ui.vertical.stripe h2 {
  margin-bottom: 2em;
}
.ui.vertical.stripe .button + h3,
.ui.vertical.stripe p + h3 {
  margin-top: 3em;
}
.ui.vertical.stripe .floated.image {
  clear: both;
}
.ui.vertical.stripe p {
  font-size: 1.33em;
}
.ui.vertical.stripe .horizontal.divider {
  margin: 3em 0em;
}

.quote.stripe.segment {
  padding: 0em;
}
.quote.stripe.segment .grid .column {
  padding-top: 5em;
  padding-bottom: 5em;
}

.footer.segment {
  padding: 5em 0em;
}

.secondary.pointing.menu .toc.item {
  display: none;
}

@media only screen and (max-width: 700px) {
  .masthead.segment {
    min-height: 260px;
  }
  .masthead h1.ui.header {
    font-size: 2em;
    margin-top: 1.5em;
  }
  .masthead h2 {
    margin-top: 0.5em;
    font-size: 1.5em;
  }
  .ui.vertical.stripe {
    padding: 4em 0em;
  }
}
</style>
