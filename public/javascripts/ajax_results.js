function getMoreHistory() {
	var indexVal = parseInt($("history_index").value);
	var params = "page=" + indexVal;
	if (indexVal <= parseInt($("total_pages").value)) {
		new Ajax.Request(document.location, {asynchronous:true, method: 'post', onComplete: addMoreHistory, onFailure: failure, parameters: params});
	}
}

function failure() {
	$("more_history").innerHTML = "<p><strong>Could not contact the server.</strong><br />Please wait awhile and try again. <br /><br />We apologize for the inconvenience.</p>";
}

function addMoreHistory(ajax){
	var response = ajax.responseText;

	if (response == "No results!") {
		Element.hide("more_history");
		Element.show("no_results");
		Element.hide("more_loading");
	} else {
		if (parseInt($("total_pages").value) == 1) {
			$("more_history").innerHTML += response;
			Element.hide("more_loading");
			Element.hide("page_end");
		} else {
			if (parseInt($("history_index").value) == parseInt($("total_pages").value)) {
				$("more_history").innerHTML += response;
				Element.hide("more_loading");
				Element.show("page_end");
				$("history_index").value = parseInt($("history_index").value) + 1;
			} else {
				Element.show("more_loading");
				$("more_history").innerHTML += response;
				$("history_index").value = parseInt($("history_index").value) + 1;
			}
		}
	}
	
	isUpdating = false;
}

function updatePage(){
	if (isUpdating == false && mouseState == "up" && getPageHeight() - getScrollHeight() < preloadDistance) {
		setCookie(id, $("history_index").value );
		isUpdating = true;
		getMoreHistory();
	}
	if (parseInt($("history_index").value) <= parseInt($("total_pages").value) && parseInt($("total_pages").value) != 1) {
		setTimeout("updatePage()", checkInterval);
	}
}

function onMouseDown(e ){
	mouseState = "down";
	setCookie(id+"_height", getScrollHeight());
	setCookie(id+"_scroll", getScrollHeight() - _getWindowHeight());
}

function onMouseUp(){
	mouseState = "up";
}

var checkInterval = 200;
var preloadDistance = 1000;
var isUpdating = false;
var mouseState = "up";
var id;

function init( ){
	document.onmousedown = onMouseDown;
	document.onmouseup = onMouseUp;

	id = $("page_id").value;

	var fromBackButton = false;
	if (getCookie(id)){ fromBackButton = true; }
	else{ setCookie(id, "1") }

	if( fromBackButton ) {
		$("spacer").style.height = getCookie(id+"_height") + "px";
		scroll(0, getCookie(id + "_scroll") );            
	}

	$("history_index").value = 1;
	/*setTimeout("updatePage()", 10000);*/
}

Event.observe(window, 'load', init, false);

function setCookie(name, value, expires, path, domain, secure) {
  document.cookie= name + "=" + escape(value) +
    ((expires) ? "; expires=" + expires.toGMTString() : "") +
    ((path) ? "; path=" + path : "") +
    ((domain) ? "; domain=" + domain : "") +
    ((secure) ? "; secure" : "");
}

function getCookie(name) {
  var dc = document.cookie;
  var prefix = name + "=";
  var begin = dc.indexOf("; " + prefix);
  if (begin == -1) {
    begin = dc.indexOf(prefix);
    if (begin != 0) return null;
  } else {
    begin += 2;
  }
  var end = document.cookie.indexOf(";", begin);
  if (end == -1) {
    end = dc.length;
  }
  return unescape(dc.substring(begin + prefix.length, end));
}

function deleteCookie(name, path, domain) {
	if (getCookie(name)) {
    document.cookie = name + "=" +
      ((path) ? "; path=" + path : "") +
      ((domain) ? "; domain=" + domain : "") +
      "; expires=Thu, 01-Jan-70 00:00:01 GMT";
	}
}

function getPageHeight(){
  var y;
  var test1 = document.body.scrollHeight;
  var test2 = document.body.offsetHeight
  if (test1 > test2) {
    y = document.body.scrollHeight;
  } else {
	  y = document.body.offsetHeight;
  }
  return parseInt(y);
}

function _getWindowHeight(){
  if (self.innerWidth) {
		frameWidth = self	.innerWidth;
		frameHeight = self.innerHeight;
  } else if (document.documentElement && document.documentElement.clientWidth) {
    frameWidth = document.documentElement.clientWidth;
    frameHeight = document.documentElement.clientHeight; 
  } else if (document.body) {
    frameWidth = document.body.clientWidth;
    frameHeight = document.body.clientHeight;
  }
  return parseInt(frameHeight);
}

function getScrollHeight(){
  var y;
  // all except Explorer
  if (self.pageYOffset) {
      y = self.pageYOffset;
  } else if (document.documentElement && document.documentElement.scrollTop) {
      y = document.documentElement.scrollTop;
  } else if (document.body)	{
      y = document.body.scrollTop;
  }
  return parseInt(y)+_getWindowHeight();
}