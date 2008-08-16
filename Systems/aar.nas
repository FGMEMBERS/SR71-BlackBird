# Properties under /consumables/fuel/tank[n]:
# + level-gal_us    - Current fuel load.  Can be set by user code.
# + level-lbs       - OUTPUT ONLY property, do not try to set
# + selected        - boolean indicating tank selection.
# + density-ppg     - Fuel density, in lbs/gallon.
# + capacity-gal_us - Tank capacity 
#
# Properties under /engines/engine[n]:
# + fuel-consumed-lbs - Output from the FDM, zeroed by this script
# + out-of-fuel       - boolean, set by this code.

# ==================================== timer stuff ===========================================

# set the update period

UPDATE_PERIOD = 0.3;

# set the timer for the selected function

registerTimer = func {
	
	settimer(arg[0], UPDATE_PERIOD);

} # end function 

# =============================== end timer stuff ===========================================



     var initialized = 0;
     var enabled = 0;
    
    print ("running aar");
    #print (" enabled " , enabled,  " initialized ", initialized);  
    
    updateTanker = func {
    #print ("tanker update running ");
                                if (!initialized ) {
                                # print("calling initialize");
                                initialize();}
        
                var Refueling = props.globals.getNode("/systems/refuel/contact");
                var AllAircraft = props.globals.getNode("ai/models").getChildren("tanker");
                var AllMultiplayer = props.globals.getNode("ai/models").getChildren("multiplayer");
                var Aircraft = props.globals.getNode("ai/models/aircraft");
                
    
                
    #   select all tankers which are in contact. For now we assume that it must be in 
    #		contact	with us.
                                
                var selectedTankers = [];
                                
                        if ( enabled ) { # check that AI Models are enabled, otherwise don't bother
                        foreach(a; AllAircraft) { 
                                                              var  id_node = a.getNode("id" , 1 ); 
                                                              var  id = id_node.getValue();
                                                                if ( id != nil ) {
                                                                              var  contact_node = a.getNode( "refuel/contact" );
                                                                               var tanker_node = a.getNode( "tanker" );
                                                                               
                                                                                
                                                                               var contact = contact_node.getValue();
                                                                               var tanker = tanker_node.getValue();
                                                                                
                                                                #print ("contact ", contact , " tanker " , tanker );
                                                                                                                                
                                                                                if (tanker and contact) {
                                                                                                append(selectedTankers, a);
                                                                                } # endif
                                                                } # endif
                        } # end foreach
                                                
                                                foreach(m; AllMultiplayer) {
                                                             var   id_node = m.getNode("id" , 1 );
                                                              var  id = id_node.getValue();
                                                                
                                                                if ( id != nil ) {
                                                                               var  contact_node = m.getNode("refuel/contact");
                                                                                var  tanker_node = m.getNode("tanker");
                                                                                
                                                                                var  contact = contact_node.getValue();
                                                                                var  tanker = tanker_node.getValue();
                                
                                                                                #print (" mp contact ", contact , " tanker " , tanker );
                                                        
                                                                                if (tanker and contact) {
                                                                                                append(selectedTankers, m);
                                                                                } # endif
                                                                }  # endif
                        } # end foreach
                } # endif
                    
                #print ("tankers ", size(selectedTankers) );
    
                if ( size(selectedTankers) >= 1 ){
                        Probe();
                } else {
                        Refueling.setBoolValue(0);
                }
                registerTimer(updateTanker);
    }
    
    # Initalize: Make sure all needed properties are present and accounted
    # for, and that they have sane default values.
    
    initialize = func {
    
        var  AI_Enabled = props.globals.getNode("sim/ai/enabled");
        var  Refueling = props.globals.getNode("/systems/refuel/contact",1);
                        
        Refueling.setBoolValue(0);
        var  enabled = AI_Enabled.getValue();
                
        var  initialized = 1;
    }
    
    initDoubleProp = func {
        node = arg[0]; prop = arg[1]; val = arg[2];
        if(node.getNode(prop) != nil) {
                var  val = num(node.getNode(prop).getValue());
        }
        node.getNode(prop, 1).setDoubleValue(val);
    }
    
    # Fire it up
    if (!initialized) {initialize();}
    registerTimer(updateTanker);
    
    # ====refueling only if  Probe ready=========
    Probe = func {
                Refueling_probe = props.globals.getNode("/systems/refuel/contact");
                Probe_position = getprop("/surface-positions/refueling-pos-norm");
                Probe_control = props.globals.getNode("/controls/flight/probe-refuel");
                Probe_control.setBoolValue(1);
                if (Probe_position ==1){
                    Refueling_probe.setBoolValue(1);
                }else{
                    settimer (Probe,1);
                }
    }
    
    # end
