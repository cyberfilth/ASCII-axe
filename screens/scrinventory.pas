unit scrInventory;

{$mode fpc}{$H+}

interface

procedure displayInventoryScreen;

implementation

uses
  ui;

procedure displayInventoryScreen;
var
  x, y: byte;
  letter: char;
begin
  screenBlank;
  { Header }
  TextOut(10, 2, 'cyan', chr(218));
  for x := 11 to 69 do
    TextOut(x, 2, 'cyan', chr(196));
  TextOut(70, 2, 'cyan', chr(191));
  TextOut(10, 3, 'cyan', chr(180));
  { Inventory title }
  TextOut(15, 3, 'cyan', 'Inventory slots');
  TextOut(70, 3, 'cyan', chr(195));
  TextOut(10, 4, 'cyan', chr(192));
  for x := 11 to 69 do
    TextOut(x, 4, 'cyan', chr(196));
  TextOut(70, 4, 'cyan', chr(217));
  { Footer menu }
  TextOut(3, 23, 'cyanBGblackTXT', ' D - Drop menu ');
  TextOut(20, 23, 'cyanBGblackTXT', ' Q - Quaff/drink menu ');
  TextOut(44, 23, 'cyanBGblackTXT', ' W - Weapons/Armour ');
  TextOut(66, 23, 'cyanBGblackTXT', ' ESC - Exit ');

  { Display items in inventory }
  y := 6;
  for letter := 'a' to 'j' do
  begin
    TextOut(10, y, 'cyan', '[' + letter + ']  <empty slot>');
    Inc(y);
  end;
end;

end.
