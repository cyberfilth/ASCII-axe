(* Information Dialog box *)

unit dlgInfo;

{$mode fpc}{$H+}

interface

uses
  SysUtils;

(* Display Info dialog box *)
procedure infoDialog(message: shortstring);
(* Display level up dialog box *)
procedure levelUpDialog(message: shortstring);

implementation

uses
  ui, entities;

procedure infoDialog(message: shortstring);
var
  x, y: smallint;
begin
  x := 8;
  y := 5;
  (* Top border *)
  TextOut(x, y, 'LgreyBGblack', chr(201));
  for x := 9 to 45 do
    TextOut(x, 5, 'LgreyBGblack', chr(205));
  TextOut(46, y, 'LgreyBGblack', chr(187));
  (* Vertical sides *)
  for y := 6 to 12 do
    TextOut(8, y, 'LgreyBGblack', chr(186) + '                                     ' +
      chr(186));
  (* Bottom border *)
  TextOut(8, y + 1, 'LgreyBGblack', chr(200)); // bottom left corner
  for x := 9 to 45 do
    TextOut(x, y + 1, 'LgreyBGblack', chr(205));
  TextOut(46, y + 1, 'LgreyBGblack', chr(188)); // bottom right corner
  (* Write the title *)
  TextOut(10, 5, 'LgreyBGblack', 'Info');
  (* Write the message *)
  TextOut(10, 7, 'LgreyBGblack', message);
end;

procedure levelUpDialog(message: shortstring);
  var
  x, y: smallint;
begin
  x := 8;
  y := 5;
  (* Top border *)
  TextOut(x, y, 'LgreyBGblack', chr(201));
  for x := 9 to 46 do
    TextOut(x, 5, 'LgreyBGblack', chr(205));
  TextOut(47, y, 'LgreyBGblack', chr(187));
  (* Vertical sides *)
  for y := 6 to 16 do
    TextOut(8, y, 'LgreyBGblack', chr(186) + '                                      ' +
      chr(186));
  (* Bottom border *)
  TextOut(8, y + 1, 'LgreyBGblack', chr(200)); // bottom left corner
  for x := 9 to 46 do
    TextOut(x, y + 1, 'LgreyBGblack', chr(205));
  TextOut(47, y + 1, 'LgreyBGblack', chr(188)); // bottom right corner
  (* Write the title *)
  TextOut(10, 5, 'LgreyBGblack', chr(181) + ' Level up ' + chr(198));

  (* Write the message *)
  TextOut(10, 7, 'LgreyBGblack', 'Your experiences have sharpened your');
  TextOut(10, 8, 'LgreyBGblack', 'skills.');
  TextOut(10, 9, 'LgreyBGblack', 'You have advanced to level ' + message);
  TextOut(10, 11, 'LgreyBGblack', 'Increase one of the following:');
  { Increase max health by 10 % }
  TextOut(10, 12, 'LgreyBGblack', 'A - Increase Max Health by ' + IntToStr(round((entityList[0].maxHP / 100) * 10)));
  { Increase attack strength by level number }
  TextOut(10, 13, 'LgreyBGblack', 'B - Increase Attack by ' + message);
  { Increase defence by level number }
  TextOut(10, 14, 'LgreyBGblack', 'C - Increase Defence by ' + message);
   { Increase both attack and defence by half of level number }
  TextOut(10, 15, 'LgreyBGblack', 'D - Increase Attack & Defence by ' + IntToStr(StrToInt(message) DIV 2));
  { Options }
  TextOut(18, 17, 'LgreyBGblack', '[A]   [B]   [C]   [D]');
end;

end.

