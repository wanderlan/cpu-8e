unit CPU8E_Oper;

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
    Versão: 2.0  - 30/11/2009 - Nova interface gráfica.
    Versão: 2.1  - 16/12/2009 - Disassembler.
}

{
  CPU8E_Oper.pas
  Esta Unit implementa a logica de diálogo com o usuário, sendo responsável
  pelas respostas aos principais comandos do usuário, chamando as rotinas
  apropriadas para a execução dos mesmos.
}

interface

uses SysUtils,CPU8E,CPU8E_Utils,CPU8E_Control;

function LoadFile(fname : string) : integer;
{ Faz a carga de um arquivo executavel pela CPU-8E para sua "memoria" }
function SaveFile(fname : string) : integer;
{ Salva o conteudo da memoria para um arquivo binario }
procedure Run;
{ Executa o arquivo em memoria pela CPU simulada }
procedure ResetCPU;
{ Executa um "hardware reset" da CPU simulada }
procedure SetClock;
{ Estabelece um valor de "clock" para a CPU simulada }

const
  DefaultClock = 50;    // valor "default" para o "clock" da CPU

var
  CpuClock : integer = DefaultClock;    // o "clock" da CPU (1 <= Ck <= 100)

implementation

uses Dialogs;

function LoadFile(fname : string) : integer;
{ Faz a carga de um arquivo executavel pela CPU-8E para sua "memoria" }
var
  f : file;
begin
  Cmd := _Halt;               // pausa a CPU após esta operacao
  assign(f, fname);
  {$I-}
  reset(f,1);
  if IOResult <> 0 then begin  // se houve erro na abertura do arquivo ...
    close(f);
    Buzz;
    Result := -1;
    exit;
  end;
  fillchar(CPU.Mem, sizeof(CPU.Mem), 0);
  blockread(f, CPU.Mem, sizeof(CPU.Mem), CPU.LenProg);  // le arquivo completo
  Result := CPU.LenProg;
  close(f);
  {$I+}
end;

function SaveFile(fname : string) : integer;
{ Salva o conteudo da memoria para um arquivo binario }
var
  f : file;
begin
  assign(f,fname);
  {$I-}
  rewrite(f,1);
  if IOResult <> 0 then begin  // se houve erro na gravação do arquivo ...
    Buzz;
    Result := -1;
  end
  else
    blockwrite(f, CPU.Mem, CPU.LenProg, Result);  // grava arquivo completo
  close(f);
  {$I+}
end;

procedure Run;
{ Executa o arquivo em memoria pela CPU simulada }
begin
   if CPU.LenProg = 0 then begin   // se nao ha programa carregado ...
     Buzz;
     ShowMessage('Nenhum programa carregado em memoria!');
     Cmd := _Halt;
   end
   else
     RunProgram;            // executa o programa
   if UControl.S = 3 then    // se programa terminou ...
     Cmd := _Halt;
end;

procedure ResetCPU;
{ Executa um "hardware reset" da CPU simulada }
begin
  CPU_Reset;                   // executa o reset da CPU e ...
  UControl.S := 0;             // das variaveis de controle
  UControl.T := 0;
  ShowMem(CPU.PC);             // atualiza display da memoria
  ShowCPU;                     // atualiza display da CPU
end;

procedure SetClock;
{ Estabelece um valor de "clock" para a CPU simulada }
begin
// Clock = 1 --> ~1Hz
// Clock = 99 --> ~1KHz
// Clock = 100 --> Top Speed (dependente da plataforma)
  with UControl do
    case CpuClock of
        1 : Timer := 1000; // delay = 1 ms, f = 1KHz
      100 : Timer := 0;    // no delay
    else
      Timer := 510 - trunc(5.144*CpuClock);   // Formula Mágica  :-)
    end;
end;

end.
