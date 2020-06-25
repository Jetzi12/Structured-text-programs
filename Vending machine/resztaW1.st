(* created by  GEB Automation IDE v3.2.15.107, 2020-06-08 *)
(* Wojciech Bąba, Jerzy Cal, Michał Wiecha, AGH Kraków *)
// Systemy mikrokomputerowe 2020
FUNCTION resztaW1 : BYTE
	VAR
		reszt : INT;
		b_1 : INT;
		a_1 : INT;
		c : INT;
	END_VAR
	VAR_INPUT
	reset : BOOL;
		a : BYTE;
		b : BYTE;
		reszta : BYTE;
		
	END_VAR
	VAR_OUTPUT
		ilosc1 : BYTE;
	END_VAR
	
	IF reset THEN
		ilosc1 := 0;
	ELSE
		b_1 := BYTE_TO_INT(b);
		a_1 := BYTE_TO_INT(a);
		reszt := BYTE_TO_INT(reszta);
	
		c := reszt - (a_1*5) - (b_1*2);

		 ilosc1 := INT_TO_BYTE(c);
	 
	END_IF;

END_FUNCTION
