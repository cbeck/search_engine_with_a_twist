var find_it = true;

function clear_filter() {
	$('search_activity_do').checked = false
	$('search_activity_do').up().className = 'filter'
	$('search_activity_shop').checked = false
	$('search_activity_shop').up().className = 'filter'
	$('search_activity_see').checked = false
	$('search_activity_see').up().className = 'filter'
	$('search_activity_find').checked = false
	$('search_activity_find').up().className = 'filter'
	$$("li.activity_see").invoke("show");
	$$("li.activity_do").invoke("show");
	$$("li.activity_shop").invoke("show");
	if (!find_it)
		toggle_find_it();
}

function highlight_filter() {
	var arr = ['do', 'see', 'shop', 'find'];	
	
	for (var i=0; i<4; i++) {
		if ($('search_activity_'+arr[i]).checked) {
			$('search_activity_'+arr[i]).up().className = 'selected-filter';
			if (arr[i] == 'see') {
				$$("li.activity_see").invoke("show");
				$$("li.activity_do").invoke("hide");
				$$("li.activity_shop").invoke("hide");
				if (!find_it)
					toggle_find_it();
			}	else if (arr[i] == 'do') {
				$$("li.activity_see").invoke("hide");
				$$("li.activity_do").invoke("show");
				$$("li.activity_shop").invoke("hide");
				if (!find_it)
					toggle_find_it();
			} else if (arr[i] == 'shop') {
				$$("li.activity_see").invoke("hide");
				$$("li.activity_do").invoke("hide");
				$$("li.activity_shop").invoke("show");
				if (!find_it)
					toggle_find_it();
			}	else {
				toggle_find_it();
			}	
		}
		else {
			$('search_activity_'+arr[i]).up().className = 'filter';
		}
	}
}

function toggle_find_it() {
	if (find_it) {
		var locs = getElementsByClassName("location");
		for(var i=0,j=locs.length; i<j; i++)
			locs[i].className = 'highlight-green-action';
		find_it = false;
	} else {
		var locs = getElementsByClassName("highlight-green-action");
		for(var i=0,j=locs.length; i<j; i++)
			locs[i].className = 'location';
		find_it = true;
	}
}



function getElementsByClassName(classname, node) {
	if(!node) node = document.getElementsByTagName("body")[0];
	var a = [];
	var re = new RegExp('\\b' + classname + '\\b');
	var els = node.getElementsByTagName("*");
	for(var i=0,j=els.length; i<j; i++)
		if(re.test(els[i].className))a.push(els[i]);
	return a;
}





