# By G ROBIN  , that nasal code must not be modified
#
#COPIED FROM F8E CRUSADER, some componants are not usables with the F4U CORSAIRE========================
#
#========SAISIE=====================================

setprop("/preset/input/modrw",0);
#*********read=0********** write=1**********************

setprop("/preset/input/standby",0);
#**********normal=0********standby=1*****************


setprop("/preset/input/chan-XX",01);
#***************from 1 to 20****************************

setprop("/preset/input/selector",0);
#**************manual=0***********preset=1*********

setprop("/preset/input/store",0);
#*************transmit=1****************************

setprop("/preset/input/freqtype",0);
#***0=adf********1=dme*******2=nav**************3=comm*********4=acls*********


setprop("instrumentation/heading-indicator/nav-switch",0);
#*********    Manuel = 0 ,3   ADF  = 1  NAV =2 

setprop("/instrumentation/tacan/indicated-bearing-true-deg",0);
setprop("/instrumentation/heading-indicator/switch-tacan-acls",0);
#temporairement tacan est exclusif à TACAN  et acls dédié à MARKER ADF DME NAV
#*********ŧacan=0              acls=1

setprop("/environment/magnetic-variation-deg",0);
#zone tampon et fonction de mise en forme======================================

setprop("/preset/input/val-XXn-nn",0);
setprop("/preset/input/val-nnX-nn",0);
setprop("/preset/input/val-nnn-XX",0);

setprop("/preset/input/frequence",0);

frequence=0;



val_XXn_nn=getprop("/preset/input/val-XXn-nn");
val_nnX_nn=getprop("/preset/input/val-nnX-nn");
val_nnn_XX=getprop("/preset/input/val-nnn-XX");


channel=[];
setsize(channel,10);

channel[0]="0";
channel[1]="1";
channel[2]="2";
channel[3]="3";
channel[4]="4";
channel[5]="5";
channel[6]="6";
channel[7]="7";
channel[8]="8";
channel[9]="9";


#mise en forme des données pour affichage==============================================


format_display = func{
	val_XXn_nn=int(frequence/10);
	val_nnX_nn=int(frequence-(val_XXn_nn*10));
	val_nnn_XX=int(frequence*100)-int(val_XXn_nn*1000)-int(val_nnX_nn*100);
	setprop("/preset/input/val-XXn-nn",val_XXn_nn);
	setprop("/preset/input/val-nnX-nn",val_nnX_nn);
	setprop("/preset/input/val-nnn-XX",val_nnn_XX);	
}

#mise en forme des données pour transfert==============================================

format_write = func{
	val_XXn_nn=getprop("/preset/input/val-XXn-nn");
	val_nnX_nn=getprop("/preset/input/val-nnX-nn");
	val_nnn_XX=getprop("/preset/input/val-nnn-XX");
	frequence=int(val_XXn_nn*10)+val_nnX_nn+(val_nnn_XX/100);
	setprop("/preset/input/frequence",frequence);
}

#=============================ADF====================================

init_adf=func{
	for(i=0;i<20;i=i+1){
		select_num=i;
		setprop("/preset/presets["~select_num~"]/selected/adf-freq-khz",000.00);
		setprop("/preset/presets["~select_num~"]/standby/adf-freq-khz",000.00);
	}
}
#init_adf();



setprop("/preset/adf/frequencies/selected-khz",0);
setprop("/preset/adf/frequencies/standby-khz",0);

load_preset_adf_frequency=func{
	select_num=getprop("/preset/input/chan-XX")-1;	
	setprop("/preset/adf/frequencies/selected-khz",getprop("/preset/presets["~select_num~"]/selected/adf-freq-khz"));
	setprop("/instrumentation/adf/frequencies/selected-khz",getprop("/preset/adf/frequencies/selected-khz"));
}
	
write_preset_adf_frequency=func{	
	store_num=getprop("/preset/input/chan-XX")-1;	
	setprop("/preset/adf/frequencies/selected-khz",frequence);
	setprop("/preset/presets["~store_num~"]/selected/adf-freq-khz",getprop("/preset/adf/frequencies/selected-khz"));
}



