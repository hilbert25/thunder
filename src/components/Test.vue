<template>
  <div class="hello">
    <h1>{{ msg }}</h1>
    <h2>Essential Links</h2>
    <ul>
      <li>
        <a
          href="https://vuejs.org"
          target="_blank"
        >
          Core Docs
        </a>
      </li>
      <li>
        <a
          href="https://forum.vuejs.org"
          target="_blank"
        >
          Forum
        </a>
      </li>
      <li>
        <a
          href="https://chat.vuejs.org"
          target="_blank"
        >
          Community Chat
        </a>
      </li>
      <li>
        <a
          href="https://twitter.com/vuejs"
          target="_blank"
        >
          Twitter
        </a>
      </li>
      <br>
      <li>
        <a
          href="http://vuejs-templates.github.io/webpack/"
          target="_blank"
        >
          Docs for This Template
        </a>
      </li>
    </ul>
    <h2>Ecosystem</h2>
    <ul>
      <li>
        <a
          href="http://router.vuejs.org/"
          target="_blank"
        >
          vue-router
        </a>
      </li>
      <li>
        <a
          href="http://vuex.vuejs.org/"
          target="_blank"
        >
          vuex
        </a>
      </li>
      <li>
        <a
          href="http://vue-loader.vuejs.org/"
          target="_blank"
        >
          vue-loader
        </a>
      </li>
      <li>
        <a
          href="https://github.com/vuejs/awesome-vue"
          target="_blank"
        >
          awesome-vue
        </a>
      </li>
    </ul>
    <button class="ui button" v-on:click ="create()">创建</button>
    <button class="ui button" v-on:click ="getuser()">订购</button>
  </div>
  
</template>

<script>
import vis from 'vis'
import { web3 } from 'wallet'
const abi = require('../../truffle/build/contracts/Main').abi
const main = web3.loadContract(
  abi,
  '0x345ca3e014aaf5dca488057592ee47305d9b3e10'
)
console.log(main);
export default {
  async beforeMount () {
    var userCount = await main.userCount();
    console.log("userCount",userCount.toString());
  },
  methods: {
    getuser: async function () {
      var res = await main.getUserByUserId(1);
      console.log("res----"+res);
      //alert(res)
    },
    create: async function () {
      await main.createUser("1wwwww","111dsdgfg","uyhjg");
      //console.log("userId",userId.toString());
      alert("success")
    }
  },
  name: 'Test',
  data () {
    return {
      msg: "hello"
    }
  },
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h1, h2 {
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
</style>