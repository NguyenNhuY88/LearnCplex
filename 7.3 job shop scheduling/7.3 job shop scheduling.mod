/*********************************************
 * OPL 12.6.2.0 Model
 * Author: Y
 * Creation Date: Mar 25, 2018 at 9:15:16 AM
 *********************************************/
range TASKS = 1..8;
int DUR[TASKS]=...;
int ARC[TASKS][TASKS]=...;
int DISJ[TASKS][TASKS]=...;

dvar float start[TASKS];
dvar float finish;
dvar boolean y[TASKS];
float BIGM = sum(j in TASKS) DUR[j];

minimize finish;

subject to{
	forall(j in TASKS) finish >= start[j] + DUR[j];
	forall(i,j in TASKS :  ARC[i][j]!= 0) {
			 start[i] +DUR[i] <= start[j];
	}
	
	forall(i,j in TASKS ,d in TASKS: i < j && DISJ[i][j]!=0){
		
	  start[i]+DUR[i] <= start[j]+BIGM*y[d];
	  start[j] + DUR[j] <= start[i] + BIGM*(1-y[d]);
	}	
	finish <= BIGM;
	
}