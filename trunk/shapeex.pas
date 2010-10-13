unit ShapeEx;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls;

type
  TShapeExType = (stRectangle, stSquare, stRoundRect, stRoundSquare,
                  stEllipse, stCircle, stSquaredDiamond, stDiamond, stRightTriangle,
                  stLeftTriangle, stUpTriangle, stDownTriangle);

  { TShapeEx }

  TShapeEx = class(TShape)
  private
    { Private declarations }
    FShape: TShapeExType;
    procedure SetShape(Value: TShapeExType); reintroduce;
  protected
    { Protected declarations }
  public
    { Public declarations }
    procedure Paint; override;
  published
    { Published declarations }
    property Shape: TShapeExType read FShape write SetShape default stRectangle;
  end;

procedure Register;

implementation

uses
  Math;

procedure Register; begin
  RegisterComponents('Additional',[TShapeEx]);
end;

{ TShapeEx }

procedure TShapeEx.SetShape(Value: TShapeExType); begin
  if FShape <> Value then begin
    FShape := Value;
    StyleChanged(Self);
  end;
end;

procedure TShapeEx.Paint;
var
  PaintRect : TRect;
  MinSize : Longint;
  P : array[0..3] of TPoint;
  PenInc, PenDec : Integer;
  T : array[0..2] of TPoint;
begin
  with Canvas do begin
    Pen    := Self.Pen;
    Brush  := Self.Brush;
    PenInc := Pen.Width div 2;
    PenDec := (Pen.Width - 1) div 2;
    PaintRect := Rect(PenInc, PenInc, Self.Width - PenDec, Self.Height - PenDec);
    with PaintRect do begin
      MinSize := Min(Right - Left, Bottom - Top);
      if FShape in [stSquare, stRoundSquare, stCircle, stSquaredDiamond] then begin
        Left := Left + ((Right - Left) - MinSize) div 2;
        Top := Top + ((Bottom - Top) - MinSize) div 2;
        Right := Left + MinSize;
        Bottom := Top + MinSize;
      end;
    end;
    case FShape of
      stRectangle, stSquare :      Rectangle(PaintRect);
      stRoundRect, stRoundSquare : RoundRect(PaintRect, MinSize div 4, MinSize div 4);
      stCircle, stEllipse :        Ellipse(PaintRect);
      stSquaredDiamond, stDiamond :
        with Self do begin
          P[0].x := 0;
          P[0].y := (Height - 1) div 2;
          P[1].x := (Width - 1) div 2;
          P[1].y := 0;
          P[2].x := Width - 1;
          P[2].y := P[0].y;
          P[3].x := P[1].x;
          P[3].y := Height - 1;
          Polygon(P);
        end;
      stRightTriangle :
        with Self do begin
          T[0].x := 0;
          T[0].y := 0;
          T[1].x := Width - 1;
          T[1].y := (Height - 1) div 2;
          T[2].x := 0;
          T[2].y := Height - 1;
          Polygon(T);
        end;
      stLeftTriangle:
        with Self do begin
          T[0].x := 0;
          T[0].y := (Height - 1) div 2;
          T[1].x := Width - 1;
          T[1].y := 0;
          T[2].x := Width - 1;
          T[2].y := Height - 1;
          Polygon(T);
        end;
      stUpTriangle:
        with Self do begin
          T[0].x := 0;
          T[0].y := Height - 1;
          T[1].x := (Width - 1) div 2;
          T[1].y := 0;
          T[2].x := Width - 1;
          T[2].y := Height - 1;
          Polygon(T);
        end;
      stDownTriangle:
        with Self do begin
          T[0].x := 0;
          T[0].y := 0;
          T[1].x := Width - 1;
          T[1].y := 0;
          T[2].x := (Width - 1) div 2;
          T[2].y := Height - 1;
          Polygon(T);
        end;
    end;
  end;
  // to fire OnPaint event
  if Assigned(OnPaint) then OnPaint(Self);
end;

end.
