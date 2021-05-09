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
(* Show menu at bottom of screen *)
procedure bottomMenu(style: byte);
(* Show hint at bottom of screen *)
procedure showHint(message: shortstring);
(* Highlight inventory slots *)
procedure highlightSlots(i, x: smallint);
(* Dim inventory slots *)
procedure dimSlots(i, x: smallint);
(* Accept menu input *)
procedure menu(selection: word);
(* Drop menu *)
procedure drop(dropItem: byte);
(* Quaff menu *)
procedure quaff(quaffItem: byte);
(* Wear / Wield menu *)
procedure wield(wieldItem: byte);

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

  (* Accept keyboard commands for inventory screen *)
  //InvMenuState := mnuMain;


  { Write those changes to the screen }
  UnlockScreenUpdate;
  { only redraws the parts that have been updated }
  UpdateScreen(False);

  keyboardinput.waitForInput;
end;

procedure bottomMenu(style: byte);
(* 0 - main menu, 1 - inventory slots, exit *)
begin

end;

procedure showHint(message: shortstring);
begin

end;

procedure highlightSlots(i, x: smallint);
begin

end;

procedure dimSlots(i, x: smallint);
begin

end;

{ REFACTOR ALL OF THE BELOW ONCE THE INVENTORY IS RUNNING WITHOUT BUGS

  Start off with just the main inventory screen, test it with an earlier iteration
  of the title screen. }


procedure menu(selection: word);
begin
  //case selection of
  //  0: // ESC key i pressed
  //  begin
  //    if (InvMenuState = mnuMain) then
  //    begin
  //      main.gameState := 1;
  //      main.currentScreen := tempScreen;
  //      exit;
  //    end
  //    else if (InvMenuState = mnuDrop) then { In the Drop screen }
  //      showInventory
  //    else if (InvMenuState = mnuQuaff) then { In the Quaff screen }
  //      showInventory
  //    else if (InvMenuState = mnuWearWield) then { In the Wear / Wield screen }
  //      showInventory;
  //  end;
  //  1: drop(10); // Drop menu
  //  2:  // 0 slot
  //  begin
  //    if (InvMenuState = mnuDrop) then
  //      drop(0)
  //    else if (InvMenuState = mnuQuaff) then
  //      quaff(0)
  //    else if (InvMenuState = mnuWearWield) then
  //      wield(0);
  //  end;
  //  3: // 1 slot
  //  begin
  //    if (InvMenuState = mnuDrop) then
  //      drop(1)
  //    else if (InvMenuState = mnuQuaff) then
  //      quaff(1)
  //    else if (InvMenuState = mnuWearWield) then
  //      wield(1);
  //  end;
  //  4: // 2 slot
  //  begin
  //    if (InvMenuState = mnuDrop) then
  //      drop(2)
  //    else if (InvMenuState = mnuQuaff) then
  //      quaff(2)
  //    else if (InvMenuState = mnuWearWield) then
  //      wield(2);
  //  end;
  //  5: // 3 slot
  //  begin
  //    if (InvMenuState = mnuDrop) then
  //      drop(3)
  //    else if (InvMenuState = mnuQuaff) then
  //      quaff(3)
  //    else if (InvMenuState = mnuWearWield) then
  //      wield(3);
  //  end;
  //  6: // 4 slot
  //  begin
  //    if (InvMenuState = mnuDrop) then
  //      drop(4)
  //    else if (InvMenuState = mnuQuaff) then
  //      quaff(4)
  //    else if (InvMenuState = mnuWearWield) then
  //      wield(4);
  //  end;
  //  7: // 5 slot
  //  begin
  //    if (InvMenuState = mnuDrop) then
  //      drop(5)
  //    else if (InvMenuState = mnuQuaff) then
  //      quaff(5)
  //    else if (InvMenuState = mnuWearWield) then
  //      wield(5);
  //  end;
  //  8: // 6 slot
  //  begin
  //    if (InvMenuState = mnuDrop) then
  //      drop(6)
  //    else if (InvMenuState = mnuQuaff) then
  //      quaff(6)
  //    else if (InvMenuState = mnuWearWield) then
  //      wield(6);
  //  end;
  //  9: // 7 slot
  //  begin
  //    if (InvMenuState = mnuDrop) then
  //      drop(7)
  //    else if (InvMenuState = mnuQuaff) then
  //      quaff(7)
  //    else if (InvMenuState = mnuWearWield) then
  //      wield(7);
  //  end;
  //  10: // 8 slot
  //  begin
  //    if (InvMenuState = mnuDrop) then
  //      drop(8)
  //    else if (InvMenuState = mnuQuaff) then
  //      quaff(8)
  //    else if (InvMenuState = mnuWearWield) then
  //      wield(8);
  //  end;
  //  11: // 9 slot
  //  begin
  //    if (InvMenuState = mnuDrop) then
  //      drop(9)
  //    else if (InvMenuState = mnuQuaff) then
  //      quaff(9)
  //    else if (InvMenuState = mnuWearWield) then
  //      wield(9);
  //  end;
  //  12: quaff(10);  // Quaff menu
  //  13: wield(10);  // Wear / Wield menu
  //end;
end;

procedure drop(dropItem: byte);
begin

end;

procedure quaff(quaffItem: byte);
begin

end;

procedure wield(wieldItem: byte);
begin
end;

end.
