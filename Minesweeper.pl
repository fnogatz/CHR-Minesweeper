:- use_module(library(chr)).
:- chr_constraint minesweeper/2, mine/2, mines/1, field/3, check/2.


%% minesweeper/2
%% minesweeper(X,Y)
%% Holds the dimensions X (rows) and Y (columns) of the minesweeper field.


%% Exercise a): Generate Mines
%% mines/1
mines(0) <=> true.
minesweeper(X,Y) \ mines(N) <=> NN is N-1,
  random_between(1,X,Xm), random_between(1,Y,Ym),
  mine(Xm,Ym), mines(NN).


%% Exercise b): Replace Duplicates
mine(X,Y) \ mine(X,Y) <=> mines(1).


%% Remove Duplicates of check/2
check(A,B) \ check(A,B) <=> true.


%% Exercise c): Remove check/2 beyond the minesweeper/2 boundaries
minesweeper(Xmax,Ymax) \ check(X,Y) <=> X < 1; Y < 1; X > Xmax; Y > Ymax | true.


%% Exercise d): Check - Mine found
check(X,Y), mine(X,Y) <=> write('That was a mine!'), halt.


%% Exercise e): Check - Count neighboring Mines
check(X,Y), mine(Xmine,Ymine) ==>
  Xmine =< X+1, Xmine >= X-1, 
  Ymine =< Y+1, Ymine >= Y-1 |
  field(X,Y,1).
field(X,Y,N1), field(X,Y,N2) <=> N is N1+N2 | field(X,Y,N).


%% Exercise f): Check - Add default field/3
check(X,Y) ==> field(X,Y,0).


%% Exercise g): Check all neighbors of field(X,Y,0)
check(X,Y), field(X,Y,0) ==> Xm is X-1, Xp is X+1, Ym is Y-1, Yp is Y+1,
  check(X,Ym), check(X,Yp),
  check(Xm,Y), check(Xp,Y),
  check(Xm,Ym), check(Xm,Yp),
  check(Xp,Ym), check(Xp,Yp).


:- include('Play.pl').