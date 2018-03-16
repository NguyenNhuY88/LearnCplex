/*********************************************
 * OPL 12.6.2.0 Model
 * Author: Y
 * Creation Date: Mar 16, 2018 at 4:03:53 PM
 *********************************************/
 int NW = 11;
 int NL = 3;
 range WAGONS = 1..NW;
 range SLOTS = 1..(ftoi(round(NW/NL)));
 float LOSS[WAGONS] = ...;
 float LIFE[WAGONS] =...;
 int DUR =...;
 dvar boolean process[WAGONS][SLOTS];
 
 minimize sum(w in WAGONS, s in SLOTS) s*DUR*LOSS[w]*process[w][s];
 
 subject to {
 	forall (w in WAGONS) sum(s in SLOTS) process[w][s] == 1;
 	forall (s in SLOTS) sum (w in WAGONS) process[w][s] <= NL; 
 	forall (w in WAGONS) sum (s in SLOTS) s*process[w][s] <= LIFE[w]/DUR;
 	 
 }
 execute {
 	writeln("minimum loss of sugar", cplex.getObjValue());	 	
 	for(var s in SLOTS ){
 	
 		write("slot " ,s, " include wagon: ");	
 		for(var w in WAGONS){
 			if(process[w][s]==1) 	
 				write(w, " ,sugar loss: ", LOSS[w]*s*DUR ,"; ")
 		}
 		
 		writeln("");
 	}
 	
 }
