(* created by  GEB Automation IDE v3.2.15.107, 2020-06-08 *)
(* Wojciech Bąba, Jerzy Cal, Michał Wiecha, AGH Kraków *)
// Systemy mikrokomputerowe 2020
FUNCTION wyborCenyTowaru : BYTE
	VAR
		ArrCeny : S5BYTE1;
		i : INT;
	END_VAR
	VAR_INPUT
		wyjsciaTowarow : S5BOOL;
	END_VAR
	VAR_OUTPUT
		cena : BYTE;
	END_VAR
	
		FOR i := 1 TO 5 BY 1 DO
		IF wyjsciaTowarow[i] THEN
		cena := ArrCeny[i];
		END_IF;
		END_FOR;
	
END_FUNCTION
