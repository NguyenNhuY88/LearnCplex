/*********************************************
 * OPL 12.7.1.0 Model
 * Author: Chung
 * Creation Date: Mar 22, 2018 at 12:44:40 AM
 *********************************************/
int NM = 3;							//Number of machines
int NJ = 6;							//NUmber of jobs
range MACH = 1..NM;
range RANKS = 1..NJ;
range JOBS = 1..NJ;

int DUR[MACH][JOBS] = ...;			//Durations of jobs on machines

dvar boolean rank[JOBS][RANKS];		//1 if job j has rank k, 0 otherwise
dvar float+ empty[MACH][1..NJ-1];	//Space between jobs of ranks k and k+1
dvar float+ wait[1..NM-1][RANKS];	//Waiting time between machines m and m+1 for job of rank k
dvar float start[MACH][RANKS];

//Objective: total waiting time (= time before first job + times between jobs) on the last machine
dexpr float TotWait = sum(m in 1..NM-1, j in JOBS) (DUR[m][j]*rank[j][1]) + sum(k in 1..NJ-1) empty[NM][k];
minimize TotWait;

subject to{

	//Every position gets a jobs
	forall(k in RANKS) sum(j in JOBS) rank[j][k] == 1;
	
	//Every job is assigned a rank
	forall(j in JOBS) sum(k in RANKS) rank[j][k] == 1;
	
	//Relations between the end of job rank k on machine m and start of job on machine m+1
	forall(m in 1..NM-1, k in 1..NJ-1)	
		empty[m][k] + sum(j in JOBS) DUR[m][j]*rank[j][k+1] + wait[m][k+1]
		== wait[m][k] + sum(j in JOBS) DUR[m+1][j]*rank[j][k] + empty[m+1][k];
		
	//Calculation of start times (to facilitate the interpretation of results)
	forall(m in MACH, k in RANKS)
	  start[m][k] == sum(u in 1..m-1,j in JOBS) DUR[u][j]*rank[j][1] +
	  				 sum(p in 1..k-1,j in JOBS) DUR[m][j]*rank[j][p] +
					 sum(p in 1..k-1) empty[m][p];
	
	//First machine has no idle times
	forall(k in 1..NJ-1) empty[1][k] == 0;
	
	//First job has no waiting times
	forall(m in 1..NM-1) wait[m][1] == 0;
}
