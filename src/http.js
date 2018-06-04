import Vue from "vue";
import axios from "axios";
import qs from "qs";

var apiUrl = "";
axios.interceptors.request.use(
  config => {
    return config;
  },
  error => {
    return Promise.reject(error);
  }
);

axios.interceptors.response.use(
  response => {
    return response;
  },
  error => {
    return Promise.resolve(error.response);
  }
);

function post(url, data, callback, status) {
  return axios({
    method: "post",
    baseURL: apiUrl,
    url,
    data: qs.stringify(data),
    timeout: 30000,
    headers: {
      "X-Requested-With": "XMLHttpRequest",
      "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
    }
  }).then(response => {
    callback(checkStatus(response));
  });
}

function checkStatus(response) {
  if (
    response &&
    (response.status === 200 ||
      response.status === 304 ||
      response.status === 400)
  ) {
    return response.data;
  } else {
    return {
      code: 202,
      data: [],
      msg: "系统内部错误，请稍后尝试",
      author: "Youmeng"
    };
  }
}

/* setCookie */
function setCookie(cname, cvalue, exHours) {
  var d = new Date();
  d.setTime(d.getTime() + exHours * 60 * 60 * 1000);
  var expires = "expires=" + d.toUTCString();
  console.info(cname + "=" + cvalue + "; " + expires);
  document.cookie = cname + "=" + cvalue + "; " + expires;
}

/* getCookie */
function getCookie(cName) {
  if (window.document.cookie.length > 0) {
    let cStart = window.document.cookie.indexOf(cName + "=");
    if (cStart !== -1) {
      cStart = cStart + cName.length + 1;
      let cEnd = window.document.cookie.indexOf(";", cStart);
      if (cEnd === -1) {
        cEnd = window.document.cookie.length;
      }
      return unescape(window.document.cookie.substring(cStart, cEnd));
    }
  }
  return "";
}

function delCookie(cName) {
  setCookie(cName, "", -1);
}

Vue.prototype.$apiUrl = apiUrl;

Vue.prototype.$post = post;

Vue.prototype.$getCookie = getCookie;

Vue.prototype.$setCookie = setCookie;

Vue.prototype.$delCookie = delCookie;

// test() {
//   var _this = this;
//   var url = "";
//   var body = {};
//   function successCallback(res) {
//     console.log(res);
//     // 这里的this不是指向Vue本身，访问Vue变量请使用_this
//   }
//   this.$post(url, body, successCallback);
// }
