//提示弹框
function firstClick(message){
    alert("点击成功");
}

//确认弹框
function secondClick(){
    var con=confirm("喜欢玫瑰花吗？");
    if(con==true)
        alert("非常喜欢!");
    else alert("不喜欢!");
}

//输入弹框
function thirdClick(){
    var name=prompt("请问你叫什么名字?");
    alert(name);
}

//js交互方式一: 通过拦截url方式, 网址中拼接的内容
function normalClick() {
    LoadUrl("app://shareClick?title=分享的标题&content=分享的内容&url=链接地址&imagePath=图片地址");
}

function LoadUrl(url){
    var iFrame;
    iFrame = document.createElement("iframe");
    iFrame.setAttribute("src", url);
    document.body.appendChild(iFrame);
    iFrame.parentNode.removeChild(iFrame);
    iFrame = null;
}

//js交互方式二: 使用js传值
function JSClick(array) {
//    alert(JSON.stringify(GetDeviceSysInfo()))
    window.webkit.messageHandlers.universal.postMessage(array);
}

//自定义
function asyncAlert(content) {
    setTimeout(function(){
               alert(content);
               },1);
}

//获取参数,url拼接方式
function getParams() {
    var params = window.location.href.split("?")[1];
    alert(params);
}

function getQueryString(key) {
    var _url = window.location.href;
    var qulist = _url.match(new RegExp('[^\?&]*' + key + '=+[^&]*'));
    var v = qulist ? qulist[0].split('=')[1] : null;
    alert(v + "v");
}

//获取WebGL版本
function GetDeviceSysInfo() {
    var canvasObj = document.createElement("canvas");
    if (canvasObj && "function" == typeof canvasObj.getContext)
        //根据不同的渲染支持
        for (var webgls = ["webgl", "webgl2", "experimental-webgl2", "experimental-webgl"], r = 0; r < webgls.length; r++) {
            var webgl = webgls[r],
                cavContext = canvasObj.getContext(webgl);
            if (cavContext) { //获取canvas的上下文成功
                var params = {};
                params.context = webgl,
                    params.version = cavContext.getParameter(cavContext.VERSION),
                    params.vendor = cavContext.getParameter(cavContext.VENDOR),
                    params.sl_version = cavContext.getParameter(cavContext.SHADING_LANGUAGE_VERSION),
                    params.max_texture_size = cavContext.getParameter(cavContext.MAX_TEXTURE_SIZE);
                var debugInfo = cavContext.getExtension("WEBGL_debug_renderer_info");
                return debugInfo && (params.vendor = cavContext.getParameter(debugInfo.UNMASKED_VENDOR_WEBGL),
                    params.renderer = cavContext.getParameter(debugInfo.UNMASKED_RENDERER_WEBGL)), params
            }
        }
    return {}
}
