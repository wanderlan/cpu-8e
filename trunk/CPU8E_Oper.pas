Unit CPU8E_Oper;

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
}

{
  CPU8E_Oper.pas
  Esta Unit implementa a logica de di�logo com o usu�rio, sendo respons�vel
  pelas respostas aos principais comandos do usu�rio, chamando as rotinas
  apropriadas para a execu��o dos mesmos.
}

interface

uses Crt,SysUtils,CPU8E,CPU8E_Utils,CPU8E_Control;

function LoadFile(fname : string) : integer;
{ Faz a carga de um arquivo executavel pela CPU-8E para sua "memoria" }
procedure Run;
{ Executa o arquivo em memoria pela CPU simulada }
procedure ResetCPU;
{ Executa um "hardware reset" da CPU simulada }
procedure SetClock;
{ Estabelece um valor de "clock" para a CPU simulada }
procedure GetCmd;
{ Interpreta comandos fornecidos pelo usu�rio atraves do teclado }

const
  DefaultClock = 50;    // valor "default" para o "clock" da CPU

var
  CpuClock : integer = DefaultClock;    // o "clock" da CPU (1 <= Ck <= 100)

implementation

uses DOS, Dialogs, CPU8E_Panel;

function LoadFile(fname : string) : integer;
{ Faz a carga de um arquivo executavel pela CPU-8E para sua "memoria" }
var
  f : file;
begin
  Cmd := _Halt;               // pausa a CPU ap�s esta operacao
  assign(f,fname);
  {$I-}
  reset(f,1);
  if IOResult <> 0 then begin  // se houve erro na abertura do arquivo ...
    close(f);
    Buzz;
    Result := -1;
    exit;
  end;
  blockread(f,CPU.Mem,sizeof(CPU.Mem),Result);  // le arquivo completo
  close(f);
  {$I+}
  ProgramLoaded := true;       // sinaliza que programa carregado Ok
end;

function SaveFile(fname : string) : integer;
{ Salva a memriaFaz a carga de um arquivo executavel pela CPU-8E para sua "memoria" }
var
  f : file;
begin
  Cmd := _Halt;               // pausa a CPU ap�s esta operacao
  assign(f,fname);
  {$I-}
  reset(f,1);
  if IOResult <> 0 then begin  // se houve erro na abertura do arquivo ...
    close(f);
    Buzz;
    Result := -1;
    exit;
  end;
  blockread(f,CPU.Mem,sizeof(CPU.Mem),Result);  // le arquivo completo
  close(f);
  {$I+}
  ProgramLoaded := true;       // sinaliza que programa carregado Ok
end;

procedure Run;
{ Executa o arquivo em memoria pela CPU simulada }
begin
   if not ProgramLoaded then begin   // se nao ha programa carregado ...
      Buzz;
      ShowMessage('Nenhum programa carregado em memoria!');
      Cmd := _Pause;
   end else
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
      Timer := 510 - trunc(5.144*CpuClock);   // Formula M�gica  :-)
    end;
end;

procedure GetCmd;
{ Interpreta comandos fornecidos pelo usu�rio atraves do teclado }
begin
   Write('Entre Comando: ');
   if keypressed or (Cmd = _Up) or (Cmd = _Down) then
// '_Up' e '_Down' sao comandos para rolar a tela da memoria, e devem ser
// repetidos at� que um comando distinto seja acionado pelo usuario
   begin
//      Option := upcase(readkey);
//      if Option = #$00 then
// devem ser as setas para rolar a janela da memoria
         begin
//         Option := readkey;
(*         case Option of
            #$48: Option := 'U';   // seta para cima - UP
            #$50: Option := 'D';   // seta para baixo - DOWN
            #$3B: Option := 'A';   // tecla <F1> - Auxilio (Help)
        *) end;
      end;
(*      case Option of
           'A': Exec('Notepad.exe','CPU8E_Sim.txt');
           'L': Cmd := _Load;
           'E': Cmd := _Edit;
           'C': Cmd := _Clock;
           'M': Cmd := _Mode;
           'G': Cmd := _Go;
           'P': Cmd := _Pause;
           'H': begin
                   Cmd := _Halt;
                   UControl.S := 3;
                end;
           'R': Cmd := _Rst;
           'X': Cmd := _eXit;
           'U': Cmd := _Up;
           'D': Cmd := _Down;
      end;
//      write(Option,BS);
   end;*)
end;

end.

