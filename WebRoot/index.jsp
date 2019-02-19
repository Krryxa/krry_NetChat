<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<!doctype html>
<html>
  
  <head>
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
    <meta name="keywords" content="">
    <meta name="description" content="">
    <title>
      基于Java服务器端的消息主动推送技术揭秘 --krry
    </title>
    <link rel="stylesheet" href="css/animate.css" />
    <link rel="stylesheet" type="text/css" href="css/sg.css" />
    <style>
      *{margin:0;padding:0;} body{background:url("images/5.jpg");background-size:cover;}
      h1{margin-top:50px;text-align:center;color:#fff;text-shadow:1px 1px 1px
      #000;font-family:-webkit-body;font-size:24px;} .box{width:700px;margin:20px
      auto;} .box span{color:#f60;font-size:16px;font-family:"微软雅黑";} .box .shu{text-indent:1em;height:24px;font-family:"微软雅黑";border:0;outline:none;font-size:14px;}
      .box .add{width:300px;margin-right:24px;} .box .user{width:200px;} .box
      .btn{width:80px;height:34px;color:#fff;background:#6c0;border:0;outline:none;cursor:pointer;margin-top:20px;font-size:16px;font-family:"微软雅黑";}
      .box .area{line-height: 29px;height:280px;width:680px;padding:10px;overflow:auto;font-size:16px;font-family:"微软雅黑";margin:20px
      0;outline:none;box-shadow:1px 2px 18px #000} .box .setex{text-indent:1em;height:28px;border:1px
      solid #6c0;width:618px;outline:none;float:left;font-family:"微软雅黑";} .box
      .send{font-size:14px;width:80px;height:30px;color:#fff;background:#6c0;border:0;outline:none;cursor:pointer;font-family:"微软雅黑";}
    </style>
  </head>
  
  <body>
    <h1>
      基于Java服务器端的消息主动推送技术揭秘 --krry
    </h1>
    <div class="box">
      <span>
        服务器地址：
      </span>
      <input type="text" class="shu add" value="www.ainyi.com/krry_NetChat/websocket"
      readonly/>
      <span>
        用户名：
      </span>
      <input type="text" class="shu user" value="匿名" />
      <input type="button" value="连接" class="btn" />
      <div class="area" id="boxx">
      </div>
      <div class="c_cen">
        <input type="text" class="setex" />
        <input type="button" value="发送" class="send">
      </div>
    </div>
    <script src="js/jquery-1.11.1.min.js">
    </script>
    <script src="js/sg.js">
    </script>
    <script src="js/sgutil.js">
    </script>
    <script>
      var close = true;
      var ws;
      $(function() {
        $(".c_cen").hide();
        //首先判断浏览器是否支持webSocket，支持h5的浏览器才会支持
        if (window.WebSocket) {
          printMsg("您的浏览器支持WebSocket，您可以尝试连接到聊天服务器！", "OK");
        } else {
          printMsg("您的浏览器不支持WebSocket，请选择其他浏览器！", "ERROR");
          //设置按钮不可点击
          $(".btn").attr("disabled", "true");
        }
      });
      //打印信息
      function printMsg(msg, msgType) {
        if (msgType == "OK") {
          msg = "<span style='color:green'>" + msg + "</span>";
        }
        if (msgType == "ERROR") {
          msg = "<span style='color:red'>" + msg + "</span>";
        }
        $(".area").append(msg + "<br/>");
        var boxx = document.getElementById("boxx");
        boxx.scrollTop = boxx.scrollHeight; //使滚动条一直在底部
      }

      //打开Socket
      function openWs() {
        printMsg("链接已建立", "OK");
        ws.send("【" + $(".user").val() + "】已进入聊天室");
        $(".c_cen").show();
      }

      //接收消息的时候
      function msgWs(e) {
        printMsg(e.data);
      }
      //关闭连接
      function closeWs() {
        $(".btn").val("连接");
        $(".c_cen").hide();
      }
      //产生错误
      function errorWs() {
        printMsg("您与服务器连接错误...", "ERROR");
      }

      //点击发送按钮
      $(".send").click(function() {
        var text = $(".setex").val();
        if (text == null || text == "") return;
        $(".setex").val("");
        ws.send("【" + $(".user").val() + "】：" + text);
      });

      //点击连接
      $(".btn").click(function() {
        if ($(".add").val() && $(".user").val()) {
          if (close) {
            printMsg("正在准备连接服务器，请稍等...");
            var url = "wss://" + $(".add").val();
            if ("WebSocket" in window) {
              ws = new WebSocket(url);
            } else if ("MozWebSocket" in window) {
              ws = new MozWebSocket(url);
            }
            //已连接
            $(".btn").val("断开");
            close = false;

            //注册事件
            ws.onopen = function() {
              openWs();
            };
            ws.onmessage = function(event) {
              msgWs(event);
            };
            ws.onclose = function() {
              closeWs();
            };
            ws.onerror = function() {
              errorWs();
            };

            //监听窗口关闭事件，当窗口关闭时，主动去关闭websocket连接，防止连接还没断开就关闭窗口，server端会抛异常。
            window.onbeforeunload = function() {
              ws.send("【" + $(".user").val() + "】离开了聊天室");
              close = true;
              ws.close();
            };

          } else {
            ws.send("【" + $(".user").val() + "】离开了聊天室");
            close = true;
            ws.close();
          }
        } else {
          $.tmDialog.alert({
            open: "left",
            content: "服务器地址和用户名不能为空哦...",
            title: "提示哦~~~"
          });
        }
      });

      //回车键
      $(".setex").keypress(function(event) {
        if (event.keyCode == 13) {
          $(".send").trigger("click");
        }
      });
    </script>
  </body>

</html>