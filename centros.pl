%elecciones(año).
elecciones(2017).
elecciones(2019).

%estudiante(departamento, año, nombre).
estudiante(sistemas, 2019, juanPerez).
estudiante(sistemas, 2019, unter).
estudiante(sistemas, 2019, mathy).
estudiante(sistemas, 2017, unter).
estudiante(sistemas, 2017, mathy).
estudiante(sistemas, 2018, unter).
estudiante(quimica, 2018, cacho).

%votos(agrupacion, votos, año).
votos(franjaNaranja, 2500, 2017).
votos(franjaNaranja, 2152, 2019).
votos(agosto29, 710, 2019).
votos(seu, 917, 2019).

%realizoAccion(agrupacion, accion).
realizoAccion(franjaNaranja, lucha(salarioDocente)).
realizoAccion(franjaNaranja, gestionIndividual(“Excepción de correlativas”, juanPerez, 2019)).
realizoAccion(franjaNaranja, obra(2019)).
realizoAccion(agosto29, lucha(salarioDocente)).
realizoAccion(agosto29, lucha(boletoEstudiantil)).
