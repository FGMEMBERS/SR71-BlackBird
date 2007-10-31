# By G ROBIN    May-2005  beta version
#====CRASH_ANIMATION_WITH_JSBSim_FDM====



#===========================INITIALIZATION================================


type = getprop("sim/aircraft");
print ("type: " , type);



#=Init_SENSORS======each_one_being_defined_in_JSBAircraft.xml==========

setprop("gear/gear[3]/wow",0);
setprop("gear/gear[4]/wow",0);
setprop("gear/gear[5]/wow",0);
setprop("gear/gear[6]/wow",0);
setprop("gear/gear[7]/wow",0);
setprop("gear/gear[8]/wow",0);
setprop("gear/gear[9]/wow",0);
setprop("gear/gear[10]/wow",0);
setprop("gear/gear[11]/wow",0);
setprop("gear/gear[12]/wow",0);
setprop("sim/crashed",0);



#==========================



delay = 4;
print ("crash detection ON: ");
crashstart = 0;

# ==========================CRASH MANAGEMENT========================
crash = func {
	setprop("controls/engines/engine[0]/magnetos",0);	
	print ("moteur coupé");
	crashstart = getprop("/sim/time/elapsed-sec");	
	#======include here ===any_animations_we_want========
	print ("start", crashstart);
	crashdeb();
}

#==Delay_before_Stop====
crashdeb = func {
	now  = getprop("sim/time/elapsed-sec");		
	if (now - crashstart > delay ) {
	print ("now", now);	
	crashend();	
	} else {
	settimer (crashdeb,1);
	print ("boucle");
	}		
}
#===fin_crash=========
crashend = func {	
	print ("crash actif");	
	setprop("sim/crashed",1);
	setprop("sim/freeze/clock", 1);	
	setprop("sim/freeze/main", 1)
}
#==another_quick_end_without_delay====		
crashgr = func {
	setprop("controls/engines/engine[0]/magnetos",0);
	print ("moteur coupé");	
	setprop("sim/freeze/clock", 1);	
}






# ==========================CRASH_DETECTION================================



main_loop = func {
	crashedgr = props.globals.getNode("gear/gear[12]/wow",1);
	crashed3 = props.globals.getNode("gear/gear[3]/wow",1);	
	crashed4 = props.globals.getNode("gear/gear[4]/wow",1);
	crashed5 = getprop("gear/gear[5]/wow");	
	crashed6 = getprop("gear/gear[6]/wow");
	crashed7 = getprop("gear/gear[7]/wow");	
	crashed8 = getprop("gear/gear[8]/wow");
	crashed9 = getprop("gear/gear[9]/wow");	
	crashed10 = getprop("gear/gear[10]/wow");
	crashed11 = getprop("gear/gear[11]/wow");

	if (crashed3.getValue()) {
	print ("sensor3");
	#crashgr();	
	} 
	elsif (crashed4.getValue()) {
	print ("sensor4");
	crashgr();	
	} 
	elsif (crashed5 == 1) {
	print ("sensor5");
	crash();
	}
	elsif (crashed6 == 1) {
	print ("sensor6");
	crash();	
	} 	
	elsif (crashed7 == 1) {
	print ("sensor7");
	crash();	
	} 
	elsif (crashed8 == 1) {
	print ("sensor8");
	crash();	
	} 
	elsif (crashed9 == 1) {
	print ("sensor9");
	crash();
	}
	elsif (crashed10  == 1) {
	print ("sensor10");	
	crash();
	}
	elsif (crashed11 == 1) {
	print ("sensor11");
	crash();	
	} 	
	else {
	settimer(main_loop,2);
	}
}
main_loop();

#===========
