/**---------------------------------------**/
/**                                       **/
/**           NO CHANGES NEEDED           **/
/**                                       **/
/**  The following is just for the game.  **/
/**                                       **/
/**---------------------------------------**/

:- chr_constraint info/3.

main :-
  request_info(X,Y,Mines),
  info(X,Y,Mines),
  minesweeper(X,Y),
  mines(Mines),
  %print_store,
  prompt.


print_store :- chr_show_store(minesweeper).


prompt :-
  used_time(Seconds),
  write('[Current Field - '), write(Seconds), write(' Seconds]'), nl,
  print_field, nl,
  write('[Check Location]'), nl,
  write('  Row:    '), read(X),
  write('  Column: '), read(Y), nl,
  check(X,Y),
  prompt.


used_time(Seconds) :-
  start_time(Start),
  get_time(Now),
  Seconds is round(Now - Start).


request_info(X,Y,Mines) :-
  write('[Initialization]'), nl,
  write('  Numer of Rows:     '),
  read(X),
  write('  Number of Columns: '),
  read(Y),
  write('  Number of Mines:   '),
  read(Mines),
  % save start time
  get_time(StartTime),
  asserta(start_time(StartTime)).


print_field :-
  get_field(Field,OpenFields),
  get_info(_X,_Y,Mines),
  (
    Mines =:= OpenFields,
    solved
  ;
    Mines =\= OpenFields,
    print_field(Field)
  ).

solved :-
  used_time(Seconds),
  write('Congratulations! You won in '), write(Seconds), write(' seconds!'),
  halt.


repeat(_Char,0).
repeat(Char,N) :-
  N > 0, Nm is N-1,
  write(Char),
  repeat(Char,Nm).


write_width(Value,Width) :-
  atom_length(Value,ValueWidth),
  Spaces is Width-ValueWidth,
  repeat(' ',Spaces),
  write(Value).


print_field(Field) :-
  % get dimensions
  length(Field,DimRows),
  Field = [Row|_Rows],
  length(Row,DimCols),
  RowWidth is ceil(log10(DimRows+1)),
  ColWidth is ceil(log10(DimCols+1)),
  print_header(1,DimRows,DimCols,RowWidth,ColWidth),
  print_seperator(1,DimRows,DimCols,RowWidth,ColWidth),
  print_field(Field,1,DimRows,DimCols,RowWidth,ColWidth),
  print_seperator(1,DimRows,DimCols,RowWidth,ColWidth),
  print_header(1,DimRows,DimCols,RowWidth,ColWidth).


print_header(1,DimRows,DimCols,RowWidth,ColWidth) :-
  write(' '),
  repeat(' ',RowWidth), write(' | '),
  write_width(1,ColWidth), write(' '),
  print_header(2,DimRows,DimCols,RowWidth,ColWidth).
print_header(N,DimRows,DimCols,RowWidth,ColWidth) :-
  N < DimCols, N > 1,
  write_width(N,ColWidth), write(' '),
  Np is N+1,
  print_header(Np,DimRows,DimCols,RowWidth,ColWidth).
print_header(DimCols,_DimRows,DimCols,RowWidth,ColWidth) :-
  write_width(DimCols,ColWidth), write(' | '),
  repeat(' ',RowWidth),
  write(' '), nl.


print_seperator(1,DimRows,DimCols,RowWidth,ColWidth) :-
  write('-'),
  repeat('-',RowWidth),
  write('-+-'),
  repeat('-',ColWidth), write('-'),
  print_seperator(2,DimRows,DimCols,RowWidth,ColWidth).
print_seperator(N,DimRows,DimCols,RowWidth,ColWidth) :-
  N < DimCols, N > 1,
  repeat('-',ColWidth), write('-'),
  Np is N+1,
  print_seperator(Np,DimRows,DimCols,RowWidth,ColWidth).
print_seperator(DimCols,_DimRows,DimCols,RowWidth,ColWidth) :-
  repeat('-',ColWidth),
  write('-+-'), 
  repeat('-',RowWidth),
  write('-'), nl.
  

print_field([],_CurrRow,_DimRows,_DimCols,_RowWidth,_ColWidth).
print_field([Row|Rows],CurrRow,DimRows,DimCols,RowWidth,ColWidth) :-
  write(' '),
  write_width(CurrRow,RowWidth), write(' | '),
  print_row(Row,DimCols,ColWidth),
  write('| '), write_width(CurrRow,RowWidth), 
  write(' '), nl,
  CurrRowN is CurrRow+1,
  print_field(Rows,CurrRowN,DimRows,DimCols,RowWidth,ColWidth).


print_row([],_DimCols,_ColWidth).
print_row([Col|Cols],DimCols,ColWidth) :-
  write_width(Col,ColWidth), write(' '),
  print_row(Cols,DimCols,ColWidth).


:- chr_constraint get_field/2, get_field/4.
get_field(Field,OpenFields), minesweeper(X,Y) ==> var(Field), var(OpenFields) | get_field(X,Y,[[]],0).
get_field(Field,OpenFieldsV), get_field(1,0,Mines,OpenFields) <=> var(Field), var(OpenFieldsV) | Field = Mines, OpenFieldsV = OpenFields.

minesweeper(_,Y) \ get_field(X,0,Field,OpenFields) <=> X > 1 | Xm is X-1, get_field(Xm,Y,[[]|Field],OpenFields).

field(X,Y,Mines) \ get_field(X,Y,[Row|Rows],OpenFields) <=> Y > 0, X > 0 | 
  (
    Mines = 0,
    MinesToShow = ' '
  ;
    Mines =\= 0,
    MinesToShow = Mines
  ),
  Ym is Y-1, get_field(X,Ym,[[MinesToShow|Row]|Rows],OpenFields).
get_field(X,Y,[Row|Rows],OpenFields) <=> Y > 0 | Ym is Y-1, OpenFieldsP is OpenFields+1, get_field(X,Ym,[['.'|Row]|Rows],OpenFieldsP).


:- chr_constraint get_info/3.
info(X,Y,Mines) \ get_info(Xg,Yg,Minesg) <=> Xg = X, Yg = Y, Minesg = Mines.