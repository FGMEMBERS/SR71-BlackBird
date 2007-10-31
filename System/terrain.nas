terrain_under = func {

var lat = getprop("/position/latitude-deg");
var lon = getprop("/position/longitude-deg");
var info = geodinfo(lat, lon);

    if (info != nil) {
    if (info[1] != nil)
        setprop("/environment/terrain",info[1].solid);
       #print("and it is ", info[1].solid ? "solid ground" : "covered by water");
       #debug.dump(geodinfo(lat, lon));
    }else {
    setprop("/environment/terrain",1);
    }
settimer (terrain_under, 0.1);
}


terrain_under();

