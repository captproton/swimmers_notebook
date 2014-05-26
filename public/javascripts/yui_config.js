var YUI_config = {
    groups: {
        'jquery': {
            base: 'http://ajax.googleapis.com/ajax/libs/',
            async: false,
            modules: {
                'jquery': {
                    path: 'jquery/1.7/jquery.min.js'
                },
                'jquery-ui': {
                    path: 'jqueryui/1.8/jquery-ui.min.js',
                    requires: ['jquery', 'jquery-ui-css']
                },
                'jquery-ui-css': {
                    path: 'jqueryui/1.8/themes/base/jquery-ui.css',
                    type: 'css'
                }
            }
        },

	    "d3lib": {
	      base: "http://d3js.org/",  //the modules of this group will be downloaded from there
          async: false,
	      modules: {
	        "d3": {
	          path:"d3.v3.min.js",   // base + path = http://d3js.org/d3.v2.js
			  requires: ['d3']
	        },
	        "d3fake": {  //another module of the "d3lib" group
	          path:"d3fake.js"  
	        }
	      }
	    }

    }

};