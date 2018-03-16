/*********************************************
 * OPL 12.6.2.0 Model
 * Author: Y
 * Creation Date: Mar 16, 2018 at 11:05:23 PM
 *********************************************/
range BLOCKS = 1..18;	// set of blocks
//int LEVEL23[1..10] = [9,10, 11, 12, 13, 14, 15, 16, 17, 18];
{int} LEVEL23 = {9,10, 11, 12, 13, 14, 15, 16, 17, 18}; // set of integer blocks in levels 2 and 3
float COST[BLOCKS] =...;
float VALUE[BLOCKS]=...;
int ARC[LEVEL23][1..3]=...;

dvar boolean extract[BLOCKS];

maximize sum(b in BLOCKS) (VALUE[b]-COST[b])*extract[b];

subject to{
	forall(b in LEVEL23)
	  forall(i in 1..3) extract[b] <= extract[ARC[b][i]];
}

execute {
	writeln("the maximal profit per tonne is : $", cplex.getObjValue(),
			". So with 10000 tonnes, profit is: ", cplex.getObjValue()*10000);
	
	writeln("Set of blocks are extracted is: ");
	for(var i in BLOCKS)
		if(extract[i]==1) write(i," ");
}