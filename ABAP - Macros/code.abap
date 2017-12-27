REPORT  zombie_macro.

* Variável contadora de comida de zumbi.
DATA: v_cerebros_consumidos TYPE i.

* Criação da MACRO
*--------------------------------------------------------------------*
DEFINE comer_cerebros.

* Parâmetros em MACROs são marcados com &1...&9 Tome cuidado pois
* ele vai validar a sintaxe abaixo usando o valor do parâmetro.
  v_cerebros_consumidos = v_cerebros_consumidos + &1.

END-OF-DEFINITION.

*--------------------------------------------------------------------*
* START-OF-SELECTION
*--------------------------------------------------------------------*
START-OF-SELECTION.

* Sim, os zumbis estão com fome! :)
* Note que você não vai conseguir debuggar...
  comer_cerebros 4.
  comer_cerebros 8.
  comer_cerebros 2.
  comer_cerebros 5.
  comer_cerebros 20.

* Vamos ver se somou mesmo.
  WRITE v_cerebros_consumidos.