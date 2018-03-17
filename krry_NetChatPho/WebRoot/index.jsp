<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<!doctype html>
<html>
   <head>
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8"/>
		<meta name="viewport" content="width=device-width; initial-scale=1.0">
		<title>乐信 --Krry</title>
		<meta name="keywords" content="关键词,关键词">
		<meta name="description" content="">
		<link rel="stylesheet" href="css/index.css" />
		<link type="text/css" rel="stylesheet" href="js/sg/css/sg.css" />
   </head>

	<body>
		<div class="phone">
			<div class="p_title">乐信 - 悦动你我的心</div>
			<span class="username" contenteditable="true"></span>
			<div class="p_con">
				<div class="p_box" id="boxx">
				   
				</div>
				<div class="p_msg">
					<p class="p_more" onclick="moretext();"></p>
				    <input class="p_text"  id="message" type="text" />
				    <input type="button" value="发&nbsp;送" class="p_btn" id="p_btn_button" disabled="true" />
				</div>
				<div class="p_moremsg">
					<div class="g_container">
						<ul>
							<li style="margin-top:10px;"><span>湛江天气</span></li>
							<li><span>早上好！</span></li>
							<li><span>想你了</span></li>
							<li><span>我爱你</span></li>
							<li><span>啦啦啦</span></li>
							<div class="clear"></div>
						</ul>
					</div>
				</div>
			</div>
		</div>   
     <!-- 引入jQuery官方类库-->
	<script type="text/javascript" src="js/jquery-1.11.3.min.js"></script>
	<script src="js/sg/sg.js"></script>
	<script src="js/sg/tz_util.js"></script>
	<script type="text/javascript" src="js/index.js"></script>
	<script type="text/javascript">
		var widHeight = $(window).height();
		$(".phone .p_con").height(widHeight-40);
		
		var users = ["小月","小程","小郭","小筱","小熊","小玲","小清"];
		//取0~6之间整数，包括0和6
		var ii = Math.ceil(Math.random() * 6);
		$(".username").text(users[ii]);
		
		loading("点击右上角更换昵称哦~",5);
		
		$(".username").focus(function(){
			if(isEmpty($(this).text())){
				$(".username").focus();
			}
		});
		
		//获取唯一标识
		var timeUUID = new Date().getTime();
		
		var ws;
		
		//首先判断浏览器是否支持webSocket，支持h5的浏览器才会支持
		if(!window.WebSocket){
			alert("您的浏览器不支持WebSocket，请选择其他浏览器");
		}
		
		//获取窗口
		var boxx = document.getElementById("boxx");
		
		//连接
		var url = "ws://localhost/krry_NetChatPho/websocket";
		if("WebSocket" in window){
			ws = new WebSocket(url);
		}else if("MozWebSocket" in window){
			ws = new MozWebSocket(url);
		}
		
		//注册事件
		//打开Socket
		ws.onopen = function(){
			var username = $(".username").text();
			ws.send("【"+username+"】已进入乐信");
		};
		//接收服务端的信息
		ws.onmessage = function(event){
			var msg = event.data;
			//如果匹配到是自己发送的信息，则不用显示
			if(msg.indexOf("##$#$"+timeUUID+"$%%") != -1) return;
			//截取掉后面的唯一标识符  arr[0]就是需要的信息
			var arr = msg.split("##$#$");
			var string = "<div class='p_left'>"+
					"<img class='imag' src='images/123.png' alt='meimei' width='36' height='36'/>"+
					"<img class='jiaoleft' src='images/sanjiao1.png' width='5'/>"+
					"<span>"+arr[0]+"</span><div class='clear'></div></div>";
			$(".p_box").append(string);
			boxx.scrollTop = boxx.scrollHeight;//使滚动条一直在底部
		};
		//关闭连接
		ws.onclose = function(){
			
		};
		//出错
		ws.onerror = function(event){
			console.log(event);
			alert("您与服务器连接错误...");
		};
		
		//监听窗口关闭事件，当窗口关闭时，主动去关闭websocket连接，防止连接还没断开就关闭窗口，server端会抛异常。
	    window.onbeforeunload = function(){
	    	var username = $(".username").text();
	    	ws.send("【"+username+"】离开了聊天室");
	    	ws.close();
	    };
		
		$(window).resize(changewidth);
		changewidth();
		//当窗口变化的时候
		function changewidth(){
			var height = $(window).height() - 40;
			$(".p_con").css({
				height:height
			});
			$(".p_box").css("height",height-40);
		}
		//监听键盘按下去的事件
		$("#message").keyup(function(){
			if(isEmpty($("#message").val())){ //如果有输入内容,则设置按钮可用
				$("#p_btn_button").attr("disabled",true);
			}else{  //否则不可用
				$("#p_btn_button").attr("disabled",false);
			}
		});
		

		$("#message").focus(function(){
			$("#message").addClass("clicked");
			var height = $(window).height() - 40;
			$(".phone .p_con .p_msg").css("bottom","0");
			$(".phone .p_con .p_box").css("height",height-40);
			$(".phone .p_con .p_moremsg").css("bottom","-163px");
			mote = true;
			setTimeout(function(){
				boxx.scrollTop = boxx.scrollHeight;//使滚动条一直在底部		
			},200);
		});
		
		$("#message").blur(function(){
			setTimeout(function(){
				$("#message").removeClass("clicked");			
			},400);
		});
		
		//点击发送
		$("#p_btn_button").click(function(){
			if(isEmpty($(".username").text())){
				alert("取一个昵称哦~");
				$(".username").focus();
				return;
			}
			var value = $("#message").val();
			$("#p_btn_button").attr("disabled",true);//马上设置按钮不可用
			$("#message").val("");
			$(".p_box").append("<div class='p_right'><img class='imag' src='images/mine.jpg' alt='krry' width='36' height='36' />"+
					"<img class='jiaoright' src='images/sanjiao2.png' width='5'/>"+
					"<span>"+value+
		 		    "</span><div class='clear'></div></div>");
			var username = $(".username").text();
			//发送消息到服务端
			ws.send("【"+username+"】"+value+"##$#$"+timeUUID+"$%%");
			$("#message").focus();
			boxx.scrollTop = boxx.scrollHeight;//使滚动条一直在底部
			
	  });
		
		//回车键
		$(".p_text").keypress(function(event){
			if(event.keyCode == 13 && !isEmpty($("#message").val())){
				$("#p_btn_button").trigger("click");
			}
		});
	  
	  
	  //点击+按钮
		var mote = true;
		var height = $(window).height() - 40;
		function moretext(){
			if(mote){
				if($("#message").hasClass("clicked")) {
					setTimeout(function(){
						toggerdown();
					},400);
				}else{
					toggerdown();
				}
			}else{
				toggerup();
			}
		}
		
		function toggerdown(){
			$(".phone .p_con .p_msg").animate({
				"bottom":"163px"
			},200);
			$(".phone .p_con .p_box").animate({
				"height":height-203
			},200);
			$(".phone .p_con .p_moremsg").animate({
				"bottom":0
			},200,function(){
				boxx.scrollTop = boxx.scrollHeight;//使滚动条一直在底部
			});
			mote = false;
		}
		
		function toggerup(){
			$(".phone .p_con .p_msg").animate({
				"bottom":"0"
			},200);
			$(".phone .p_con .p_box").animate({
				"height":height-40
			},200);
			$(".phone .p_con .p_moremsg").animate({
				"bottom":"-163px"
			},200);
			mote = true;
		}

		$(".phone .p_con .p_moremsg ul li span").click(function(){
			if(isEmpty($(".username").text())){
				alert("取一个昵称哦~");
				$(".username").focus();
				return;
			}
			var message = $(this).text();
			$(".p_box").append("<div class='p_right'><img class='imag' src='images/mine.jpg' alt='krry' width='36' height='36' />"+
					"<img class='jiaoright' src='images/sanjiao2.png' width='5'/>"+
					"<span>"+message+
		 		    "</span><div class='clear'></div></div>");
			var username = $(".username").text();
			//发送消息到服务端
			ws.send("【"+username+"】"+message+"##$#$"+timeUUID+"$%%");
			boxx.scrollTop = boxx.scrollHeight;//使滚动条一直在底部
			
		});
		
		/**
		 * 判断非空
		 * 
		 * @param val
		 * @returns {Boolean}
		 */
		function isEmpty(val) {
			val = $.trim(val);
			if (val == null)
				return true;
			if (val == undefined || val == 'undefined')
				return true;
			if (val == "")
				return true;
			if (val.length == 0)
				return true;
			if (!/[^(^\s*)|(\s*$)]/.test(val))
				return true;
			return false;
		}
	</script>
	</body>
</html>