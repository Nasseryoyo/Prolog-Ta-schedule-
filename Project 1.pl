/*
?- ta_slot_assignment([ta(y, 4), ta(h, 7), ta(r, 8), ta(s, 8)],RemTAs,y).
RemTAs = [ta(y, 3), ta(h, 7), ta(r, 8), ta(s, 8)]
?- ta_slot_assignment([ta(k, 8), ta(m, 4), ta(n, 3)],RemTAs,m).
RemTAs = [ta(k, 8), ta(m, 3), , ta(n, 3)];
false.
*/
ta_slot_assignment([ta(Name,L)| T],[ta(Name,L2)|T],Name):-
	L > 0,
 	L2 is L-1 .
	
ta_slot_assignment([ta(N,T)|R],[ta(N,T)|R2],Name):-
	ta_slot_assignment(R,R2,Name).
	

	

	
/*
slot_assignment(3,[ta(y,4),ta(h,7),ta(r,8),ta(s,8)],RemTAs,Assignment).
RemTAs = [ta(s, 7), ta(y, 3), ta(h, 6), ta(r, 8)]
Assignment = [s, y, h].
slot_assignment(2, [ta(k, 8), ta(m, 4), ta(n, 3)],RemTAs,Assignment).
RemTAs = [ta(k, 7), ta(m, 3), ta(n, 3)],
Assignment = [k,m];
...

?- slot_assignment(2, [ta(k, 1), ta(m, 2), ta(n, 1)], RemTAs,Assignment).
RemTAs = [ta(k, 0), ta(m, 1), ta(n, 1)],
Assignment = [k, m] ;
RemTAs = [ta(k, 0), ta(m, 2), ta(n, 0)],
Assignment = [k, n] ;
RemTAs = [ta(k, 0), ta(m, 1), ta(n, 1)],
Assignment = [m, k] ;
RemTAs = [ta(k, 1), ta(m, 1), ta(n, 0)],
Assignment = [m, n] ;
RemTAs = [ta(k, 0), ta(m, 2), ta(n, 0)],
Assignment = [n, k] ;
RemTAs = [ta(k, 1), ta(m, 1), ta(n, 0)],
Assignment = [n, m] ;
false.

%case if labnum is more than available tas
%case if tas is more than labnum
%case if load is zero
%case if tas and labnum are equal
*/

	
	
slot_assignment(0,A,A,[]).
slot_assignment(N, TAs, RemTAs, [H|T]) :-
	N>0,
	N1 is N - 1,
	ta_slot_assignment(TAs,[H1|T2],H),
	slot_assignment(N1,[H1|T2],RemTAs,T),
	\+ member(H,T).

	


	
/*
max_slots_per_day([[m], [n], [m,n,k], [n,k], [n]], 3).
false
max_slots_per_day([[], [m,n], [m], [k], []], 2).
true
max_slots_per_day([[y, h], [y], [r, s], [r, s, h], []], 1).
false
max_slots_per_day([[y, h], [y], [r, s], [r, s, h], []], 3).
true
*/
max_slots_per_day(DaySched,Max):-
	flatten(DaySched,Flatsched),
	list_to_set(Flatsched,TAs),
	max_slots_per_day_helper(Flatsched,TAs,Max).

max_slots_per_day_helper(_,[],_).
max_slots_per_day_helper(Flatsched,[H1|T1], Max) :-
  count(H1, Flatsched, Count), 
  Count =< Max,
  Count > 0,
  max_slots_per_day_helper(Flatsched,T1,Max).

count(_, [], 0).
count(X, [X|T], N) :- 
	count(X, T, N1), 
	N is N1 + 1 .
count(X, [Y|T], N) :- 
	X \= Y,
	count(X, T, N).
	
	
	
/*
day_schedule([2, 1, 2, 3, 0], [ta(y, 4), ta(h, 7), ta(r, 8), ta(s, 8)],RemTAs,Assignment).
RemTAs = [ta(y, 1), ta(h, 5), ta(r, 5), ta(s, 8)]
Assignment = [[r, y], [y], [r, h], [r, h, y], []]
day_schedule([1,1,2,1,0], [ta(k, 8), ta(m, 4), ta(n, 3)],RemTAs,Assignment).
RemTAs = [ta(k, 6), ta(m, 2), ta(n, 2)],
Assignment = [[m], [m], [n,k], [k], []];
...

?- day_schedule([0,2,0,1,0], [ta(k, 1), ta(m, 2), ta(n, 1)],RemTAs,Assignment).
RemTAs = [ta(k, 0), ta(m, 0), ta(n, 1)],
Assignment = [[], [k, m], [], [m], []] ;
RemTAs = [ta(k, 0), ta(m, 1), ta(n, 0)],
Assignment = [[], [k, m], [], [n], []] ;
RemTAs = [ta(k, 0), ta(m, 1), ta(n, 0)],
Assignment = [[], [k, n], [], [m], []] ;
RemTAs = [ta(k, 0), ta(m, 0), ta(n, 1)],
Assignment = [[], [m, k], [], [m], []] ;
RemTAs = [ta(k, 0), ta(m, 1), ta(n, 0)],
Assignment = [[], [m, k], [], [n], []] ;
RemTAs = [ta(k, 0), ta(m, 1), ta(n, 0)],
Assignment = [[], [m, n], [], [k], []] ;
RemTAs = [ta(k, 1), ta(m, 0), ta(n, 0)],
Assignment = [[], [m, n], [], [m], []] ;
RemTAs = [ta(k, 0), ta(m, 1), ta(n, 0)],
Assignment = [[], [n, k], [], [m], []] ;
RemTAs = [ta(k, 0), ta(m, 1), ta(n, 0)],
Assignment = [[], [n, m], [], [k], []] ;
RemTAs = [ta(k, 1), ta(m, 0), ta(n, 0)],
Assignment = [[], [n, m], [], [m], []] ;
false.
*/ 
day_schedule([],A,A,[]).
day_schedule([H|T],TAs,RemTAs,[H1|T1]):-
	slot_assignment(H,TAs,RemTAs1,H1),
	day_schedule(T,RemTAs1,RemTAs,T1).

	