read_adf_frequency=func{
	if(getprop("/preset/input/selector")==1){
		load_preset_adf_frequency();
	}	
	frequence=getprop("/instrumentation/adf/frequencies/selected-khz");
	setprop("/preset/input/frequence",frequence);
	format_display();
}

write_adf_frequency=func{
	frequence=getprop("/preset/input/frequence");
	setprop("/instrumentation/adf/frequencies/selected-khz",frequence);
}




#===========================DME===========================================


init_dme=func{
	for(i=0;i<20;i=i+1){
		    select_num=i;
		    setprop("/preset/presets["~select_num~"]/selected/dme-freq-mhz",000.00);
		    setprop("/preset/presets["~select_num~"]/standby/dme-freq-mhz",000.00);
	}
}
#init_dme();





setprop("/preset/dme/frequencies/selected-mhz",0);
setprop("/preset/dme/frequencies/standby-mhz",0);



load_preset_dme_frequency=func{
	select_num=getprop("/preset/input/chan-XX")-1;
	setprop("/preset/dme/frequencies/selected-mhz",getprop("/preset/presets["~select_num~"]/selected/dme-freq-mhz"));
	setprop("/instrumentation/dme/frequencies/selected-mhz",getprop("/preset/dme/frequencies/selected-mhz"));
}



write_preset_dme_frequency=func{	
	store_num=getprop("/preset/input/chan-XX")-1;
	setprop("/preset/dme/frequencies/selected-mhz",frequence);
	setprop("/preset/presets["~store_num~"]/selected/dme-freq-mhz",getprop("/preset/dme/frequencies/selected-mhz"));
}



read_dme_frequency=func{
	if(getprop("/preset/input/selector")==1){
		load_preset_dme_frequency();
	}
	if(getprop("/instrumentation/dme/frequencies/selected-mhz")==nil){
	frequence=0;
	}else{
	frequence=getprop("/instrumentation/dme/frequencies/selected-mhz");
	}
	setprop("/preset/input/frequence",frequence);
	format_display();
}


write_dme_frequency=func{
	frequence=getprop("/preset/input/frequence");
	setprop("/instrumentation/dme/frequencies/selected-mhz",frequence);
}



#=============================NAV ILS====================================


init_nav=func{
	for(i=0;i<20;i=i+1){
		    select_num=i;
		    setprop("/preset/presets["~select_num~"]/selected/nav-freq-mhz",000.00);
		    setprop("/preset/presets["~select_num~"]/standby/nav-freq-mhz",000.00);
	}
}
#init_nav();



setprop("/preset/nav/frequencies/selected-mhz",0);
setprop("/preset/nav/frequencies/standby-mhz",0);


load_preset_nav_freq = func {
	select_num=getprop("/preset/input/chan-XX")-1;
	setprop("/preset/nav/frequencies/selected-mhz",getprop("/preset/presets["~select_num~"]/selected/nav-freq-mhz"));
	setprop("/instrumentation/nav/frequencies/selected-mhz",getprop("/preset/nav/frequencies/selected-mhz"));
}



write_preset_nav_frequency=func{	
	store_num=getprop("/preset/input/chan-XX")-1;	
	setprop("/preset/nav/frequencies/selected-mhz",frequence);
	setprop("/preset/presets["~store_num~"]/selected/nav-freq-mhz",getprop("/preset/nav/frequencies/selected-mhz"));
}



read_nav_frequency= func {
	if(getprop("/preset/input/selector")==1){
		load_preset_nav_freq();
	}	
	frequence=getprop("/instrumentation/nav/frequencies/selected-mhz");
	setprop("/preset/input/frequence",frequence);
	format_display();
	}

write_nav_frequency=func{
	frequence=getprop("/preset/input/frequence");
	setprop("/instrumentation/nav/frequencies/selected-mhz",frequence);
}

#=============================COMM====================================


init_comm=func{
	for(i=0;i<20;i=i+1){
		select_num=i;
		setprop("/preset/presets["~select_num~"]/selected/comm-freq-mhz",000.00);
		setprop("/preset/presets["~select_num~"]/standby/comm-freq-mhz",000.00);
	}
}
#init_comm();



setprop("/preset/comm/frequencies/selected-mhz",0);
setprop("/preset/comm/frequencies/standby-mhz",0);


