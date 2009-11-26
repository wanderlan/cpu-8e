Unit CPU8e_Utils;
{
  CPU-8E Simulator

                                                   Copyright 2009 Joel Guilherme

  Simulador para uma CPU de 8-bits Educacional, conforme especifica��es
  contidas no documento CPU-8E-Specs-vX.Y.pdf ('X.Y' conforme a vers�o atual
  do programa), parte deste pacote.

  Este programa, e todos seus componentes, � colocado � disposi��o do p�blico
  na forma de um 'Programa Livre' ("Free Software") sob uma licen�a "GNU -
  General Public License" (Copyleft), sendo assim entendido que voc� tem o
  direito de utiliz�-lo livremente, sem pagar quaisquer direitos por isto,
  inclusive o direito de copi�-lo, modific�-lo e redistribu�-lo, desde que
  mantidos estes termos a quaisquer c�pias ou modifica��es.
  Este programa � distribuido na esperan�a de que possa ser �til, mas SEM
  NENHUMA GARANTIA, IMPL�CITA OU EXPL�CITA, de ADEQUA��O a qualquer MERCADO
  ou APLICA��O EM PARTICULAR. Para maiores detalhes veja o documento
  "Copiando(GPL).txt", parte integrante deste pacote de programa.

  Autor: Prof. Joel Guilherme da Silva Filho
  Organiza��o: IESB - Instituto de Educa��o Superior de Bras�lia
  Local: Bras�lia/DF, Brasil

  Hist�rico:
    Vers�o: 0.9 - 01/02/2009: Primeira vers�o totalmente operacional
    Vers�o: 1.0  - 04/02/2009 - Corrigida l�gica de "Single Step"/"Single Cycle"
                              - Corrigida representac�o de End. Imediato/Direto
    Vers�o: 1.0b - 28/04/2009 - Registradores CPU.A e CPU.B (ULA) foram
                                redefinidos como do tipo "Byte"
                              - Corrigida l�gica de gera��o dos flags da ULA.
    Vers�o: 2.0 - 24/11/2009  - Elimina��o das rotinas da interface caractere
}

{
  CPU8E_Utils.pas
  Esta Unit implementa algumas rotinas utilit�rias
}

interface

uses DOS,SysUtils;

procedure SetLocalDir;
{ Estabelece diretorio local do programa }
procedure Beep;
{ Produz um som de "beep" no alto-falante }
procedure Buzz;
{ Produz um som de "buzz" no alto-falante }

implementation

procedure SetLocalDir;
{ Estabelece diretorio local do programa }
begin
  ChDir(ExtractFileDir(ParamStr(0)));
end;

procedure Beep;
{ Produz um som de "beep" no alto-falante }
begin
  SysUtils.Beep;
end;

procedure Buzz;
{ Produz um som de "buzz" no alto-falante }
var r: word;
begin
  for r := 1 to 6 do Beep;
end;

end.
