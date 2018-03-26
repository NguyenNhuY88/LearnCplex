/*********************************************
 * OPL 12.6.2.0 Model
 * Author: Y
 * Creation Date: Mar 13, 2018 at 12:03:02 AM
 *********************************************/
int m = ...;
int n = ...;
range COMP = 1..m;
range RAW = 1..n;
string NAMES[RAW]=...;
dvar float+ USE[RAW];
//float PRODUCE;

float P[RAW][COMP]=...;
float PMIN[COMP] = ...;
float PMAX[COMP]=...;
float AVAIL[RAW]=...;
float COST[RAW]=...;
float DEM=...;

minimize sum(r in RAW) COST[r]*USE[r];

subject to {
//	PRODUCE := sum(r in RAW) USE[r];
	forall (c in COMP){
	  sum(r in RAW) P[r][c]*USE[r] >= PMIN[c]*(sum(r in RAW) USE[r]);
	  sum(r in RAW) P[r][c]*USE[r] <= PMAX[c]*(sum(r in RAW) USE[r]);
	 }
	 
	 forall (r in RAW) USE[r] <= AVAIL[r];
	 (sum(r in RAW) USE[r])>=DEM;
//	 PRODUCE >= DEM;
	 	  
}

execute {

	writeln("Optimal value: ", cplex.getObjValue());
	
	 writeln("Alloys used: ");
	 for(var i in RAW){
	 	if(USE[i] >0)	 
	 		 writeln(NAMES[i],": ", USE[i]);
	}	
	
 }
