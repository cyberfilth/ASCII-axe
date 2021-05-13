(* Handles player inventory and associated functions *)

unit player_inventory;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, video, entities, items, ui, globalutils, logging;

type
  InvMenuStatus = (mnuMain, mnuDrop, mnuQuaff, mnuWearWield);

type
  (* Items in inventory *)
  Equipment = record
    id, useID: smallint;
    Name, description, itemType: shortstring;
    glyph: shortstring;
    glyphColour: shortstring;
    (* Is the item still in the inventory *)
    inInventory: boolean;
    (* Is the item being worn or wielded *)
    equipped: boolean;
  end;

var
  inventory: array[0..9] of Equipment;
  InvMenuState: InvMenuStatus;

(* Initialise empty player inventory *)
procedure initialiseInventory;
(* Setup equipped items when loading a saved game *)
procedure loadEquippedItems;
(* Add to inventory *)
function addToInventory(itemNumber: smallint): boolean;
(* Display the inventory screen *)
procedure showInventory;
(* Show hint at bottom of screen *)
procedure showHint(message: shortstring);
(* Accept menu input *)
procedure menu(selection: shortstring);
(* Drop menu *)
procedure drop;
(* Quaff menu *)
//procedure quaff(quaffItem: char);
(* Wear / Wield menu *)
//procedure wield(wieldItem: char);

implementation

uses
  main, KeyboardInput, scrInventory;

procedure initialiseInventory;
var
  i: byte;
begin
  for i := 0 to 9 do
  begin
    inventory[i].id := i;
    inventory[i].Name := 'Empty';
    inventory[i].equipped := False;
    inventory[i].description := 'x';
    inventory[i].itemType := 'x';
    inventory[i].glyph := 'x';
    inventory[i].glyphColour := 'x';
    inventory[i].inInventory := False;
    inventory[i].useID := 0;
  end;
end;

procedure loadEquippedItems;
var
  i: smallint;
begin
  for i := 0 to 9 do
  begin
    if (inventory[i].equipped = True) then
    begin
      (* Check for weapons *)
      //if (inventory[i].itemType = 'weapon') then
      //  ui.updateWeapon(inventory[i].Name)
      //(* Check for armour *)
      //else if (inventory[i].itemType = 'armour') then
      //  ui.updateArmour(inventory[i].Name);
    end;
  end;

end;

(* Returns TRUE if successfully added, FALSE if the inventory is full *)
function addToInventory(itemNumber: smallint): boolean;
var
  i: smallint;
begin
  Result := False;
  for i := 0 to 9 do
  begin
    if (inventory[i].Name = 'Empty') then
    begin
      itemList[itemNumber].onMap := False;
      (* Populate inventory with item description *)
      inventory[i].id := i;
      inventory[i].Name := itemList[itemNumber].itemname;
      inventory[i].description := itemList[itemNumber].itemDescription;
      inventory[i].itemType := itemList[itemNumber].itemType;
      inventory[i].useID := itemList[itemNumber].useID;
      inventory[i].glyph := itemList[itemNumber].glyph;
      inventory[i].glyphColour := itemList[itemNumber].glyphColour;
      inventory[i].inInventory := True;
      ui.displayMessage('You pick up the ' + inventory[i].Name);
      (* Remove the item from list of items on the map *)
      Delete(itemList, 1, 1);
      Dec(itemAmount);
      Result := True;
      exit;
    end;
  end;
end;

procedure showInventory;
begin
  { prepare changes to the screen }
  LockScreenUpdate;
  (* Clear the screen *)
  ui.screenBlank;

  (* Draw the game screen *)
  scrInventory.displayInventoryScreen;


  { Write those changes to the screen }
  UnlockScreenUpdate;
  { only redraws the parts that have been updated }
  UpdateScreen(False);

  keyboardinput.waitForInput;
end;


procedure showHint(message: shortstring);
begin

end;

{ REFACTOR ALL OF THE BELOW ONCE THE INVENTORY IS RUNNING WITHOUT BUGS

  Start off with just the main inventory screen, test it with an earlier iteration
  of the title screen. }


procedure menu(selection: shortstring);
begin

end;

procedure drop;
begin
  { prepare changes to the screen }
  LockScreenUpdate;
  (* Clear the screen *)
  ui.screenBlank;
  (* Draw the game screen *)
  scrInventory.displayDropMenu;
  InvMenuState := mnuDrop;
  { Write those changes to the screen }
  UnlockScreenUpdate;
  { only redraws the parts that have been updated }
  UpdateScreen(False);
  keyboardinput.waitForInput;
end;

procedure wield(wieldItem: char);
begin
end;

end.
