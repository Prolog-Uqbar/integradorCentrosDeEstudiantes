% Anios que hay elecciones.
% elecciones/2 -> Anio.
elecciones(2017).
elecciones(2019).

% Padron de estudiantes regulares organizado por carrera y año.
% estudiantes(Carrera, Anio, Estudiante).
estudiantes(sistemas, 2019, juanPerez).
estudiantes(sistemas, 2019, unter).
estudiantes(sistemas, 2019, mathy).
estudiantes(sistemas, 2017, unter).
estudiantes(sistemas, 2017, mathy).
estudiantes(sistemas, 2018, unter).

% Cantidad de votos obtenida en cada eleccion.
% votos(Agrupacion, Voto, Carrera, Anio).
votos(franjaNaranja, 2, sistemas, 2017).
votos(franjaNaranja, 2, sistemas, 2019).
votos(agosto29, 1, sistemas, 2019).

% Total de votos obtenidos de una agrupación en un año determinado.
votosAgrupacion(Agrupacion, Anio, Total):-
    sePresento(Agrupacion, Anio),
    votosGeneral(Agrupacion, Anio, Total).

sePresento(Agrupacion, Anio):-
    votos(Agrupacion,_,_,Anio).

votosGeneral(Agrupacion, Anio, Total):-
        findall(Voto, votos(Agrupacion, Voto, _, Anio), ListaVotos),
        sumlist(ListaVotos, Total).
    
% 1) Quien gano en cada eleccion.
ganoEleccion(Agrupacion, Anio):-
    votosAgrupacion(Agrupacion, Anio, UnTotal),
    forall(votosAgrupacion(_, Anio, OtroTotal), UnTotal >= OtroTotal).

% 2) Si es cierto que siempre gana el mismo.
ganaSiempre(Agrupacion):-
    ganoEleccion(Agrupacion, _),
    forall(elecciones(Anio), ganoEleccion(Agrupacion, Anio)).

% Cantidad de estudiantes regulares en un anio electoral.
cantEstudiantes(Anio, Cantidad):-
    elecciones(Anio),
    findall(Estudiantes, estudiantes(_, Anio, Estudiantes), ListaEstudiantes),
    length(ListaEstudiantes, Cantidad).

% 3) Hubo fraude algún año? 
fraude(Anio):-
    cantEstudiantes(Anio, CantElectores),
    votosGeneral(_, Anio, CantVotos),
    CantVotos > CantElectores.

% 4) Todos los anios en los que hubo fraude.
% ?- fraude(Anio).



% Acciones que realiza cada agrupacion.
% realizoAccion(Agrupacion, Accion).
realizoAccion(franjaNaranja, lucha(salarioDocente)).
realizoAccion(franjaNaranja, gestionIndividual('Excepción de correlativas', juanPerez, 2019)).
realizoAccion(franjaNaranja, obra(2019)).
realizoAccion(agosto29, lucha(salarioDocente)).
realizoAccion(agosto29, lucha(boletoEstudiantil)).

% 1) Agrupacion demagogica (solo hizo gestiones individuales).
esDeTipo(Agrupacion, demagogica):-
    realizoAccion(Agrupacion, _),
    forall(realizoAccion(Agrupacion, Accion), Accion = gestionIndividual(_, _, _)).
% 2) Agrupacion burocratica (no participa en ninguna lucha).
esDeTipo(Agrupacion, burocratica):-
    realizoAccion(Agrupacion, _),
    not(realizoAccion(Agrupacion, lucha(_))).
% 3) Agrupacion transparente (Si todas las acciones fueron genuinas).
esDeTipo(Agrupacion, transparente):-
    realizoAccion(Agrupacion, _),
    forall(realizoAccion(Agrupacion, Accion), esGenuina(Accion)).

% esGenuina/1 -> Accion.
% - Una obra es genuina si se hizo en un año no electoral.
esGenuina(obra(Anio)):-
    realizoAccion(_, obra(Anio)),
    not(elecciones(Anio)).
% - Una gestion individual es genuina si el estudiante era regular en el mismo anio.
esGenuina(gestionIndividual(_, Estudiante, Anio)):-
    estudiantes(_, Anio, Estudiante).
% - Una lucha es siempre genuina.
esGenuina(lucha(_)).

% 4) Saber si hay alguna Agrupacion que tiene mas de una caracteristica (Demagogica, Burocratica, Transparente).
% multipleCaracteristica/1 -> Agrupacion.
multipleCaracteristica(Agrupacion):-
    esDeTipo(Agrupacion, UnaCaracteristica),
    esDeTipo(Agrupacion, OtraCaracteristica),
    UnaCaracteristica \= OtraCaracteristica.
