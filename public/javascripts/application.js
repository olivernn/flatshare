// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

Event.observe(window, 'load',
      function() { $('busy').hide();}
    );

Ajax.Responders.register({
  onCreate: function() {
    if($$('busy') && Ajax.activeRequestCount>0)
      Effect.Appear('busy',{duration:0.5,queue:'end'});
	  Effect.Appear('busy_bottom',{duration:0.5,queue:'end'});
  },
  onComplete: function() {
    if($$('busy') && Ajax.activeRequestCount==0)
      Effect.Fade('busy',{duration:0.5,queue:'end'});
 	  Effect.Fade('busy_bottom',{duration:0.5,queue:'end'});
  }
});

//this function will act as the opposite of the HTML tag <noscript> it will unhide everything that is set as hidden
//this means that elements classed as 'scriptOnly' will be hidden if javascript is disabled
function scriptOnly(){
	//var scriptOnlyTags = document.getElementsByClassName('script_only');
	var scriptOnlyTags = $$('form input');
	for(i=0; i<scriptOnlyTags.length; i++){
		//scriptOnlyTags[i].setStyle({visibility:'visible'});
		scriptOnlyTags[i].style.visibility = 'visible';
	}
}

//this is to allow the dynamic link to add a bookmark to the site
function bookmarksite(title,url){
if (window.sidebar) // firefox
	window.sidebar.addPanel(title, url, "");
else if(window.opera && window.print){ // opera
	var elem = document.createElement('a');
	elem.setAttribute('href',url);
	elem.setAttribute('title',title);
	elem.setAttribute('rel','sidebar');
	elem.click();
} 
else if(document.all)// ie
	window.external.AddFavorite(url, title);
}

function spin_div(div_id) {
  container = $(div_id);
  positioning = 'top: '+container.offsetTop+'px; width: '+container.offsetWidth+'px; height: '+container.offsetHeight+'px; ';
  container.innerHTML += '<div class="spin_div" style="position: absolute; ' + positioning + '"></div>';
}