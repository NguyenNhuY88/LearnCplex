/*********************************************
 * OPL 12.6.2.0 Model
 * Author: Y
 * Creation Date: Apr 21, 2018 at 11:36:01 PM
 *********************************************/
range DEPOTS =1..12;
range CUST = 1..12;
int COST[DEPOTS][CUST] = ...;
int CFIX[DEPOTS]=...;
int CAP[DEPOTS]=...;
int DEM[CUST]=...;
dvar float+ fflow[DEPOTS][CUST];
dvar boolean build[DEPOTS];

minimize sum(d in DEPOTS, c in CUST) COST[d,c]*fflow[d,c] + sum(d in DEPOTS) CFIX[d]*build[d];

subject to{
	forall( c in CUST) sum (d in DEPOTS) fflow[d,c]==1;
	
	forall(d in DEPOTS) sum (c in CUST) DEM[c]*fflow[d,c] <=CAP[d]*build[d];
	forall(d in DEPOTS, c in CUST) fflow[d,c]<=1;	
}
execute {
	writeln("total cost: ", cplex.getObjValue());
	for(var d in DEPOTS)
	{
		if(build[d]==1)	{
			writeln("\n\ndepot ", d ," deliver to: ");	
			for(var c in COST)
			{
				if(fflow[d][c]!=0)
					write( "customer ",c, ":  ", DEM[c]*fflow[d][c], ";\t");
			}		
		}
		
	}
}