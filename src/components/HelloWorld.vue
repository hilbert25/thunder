<template>
  <div class="hello">
    <div class="nav">
      <ul class="nav navbar-nav navbar-right">
				<li class="active"><a href="#banner">Home</a></li>
				<li><a href="#services">Services</a></li>
				<li><a href="#about">About</a></li>
				<li><a href="#portfolio">Portfolio</a></li>
				<li><a href="#team">Team</a></li>
				<li><a href="#price">Price</a></li>
				<li><a href="#contact">Contact</a></li>
			</ul>
    </div>
  </div>
</template>

<script>
export default {
  name: "HelloWorld",
  data() {
    return {
      list: ["首页", "关于", "公示", "联系"]
    };
  }
};
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped lang="less">
ul {
  list-style: none;
  li {
    float: right;
    color: red;
  }
}
</style>
