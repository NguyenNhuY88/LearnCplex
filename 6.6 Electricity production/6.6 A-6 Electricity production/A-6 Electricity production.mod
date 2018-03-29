/*********************************************
 * OPL 12.7.1.0 Model
 * Author: Chung
 * Creation Date: Mar 17, 2018 at 12:44:37 AM
 *********************************************/
int NT = 7;
range TIME = 1..NT;				// Time periods
range TYPES = 1..4;				// Power generator types

float LEN[TIME] = ...; 			// Length of time periods
float DEM[TIME] = ...; 			// Demand of time periods
float PMIN[TYPES] = ...; 			// Min. & max output of a generator type
float PMAX[TYPES] = ...;			// Min. & max output of a generator type
float CSTART[TYPES] =...;			// Start-up cost of a generator
float CMIN[TYPES] = ...;			// Hourly cost of gen. at min. output
float CADD[TYPES] = ...;		// Cost/hour/MW of prod. above min. level
float AVAIL[TYPES] = ...;			// Number of generators per type

dvar int+ start[TYPES][TIME];	// No. of gen.s started in a period
dvar int+ work[TYPES][TIME];		// No. of gen.s working during a period
dvar float+ padd[TYPES][TIME]; 	// Production above min. output level

dexpr float cost = sum(p in TYPES, t in TIME) (CSTART[p]*start[p][t] + LEN[t]*(CMIN[p]*work[p][t] + CADD[p]*padd[p][t]));
minimize cost;

subject to{

	//Number of generators started per period and per type
	forall(p in TYPES, t in TIME){
			if(t > 1) start[p][t] >= work[p][t] - work[p][t-1];
			else start[p][t] >= work[p][t] - work[p][NT];
	}
	
	//Limit on power production above minimum level
	forall(p in TYPES, t in TIME) padd[p][t] <= (PMAX[p] - PMIN[p])*work[p][t];
	
	//Satisfy demands
	forall(t in TIME) sum(p in TYPES) (PMIN[p]*work[p][t] + padd[p][t]) >= DEM[t];
	
	//Security reserve of 20%
	forall(t in TIME) sum(p in TYPES) PMAX[p]*work[p][t] >= 1.20*DEM[t];
	
	//Limit number of available generators; numbers of generators are integer
	forall(p in TYPES, t in TIME){
		work[p][t] <= AVAIL[p];
	}
		
}

