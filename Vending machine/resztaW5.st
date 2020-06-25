(* created by  GEB Automation IDE v3.2.15.107, 2020-06-08 *)
(* Wojciech Bąba, Jerzy Cal, Michał Wiecha, AGH Kraków *)
// Systemy mikrokomputerowe 2020
FUNCTION resztaW5 : BYTE
	VAR
		reszt : INT;
		a : INT;
	END_VAR
	VAR_INPUT
		reset : BOOL;
		reszta : BYTE;
		
	END_VAR
	VAR_OUTPUT
		ilosc5 : BYTE;
	END_VAR
	
		IF reset THEN
			ilosc5 := 0;
		ELSE
			reszt := BYTE_TO_INT(reszta);
			a := reszt/5;
			ilosc5 := INT_TO_BYTE(a);

END_IF;
END_FUNCTION