load_preset_nav_frequency=func{
	select_num=getprop("/preset/input/chan-XX")-1;
	setprop("/preset/comm/frequencies/selected-mhz",getprop("/preset/presets["~select_num~"]/selected/comm-freq-mhz"));
	setprop("/instrumentation/comm/frequencies/selected-mhz",getprop("/preset/comm/frequencies/selected-mhz"));	
}


write_preset_comm_frequency=func{	
	store_num=getprop("/preset/input/chan-XX")-1;
	setprop("/preset/comm/frequencies/selected-mhz",frequence);
	setprop("/preset/presets["~store_num~"]/selected/comm-freq-mhz",getprop("/preset/comm/frequencies/selected-mhz"));	
}



read_comm_frequency=func{
	if(getprop("/preset/input/selector")==1){
		load_preset_nav_frequency();
	}	
	frequence=getprop("/instrumentation/comm/frequencies/selected-mhz");
	setprop("/preset/input/frequence",frequence);
	format_display();
}

write_comm_frequency=func{
	frequence=getprop("/preset/input/frequence");
	setprop("/instrumentation/comm/frequencies/selected-mhz",frequence);
}


#Affichage des frequences================================================

display_frequency=func{
	if(getprop("/preset/input/modrw")==0){
		if(getprop("/preset/input/freqtype")==0){
		read_adf_frequency();
		}
		elsif(getprop("/preset/input/freqtype")==1){
		read_dme_frequency();
		}
		elsif(getprop("/preset/input/freqtype")==2){
		read_nav_frequency();
		}
		elsif(getprop("/preset/input/freqtype")==3){
		read_comm_frequency();
		}
	}
	elsif(getprop("/preset/input/modrw")==1){
	frequence=0;
	format_display();
	}	
}

display_frequency();

setlistener("/preset/input/freqtype",display_frequency);

setlistener("/preset/input/modrw",display_frequency);

setlistener("/preset/input/chan-XX",display_frequency);

setlistener("/preset/input/selector",display_frequency);


#Stockage des frequences================================================

transfer_frequency=func{
	if(getprop("/preset/input/modrw")==1){
		format_write();
		#print("Frequence:   ",frequence);
		if(getprop("/preset/input/selector")==0){
			if(getprop("/preset/input/freqtype")==0){
			write_adf_frequency();
			}
			elsif(getprop("/preset/input/freqtype")==1){
			write_dme_frequency();
			}
			elsif(getprop("/preset/input/freqtype")==2){
			write_nav_frequency();
			}
			elsif(getprop("/preset/input/freqtype")==3){
			write_comm_frequency();
			}
		} else {
		preset_storage();
		}
	}
}


preset_storage=func{
	if(getprop("/preset/input/freqtype")==0){
	write_preset_adf_frequency();
	}
	elsif(getprop("/preset/input/freqtype")==1){
	write_preset_dme_frequency();
	}
	elsif(getprop("/preset/input/freqtype")==2){
	write_preset_nav_frequency();
	}
	elsif(getprop("/preset/input/freqtype")==3){
	write_preset_comm_frequency();
	}	
}

transfer_frequency();

setlistener("/preset/input/store",transfer_frequency);



#init_adf(); init_dme(); init_nav(); init_comm();


#Specifique  HSI  ACLS  instruments========
orientation=nav_heading=fromto_pointer=store_heading_marker=store_course_pointer=aig_course_pointer=aig_heading_marker=course_pointer_calc=0;

setprop("/instrumentation/heading-indicator/heading-marker",0);
setprop("/instrumentation/heading-indicator/manual-heading",0);
setprop("/instrumentation/heading-indicator/setting-manual-hdg",0);
setprop("/instrumentation/heading-indicator/course-pointer",0);
setprop("/instrumentation/heading-indicator/switch-tacan-acls",0);


setprop("/instrumentation/heading-indicator/fromto-pointer",0);

setprop("/orientation/heading-magnetic-deg",0);
setprop("/instrumentation/nav[0]/heading-deg",0);

