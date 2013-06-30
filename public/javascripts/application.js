function toggle_div(name) {
	$(name).toggle();
}

function clearDefault(fld, defval)
{
	if (fld.value == defval) { fld.value == ''}
}

/* see: http://www.bloggingdeveloper.com/post/Disable-Form-Submit-on-Enter-Key-Press.aspx */
function disableEnterKey(e)
{
	var key;
	if (window.event) {
		key = window.event.keyCode; //IE
	}
	else {
	  key = e.which; //firefox
	}
	return (key != 13);
}

/*-------------------- Messenger Functions ------------------------------*/
// The following object and code was taken and modified from Jaded 
// Pixel's Shopify system. (http://www.myshopify.com/javascripts/shopify.js)
//
// Messenger is used to manage error messages and notices
//
var Messenger = {
  autohide_error: null,
  autohide_notice: null,
  // When given an error message, wrap it in a list 
  // and show it on the screen.  This message will auto-hide 
  // after a specified amount of miliseconds
  error: function(message) {
    $('flasherrors').update(message);
    new Effect.Appear('flasherrors', {duration: 0.3});
    
    if (this.autohide_error != null) {clearTimeout(this.autohide_error);}
    this.autohide_error = setTimeout(Messenger.fadeError.bind(this), 5000);
  },

  // Notice-level messages.  See Messenger.error for full details.
  notice: function(message) {
    $('flashnotice').update(message);
    new Effect.Appear('flashnotice', {duration: 0.3});

    if (this.autohide_notice != null) {clearTimeout(this.autohide_notice);}
    this.autohide_notice = setTimeout(Messenger.fadeNotice.bind(this), 5000);
  },
  
  // Responsible for fading notices level messages in the dom    
  fadeNotice: function() {
    new Effect.Fade('flashnotice', {duration: 0.3});
    this.autohide_notice = null;
  },
  
  // Responsible for fading error messages in the DOM
  fadeError: function() {
    new Effect.Fade('flasherrors', {duration: 0.3});
    this.autohide_error = null;
  }
}

/*------------------ Macromedia Standard Stuff for Rollovers -----------------*/
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}