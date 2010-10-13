{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit ShapeExPackage; 

interface

uses
  ShapeEx, LazarusPackageIntf;

implementation

procedure Register; 
begin
  RegisterUnit('ShapeEx', @ShapeEx.Register); 
end; 

initialization
  RegisterPackage('ShapeExPackage', @Register); 
end.
