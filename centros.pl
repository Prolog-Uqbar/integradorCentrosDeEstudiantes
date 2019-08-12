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
estudiante(electronica, 2018, pepe).
estudiante(electronica, 2018, laura).
estudiante(textil, 2017, gomez).
estudiante(textil, 2017, perez).
estudiante(textil, 2017, gonzalez).
estudiante(textil, 2017, leon).
estudiante(textil, 2017, juancito).
estudiante(textil, 2017, laurita).
estudiante(textil, 2017, pedrito).
estudiante(textil, 2017, anita).
estudiante(textil, 2017, marianito).
estudiante(textil, 2017, luquitas).

%votos(agrupacion, votos, año).
votos(franjaNaranja, 2500, 2017).
votos(franjaNaranja, 2152, 2019).
votos(agosto29, 710, 2019).
votos(seu, 917, 2019).

%realizoAccion(agrupacion, accion).
realizoAccion(franjaNaranja, lucha(salarioDocente)).
realizoAccion(franjaNaranja, gestionIndividual(excepcionCorrelativas, juanPerez, 2019)).
realizoAccion(franjaNaranja, obra(2019)).
realizoAccion(agosto29, lucha(salarioDocente)).
realizoAccion(agosto29, lucha(boletoEstudiantil)).


%agrupacion(agrupacion).
agrupacion(franjaNaranja).
agrupacion(agosto29).
agrupacion(seu).


%departamento(departamento).
departamento(sistemas).
departamento(textil).
departamento(electronica).
departamento(quimica).

%Primera parte

%Quien ganó cada elección.
ganoEleccion(Anio,Agrupacion):-
  elecciones(Anio),
  votos(Agrupacion, CantVotosGanador, Anio),
  forall(votos(_, CantVotosPerdedores, Anio), CantVotosGanador >= CantVotosPerdedores).

%Si es cierto que siempre gana el mismo.
siempreGana(Agrupacion):-
  agrupacion(Agrupacion),
  not(ganoOtro(Agrupacion)).

ganoOtro(Agrupacion):-
  ganoEleccion(_, OtroAgrupacion),
  OtroAgrupacion \= Agrupacion.

%Si hubo fraude en un año en particular, lo que ocurre si hay más votos registrados que electores en el padrón.
%Todos los años en que hubo fraude.
huboFraude(Anio):-
  elecciones(Anio),
  electoresAnio(Electores,Anio),
  votosAnio(Votos,Anio),
  Votos > Electores.

electoresAnio(CantidadElectores,Anio):-
  elecciones(Anio),
  findall(Nombre, estudiante(_, Anio, Nombre), ListaNombres),
  length(ListaNombres, CantidadElectores).

votosAnio(VotosTotales,Anio):-
  elecciones(Anio),
  findall(CantVotos, votos(_, CantVotos, Anio), ListaVotos),
  sumlist(ListaVotos, VotosTotales).

%Comprobar si hay algun departamento que tenga más estudiantes que todos los demás departamentos sumados, en un año en particular
/*departamentoSuperPoblado(Departamento, Anio) :-
    departamento(Departamento),
    estudiante(_,Anio,_),
    cantidadEstudiantes(Departamento, Cantidad, Anio),
    cantidadEstudiantesDemasDepartamentos(Departamento, CantidadOtros, Anio),
    Cantidad > CantidadOtros.
*/
cantidadEstudiantes(Departamento, Cantidad, Anio):-
  findall(Nombre, estudiante(Departamento, Anio, Nombre), ListaNombres),
  length(ListaNombres, Cantidad).

cantidadEstudiantesDemasDepartamentos(Departamento, Total, Anio):-
  findall(_, (estudiante(OtroDepartamento, Anio, _),OtroDepartamento \= Departamento), Lista),
  length(Lista, Total).


% Variante usando criterio de mayoria 
 
departamentoSuperPoblado(Departamento, Anio) :-
    departamento(Departamento),
    estudiante(_,Anio,_),
    cantidadEstudiantes(Departamento, Cantidad, Anio),
    cantidadEstudiantes(_, CantidadTotal, Anio),
    Cantidad > CantidadTotal/2.


%Segunda parte
%Realizar los predicados para encontrar a las agrupaciones que sean:

%Demagógica, es decir, si solo hizo gestiones individuales.
esDemagogica(Agrupacion):-
  agrupacion(Agrupacion),
  forall(realizoAccion(Agrupacion, Accion), Accion=gestionIndividual(_, _, _)).

%Burócrata: si no participó en ninguna lucha.
esBurocrata(Agrupacion):-
  agrupacion(Agrupacion),
  not(realizoAccion(Agrupacion,lucha(_) )).

%Transparente: si todas las acciones que realizó fueron genuinas.
%    Obra: es genuina si se hizo en un año en que no hubo elecciones.
%    Gestion individual: es genuina si la persona beneficiada era estudiante regular en el año en que se hizo.
%    Lucha: siempre es genuina.
esTransparente(Agrupacion):-
  agrupacion(Agrupacion),
  forall(realizoAccion(Agrupacion, Accion), esGenuina(Accion)).

esGenuina(obra(Anio)):-
  not(elecciones(Anio)).

esGenuina(gestionIndividual(_, Alguien, Anio)):-
  estudiante(_, Anio, Alguien).

esGenuina(lucha(_)).