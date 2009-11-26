Unit CPU8e_Utils;
{
  CPU-8E Simulator

                                                   Copyright 2009 Joel Guilherme

  Simulador para uma CPU de 8-bits Educacional, conforme especificações
  contidas no documento CPU-8E-Specs-vX.Y.pdf ('X.Y' conforme a versão atual
  do programa), parte deste pacote.

  Este programa, e todos seus componentes, é colocado à disposição do público
  na forma de um 'Programa Livre' ("Free Software") sob uma licença "GNU -
  General Public License" (Copyleft), sendo assim entendido que você tem o
  direito de utilizá-lo livremente, sem pagar quaisquer direitos por isto,
  inclusive o direito de copiá-lo, modificá-lo e redistribuí-lo, desde que
  mantidos estes termos a quaisquer cópias ou modificações.
  Este programa é distribuido na esperança de que possa ser útil, mas SEM
  NENHUMA GARANTIA, IMPLÍCITA OU EXPLÍCITA, de ADEQUAÇÃO a qualquer MERCADO
  ou APLICAÇÃO EM PARTICULAR. Para maiores detalhes veja o documento
  "Copiando(GPL).txt", parte integrante deste pacote de programa.

  Autor: Prof. Joel Guilherme da Silva Filho
  Organização: IESB - Instituto de Educação Superior de Brasília
  Local: Brasília/DF, Brasil

  Histórico:
    Versão: 0.9 - 01/02/2009: Primeira versão totalmente operacional
    Versão: 1.0  - 04/02/2009 - Corrigida lógica de "Single Step"/"Single Cycle"
                              - Corrigida representacão de End. Imediato/Direto
    Versão: 1.0b - 28/04/2009 - Registradores CPU.A e CPU.B (ULA) foram
                                redefinidos como do tipo "Byte"
                              - Corrigida lógica de geração dos flags da ULA.
    Versão: 2.0 - 24/11/2009  - Eliminação das rotinas da interface caractere
}

{
  CPU8E_Utils.pas
  Esta Unit implementa algumas rotinas utilitárias
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
