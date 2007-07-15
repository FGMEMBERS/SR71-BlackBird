#Parachute de freinage=========================================
#switch chute
#
switch1=1;
switch0=0;
Aig=0;
deployed=0;
setprop("fdm/jsbsim/fcs/chute-switch-once",switch0);

Chute_once=func{
                    if (getprop("sim/model/controls/chute") == 1 ) {
                        if (getprop("fdm/jsbsim/fcs/brake-chute-deploy") != deployed and Aig == 1) {
                            setprop("fdm/jsbsim/fcs/chute-switch-once",switch1);
                        }else{
                        if (getprop("fdm/jsbsim/fcs/brake-chute-deploy") == 1 and Aig == 0 ){
                            Aig=1;
                            deployed=getprop("fdm/jsbsim/fcs/brake-chute-deploy");
                            print("brake-chute-once");
                        }
                        }
                        #print("hh");
                     settimer(Chute_once,1);
                    } else {
                    Aig=0;
                    print("Aig");
                    }
        }

setlistener("sim/model/controls/chute",Chute_once);

print("start init");


#Alimentation Electrique========Allumé   Coupé===========================================


Aig_AC=0;
setprop("/controls/electric/master-switch",Aig_AC);

Electric_Cmt=func{
        Aig_AC=getprop("/controls/electric/master-switch");
        Aig_AC=1-Aig_AC;
        setprop("/controls/electric/master-switch",Aig_AC);
}

Electric_Cmd=func{
        if(getprop("/controls/electric/master-switch")=="1"){
        setprop("/controls/electric/battery-switch","true");
        setprop("controls/electric/external-power", "true");
        setprop("/controls/engines/engine[0]/master-bat", "true");
        
        setprop("/controls/switches/master-avionics", "true");  
        }
        elsif(getprop("/controls/electric/master-switch")=="0"){
        setprop("/controls/electric/battery-switch","false");
        setprop("controls/electric/external-power", "false");
        setprop("/controls/engines/engine[0]/master-bat", "false");
        
        setprop("/controls/switches/master-avionics", "false");
        setprop("/controls/lighting/instruments-norm",0);
        }
}
Electric_Cmd();

setlistener("/controls/electric/master-switch",Electric_Cmd);


#Control des eclairages==============================

setprop("/sim/model/blackbird-sr71/lighting/instrument-lights",0);
 #seulement pour initialiser en valeur numerique
setprop("/systems/electrical/outputs/instrument-lights",0);

Light_Cmd=func{ 
                if(getprop("/systems/electrical/outputs/instrument-lights")>27){
                        Light_Value=getprop("/sim/model/blackbird-sr71/lighting/instrument-lights");
                        setprop("/controls/lighting/instruments-norm",Light_Value);
                }       
}               
setlistener("/sim/model/blackbird-sr71/lighting/instrument-lights",Light_Cmd);


#Control Moteur  "Engine Master"=======from f8e  adapted to sr71=======================

setprop("/controls/switches/delay",0 );
setprop("/controls/engines/engine[0]/fuel-pump",0);

Cutoff_Cmd=func{
        setprop("/controls/switches/delay",0 );
        setprop("controls/engines/engine[0]/throttle",0);
        setprop("controls/engines/engine[1]/throttle",0);
        if(getprop("/controls/engines/engine[0]/fuel-pump")==1){
                setprop("/controls/engines/engine[0]/cutoff",1);
                setprop("/controls/engines/engine[0]/fuel-pump",0);
      }elsif (getprop("/controls/engines/engine[1]/fuel-pump")==1){
                setprop("/controls/engines/engine[1]/cutoff",1);
                setprop("/controls/engines/engine[1]/fuel-pump",0);
        }else{
        Eng_Master_On();        
        }
}       
        
Eng_Master_On=func{             
                setprop("/controls/engines/engine[0]/fuel-pump",1);
                setprop("/controls/engines/engine[1]/fuel-pump",1);
                interpolate("/controls/switches/delay",5,1 );
                if (getprop("/controls/switches/delay")==5){
                        if (getprop("/systems/electrical/outputs/fuel-pump")>27){
                                setprop("/controls/engines/engine[0]/cutoff",0);
                                setprop("/controls/engines/engine[1]/cutoff",0);
                        }else{
                                setprop("/controls/engines/engine[0]/fuel-pump",0);
                                setprop("/controls/engines/engine[1]/fuel-pump",0);
                        }
                }else{
                settimer(Eng_Master_On,1);
                }       
}


