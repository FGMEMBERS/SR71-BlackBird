# ================================== EHSI Stuff ===================================


range_control_node = props.globals.getNode("/instrumentation/radar/range-control", 1);
range_node = props.globals.getNode("/instrumentation/radar/range", 1);
wx_range_node = props.globals.getNode("/instrumentation/wxradar/range", 1);
x_shift_node=  props.globals.getNode("instrumentation/tacan/display/x-shift", 1);
x_shift_scaled_node=  props.globals.getNode("instrumentation/tacan/display/x-shift-scaled",1);
y_shift_node=  props.globals.getNode("instrumentation/tacan/display/y-shift", 1);
y_shift_scaled_node=  props.globals.getNode("instrumentation/tacan/display/y-shift-scaled",1);
display_control_node = props.globals.getNode("/instrumentation/display-unit/control", 1);
radar_control_node = props.globals.getNode("/instrumentation/radar/mode-control", 1);
radar_mode_control_node = props.globals.getNode("/instrumentation/radar/mode-control", 1);
radar_display_node = props.globals.getNode("/instrumentation/radar/display-mode", 1);

range_control_node.setIntValue(3); 
range_node.setIntValue(40); 
wx_range_node.setIntValue(40); 
x_shift_node.setDoubleValue(0);
x_shift_scaled_node.setDoubleValue(0);
y_shift_node.setDoubleValue(0);
y_shift_scaled_node.setDoubleValue(0);
display_control_node.setIntValue(1);
radar_control_node.setIntValue(1);
var scale = 2.55;	

# Lib functions
pow2 = func(e) { return e ? 2 * pow2(e - 1) : 1 } # calculates 2^e


adjustRange = func{

	range = range_node.getValue();
	range_control = range_control_node.getValue();
	
	range = 5 * pow2(range_control); 

#  	print ("range " , range);

	range_node.setIntValue(range);
	wx_range_node.setIntValue(range);
	scale = 1.275 * pow2 (7 - range_control) * 0.1275;
	scale = sprintf("%2.3f" , scale);

#	print ("scale " , scale);

} # end function adjustRange

scaleShift = func {

	x_shift_scaled_node.setDoubleValue(x_shift_node.getValue() * scale);
	y_shift_scaled_node.setDoubleValue(y_shift_node.getValue() * scale);
#	print ("x-shift-scaled " , x_shift_scaled_node.getValue());
#	print ("y-shift-scaled " , y_shift_scaled_node.getValue());
	settimer(scaleShift, 0.3);

} # end func scaleshift


scaleShift();

setlistener(range_control_node , adjustRange);

updateRadarMode = func{
	radar_mode_control = radar_mode_control_node.getValue();
		if ( radar_mode_control == 2 ) {
				radar_display_node.setValue("map");
		} else {
				radar_display_node.setValue("plan");
		}
} # end func

setlistener( radar_mode_control_node , updateRadarMode );


#end