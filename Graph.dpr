program Graph;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type
  str =record
   num:integer;
   s:string;
   end;
   Mn=Set of Byte;
   TWay = record
      Name:string;
      Used:Mn;
      Cost:Integer;
    end;

    TList = ^TListRec;

    TListRec = record
      Way:TWay;
      Next:TList;
    end;
  DeykstRes = array of Integer;
  Matr = array of array of Integer;
   MinMatr = array of array of str;
  var
    A:Matr;
    kol:Integer;
    Ways:TList;





  function NewList : TList;
  begin
    New(Result);
    Result^.Next:=nil;
  end;


  procedure AddToList(Way:TWay; var List:TList);
  var
    x:TList;
  begin
    x:=List;
    while x^.Next<> nil do
      x:=x^.Next;
    New(x^.Next);
    x^.Next^.Way:=Way;
    x^.Next^.Next:=nil;
  end;

  procedure Sort(var W:TList);
  var
  temp:TWay;
  Curr,prev:TList;
  begin
    prev:=W;
    while prev^.Next<> nil do
    begin
      prev:=prev^.Next;
      Curr:=prev;
       while curr^.next<>nil do
         begin
           curr:=curr^.Next;
           if Curr^.Way.Cost<prev^.Way.Cost then
             begin
               temp:=prev^.Way;
               Prev^.Way:=Curr^.Way;
               Curr^.Way:=temp;
             end;
         end;
    end;
  end;

  procedure AddToSortedList(Way:TWay; var List:TList);
  var
    x,y:TList;
  begin
    x:=List;
    while (x^.Next<> nil) and (x^.Next.Way.Cost < Way.Cost) do
    New(y);
    y^.Way:=Way;
    New(y^.Next);
    y^.Next:=x^.Next;
    x^.Next:=y;
    New(x^.Next^.Next);
  end;

  function FindWays( Src,Dest:integer):TList;
var

  NullWay:TWay;

  procedure FindRoute(V: Integer; Way:TWay);
  var
    i: Integer;
    NewWay:TWay;
  begin
    if V = Dest then
      AddToList(Way,Ways)
    else
    for i := 0 to High(A[V]) do
      if (A[V, i] <> 666) and Not( i in Way.Used) then
      begin
        NewWay.Used:= Way.Used + [i];
        NewWay.Name:= Way.Name +  ','+IntToStr(i+1);
        NewWay.Cost:=Way.Cost + A[V,i];
        FindRoute(i,NewWay);
      end;
  end;

begin
  Ways:=NewList;
  with NullWay do
  begin
    Name:= IntToStr(Src+1);
    Cost:=0;
    Used:= [Src];
  end;
  FindRoute(Src,NullWay);
  Result:=Ways;
  Sort(Ways);
  Result:=Ways;
end;


procedure Menu;
 begin
   Writeln('Choose action:');
   Writeln('  1. Change graph');
   Writeln('  2. Output matrix');
   Writeln('  3. Find the shortest way between two');
   Writeln('  4. Find the longest way between two');
   Writeln('  5. Find all ways between two');
   Writeln('  6. Find graph center');
   Writeln('  7. Exit');
 end;

 procedure MadeGraph(n:integer);
 var i,j:integer;
 begin
    SetLength (A,n,n);
    for i:=0 to n-1 do
      for j:=0 to n-1 do
       begin
         if i=j then A[i,j]:=0
         else
         begin
            Write('Please, enter distance between ',i+1, ' and ',j+1,' (if no arc enter 666): ');
            readln(A[i,j]);
         end;
       end;
 end;

 procedure DrawGraph;
 var i,j:Integer;
 begin
   write('-----');
   for i:=0 to kol-1 do
     begin
       write('----');
     end;
     Writeln;
     write('|   |');
      for i:=1 to kol do
     begin
       write(i:3,'|');
     end;
     Writeln;
      write('-----');
   for i:=0 to kol-1 do
     begin
       write('----');
     end;
     Writeln;
     for i:=0 to kol-1 do
     begin
       Write('|',i+1:3,'|');
      for j:=0 to kol-1 do
        begin
           Write(A[i,j]:3,'|');
        end;
        Writeln;
     end;
      write('-----');
   for i:=0 to kol-1 do
     begin
       write('----');
     end;
     Writeln;
 end;



 function Floid:MinMatr;
var
  i,j,k:Integer;
begin
  SetLength(Result,High(A)+1,High(A)+1);

  for i:= 0 to High(A) do
    for j:= 0 to High(A) do
    begin
      Result[i,j].num:=A[i,j];
      Result[i,j].s:=IntToStr(i+1);
      end;


    
    for i:= 0 to High(A) do
    begin
      for j := 0 to High(A) do
      begin
          for k:=0 to High(A) do
         begin
            if Result[i,k].num + Result[k,j].num < Result[i,j].num then
             begin
               Result[i,j].num:= Result[i,k].num + Result[k,j].num;
               Result[i,j].s:= Result[i,j].s + ','+ copy(Result[i,k].s,3,length(Result[i,k].s));
             end;

          end;
         // if j=High(A) then
         if (Result[i,j].s<>inttostr(j+1))then
         Result[i,j].s:= Result[i,j].s + ','+ inttostr(j+1);
      end;

      end;
end;

 function GraphCenter (FloidRes:MinMatr):integer;
var
  MaxWay:array of Integer;
  i,j:Integer;
begin
  SetLength(MaxWay,High(A)+1);

  for i:= 0 to High(A)  do
  begin
    MaxWay[i]:=FloidRes[0,i].num;
    for j:= 0 to High(A) do
      if MaxWay[i] < FloidRes[j,i].num then
        MaxWay[i]:= FloidRes[j,i].num;
  end;

  Result:=0;
  for i := 0 to High(A) do
    if MaxWay[i] < MaxWay[Result] then
      Result:=i+1;
end;






 var k,i,j:integer;
 Fl:MinMatr;
 x:TList;
begin
  k:=1;
  while (k<>7) do
  begin
    Menu;
    Write('What you want to do? ');
    readln(k);
    if (k>0)and(k<7) then
     begin
        case k of
         1: begin
                Write('How many vertex in graph? ');
                readln(kol);
                MadeGraph(kol);
                Fl:=Floid ;
             end;
         2: begin
               DrawGraph;
             end;
         3: begin
               Write('Please,enter first vertex: ');
               readln(i);
               Write('Please,enter second vertex: ');
               readln(j);
               if Fl[i-1,j-1].num=666 then Writeln('No way') else
               begin
               Writeln(Fl[i-1,j-1].num,'|',Fl[i-1,j-1].s);
               end;
             end;
         4: begin
               Write('Please,enter first vertex: ');
               readln(i);
               Write('Please,enter second vertex: ');
               readln(j);
                Ways:=FindWays(i-1,j-1);
                x:=Ways;
                while x^.Next<> nil do
                    x:=x^.Next;
               Writeln(IntToStr(x^.Way.Cost)+'|'+x^.Way.Name);
             end;
         5: begin
               Write('Please,enter first vertex: ');
               readln(i);
               Write('Please,enter second vertex: ');
               readln(j);
                 Ways:=FindWays(i-1,j-1);
                 x:=Ways^.Next;
                 while x<> nil do
                   begin
                     writeln(IntToStr(x^.Way.Cost)+'|'+x^.Way.Name);
                      x:=x^.Next;
                    end;

             end;
         6: begin
              Writeln(GraphCenter(Fl));
             end;
         end;
     end;
  end;
end.
