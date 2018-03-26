/*********************************************
 * OPL 12.6.2.0 Model
 * Author: Thuong
 * Creation Date: Mar 23, 2018 at 11:27:13 AM
 *********************************************/
int N = 19;
range TASKS = 1..N;
float ARC[1..N][1..N]=...;
float DUR[TASKS]=...;
dvar float+ start[TASKS];

int BONUS = ...;
float MAXW[TASKS] = ...;
float COST[TASKS] =...;

dvar int+ save[TASKS];
int obj1;
dexpr float profit = BONUS*save[N] - sum(i in 1..N-1)COST[i]*save[i];
maximize profit;

subject to {
	forall(i,j in TASKS){
	  if(ARC[i][j]==1)
	  		start[j] - start[i] + save[i] >= DUR[i];
	}
	start[N] + save[N]== obj1;
	forall(i in 1..N-1) save[i] <= MAXW[i];
}
execute {
	writeln("total profit ", cplex.getObjValue());
	writeln("save ", save[N]);
/*	thisOplModel.generate();
		if (cplex.solve()) {
	 		writeln("result2: ", cplex.getObjValue());
		}
		else{
			writeln ("No solution1");
		}*/
} 
main {
	var proj = new IloOplProject("D:\\OPL\\LearnCplex\\7.1 Construction of stadium\\question1");
	var rc = proj.makeRunConfiguration();
	rc.oplModel.generate();
	
	rc.cplex.solve();
	 	thisOplModel.obj1  == rc.cplex.getObjValue();
	
		
	 	writeln("result2: ", rc.cplex.getObjValue(), " obj1 =  ", thisOplModel.obj1);
		rc.end();
		proj.end();	
		thisOplModel.generate();
		if (cplex.solve()) {
	 		writeln("result2: ", cplex.getObjValue());
		}
		else{
			writeln ("No solution1");
		}
	
}
	  