cal_fromto_pointer=func{
		orientation=getprop("/orientation/heading-magnetic-deg");
		nav_heading=getprop("/instrumentation/nav[0]/heading-deg");
		fromto_pointer= orientation - nav_heading ;
		if (fromto_pointer <0 ){
		fromto_pointer=360 + fromto_pointer;
		}		
		if (fromto_pointer>30 and fromto_pointer< 90){
		fromto_pointer=30;
		}
		elsif (fromto_pointer<150 and fromto_pointer >= 90){
		fromto_pointer=150;
		}
		elsif (fromto_pointer>210 and fromto_pointer <= 270){
		fromto_pointer=210;
		}elsif
		(fromto_pointer<330 and fromto_pointer > 270){
		fromto_pointer=330;
		}
		setprop("instrumentation/heading-indicator/fromto-pointer",fromto_pointer);
		settimer(cal_fromto_pointer,0.1);
}
cal_fromto_pointer();

#aig_course_pointer  	aig_heading_markr  pour garder la position en mémoire lorsque nav-switch activé

course_pointer=func{
	if (getprop("/instrumentation/heading-indicator/switch-tacan-acls")==1){
		if (getprop("/instrumentation/heading-indicator/nav-switch")==1 ){
		course_pointer_calc=getprop("/instrumentation/adf/indicated-bearing-deg")+getprop("/orientation/heading-magnetic-deg");
			if(course_pointer_calc>360){
			setprop("/instrumentation/heading-indicator/course-pointer",course_pointer_calc-360);
			}else{
			setprop("/instrumentation/heading-indicator/course-pointer",course_pointer_calc);
			}
		}
		elsif (getprop("/instrumentation/heading-indicator/nav-switch")==2 ){
		setprop("/instrumentation/heading-indicator/course-pointer",getprop("/instrumentation/nav[0]/heading-deg"));
		}
		elsif (getprop("/instrumentation/heading-indicator/nav-switch")==3 ){
			if(aig_course_pointer==1){
			aig_course_pointer=0;
			setprop("/instrumentation/heading-indicator/setting-manual-hdg",store_course_pointer);
			}
		store_course_pointer=getprop("/instrumentation/heading-indicator/setting-manual-hdg");		
		setprop("/instrumentation/heading-indicator/course-pointer",store_course_pointer);
		}		
	}
	elsif	(getprop("/instrumentation/heading-indicator/switch-tacan-acls")==0){
	setprop("/instrumentation/heading-indicator/course-pointer",getprop("/instrumentation/tacan/indicated-bearing-true-deg")-getprop("/environment/magnetic-variation-deg"));		
	}
	if (getprop("/instrumentation/heading-indicator/nav-switch")!=3 or getprop("/instrumentation/heading-indicator/switch-tacan-acls")==0){
		if(aig_heading_marker==1){
		aig_heading_marker=0;
		setprop("/instrumentation/heading-indicator/setting-manual-hdg",store_heading_marker);
		}
	store_heading_marker=getprop("/instrumentation/heading-indicator/setting-manual-hdg");
	setprop("/instrumentation/heading-indicator/heading-marker",store_heading_marker);
	}	
	settimer(course_pointer,0,1);
}
course_pointer();


survey_nav_switch=func{	
	aig_course_pointer=1;
	aig_heading_marker=1;	
}

setlistener("/instrumentation/heading-indicator/nav-switch",survey_nav_switch,3);



#Pilote Automatique============F8E======================================================================

#========F8E==========setprop("/autopilot/switch-heading",0);

																		#========F8E==========setprop("/autopilot/locks/heading", "");
#========F8E==========setprop("/autopilot/switch-master",0);

#FIXE ME must be done Bug-Heading****************
#FIXE ME  test si  instrument OK (voltage OK)

