(* Store each dungeon, its levels and related info *)

unit universe;

{$mode objfpc}{$H+}
{$modeswitch UnicodeStrings}

interface

uses
  SysUtils, DOM, XMLWrite, logging, globalutils, cave, map;

var
  (* Number of dungeons *)
  dlistLength, uniqueID: smallint;
  (* Info about current dungeon *)
  totalRooms, currentDepth, totalDepth, dungeonType: byte;
  title: string;
  currentDungeon: array[1..MAXROWS, 1..MAXCOLUMNS] of shortstring;

(* Creates a dungeon of a specified type *)
procedure createNewDungeon(levelType: byte);
(* Write a newly generate level of a dungeon to disk *)
procedure writeNewDungeonLevel(idNumber, dType, lvlNum, totalDepth, totalRooms: byte);

implementation


procedure createNewDungeon(levelType: byte);
begin
  r := 1;
  c := 1;
  (* Increment the number of dungeons *)
  Inc(dlistLength);
  (* Dungeons unique ID number becomes the highest dungeon amount number *)
  uniqueID := dlistLength;
  // hardcoded values for testing
  title := 'First cave';
  dungeonType := levelType;
  totalDepth := 3;
  currentDepth := 1;

  (* generate the dungeon *)
  case levelType of
    0: ; { reserved for random type 1 }
    1: ; { reserved for random type 2 }
    { cave }
    2: cave.generate(dlistLength, totalDepth);
    3: ;//bitmask_dungeon.generate;
  end;

  (* Copy the 1st floor of the current dungeon to the game map *)
  map.setupMap;
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
    { creates future Node/Name }
    NameNode := Doc.CreateElement(Name);
    { creates future Node/Name/Value }
    ValueNode := Doc.CreateTextNode(Value);
    { place value in place }
    NameNode.Appendchild(ValueNode);
    { place Name in place }
    Node.Appendchild(NameNode);
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
    { Create a document }
    Doc := TXMLDocument.Create;
    { Create a root node }
    RootNode := Doc.CreateElement('root');
    Doc.Appendchild(RootNode);
    RootNode := Doc.DocumentElement;

    (* Level data *)
    DataNode := AddChild(RootNode, 'levelData');
    AddElement(datanode, 'dungeonID', UnicodeString(IntToStr(idNumber)));
    AddElement(datanode, 'title', UnicodeString(title));
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
    { free memory }
    Doc.Free;
  end;

end;

end.
