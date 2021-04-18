(* Store each dungeon, its levels and related info *)

unit universe;

{$mode objfpc}{$H+}
{$modeswitch UnicodeStrings}

interface

uses
  SysUtils, DOM, XMLWrite, logging, globalutils, cave, map;

(* individual dungeon / cave *)
type
  dungeonLayout = record
    (* unique identifier *)
    uniqueID: smallint;
    (* human-readable name of dungeon *)
    title: string;
    (* Type of map: 0 = cave *)
    dungeonType: smallint;
    (* total number of floors *)
    totalDepth: byte;
    (* current floor the player is on *)
    currentDepth: byte;
    (* array of dungeon floor maps *)
    dlevel: array[1..10, 1..MAXROWS, 1..MAXCOLUMNS] of shortstring;
    (* stores which parts of each floor is discovered *)
    discoveredTiles: array[1..10, 1..MAXROWS, 1..MAXCOLUMNS] of boolean;
    (* stores whether each floor has been visited *)
    isVisited: array[1..10] of boolean;
    totalRooms: array[1..10] of byte;
  end;

var
  dungeonList: array of dungeonLayout;
  dlistLength: smallint;
  currentDungeon: array[1..MAXROWS, 1..MAXCOLUMNS] of shortstring;

(* Creates a dungeon of a specified type *)
procedure createNewDungeon(levelType: byte);
(* Write a newly generate level of a dungeon to disk *)
procedure writeNewDungeonLevel(idNumber, dType, lvlNum, totalDepth, totalRooms: byte);

implementation


procedure createNewDungeon(levelType: byte);
var
  i: byte;
  idNumber: smallint;
begin
  { Logging }
  logAction('>reached universe.createNewDungeon(levelType ' +
    IntToStr(levelType) + ')');

  r := 1;
  c := 1;
  (* Add a dungeon to the dungeonList *)
  dlistLength := length(dungeonList);
  SetLength(dungeonList, dlistLength + 1);
  idNumber := Length(dungeonList);
  dlistLength := length(dungeonList);

  { Logging }
  logAction('----------------------------');
  logAction(' Dungeon added to list');
  logAction(' dlistLength: ' + IntToStr(dlistLength));
  logAction(' idNumber : ' + IntToStr(idNumber));
  logAction('----------------------------');

  (* Fill dungeon record with values *)
  with dungeonList[dlistLength - 1] do
  begin
    uniqueID := idNumber;
    // hardcoded values for testing
    title := 'First cave';
    dungeonType := levelType;
    totalDepth := 3;
    currentDepth := 1;
    (* set each floor to unvisited *)
    for i := 1 to 10 do
    begin
      isVisited[i] := False;
    end;


    (* generate the dungeon *)
    case levelType of
      0: ;
      1: ;
      2:  // Cave
      begin
        { Logging }
        logAction(' universe.createNewDungeon procedure calls cave.generate(dlistLength - 1 '
          + IntToStr(dlistLength) + ', totalDepth ' +
          IntToStr(totalDepth) + ')');
        cave.generate(dlistLength, totalDepth);
      end;
      3: ;//bitmask_dungeon.generate;
    end;

    (* Copy the dungeon to the game map *)
    map.setupMap(dlistLength);

  end;
end;

procedure writeNewDungeonLevel(idNumber, dType, lvlNum, totalDepth, totalRooms: byte);
var
  r, c, id_int: smallint;
  Doc: TXMLDocument;
  RootNode, dataNode: TDOMNode;
  dfileName: string;

  procedure AddElement(Node: TDOMNode; Name, Value: string);
  var
    NameNode, ValueNode: TDomNode;
  begin
    NameNode := Doc.CreateElement(Name);    // creates future Node/Name
    ValueNode := Doc.CreateTextNode(Value); // creates future Node/Name/Value
    NameNode.Appendchild(ValueNode);        // place value in place
    Node.Appendchild(NameNode);             // place Name in place
  end;

  function AddChild(Node: TDOMNode; ChildName: string): TDomNode;
  var
    ChildNode: TDomNode;
  begin
    ChildNode := Doc.CreateElement(ChildName);
    Node.AppendChild(ChildNode);
    Result := ChildNode;
  end;

begin
  id_int := 0;
  dfileName := (globalUtils.saveDirectory + PathDelim + 'dungeon_' +
    UnicodeString(IntToStr(idNumber)) + '_f' + UnicodeString(IntToStr(lvlNum)) + '.dat');
  try
    (* Create a document *)
    Doc := TXMLDocument.Create;
    (* Create a root node *)
    RootNode := Doc.CreateElement('root');
    Doc.Appendchild(RootNode);
    RootNode := Doc.DocumentElement;

    (* Level data *)
    DataNode := AddChild(RootNode, 'levelData');
    AddElement(datanode, 'dungeonID', UnicodeString(IntToStr(idNumber)));
    AddElement(datanode, 'floor', UnicodeString(IntToStr(lvlNum)));
    AddElement(datanode, 'totalDepth', UnicodeString(IntToStr(totalDepth)));
    AddElement(datanode, 'mapType', UnicodeString(IntToStr(dType)));
    AddElement(datanode, 'totalRooms', UnicodeString(IntToStr(totalRooms)));

    (* map tiles *)
    for r := 1 to MAXROWS do
    begin
      for c := 1 to MAXCOLUMNS do
      begin
        Inc(id_int);
        DataNode := AddChild(RootNode, 'map_tiles');
        TDOMElement(dataNode).SetAttribute('id', UnicodeString(IntToStr(id_int)));
        AddElement(datanode, 'Blocks', UnicodeString(BoolToStr(True)));
        AddElement(datanode, 'Visible', UnicodeString(BoolToStr(False)));
        AddElement(datanode, 'Occupied', UnicodeString(BoolToStr(False)));
        AddElement(datanode, 'Discovered', UnicodeString(BoolToStr(False)));
        AddElement(datanode, 'Glyph', UnicodeString(cave.terrainArray[r][c]));
      end;
    end;

    (* Save XML *)
    WriteXMLFile(Doc, dfileName);
  finally
    Doc.Free;  // free memory
  end;

end;

end.