week_schedule([],_,_,[]).
week_schedule([H|T],TAs,DayMax,[Assign|T1]):-
	day_schedule(H,TAs,RemTAs,Assign),
	max_slots_per_day(Assign,DayMax),
	week_schedule(T,RemTAs,DayMax,T1).
	
/*	
set_prolog_flag(answer_write_options,[quoted(true),portray(true),max_depth(0),spacing(next_argument)]).

?- week_schedule([[1, 1, 2, 1, 0], [0, 0, 0, 0, 0],[0, 0, 0, 0, 0] , [0, 2, 0, 0, 0] , [0, 2, 1, 1, 0] ,[1, 0, 1, 1, 1] ],[ta(k, 8), ta(m, 4), ta(n, 3)],3,[ [[m], [n], [m,n], [k], []],[[], [], [], [], []],[[], [], [], [], []],[[], [k,m], [], [], []],[[], [k,m], [n], [k], []],[[k], [], [k], [k], [k]]]).
false.
?- week_schedule([[1, 1, 2, 1, 0], [0, 0, 0, 0, 0],[0, 0, 0, 0, 0] , [0, 2, 0, 0, 0] , [0, 2, 1, 1, 0] ,[1, 0, 1, 1, 1] ],[ta(k, 8), ta(m, 4), ta(n, 3)],3,WeekSched).
WeekSched = [ [[k], [k], [k,m], [m], []],
[[], [], [], [], []],
[[], [], [], [], []],
[[], [k,n], [], [], []],
[[], [k,n], [k], [n], []],
[[m], [], [k], [k], [m]]
];
WeekSched = [ [[m], [k], [k,m], [n], []],
[[], [], [], [], []],
[[], [], [], [], []],
[[], [k,m], [], [], []],
[[], [k,n], [k], [n], []],
[[k], [], [m], [k], [k]]];
...
week_schedule([ [0, 0, 0, 0, 0], [2, 1, 2, 3, 0],[2, 0, 1, 2, 0] , [0, 1, 1, 0, 0] , [1, 0, 0, 2, 2] ,[2, 1, 3, 1, 0] ],[ta(y, 4), ta(h, 7), ta(r, 8), ta(s, 8)],3,WeekSched).
WeekSched = [ [[], [], [], [], []],
[[r, y], [y], [r, h], [r, h, y], []],
[[h, y], [] , [h] , [h, s] , []],
[[], [s], [s], [], []],
[[s], [], [], [s, r], [s, r]],
[[h, r], [s], [r, h, s], [r], []]
]

?- week_schedule([[0,0,0,0,0],[0,0,0,1,0],[0,0,0,0,0],[0,2,0,1,0],[0,0,0,0,0],[0,0,0,0,0]],[ta(k, 1), ta(m, 2), ta(n, 1)],2,WeekSched).
WeekSched = [[[], [], [], [], []],
[[], [], [], [k], []],
[[], [], [], [], []],
[[], [m, n], [], [m], []],
[[], [], [], [], []],
[[], [], [], [], []]] ;
WeekSched = [[[], [], [], [], []],
[[], [], [], [k], []],
[[], [], [], [], []],
[[], [n, m], [], [m], []],
[[], [], [], [], []],
[[], [], [], [], []]] ;
WeekSched = [[[], [], [], [], []],
[[], [], [], [m], []],
[[], [], [], [], []],
[[], [k, m], [], [n], []],
[[], [], [], [], []],
[[], [], [], [], []]] ;
WeekSched = [[[], [], [], [], []],
[[], [], [], [m], []],
[[], [], [], [], []],
[[], [k, n], [], [m], []],
[[], [], [], [], []],
[[], [], [], [], []]] ;
WeekSched = [[[], [], [], [], []],
[[], [], [], [m], []],
[[], [], [], [], []],
[[], [m, k], [], [n], []],
[[], [], [], [], []],
[[], [], [], [], []]] ;
WeekSched = [[[], [], [], [], []],
[[], [], [], [m], []],
[[], [], [], [], []],
[[], [m, n], [], [k], []],
[[], [], [], [], []],
[[], [], [], [], []]] ;
WeekSched = [[[], [], [], [], []],
[[], [], [], [m], []],
[[], [], [], [], []],
[[], [n, k], [], [m], []],
[[], [], [], [], []],
[[], [], [], [], []]] ;
WeekSched = [[[], [], [], [], []],
[[], [], [], [m], []],
[[], [], [], [], []],
[[], [n, m], [], [k], []],
[[], [], [], [], []],
[[], [], [], [], []]] ;
WeekSched = [[[], [], [], [], []],
[[], [], [], [n], []],
[[], [], [], [], []],
[[], [k, m], [], [m], []],
[[], [], [], [], []],
[[], [], [], [], []]] ;
WeekSched = [[[], [], [], [], []],
[[], [], [], [n], []],
[[], [], [], [], []],
[[], [m, k], [], [m], []],
[[], [], [], [], []],
[[], [], [], [], []]] ;
false.


 
*/
