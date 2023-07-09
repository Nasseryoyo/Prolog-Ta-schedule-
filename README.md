# Prolog Ta schedule
made this prolog code in 2nd year of college 
the software takes as an input week_schedule(WeekSlots,TAs,DayMax,WeekSched) :
* WeekSlots: is a list of 6 lists with each list representing a working day from
Saturday till Thursday. A list representing a day is composed of 5 numbers
representing the 5 slots in the day. The number at position i in a day list represents
the number of parallel labs at slot i

EX:

WeekSlots = [ [0, 0, 0, 0, 0], [2, 1, 2, 3, 0],
[2, 0, 1, 2, 0] , [0, 1, 1, 0, 0] , [1, 0, 0, 2, 2] ,
[2, 1, 3, 1, 0] ]

* TAs: is a list of structures of the form ta(Name,Load) where Name is the name
of the TA and Load is an integer representing their teaching load.

EX:

TAs = [ta(y, 4), ta(h, 7), ta(r, 8), ta(s, 8)]

* DayMax is the maximum number of labs a TA can be assigned per day.

EX : 

DayMax = 3

outputs:
* WeekSched is the weekly assignment of TAs to the labs. It is represented as a
list of 6 lists. Each list represents a working day from Saturday to Thursday.
Position i in a day list is a list containing the names of the assigned TAs to
slot i in the day.

EX:

week_schedule(WeekSlots,TAs,DayMax,WeekSched).

WeekSched = [ [[], [], [], [], []],
[[r, y], [y], [r, h], [r, h, y], []],
[[h, y], [] , [h] , [h, s] , []],
[[], [s], [s], [], []],
[[s], [], [], [s, r], [s, r]],
[[h, r], [s], [r, h, s], [r], []]
]
