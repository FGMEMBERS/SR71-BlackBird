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

print("start");

test=func{print("DFG");}
#setlistener("sim/model/controls/chute",test);