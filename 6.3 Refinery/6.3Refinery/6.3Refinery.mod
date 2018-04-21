/*********************************************
 * OPL 12.6.2.0 Model
 * Author: Y
 * Creation Date: Apr 7, 2018 at 8:43:47 AM
 *********************************************/
{string} CRUDES=...;
{string} FINAL=...;
{string} IDIST=...;
{string} IREF =...;
{string} ICRACK=...;
{string} IPETROL =...;
{string} IDIESEL=...;
{string} IHO= {"hogasoil", "hocrknaphtha", "hocrkgasoil"};
{string} ALLPRODS = FINAL union IDIST  union IREF union ICRACK union IPETROL union IHO union IDIESEL;

float DEM[FINAL]=...;
float COST[CRUDES union IDIST]=...;
float AVAIL[CRUDES]=...;
float OCT[IPETROL]=...;
float VAP[IPETROL]=...;
float VOL[IPETROL]=...;


float SULF[IDIESEL]=...;
float DIST[CRUDES][IDIST]=...;
float REF[IREF]=...;
float CRACK[ICRACK]=...;

dvar float+ use[CRUDES];
dvar float+ produce[ALLPRODS];

dexpr float Cost = sum(c in CRUDES) COST[c]*use[c] + sum(p in IDIST) COST[p]*produce[p];
minimize Cost;
subject to{

	
	forall(p in IDIST) produce[p] <= sum (c in CRUDES) DIST[c][p]*use[c];
	
	//  reforming:
	forall(p in IREF) produce[p] <= REF[p]*produce["naphtha"];
	//cracking:
	forall(p in ICRACK) produce[p]<= CRACK[p]*produce["residue"];
	produce["crknaphtha"] >= produce["petcrknaphtha"] + produce["hocrknaphtha"] + produce["dslcrknaphtha"];
	produce["crkgasoil"] >= produce["hocrkgasoil"]+produce["dslcrkgasoil"];
	//desulfurization
	produce["gasoil"] >= produce["hogasoil"] + produce["dslgasoil"];
	
	
	 produce["butane"]== produce["distbutane"]+produce["refbutane"]-produce["petbutane"];
	 produce["petrol"]== sum(p in IPETROL) produce[p];
	 produce["diesel"]== sum(p in IDIESEL) produce[p];
	 produce["heating"]== sum(p in IHO) produce[p];
	 
	 // Properties diesel oil
	
	
	 sum(p in IPETROL) OCT[p]*produce[p] >=94*produce["petrol"];
	 sum(p in IPETROL) VAP[p]*produce[p] <= 12.7*produce["petrol"];
	 sum(p in IPETROL) VOL[p]*produce[p] >=17*produce["petrol"];
	 
	 //limit sulfur in diesel oil
	  sum(p in IDIESEL) SULF[p]*produce[p] <=0.05*produce["diesel"];
	  
	  //crude availabilities
	  forall(c in CRUDES) use[c] <= AVAIL[c];
	  
	  // production capacities
	  produce["naphtha"] <=30000; 		//reformer
	  produce["gasoil"] <= 50000; 	//desulfuriztion
	  produce["residue"] <=40000; 	//cracker
	  
	  forall(p in FINAL) produce[p] >=DEM[p];
	 	
}

execute {
	var sumOCT = 0;
	var sumVAP = 0;
	var  sumVOL = 0;
	var sumSULF =0;
	for(var p in IPETROL)
	{
		sumOCT += OCT[p]*produce[p] ;
		sumVAP += VAP[p]*produce[p] ;
	 	sumVOL += VOL[p]*produce[p];
	}
	 sumOCT  /= produce["petrol"];
	 sumVAP  /= produce["petrol"];
	 sumVOL  /= produce["petrol"];
	
	for(var p in IDIESEL) {
		sumSULF =  SULF[p]*produce[p];
	}
	 sumSULF /= produce["diesel"];
	 
	writeln("the total production cost is: ", cplex.getObjValue());
	writeln("petrol: ",produce["petrol"], " tonnes, from: ",produce["distbutane"]," tonnes butane and ", produce["reformate"],
			" tonnes of reformate and ", produce["crknaphtha"], " tonnes of craked naphtha");
	writeln("properties of petrol: octan ", sumOCT, "; vapor: ", sumVAP, " volatility: ", sumVOL);
	writeln("butane: ",produce["butane"] );
	writeln("diesel oil: ",produce["diesel"]," product by ", produce["dslgasoil"] ,"and cracked gasoil is: ", produce["dslcrkgasoil"],
			"; with sulfur is: ", sumSULF, "%");
	writeln("heating oil: ",produce["heating"], " tonnes, from: ", produce["hogasoil"], " tonnes of cracked gasoil, ", produce["hocrknaphtha"],
			 " tonnes of cracked naphtha  and ", produce["crkgasoil"], " tonne craked gasoil");
	
}