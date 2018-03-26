/*********************************************
 * OPL 12.6.2.0 Model
 * Author: Thuong
 * Creation Date: Mar 23, 2018 at 11:27:13 AM
 *********************************************/
int N = 19;
range TASKS = 1..N;
int ARC[1..N][1..N]=...;
float DUR[TASKS]=...;
dvar float+ start[TASKS];

int BONUS = ...;
float MAXW[TASKS] = ...;
float COST[TASKS] =...;

dvar int+ save[TASKS];
string s;
dexpr float profit = BONUS*save[N] - sum(i in 1..N-1)COST[i]*save[i];
execute {
   var f = new IloOplInputFile("D:\\OPL\\LearnCplex\\7.1 Construction of stadium\\resultObj1.txt");
   if (f.exists) {
     writeln("the file obj1.txt exists");
     while (!f.eof) {
      s=f.readline();
      obj1 = cplex.intValue(s);
      writeln(s);
     }
     f.close();
   } else { 
     writeln("the file output.txt doesn't exist");
   }
}
int obj1 = intValue(s);
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

	writeln("total profit ", cplex.getObjValue(), " obj1: ", obj1);
	writeln("save ", save[N]);
}