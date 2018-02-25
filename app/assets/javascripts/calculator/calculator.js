var staDatelimit = moment("8/30/1973","MM/DD/YYYY"),	// Assumed Earliest Possible staDate Date
	n = 1;	

/* Calculator Functions */
		function compute(i){		//Computes Everthing
			i = (typeof i == 'undefined')? 0: i;
			
			computeOne(i);
			i++;
			
			if (i == n) return;
			else compute(i);
		}
		function computeOne(i){		//Computes Set for One Scholarship
			var out = findOutbx((get("areaInp_"+i).checked == true)? "Abroad":"Local",		//	Area
								(get("paidInp_"+i).checked == true)? "SLWOP":"SLWP",		//	Paid
								getV("staDate_"+i),											//	Start Date
								moment(getV("endDate_"+i)).add(1,'d').format("MM/DD/YYYY"),	//	End Date
								getV("repDate_"+i),											//	Report Date
								getV("basDate_"+i)											//	Basis Date
							);
			get("endOfCO_"+i).value = moment(out[2]).subtract(1,'d').format("MM/DD/YYYY");								//End Date of CO
			get("tSpanSL_"+i).value = out[0][0] + "y " + out[0][1] + "m " + out[0][2] + "d (" + out[0][3] + " days)";	//Duration of SL
			get("tSpanCO_"+i).value = out[1][0] + "y " + out[1][1] + "m " + out[1][2] + "d (" + out[1][3] + " days)";	//Duration of CO
			get("tSpanNS_"+i).value = out[3][0] + "y " + out[3][1] + "m " + out[3][2] + "d (" + out[3][3] + " days)";	//Duration Left
		}
		
		/* Main Function */
		function findOutbx(areaT,paidT,a,b,c,d){ //area,paid,start,end,report,basis(optional,default:report)
			/* Default Assignment */
			var c = (typeof c == 'undefined')? b: c,							//default report date is end date
				d = (typeof d == 'undefined')? Math.floor(new Date()): d,		//default basis date is report date
				outbx = [],														//output
				dateE = moment(b),												//date (end)
				yyyy = dateE						.diff(moment(a),'y'),		//number (year)
				mmmm = dateE	.subtract(yyyy,'y')	.diff(moment(a),'M'),		//number (month)
				dddd = dateE	.subtract(mmmm,'M')	.diff(moment(a),'d'),		//number (day)
				days = dayDiff(new Date(a),new Date(b));						//number (dayTotal)
			
			/* Duration of Leave */											//array (y,m,d,D)
				/*outbx[0]*/	outbx.push([yyyy, mmmm, dddd, days]);
			
			/* Get Modifier and Apply */
		if((paidT === 'SLWOP' || paidT ===  'SDWOP') && areaT === 'Local'){
				var	tymSpan = moment(c).add(Math.ceil(days/2),'d'),
					endOfCO = moment(c).add(Math.ceil(days/2),'d');
				yyyy = tymSpan						.diff(moment(c),'y'),
				mmmm = tymSpan	.subtract(yyyy,'y')	.diff(moment(c),'M'),
				dddd = tymSpan	.subtract(mmmm,'M')	.diff(moment(c),'d');
			} else {
				if((paidT === 'SLWP' || paidT === 'SDWP') && areaT === 'Abroad'){
					yyyy = (moment(a).isAfter(moment("8/21/1989","MM/DD/YYYY")))? yyyy*2: yyyy*3;
					if(mmmm+dddd == 0)	mmmm = 0, dddd = 0;
					else if(mmmm<2)		mmmm = 6, dddd = 0;
					else if(mmmm<6)		mmmm = 0, dddd = 0, yyyy += 1;
					else 				mmmm = 0, dddd = 0, yyyy += 2;
				}
				var endOfCO = moment(c).add(yyyy,'y').add(mmmm,'M').add(dddd,'d');
			}

			days = dayDiff(moment(c),endOfCO);
			
			/* Duration of Service */										//array (y,m,d,D)
				/*outbx[1]*/	outbx.push([yyyy, mmmm, dddd, days]);
			/* End Date of Service */										//string (date)
				/*outbx[2]*/	outbx.push(endOfCO.format("MM/DD/YYYY"));

			endOfCO = moment(outbx[2]),			
			d = (moment(d).isAfter(moment(c)))? d:c,
			days = dayDiff(new Date(d),new Date(outbx[2])),
			yyyy = endOfCO						.diff(moment(d),'y'),
			mmmm = endOfCO	.subtract(yyyy,'y')	.diff(moment(d),'M'),
			dddd = endOfCO	.subtract(mmmm,'M')	.diff(moment(d),'d');

			/* Duration of Balance */										//array (y,m,d,D)
				/*outbx[3]*/	outbx.push((days < 0)? [0,0,0,0]: [yyyy, mmmm, dddd, days]);

			return outbx;
		}
		
		/*Completer Functions (Unfinished)*/
		function findStart(a,b) { 		//date,[year,month,day] or days		return date
			if (typeof b == 'number')		return moment(a).subtract(b, 'd');
			else if (typeof b == 'object')	return moment(a).subtract(b[0],'d').subtract(b[1],'M').subtract(b[0],'y');
			else console.log('Error');
		}
		function findAfter(a,b) { 		//date,[year,month,day] or days		return date
			if (typeof b == 'number')		return moment(a).add(b, 'd');
			else if (typeof b == 'object')	return moment(a).add(b[0],'d').add(b[1],'M').add(b[0],'y');
			else console.log('Error');
		}		
		function addPeriod(a,b) {
			return [a[0]+b[0],a[1]+b[1],a[2]+b[2]];
		}
		
		/*Shortcuts*/
		function dayDiff(a,b) {return Math.ceil((b - a)/86400000);}			//Difference in Days

