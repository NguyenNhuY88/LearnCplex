/*********************************************
 * OPL 12.7.1.0 Model
 * Author: Chung
 * Creation Date: Mar 13, 2018 at 9:38:13 PM
 *********************************************/
//declarations
range FOOD = 1..2;
range COMP = 1..3;
string RAW[1..3] = ["oat","maize","molasses"];
range raw = 1..3;

float P[raw][COMP] = ...;
float REQ[COMP] = ...;
float AVAIL[raw] = ...;
float COST[raw] = ...;
float PCOST[1..4] = ...;
float DEM[FOOD] = ...;

//variables
dvar float USE[raw][FOOD];
dvar float produce[FOOD];

//EXPRESSION
dexpr float cost = sum(r in raw, f in FOOD) COST[r]*USE[r][f]
					+ sum(r in raw: r<3, f in FOOD) PCOST[1]*USE[r][f]
					+ sum(r in raw, f in FOOD)PCOST[2]*USE[r][f]
					+ sum(r in raw) PCOST[3]*USE[r][1]
					+ sum(r in raw) PCOST[4]*USE[r][2];
					
//SOLVER
minimize cost;

//constraints
subject to {
	forall(f in FOOD) sum(r in raw) USE[r][f] == produce[f];
	forall(f in FOOD, c in 1..2) sum(r in raw) P[r][c]*USE[r][f] >= REQ[c]*produce[f];
	forall(f in FOOD) sum(r in raw) P[r][3]*USE[r][f] <= REQ[3]*produce[f];
	forall(r in raw) sum(f in FOOD) USE[r][f] <= AVAIL[r];
	forall(f in FOOD) produce[f] >= DEM[f];
} 

//processing
execute {
	writeln("Total cost: " + cost);
	
	writeln("\t\toat \t\t maize \t\t molasses \t\tProteins \t\t Lipits \t\tFIber" );
	var pc;
	for(var f = 1; f <=2; f++){	
	
		if(f==1) write("\nGranule: ");if(f==2) write("\nPowder: ");
		
		for (var r = 1; r <= 3; r++)
			write(USE[r][f] + "\t");	
				
		for(var c = 1; c <= 3; c++){
			pc = 0;		
			for(var R = 1; R <=3 ;R++)
				pc += P[R][c]*USE[R][f];
			write(pc/produce[f] + "% \t");
		}
	}
}


