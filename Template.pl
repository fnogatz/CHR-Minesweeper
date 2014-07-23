:- use_module(library(chr)).
:- chr_constraint minesweeper/2, mine/2, mines/1, field/3, check/2.


%% minesweeper/2
%% minesweeper(X,Y)
%% Holds the dimensions X (rows) and Y (columns) of the minesweeper field.


%% Exercise a): Generate Mines
%% mines/1
% [TODO]


%% Exercise b): Replace Duplicates
% [TODO]


%% Remove Duplicates of check/2
check(A,B) \ check(A,B) <=> true.


%% Exercise c): Remove check/2 beyond the minesweeper/2 boundaries
% [TODO]


%% Exercise d): Check - Mine found
% [TODO]


%% Exercise e): Check - Count neighboring Mines
% [TODO]


%% Exercise f): Check - Add default field/3
% [TODO]


%% Exercise g): Check all neighbors of field(X,Y,0)
% [TODO]


:- include('Play.pl').