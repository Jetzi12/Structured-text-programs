(* created by  GEB Automation IDE v3.2.15.107, 2020-06-08 *)
(* Wojciech Bąba, Jerzy Cal, Michał Wiecha, AGH Kraków *)
// Systemy mikrokomputerowe 2020
FUNCTION resztaW2 : BYTE

	VAR
		reszt : INT;
		b : INT;
		a_1 : INT;
	END_VAR
	VAR_INPUT
		reset : BOOL;
		a : BYTE;
		reszta : BYTE;
		
	END_VAR
	VAR_OUTPUT
		ilosc2 : BYTE;
	END_VAR
	IF reset THEN
		ilosc2 := 0;
	ELSE
		a_1 := BYTE_TO_INT(a);
		reszt := BYTE_TO_INT(reszta);
	
		b := (reszt-(a_1*5))/2;
	

		 ilosc2 := INT_TO_BYTE(b);

	 
END_IF;

END_FUNCTION
