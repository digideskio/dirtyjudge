unit test_editor_2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, ExtCtrls, Menus, Math, contnrs;

type

  { TTestEditor2 }

  TTestEditor2 = class(TForm)
    DeleteTestButton: TButton;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    PopupMenu4: TPopupMenu;
    SortTestButton: TButton;
    Button2: TButton;
    Button3: TButton;
    SortFileButton: TButton;
    AcceptFileButton: TButton;
    DeleteFileButton: TButton;
    ComboBox1: TComboBox;
    GroupBox1: TGroupBox;
    FileListBox: TListBox;
    OutputListBox: TListBox;
    InputListBox: TListBox;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    PopupMenu1: TPopupMenu;
    PopupMenu2: TPopupMenu;
    PopupMenu3: TPopupMenu;
    SpeedButton1: TSpeedButton;
    Splitter1: TSplitter;
    procedure DeleteTestButtonClick(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure SortTestButtonClick(Sender: TObject);
    procedure DeleteFileButtonClick(Sender: TObject);
    procedure InputListBoxSelectionChange(Sender: TObject; User: boolean);
    procedure SortFileButtonClick(Sender: TObject);
    procedure AcceptFileButtonClick(Sender: TObject);
    procedure ComboBox1EditingDone(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    FDeleting: TObjectList;
    function DeleteLater(Sender: TStringList): TStringList;
    function FindAllFiles(SearchPath: String; Depth: Integer): TStringList;
    procedure PackStrings(List: TStrings);
  public
    procedure LoadControls(AInputList, AOutputList: TStrings);
    procedure SaveControls(AInputList, AOutputList: TStrings);
    function Execute(AInputList, AOutputList: TStrings): TModalResult;
    class function DefaultExecute(AInputList, AOutputList: TStrings): TModalResult;
  end;

var
  TestEditor2: TTestEditor2;

implementation

{$R *.lfm}

function CustomCompare1(List: TStringList; Index1, Index2: Integer): Integer;
begin
  Result := CompareStr(List[Index1], List[Index2]);
end;

function CustomCompare2(List: TStringList; Index1, Index2: Integer): Integer;
begin
  Result := Length(List[Index1]) - Length(List[Index2]);
  if Result = 0 then
  Result := CompareStr(List[Index1], List[Index2]);
end;

function CustomCompare3(List: TStringList; Index1, Index2: Integer): Integer;

  function Filter(S: String): String;
  var
    c: Char;
  begin
    Result := '';
    for c in S do
    if not (c in ['0'..'9']) then
    Result += c;
  end;

begin
  Result := CompareStr(Filter(List[Index1]), Filter(List[Index2]));
  if Result = 0 then
  Result := CompareStr(List[Index1], List[Index2]);
end;

function CustomCompare4(List: TStringList; Index1, Index2: Integer): Integer;
begin
  Result := CompareStr(ExtractFileExt(List[Index1]), ExtractFileExt(List[Index2]));
  if Result = 0 then
  Result := CompareStr(List[Index1], List[Index2]);
end;

procedure CustomSort(List: TStrings; CompareFn: TStringListSortCompare);
var SList: TStringList;
begin
  SList := TStringList.Create;
  try
    SList.Assign(List);
    SList.CustomSort(CompareFn);
    List.Assign(SList);
    finally SList.Free;
  end;
end;

{ TTestEditor2 }

function TTestEditor2.FindAllFiles(SearchPath: String; Depth: Integer): TStringList;
var
  DirList: TStrings;
  Start, Finish, i: Integer;
begin
  Result := TStringList.Create;
  DirList := TStringList.Create;
  try
    DirList.Add(SearchPath);
    Start:=0; Finish:=1;
    for Depth := 1 to Depth do
    begin
      for i := Start to Finish-1 do
      DirList.AddStrings(DeleteLater(FindAllDirectories(DirList[i], False)));
      Start := Finish; Finish := DirList.Count;
      FDeleting.Clear;
    end;
    for i := 0 to DirList.Count-1 do
    Result.AddStrings(DeleteLater(FileUtil.FindAllFiles(DirList[i], '', False)));
    FDeleting.Clear;
    finally DirList.Free;
  end;
end;

procedure TTestEditor2.LoadControls(AInputList, AOutputList: TStrings);
begin
  InputListBox.Items.Assign(AInputList);
  OutputListBox.Items.Assign(AOutputList);
end;

procedure TTestEditor2.SaveControls(AInputList, AOutputList: TStrings);
begin
  AInputList.Assign(InputListBox.Items);
  AOutputList.Assign(OutputListBox.Items);
end;

function TTestEditor2.Execute(AInputList, AOutputList: TStrings): TModalResult;
begin
  LoadControls(AInputList, AOutputList);
  if AInputList.Count=0 then SpeedButton1.Click;
  Result := ShowModal;
  if Result = mrOK then
  SaveControls(AInputList, AOutputList);
end;

class function TTestEditor2.DefaultExecute(AInputList, AOutputList: TStrings
  ): TModalResult;
var
  Form: TTestEditor2;
begin
  Form := TTestEditor2.Create(nil);
  try
    Result := Form.Execute(AInputList, AOutputList);
    finally Form.Free;
  end;
end;

procedure TTestEditor2.ComboBox1EditingDone(Sender: TObject);
begin
  if not DirectoryExists(ComboBox1.Text) then exit;
  FileListBox.Items.Assign(DeleteLater(FindAllFiles(ComboBox1.Text, 2)));
  FDeleting.Clear;
end;

procedure TTestEditor2.SortTestButtonClick(Sender: TObject);
begin
  PopupMenu1.PopUp;
end;

procedure TTestEditor2.DeleteTestButtonClick(Sender: TObject);
begin
  PopupMenu4.PopUp;
end;

procedure TTestEditor2.MenuItem12Click(Sender: TObject);
var
  i: Integer;
begin
  if (Sender = MenuItem12) or (Sender = MenuItem14) then
  with InputListBox do
  for i := 0 to Count-1 do
  if Selected[i] then Items[i] := '';

  if (Sender = MenuItem13) or (Sender = MenuItem14) then
  with OutputListBox do
  for i := 0 to Count-1 do
  if Selected[i] then Items[i] := '';

  PackStrings(InputListBox.Items);
  PackStrings(OutputListBox.Items);
end;

procedure TTestEditor2.PackStrings(List: TStrings);
var
  i, j: Integer;
begin
  j := 0;
  for i := 0 to List.Count-1 do
  if List[i]<>'' then
  begin List[j] := List[i]; j += 1; end;
  while List.Count > j do List.Delete(List.Count-1);
end;

procedure TTestEditor2.DeleteFileButtonClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to FileListBox.Count-1 do
  if FileListBox.Selected[i] then
  FileListBox.Items[i] := '';
  PackStrings(FileListBox.Items);
end;

procedure TTestEditor2.InputListBoxSelectionChange(Sender: TObject; User: boolean);
var
  A, B: TListBox;
begin
  A := TListBox(Sender);
  if A=InputListBox then B:=OutputListBox else B:=InputListBox;
  if A.ItemIndex < B.Count then B.ItemIndex:=A.ItemIndex;
end;

procedure TTestEditor2.SortFileButtonClick(Sender: TObject);
begin
  PopupMenu2.PopUp;
end;

procedure TTestEditor2.AcceptFileButtonClick(Sender: TObject);
begin
  PopupMenu3.PopUp;
end;

procedure TTestEditor2.FormCreate(Sender: TObject);
begin
  FDeleting := TObjectList.Create(True);
  ComboBox1.Text := '';
end;

procedure TTestEditor2.FormDestroy(Sender: TObject);
begin
  FDeleting.Free;
end;

type
  TPairStringCompare = function (A, B, C, D: String): Integer;

function PairStringCompare1(A, B, C, D: String): Integer;
begin
  Result := CompareStr(A+B, C+D);
end;

function PairStringCompare2(A, B, C, D: String): Integer;
begin
  Result := (Length(A)+Length(B)) - (Length(C)+Length(D));
  if Result = 0 then Result := CompareStr(A+B, C+D);
end;

function PairStringCompare3(A, B, C, D: String): Integer;
begin
  Result := (FileSize(A)+FileSize(B)) - (FileSize(C)+FileSize(D));
  if Result = 0 then Result := CompareStr(A+B, C+D);
end;

procedure TTestEditor2.MenuItem1Click(Sender: TObject);
var
  Gap, n, i: Integer;
  Swapped: Boolean = True;
  A, B: TStrings;
  CompareFn: TPairStringCompare;
begin
  if Sender = MenuItem1 then CompareFn:=@PairStringCompare1;
  if Sender = MenuItem2 then CompareFn:=@PairStringCompare2;
  if Sender = MenuItem3 then CompareFn:=@PairStringCompare3;
  A := InputListBox.Items;
  B := OutputListBox.Items;
  n := Min(A.Count, B.Count);
  Gap := n;

  while (Gap>1) or Swapped do
  begin
    Gap := Max(Gap * 77 div 96, 1);
    Swapped := False;

    for i := 0 to n-1-Gap do
    if CompareFn(A[i], B[i], A[i+Gap], B[i+Gap]) > 0 then
    begin
      A.Exchange(i, i+Gap);
      B.Exchange(i, i+Gap);
      Swapped := True;
    end;
  end;
end;

procedure TTestEditor2.MenuItem4Click(Sender: TObject);
begin
  if Sender = MenuItem4 then CustomSort(FileListBox.Items, @CustomCompare1);
  if Sender = MenuItem5 then CustomSort(FileListBox.Items, @CustomCompare2);
  if Sender = MenuItem6 then CustomSort(FileListBox.Items, @CustomCompare3);
  if Sender = MenuItem7 then CustomSort(FileListBox.Items, @CustomCompare4);
end;

procedure TTestEditor2.MenuItem8Click(Sender: TObject);
var
  i: Integer;
  First, Second: TStrings;
  Odd: Boolean = false;
begin
  if (Sender = MenuItem8) or (Sender = MenuItem10)
  then First := InputListBox.Items
  else First := OutputListBox.Items;
  if (Sender = MenuItem8) or (Sender = MenuItem11)
  then Second := InputListBox.Items
  else Second := OutputListBox.Items;

  for i := 0 to FileListBox.Count-1 do
  if FileListBox.Selected[i] then
  begin
    Odd := not Odd;
    if Odd
    then First.Add(FileListBox.Items[i])
    else Second.Add(FileListBox.Items[i]);
    FileListBox.Items[i] := '';
  end;
  PackStrings(FileListBox.Items);
end;

procedure TTestEditor2.SpeedButton1Click(Sender: TObject);
var S: String;
begin
  if SelectDirectory('', ComboBox1.Text, S) then
  ComboBox1.Text := S;
  ComboBox1.EditingDone;
end;

function TTestEditor2.DeleteLater(Sender: TStringList): TStringList;
begin
  FDeleting.Add(Sender);
  Result := Sender;
end;

end.

