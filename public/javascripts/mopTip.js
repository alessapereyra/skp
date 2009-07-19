/*
 * mopTip 1.1
 * By Hiroki Miura (http://www.mopstudio.jp)
 * Copyright (c) 2008 mopStudio
 * Licensed under the MIT License: http://www.opensource.org/licenses/mit-license.php
 * September 27, 2008
*/

var mopTipCount=0;
var openMopTip=false;
var mopTipWindW,mopTipWindH,mopTipStyle;
var mopTipOpened;
var mopTipW;
var	mopTipH;
var mopTipFunc,mopTipPin,mopTipContent;
var mopTipCloseBtn=new Image();
/*path to image*/
mopTipCloseBtn.src="http://www.skykidsperu.com/javascripts/closeBtn_h.png"

jQuery.fn.extend({
	mopTip:function(setting){
		var px="px"
		if($(this).attr("href")){
			$(this).attr({href:"#?moptip"});
		}
		$(this).mouseover(function(evt){
			/*setting*/
			mopTipW=setting.w;
			mopTipH=setting.h;
			/* overOut, overClick */
			mopTipStyle=setting.style;
			mopTipPin=false;
			/* name, title, rel, next, child　*/
			if(setting.get=="name"){
				mopTipContent=$(this).attr("name");
			}else if(setting.get=="title"){
				mopTipContent=$(this).attr("title");
			}else if(setting.get=="rel"){
				mopTipContent=$(this).attr("rel");
			}else if(setting.get=="next"){
				mopTipContent=$(this).next().html();
			}else if(setting.get=="child"){
				mopTipContent=$(this).children().html();
			}else{
				mopTipContent=$(setting.get).html();
			};
			/*fasttime*/
			if(mopTipCount==0){
				mopTipFunc.tipInit();
			}
			/*setting mopTip*/
			$("#mopTip01 .tip").css({left:"20px",top:"20px",width:mopTipW+px,height:mopTipH+px});
			$("#mopTip01 .left,#mopTip01 .right").css({height:mopTipH+px});
			$("#mopTip01 .close").hide();
			if((mopTipStyle=="overClick")||(mopTipStyle=="clickClick")){
				$("#mopTip01 .close").show();
			}
			/*position fix*/
			mopTipFunc.findPosi(evt);
			/*mopTipOpen*/
			openMopTip=true;
			setTimeout("mopTipFunc.tipOpen()",300);
		});
		/*click*/
		$(this).click(function(){
			if(openMopTip==true){
				mopTipPin=true;
			}
		});
		/*mousemove*/
		$(this).mousemove(function(evt){
			if(mopTipPin!=true){
				mopTipFunc.findPosi(evt);
			}
		});
		/*mouseout*/
		$(this).mouseout(function(){
			if((openMopTip==true)&&(mopTipStyle=="overOut")){
				mopTipFunc.tipClose();
			}else if((openMopTip==true)&&(mopTipStyle=="overClick")){
				if(mopTipOpened!=true){
					openMopTip=false;
				}
			}
		});
		mopTipFunc={
			tipInit:function(){
				$("body").append(
					'<div id="mopTip01">'+
					  '<div class="tip">'+
						'<div class="content"></div>'+
					  '</div>'+
					  '<div class="leftTop"></div>'+
					  '<div class="rightTop"></div>'+
					  '<div class="leftBottom"></div>'+
					  '<div class="rightBottom"></div>'+
					  '<div class="arrow"></div>'+
					  '<div class="arrowBottom"></div>'+
					  '<div class="left"></div>'+
					  '<div class="right"></div>'+
					  '<div class="top"></div>'+
					  '<div class="bottom"></div>'+
					  '<div class="close"></div>'+
					'</div><div id="mopTip01">'+
					  '<div class="tip">'+
						'<div class="content"></div>'+
					  '</div>'+
					  '<div class="leftTop"></div>'+
					  '<div class="rightTop"></div>'+
					  '<div class="leftBottom"></div>'+
					  '<div class="rightBottom"></div>'+
					  '<div class="arrow"></div>'+
					  '<div class="arrowBottom"></div>'+
					  '<div class="left"></div>'+
					  '<div class="right"></div>'+
					  '<div class="top"></div>'+
					  '<div class="bottom"></div>'+
					  '<div class="close"></div>'+
					'</div>'
				);
				$("#mopTip01").pngfix();
				/*close button click*/
				$("#mopTip01 .close").click(function(){
					mopTipFunc.tipClose();
				});
			},
			findPosi:function(evt){
				var xOffset,yOffset;
				/*fix position*/
				if(jQuery.browser.msie==true){
					var scrollX = document.documentElement.scrollLeft;/*IE*/
					var scrollY = document.documentElement.scrollTop;/*IE*/
					var mouseX=window.event.clientX+scrollX;
					var mouseY=window.event.clientY+scrollY;
				}else{
					var scrollX = window.pageXOffset;/*other*/
					var scrollY = window.pageYOffset;/*other*/
					var mouseX=evt.pageX;
					var mouseY=evt.pageY;
				}
				mopTipWindW=document.documentElement.clientWidth;/*brotherW*/
				mopTipWindH=document.documentElement.clientHeight;/*brotherH*/
				var windXsc=mopTipWindW+scrollX;
				var windYsc=mopTipWindH+scrollY;
				var checkX=windXsc-mouseX;
				var checkY=windYsc-mouseY;
				var checkHeight=mopTipH+40+30;
				if((checkX>mopTipW)&&(checkY>checkHeight)){
					/*left top*/
					xOffset=-40;
					yOffset=30;
					$("#mopTip01 .arrow").css({
						top:"0px",
						left:"20px"
					});
					$("#mopTip01 .arrow").show();
					$("#mopTip01 .top").css({left:"60px",width:mopTipW-40+px});
					$("#mopTip01 .bottom").css({left:"20px",width:mopTipW+px});
					$("#mopTip01 .arrowBottom").hide();
				}else if((checkX<=mopTipW)&&(checkY>checkHeight)){
					/*right top*/
					xOffset=-mopTipW;
					yOffset=30;
					$("#mopTip01 .arrow").css({
						top:"0px",
						left:mopTipW-20+"px"
					});
					$("#mopTip01 .arrow").show();
					$("#mopTip01 .top").css({left:"20px",width:mopTipW-40+px});
					$("#mopTip01 .bottom").css({left:"20px",width:mopTipW+px});
					$("#mopTip01 .arrowBottom").hide();
				}else if((checkX>mopTipW)&&(checkY<=checkHeight)){
					/*left bottom*/
					xOffset=-40;
					yOffset=-(mopTipH+40+15);
					$("#mopTip01 .arrowBottom").css({
						bottom:"0px",
						left:"20px"
					});
					$("#mopTip01 .arrowBottom").show();
					$("#mopTip01 .bottom").css({left:"60px",width:mopTipW-40+px});
					$("#mopTip01 .top").css({left:"20px",width:mopTipW+px});
					$("#mopTip01 .arrow").hide();
				}else if((checkX<=mopTipW)&&(checkY<=checkHeight)){
					/*right bottom*/
					xOffset=-mopTipW;
					yOffset=-(mopTipH+40+15);
					$("#mopTip01 .arrowBottom").css({
						bottom:"0px",
						left:mopTipW-20+px
					});
					$("#mopTip01 .arrowBottom").show();
					$("#mopTip01 .bottom").css({left:"20px",width:mopTipW-40+px});
					$("#mopTip01 .top").css({left:"20px",width:mopTipW+px});
					$("#mopTip01 .arrow").hide();
				}
				/*setting mopTip*/
				$("#mopTip01").css({
					left:mouseX+xOffset+px,
					top:mouseY+yOffset+px,
					width:mopTipW+40+px,
					height:mopTipH+40+px
				});
			},
			/*open*/
			tipOpen:function(){
				if(openMopTip==true){
					/*put content*/
					$("#mopTip01 .content").html(mopTipContent);
					$("#mopTip01").show();
					mopTipOpened=true;
					mopTipCount+=1;
				}
			},
			/*close*/
			tipClose:function(){
				$("#mopTip01 .close").hide();
				$("#mopTip01 .arrow").hide();
				$("#mopTip01 .arrowBottom").hide();
				$("#mopTip01").hide();
				mopTipOpened=false;
				openMopTip=false;
				mopTipPin=false;
			}
			
		}
	}
});
