// power
var bridge_mainLeft_power = 'GEEK_ERR';
var bridge_mainRight_power = 'GEEK_ERR';
var bridge_mainCenter_power = 'GEEK_ERR';
var bridge_foldbackCenter_power = 'GEEK_ERR';
var chapel_mainSide_power = 'GEEK_ERR';
var chapel_mainCenter_power = 'GEEK_ERR';
var chapel_foldbackSide_power = 'GEEK_ERR';
var gym_mainSide_power = 'GEEK_ERR';
var well_mainCenter_power = 'GEEK_ERR';
// hours
var bridge_mainLeft_hours = 'GEEK_ERR';
var bridge_mainRight_hours = 'GEEK_ERR';
var bridge_mainCenter_hours = 'GEEK_ERR';
var bridge_foldbackCenter_hours = 'GEEK_ERR';
var chapel_mainSide_hours = 'GEEK_ERR';
var chapel_mainCenter_hours = 'GEEK_ERR';
var chapel_foldbackSide_hours = 'GEEK_ERR';
var gym_mainSide_hours = 'GEEK_ERR';
var well_mainCenter_hours = 'GEEK_ERR';
// indicator
var bridge_mainLeft_indicator = 'GEEK_ERR';
var bridge_mainRight_indicator = 'GEEK_ERR';
var bridge_mainCenter_indicator = 'GEEK_ERR';
var bridge_foldbackCenter_indicator = 'GEEK_ERR';
var chapel_mainSide_indicator = 'GEEK_ERR';
var chapel_mainCenter_indicator = 'GEEK_ERR';
var chapel_foldbackSide_indicator = 'GEEK_ERR';
var gym_mainSide_indicator = 'GEEK_ERR';
var well_mainCenter_indicator = 'GEEK_ERR';

var sdRED = '<img src="images/red-dot.png" alt="red-dot">';
var sdORANGE = '<img src="images/flashing-orange.gif" alt="warning/error">';
var sdGREEN = '<img src="images/green-dot.png" alt="green-dot">';

var myVar = setInterval(doStuffOverAndOver,500);

function doStuffOverAndOver() {
	readVars();
	runThings();
}

function runThings() {
	powerToStatusDot();
	replaceInnerHTML();
}

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

	/* Status indicators */
	document.getElementById("bridge_mainLeft_indicator").innerHTML = bridge_mainLeft_indicator;
	document.getElementById("bridge_mainRight_indicator").innerHTML = bridge_mainRight_indicator;
	document.getElementById("bridge_mainCenter_indicator").innerHTML = bridge_mainCenter_indicator;
	document.getElementById("bridge_foldbackCenter_indicator").innerHTML = bridge_foldbackCenter_indicator;
	document.getElementById("chapel_mainSide_indicator").innerHTML = chapel_mainSide_indicator;
	document.getElementById("chapel_mainCenter_indicator").innerHTML = chapel_mainCenter_indicator;
	document.getElementById("chapel_foldbackSide_indicator").innerHTML = chapel_foldbackSide_indicator;
	document.getElementById("gym_mainSide_indicator").innerHTML = gym_mainSide_indicator;
	document.getElementById("well_mainCenter_indicator").innerHTML = well_mainCenter_indicator;
	
}

/*
var indicatorStrings = [
	bridge_mainLeft_indicator,
	bridge_mainRight_indicator,
	bridge_mainCenter_indicator,
	bridge_foldbackCenter_indicator,
	chapel_mainSide_indicator,
	chapel_mainCenter_indicator,
	chapel_foldbackSide_indicator,
	gym_mainSide_indicator,
	well_mainCenter_indicator,
];
*/

function powerToStatusDot() {
	/* Bridge */
	bridge_mainLeft_indicator = statusDot(bridge_mainLeft_power);
	bridge_mainRight_indicator = statusDot(bridge_mainRight_power);
	bridge_mainCenter_indicator = statusDot(bridge_mainCenter_power);
	bridge_foldbackCenter_indicator = statusDot(bridge_foldbackCenter_power);

	/* Chapel */
	chapel_mainSide_indicator = statusDot(chapel_mainSide_power);
	chapel_mainCenter_indicator = statusDot(chapel_mainCenter_power);
	chapel_foldbackSide_indicator = statusDot(chapel_foldbackSide_power);

	/* Gym */
	gym_mainSide_indicator = statusDot(gym_mainSide_power);

	/* Well */
	well_mainCenter_indicator = statusDot(well_mainCenter_power);
}

//indicatorStrings.forEach(statusDot);

function statusDot(sdVal) { // "sd" = "status dot"
	if (sdVal == "OFF") {
		return sdRED;
	}
	else {
		if (sdVal == "ON") {
			return sdGREEN;
		}
		else {
			return sdORANGE;
		}
	}
}
	
