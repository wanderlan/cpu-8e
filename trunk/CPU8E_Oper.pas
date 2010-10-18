unit CPU8E_Oper;

{
  CPU-8E Simulator

                                 Copyright 2009/10 Joel Guilherme da Silva Filho

  Simulador para uma CPU Educacional de 8-bits, conforme especificacoes
  contidas no documento CPU-8E-Specs-vX.Y.pdf ('X.Y' indica a versão atual
  do programa), parte deste pacote.

  Este programa, e todos seus componentes, eh colocado aa disposicao do publico
  na forma de um 'Programa Livre' ("Free Software") sob uma licenca "GNU -
  General Public License" (Copyleft), sendo assim entendido que voce tem o
  direito de utiliza-lo livremente, sem pagar quaisquer direitos por isto,
  inclusive o direito de copia-lo, modifica-lo e redistribui-lo, desde que
  mantidos estes termos a quaisquer copias ou modificacoes.
  Este programa eh distribuido na esperanca de que possa ser util, mas SEM
  NENHUMA GARANTIA, IMPLICITA OU EXPLICITA, de ADEQUACAO a qualquer MERCADO
  ou APLICACAO EM PARTICULAR. Para maiores detalhes veja o documento
  "Copiando(GPL).txt", parte integrante deste pacote de programa.

  Autor: Prof. Joel Guilherme da Silva Filho
         joel@joelguilherme.com
  Organização: IESB - Instituto de Educação Superior de Brasília
  Local: Brasília/DF, Brasil

  Contribuicoes:
  V2.0 - Wanderlan Santos dos Anjos e Barbara A.B. dos Anjos
         wanderlan.anjos@gmail.com
         barbara.ab.anjos@gmail.com
  V2.1 - Wanderlan Santos dos Anjos e Barbara A.B. dos Anjos
         wanderlan.anjos@gmail.com
         barbara.ab.anjos@gmail.com
  V2.2 - Anderson de Souza Freitas e Daniel Machado Vasconcelos
         anderson.souza.freitas@gmail.com
         danielm.vasconcelos@gmail.com

  Historico:
    Versao 0.9    - 01/02/2009 - Primeira versão totalmente operacional.
    Versao 1.0a   - 04/02/2009 - Corrigida logica "Single Step"/"Single Cycle".
                               - Corrigida representacao para enderecamento
                                 Imediato/Direto.
    Versao 1.0b   - 28/04/2009 - Registradores CPU.A e CPU.B (ULA) foram
                                 redefinidos como do tipo "Byte"
                               - Corrigida lógica de geração dos flags da ULA.
    Versao 2.0    - 24/11/2009 - Interface modo texto substituida por interface
                                 grafica construida com o Lazarus/FPC,
                                 permitindo compilacao multiplataforma.
    Versao 2.1    - 16/12/2009 - Introduzido o disassembly automatico dos
                                 codigos em memoria.
                                 Introduzidas facilidades para editar e salvar
                                 um programa no simulador.
    Versao: 2.2.0 - 21/07/2010 - Expandido conjunto de instrucoes para incluir
                                 shifts, rotates e chamada de sub-rotina.
                               - Revistas funcoes de controle e do simulador.
    Versao: 2.2.2 - 09/10/2010 - Revisao geral do codigo com total adequacao
                                 deste aas especificacoes da CPU-8Ev2.0.

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
  with UControl do
    if CpuClock = 100 then
      Timer :=0
    else
      Timer := 510 - trunc(5.144*CpuClock);   // Formula Mágica  :-)

end;

end.