/* Fundamental Functions */
		/* Initialization */
		function iListen(i){				// Initialize Listen			
			get("staDate_"+i)	.addEventListener("change", function(){limitS(i)}),
			get("endDate_"+i)	.addEventListener("change", function(){limitE(i)}),
			get("repDate_"+i)	.addEventListener("change", function(){limitR(i)}),
			get("basDate_"+i)	.addEventListener("change", function(){limitB(i)});
		}
		function iValue(i){				// Initialize Values
			var today = moment().format("MM/DD/YYYY"),
				aMoSD = moment().add(2,'M').subtract(1,'d').format("MM/DD/YYYY"),
				addMo = moment().add(2,'M').format("MM/DD/YYYY");
			get('staDate_'+i).value = today,
			get('endDate_'+i).value = aMoSD,
			get('repDate_'+i).value = addMo,
			get('basDate_'+i).value = addMo;
			compute();
		}	
		
		/* Listener Functions */
		var listenerts = [];
		function doListen(i){			// Add Event Listeners
			var solve = function(){compute(i)};
			get("staDate_"+i)	.addEventListener("change", solve),
			get("endDate_"+i)	.addEventListener("change", solve),
			get("repDate_"+i)	.addEventListener("change", solve),
			get("basDate_"+i)	.addEventListener("change", solve);
			listenerts.push(solve);
		}
		function unListen(i){			// Removes Event Listeners
			var solve = listenerts.pop();
			get("staDate_"+i)	.removeEventListener("change", solve),
			get("endDate_"+i)	.removeEventListener("change", solve),
			get("repDate_"+i)	.removeEventListener("change", solve),
			get("basDate_"+i)	.removeEventListener("change", solve);
		}

/* Button Functions */
		function changeUpdate(){		// Button: Autocompute: ON or OFF
			var update = get("update").value;
			
			if(update == "Autocompute: ON"){
				get("update").value = "Autocompute: OFF";
				for(var i=(n-1); 0<=i; i--){
					get("comBut_"+i).disabled = !get("comBut_"+i).disabled;
					unListen(i);
				}
			} else {
				get("update").value = "Autocompute: ON";
				for(var i=0; i<n; i++){
					get("comBut_"+i).disabled = 'true'; //disables the Compute button
					doListen(i);
				}
			}
		}
		function tCompute(){
			if(get("update").value == "Autocompute: ON") compute();
		}

/* Limiters Functions */
		function limitS(i){				// Limit Date (Start)
			var dateS = moment(get("staDate_"+i).value),
				dateE = moment(get("endDate_"+i).value).add(1,'d'),
				dateU = moment(get("endDate_"+i).value).subtract(2,'M');
			
			if (dateS <= staDatelimit){
				console.log("!: You can't precede the BOR cited in the faculty manual ruling.");
				get("staDate_"+i).value = staDatelimit.format("MM/DD/YYYY");
			}
			if (dateS > dateU){
				console.log("!: The minimum allowed duration is two months.");
				get("endDate_"+i).value = dateS.add(2,'M').subtract(1,'d').format("MM/DD/YYYY");
				limitE(i);
			}
		}
		function limitE(i){				// Limit Date (End)
			var dateS = moment(get("staDate_"+i).value),
				dateE = moment(get("endDate_"+i).value).add(1,'d'),
				dateU = moment(get("staDate_"+i).value).add(2,'M');

			if (dateU > dateE){
				console.log("!: The minimum allowed duration is two months.");
				get("staDate_"+i).value = dateE.subtract(2,'M').format("MM/DD/YYYY");;
			}
			if (dateE <= staDatelimit){
				console.log("!: You can't precede the BOR cited in the faculty manual ruling.");
				get("staDate_"+i).value = staDatelimit.format("MM/DD/YYYY");
				get("endDate_"+i).value = staDatelimit.format("MM/DD/YYYY");
				limitS(i);
			}
			get("repDate_"+i).value = moment(get("endDate_"+i).value).add(1,'d').format("MM/DD/YYYY");
			get("basDate_"+i).value = moment(get("endDate_"+i).value).add(1,'d').format("MM/DD/YYYY");
		}
		function limitR(i){				// Limit Date (Report)
			var dateS = moment(get("staDate_"+i).value),
				dateE = moment(get("endDate_"+i).value).add(1,'d'),
				dateR = moment(get("repDate_"+i).value),
				dateU = moment(get("staDate_"+i).value).add(2,'M');
				
			if (dateS >= dateR) get("repDate_"+i).value = dateS.format("MM/DD/YYYY");
			if (dateE > dateR){
				console.log("!: The report date must be after the end date. Two months shall be the least duration.");
				get("repDate_"+i).value = dateU.format("MM/DD/YYYY");
				get("endDate_"+i).value = dateU.subtract(1,'d').format("MM/DD/YYYY");
			}
		}
		function limitB(i){				// Limit Date (Basis)
			var dateS = moment(get("staDate_"+i).value),
				dateB = moment(get("basDate_"+i).value);
				
			if (dateS >= dateB) get("basDate_"+i).value = dateS.format("MM/DD/YYYY");
		}

/* Shortcuts */
	function get(a) {return document.getElementById(a);}			//Shortcut: Get Element
	function getV(a) {return document.getElementById(a).value;}		//Shortcut: Get Value