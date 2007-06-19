# By G ROBIN  
# Basically copied from f8e  model and customized to blackbird model
# $Id$
# refueling ===========================================================
# we presume a pump capacity of 24 galon_us per second ===== =======



capacity=9000;
#"gal_us "    #Main =4500  (tank[0])    #Transfer= 4500   (tank[1])
sec_qty=14;

tank_mainfirst=4500;
tank_transferfirst=4500;

refueling_time=0;
now_ready=0;
ref_switch=0;
now_qty=0;
orig_qty_tk0=0;
orig_qty_tk1=0;
new_qty=0;
probe_ready = 0;
pump_ready=0;
ref_alarm=30;

setprop("/instrumentation/annunciator/refuel-overload",0);
setprop("consumables/fuel/transfer/level-gal_us",0);
setprop("instrumentation/annunciator/refuel-pump",0);
setprop("systems/refuel/contact","false");

refuel= func {		
		if(getprop("/position/altitude-agl-ft")>300 and getprop("/instrumentation/airspeed-indicator/indicated-speed-kt")>200){
		probe_ready= getprop("/surface-positions/refueling-pos-norm");
			if (probe_ready == 0) {	
			setprop("/controls/flight/probe-refuel",1);
			refuel_air();
			} else {
			setprop("/controls/flight/probe-refuel",0);
			ref_switch=0;
			delete_f();
			}
		}
		elsif
		(getprop("/position/altitude-agl-ft")<7 and getprop("/instrumentation/airspeed-indicator/indicated-speed-kt")<20){
		pump_ready = getprop("instrumentation/annunciator/refuel-pump");
			if (pump_ready == 0) {
			setprop("instrumentation/annunciator/refuel-pump",1);
			setprop ("/surface-positions/refueling-pos-norm",0);
			refuel_ground();
			}else{
			setprop("instrumentation/annunciator/refuel-pump",0);
			ref_switch=0;
			delete_f();
			}
		}
		else{
		print("refuel prohibited");
		return;
		}
}


refuel_air=func {
		probe_ready= getprop("/surface-positions/refueling-pos-norm");
		if (probe_ready == 1){
			setprop("instrumentation/annunciator/refuel-pump",1);
			print (probe_ready);
			now_ready  = getprop("sim/time/elapsed-sec");
			orig_qty_tk0=getprop("consumables/fuel/tank/level-gal_us");
			orig_qty_tk1=getprop("consumables/fuel/tank[1]/level-gal_us");
			now_qty = orig_qty_tk0+orig_qty_tk1;
			print("new =",new_qty," tk1 =",orig_qty_tk1," tk0 =",orig_qty_tk0);
			req_qty = capacity - now_qty;	
			refueling_time = req_qty / sec_qty;
			print(refueling_time);
			ref_switch=1;	
			full_up();
		}else{
		settimer (refuel_air,1);
		}
}

refuel_ground=func {
		pump_ready = getprop("instrumentation/annunciator/refuel-pump");
		if (pump_ready == 1){
			now_ready  = getprop("sim/time/elapsed-sec");
			orig_qty_tk0=getprop("consumables/fuel/tank/level-gal_us");
			orig_qty_tk1=getprop("consumables/fuel/tank[1]/level-gal_us");
			now_qty = orig_qty_tk0+orig_qty_tk1;
			print("new =",new_qty," tk1 =",orig_qty_tk1," tk0 =",orig_qty_tk0);
			req_qty = capacity - now_qty;	
			refueling_time = req_qty / sec_qty;
			print(refueling_time);
			ref_switch=1;	
			full_up();	
		}else{
		settimer (refuel_air,1);
		}		
}

full_up=func {
		if (ref_switch == 0) {
		not_filled();
		} else {
			now  = getprop("sim/time/elapsed-sec");
			if (now - now_ready > refueling_time ) {
			filled();
			} else {
			durat_time = now - now_ready;
			fill_qty = sec_qty * durat_time;
			new_qty = now_qty + fill_qty;
	#print("new",new_qty,"tk1",orig_qty_tk1,"tk0",orig_qty_tk0,tank_transferfirst);
			if (new_qty-orig_qty_tk0>=tank_transferfirst){
			setprop("consumables/fuel/tank[1]/level-gal_us",tank_transferfirst);
			setprop("consumables/fuel/tank[0]/level-gal_us",new_qty-tank_transferfirst);
			}else{
			setprop("consumables/fuel/tank[1]/level-gal_us",new_qty-orig_qty_tk0);
			}			
			if (new_qty > capacity-ref_alarm){
			setprop("/instrumentation/annunciator/refuel-overload",1);
			}
			settimer (full_up,1);
			}
		} 
		}

filled=func {
		setprop("consumables/fuel/tank/level-gal_us",tank_mainfirst);
		setprop("consumables/fuel/tank[1]/level-gal_us",tank_transferfirst);
                setprop("/controls/flight/probe-refuel",0);
		setprop("/instrumentation/annunciator/refuel-overload",0);
		setprop("consumables/fuel/transfer/level-gal_us",0);
		setprop("instrumentation/annunciator/refuel-pump",0);
		print ("Filled up");
}
not_filled=func {		
		setprop("consumables/fuel/transfer/level-gal_us",0);
		setprop("/instrumentation/annunciator/refuel-overload",0);
		setprop("instrumentation/annunciator/refuel-pump",0);
		print ("Not filled up, your new capacity is:  ", new_qty );
}
delete_f=func {
		print ("operation aborted");
}




Refuel_Contact=func{
	if(getprop("/systems/refuel/contact")==1){
		refuel();
	}	
}
setlistener(getprop("/systems/refuel/contact"),Refuel_Contact);



#===============================================================