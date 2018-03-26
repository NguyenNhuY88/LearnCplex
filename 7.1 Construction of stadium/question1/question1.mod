/*********************************************
 * OPL 12.6.2.0 Model
 * Author: Nhu Y
 * Creation Date: Mar 22, 2018 at 10:43:14 PM
 *********************************************/
int N = 19;
range TASKS = 1..N;
int ARC[1..N][1..N]=...;
float DUR[TASKS]=...;

dvar float+ start[TASKS];

minimize start[N];

subject to {
	forall(i,j in TASKS){
		if(ARC[i][j]==1)	
			start[i] + DUR[i] <= start[j];
	} 
}

execute {
  writeln (" the minimum of time to constructor the medium is: ", cplex.getObjValue()," weeks");

  var ofile = new IloOplOutputFile("D:\\OPL\\LearnCplex\\7.1 Construction of stadium\\resultObj1.dat");
  
  ofile.writeln(cplex.getObjValue());
  ofile.close();
}