survey_hdg_autopilot=func{
	if(getprop("/autopilot/switch-heading")==1) {	
		setprop("/autopilot/switch-master",1);
		if(getprop("/instrumentation/heading-indicator/switch-tacan-acls")==1){
			if (getprop("/instrumentation/heading-indicator/nav-switch")==0){ 			
			setprop("/autopilot/settings/heading-bug-deg",getprop("/instrumentation/heading-indicator/heading-marker"));
			}
			if (getprop("/instrumentation/heading-indicator/nav-switch")!=0){ 	
			setprop("/autopilot/settings/heading-bug-deg",getprop("/instrumentation/heading-indicator/course-pointer"));
			}
			if (getprop("/autopilot/locks/heading")==""){
			setprop("/autopilot/locks/heading", "dg-heading-hold");
			}
		}
		if(getprop("/instrumentation/heading-indicator/switch-tacan-acls")==0){
			setprop("/autopilot/settings/true-heading-deg",getprop("/instrumentation/heading-indicator/course-pointer"));
			if (getprop("/autopilot/locks/heading")==""){
			setprop("/autopilot/locks/heading", "true-heading-hold");
			}
		}	
		settimer(survey_hdg_autopilot,0);
	}else{
	setprop("/autopilot/locks/heading", "");
	
	}
}


#==========F8E===============setlistener("/autopilot/switch-heading",survey_hdg_autopilot);

#FIXE ME  test si  instrument OK (voltage OK)

setprop("/autopilot/switch-altitude",0);
preset_alt=getprop("/autopilot/settings/target-altitude-ft");
setprop("/autopilot/locks/altitude", "");


survey_alt_autopilot=func{
	if(getprop("/autopilot/switch-altitude")==1) {
		setprop("/autopilot/switch-master",1);
		if (getprop("/autopilot/locks/altitude")==""){
		setprop("/autopilot/locks/altitude", "altitude-hold");
		setprop("/autopilot/settings/target-altitude-ft",getprop("/position/altitude-ft"));
		}
		settimer(survey_alt_autopilot,0);
	}else{
	setprop("/autopilot/locks/altitude", "");
	}
}

setlistener("/autopilot/switch-altitude",survey_alt_autopilot);








#Tacan********************************************************************************
setprop("/instrumentation/tacan/frequencies/valueXY",0);



basculeXY = func{
	if(getprop("/instrumentation/tacan/frequencies/selected-channel[4]")=="X"){
	setprop("/instrumentation/tacan/frequencies/selected-channel[4]","Y");
	setprop("/instrumentation/tacan/frequencies/valueXY",1);
	}else{
	setprop("/instrumentation/tacan/frequencies/selected-channel[4]","X");
	setprop("/instrumentation/tacan/frequencies/valueXY",0);
	}
}


setprop("/instrumentation/tacan/frequencies/valueCh1",0);
setprop("/instrumentation/tacan/frequencies/valueCh1",getprop("/instrumentation/tacan/frequencies/selected-channel[1]"));

Init_Ch1=func{
	valueCh1=getprop("/instrumentation/tacan/frequencies/valueCh1");
	setprop("/instrumentation/tacan/frequencies/selected-channel[1]",channel[valueCh1]);	
}
setlistener("/instrumentation/tacan/frequencies/valueCh1",Init_Ch1);



setprop("/instrumentation/tacan/frequencies/valueCh2",0);
setprop("/instrumentation/tacan/frequencies/valueCh2",getprop("/instrumentation/tacan/frequencies/selected-channel[2]"));

Init_Ch2=func{
	valueCh2=getprop("/instrumentation/tacan/frequencies/valueCh2");
	setprop("/instrumentation/tacan/frequencies/selected-channel[2]",channel[valueCh2]);
}

setlistener("/instrumentation/tacan/frequencies/valueCh2",Init_Ch2);


setprop("/instrumentation/tacan/frequencies/valueCh3",0);
setprop("/instrumentation/tacan/frequencies/valueCh3",getprop("/instrumentation/tacan/frequencies/selected-channel[3]"));

Init_Ch3=func{	
	valueCh3=getprop("/instrumentation/tacan/frequencies/valueCh3");
	setprop("/instrumentation/tacan/frequencies/selected-channel[3]",channel[valueCh3]);
}
setlistener("/instrumentation/tacan/frequencies/valueCh3",Init_Ch3);






#Bug Heading===========F4U============PROVISOIRE   TEMPORARY===============




Init_BugH=func{
	setprop("/autopilot/settings/heading-bug-deg",getprop("/instrumentation/heading-indicator/heading-marker"));
}

setlistener("/instrumentation/heading-indicator/heading-marker",Init_BugH);