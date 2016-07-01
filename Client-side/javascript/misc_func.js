var bridge_mainLeft_indicator;
var bridge_mainRight_indicator;
var bridge_mainCenter_indicator;
var bridge_foldbackCenter_indicator;
var chapel_mainSide_indicator;
var chapel_mainCenter_indicator;
var chapel_foldbackSide_indicator;
var gym_mainSide_indicator;
var well_mainCenter_indicator;


function replaceInnerHTML() {
	/* Power statuses */
	document.getElementById("bridge_mainLeft_power").innerHTML = bridge_mainLeft_power;
	document.getElementById("bridge_mainRight_power").innerHTML = bridge_mainRight_power;
	document.getElementById("bridge_mainCenter_power").innerHTML = bridge_mainCenter_power;
	document.getElementById("bridge_foldbackCenter_power").innerHTML = bridge_foldbackCenter_power;
	document.getElementById("chapel_mainSide_power").innerHTML = chapel_mainSide_power;
	document.getElementById("chapel_mainCenter_power").innerHTML = chapel_mainCenter_power;
	document.getElementById("chapel_foldbackSide_power").innerHTML = chapel_foldbackSide_power;
	document.getElementById("gym_mainSide_power").innerHTML = gym_mainSide_power;
	document.getElementById("well_mainCenter_power").innerHTML = well_mainCenter_power;
	
	/* Hours times */
	document.getElementById("bridge_mainLeft_hours").innerHTML = bridge_mainLeft_hours;
	document.getElementById("bridge_mainRight_hours").innerHTML = bridge_mainRight_hours;
	document.getElementById("bridge_mainCenter_hours").innerHTML = bridge_mainCenter_hours;
	document.getElementById("bridge_foldbackCenter_hours").innerHTML = bridge_foldbackCenter_hours;
	document.getElementById("chapel_mainSide_hours").innerHTML = chapel_mainSide_hours;
	document.getElementById("chapel_mainCenter_hours").innerHTML = chapel_mainCenter_hours;
	document.getElementById("chapel_foldbackSide_hours").innerHTML = chapel_foldbackSide_hours;
	document.getElementById("gym_mainSide_hours").innerHTML = gym_mainSide_hours;
	document.getElementById("well_mainCenter_hours").innerHTML = well_mainCenter_hours;
	
}

function statusDot() {
	if (bridge_mainLeft_power == "OFF") { bridge_mainLeft_indicator = '<img src="images/red-dot.png" alt="red-dot">'; }
	else {
		if (bridge_mainLeft_power == "ON") { bridge_mainLeft_indicator = '<img src="images/green-dot.png" alt="green-dot">'; }
		else { bridge_mainLeft_indicator = '<img src="images/flashing-orange.gif" alt="warning/error">'; }
	}
}