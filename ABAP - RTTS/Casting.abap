CLASS cl_celular DEFINITION.
ENDCLASS.

CLASS cl_iphone DEFINITION INHERITING FROM cl_celular.
ENDCLASS.

CLASS cl_galaxy DEFINITION INHERITING FROM cl_celular.
ENDCLASS.

CLASS cl_lumia DEFINITION INHERITING FROM cl_celular.
ENDCLASS.

DATA: o_celular TYPE REF TO cl_celular, "Classe Pai de Todas as outras
      o_iphone  TYPE REF TO cl_iphone,
      o_galaxy  TYPE REF TO cl_galaxy,
      o_lumia   TYPE REF TO cl_lumia.

CREATE OBJECT o_iphone.

* Pai = Filho
o_celular = o_iphone.

* Filho = Pai.
o_iphone ?= o_celular. 

* Com o ?=, o verificador permite que você faça a operação 
* por sua conta e risco. Se estiver errado, vai dar DUMP
* e ele vai rir da sua cara. 
