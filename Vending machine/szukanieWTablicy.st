(* created by  GEB Automation IDE v3.2.15.107, 2020-06-08 *)
(* Wojciech Bąba, Jerzy Cal, Michał Wiecha, AGH Kraków *)
// Systemy mikrokomputerowe 2020
FUNCTION szukanieWTablicy : INT
	VAR
		i : INT;
	END_VAR
	VAR_INPUT
		wyjsciaTowarow : S5BOOL;
	END_VAR
	VAR_OUTPUT
		numerWybranegoTowaru : INT;
	END_VAR
	
	FOR i := 1 TO 5 BY 1 DO
	IF wyjsciaTowarow[i] THEN
	numerWybranegoTowaru := i;
	END_IF;
	END_FOR;
	
END_FUNCTION
