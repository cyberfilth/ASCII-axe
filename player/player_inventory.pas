(* Handles player inventory and associated functions *)

unit player_inventory;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, video, entities, items, ui;

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
(* Remove from inventory *)
function removeFromInventory(itemNumber: smallint): boolean;
(* Display the inventory screen *)
procedure showInventory;
(* Drop menu *)
procedure drop;
(* Drop selected item *)
procedure dropSelection(selection: byte);
(* Quaff menu *)
//procedure quaff(quaffItem: char);
(* Wear / Wield menu *)
//procedure wield(wieldItem: char);

implementation

uses
  KeyboardInput, scrInventory;

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
      { Requires FPC3.2.0 or higher }
      Delete(itemList, 1, 1);
      Dec(itemAmount);
      Result := True;
      exit;
    end;
  end;
end;

function removeFromInventory(itemNumber: smallint): boolean;
var
  newItem: item;
begin
  Result := False;
  (* Check if there is already an item on the floor here *)
  if (items.containsItem(entityList[0].posX, entityList[0].posY) = False) then
    { Create an item }
  begin
    newItem.itemID := items.itemAmount;
    newItem.itemName := inventory[itemNumber].Name;
    newItem.itemDescription := inventory[itemNumber].description;
    newItem.itemType := inventory[itemNumber].itemType;
    newItem.useID := 1;
    newItem.glyph := inventory[itemNumber].glyph;
    newItem.glyphColour := inventory[itemNumber].glyphColour;
    newItem.inView := True;
    newItem.posX := entities.entityList[0].posX;
    newItem.posY := entities.entityList[0].posY;
    newItem.onMap := True;
    newItem.discovered := True;

    { Place item on the game map }
    Inc(items.itemAmount);
    Insert(newitem, itemList, itemAmount);
    ui.bufferMessage('You drop the ' + newItem.itemName);

    (* Remove from inventory *)
    inventory[itemNumber].Name := 'Empty';
    inventory[itemNumber].equipped := False;
    inventory[itemNumber].description := 'x';
    inventory[itemNumber].itemType := 'x';
    inventory[itemNumber].glyph := 'x';
    inventory[itemNumber].glyphColour := 'x';
    inventory[itemNumber].inInventory := False;
    inventory[itemNumber].useID := 0;
    Result := True;
    (* Redraw the Drop menu *)
    drop;
  end
  else
    ui.bufferMessage('There is no room here');
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

procedure dropSelection(selection: byte);
begin
  (* Check that the slot is not empty *)
  if not (inventory[selection].Name = 'Empty') then
    removeFromInventory(selection);
  { TODO : The 'if not' condition causes a stack trace. Will need to investigate. }
end;

procedure wield(wieldItem: char);
begin
end;

end.
