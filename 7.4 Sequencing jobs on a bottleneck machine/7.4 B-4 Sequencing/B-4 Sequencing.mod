/*********************************************
 * OPL 12.7.1.0 Model
 * Author: Chung
 * Creation Date: Mar 23, 2018 at 12:15:57 AM
 *********************************************/
 using CP;
int NJ = 7;						//Number of jobs
range JOBS = 1..NJ;

int REL[JOBS] = ...;			//Release dates of jobs
int DUR[JOBS] = ...;			//Durations of jobs
int DUE[JOBS] = ...;			//Due dates of jobs

dvar boolean rank[JOBS][JOBS];	//=1 if job j at position k
dvar int+ start[JOBS];			//Start time of job at position k
dvar int+ comp[JOBS];			//Completion time of job at position k
dvar int+ late[JOBS];			//Lateness of job at position k
dvar int+ finish;				//Completion time of the entire schedule

dexpr int e1 = finish;
dexpr int e2 = sum(k in JOBS) comp[k];
dexpr int e3 = sum(k in JOBS) late[k];
 minimize staticLex(e1,e2,e3);

subject to {
	// One job per position
	forall(k in JOBS) sum(j in JOBS) rank[j][k] == 1;
	
	//One position per job
  	forall(j in JOBS) sum(k in JOBS) rank[j][k] == 1;
	
	//Sequence of jobs
  	forall(k in 1..NJ-1)
   		start[k+1] >= start[k] + sum(j in JOBS) DUR[j]*rank[j][k];
   		
   	//Start times
  	forall(k in JOBS) start[k] >= sum(j in JOBS) REL[j]*rank[j][k];
  	
  	//Completion times
  	forall(k in JOBS) comp[k] == start[k] + sum(j in JOBS) DUR[j]*rank[j][k];
  	
  	//
  	forall(k in JOBS) finish >= comp[k];
  	
  	forall(k in JOBS) late[k] >= comp[k] - sum(j in JOBS) DUE[j]*rank[j][k]; 
}

// SOLUTION PRINTING
execute to {
	
}
