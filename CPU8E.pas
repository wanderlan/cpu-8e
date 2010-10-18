Unit CPU8E;
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
  CPU8E.pas
  Esta Unit contem basicamente a descricao da arquiteruta da CPU-8E
  e algumas rotinas básicas para a interface do simulador com o usuario.
}

Interface

uses StdCtrls;

type
// Define a representacao interna, para o simulador, dos OpCodes definidos
// para a UCP-8E
   OpCodeType = (_HLT,_NOP,_NOT,_JMP,_JEQ,_JGT,_JGE,_STO,_LOD,_CMP,_ADD,_SUB,
                 _AND,_XOR,_ORL,_JCY,_SHL,_SHR,_SRA,_ROL,_ROR,_CAL,_RET,_Invalid);

// Define os comandos para operacao do simulador
{
  _Clock: ajusta a "velocidade" do clock da CPU
  _Load:  faz o carregamento em memoria de um programa executavel da CPU-8E
  _Edit:  permite a edicao de um valor em memoria
  _Mode:  seleciona um entre 3 modos de operacao para o simulador
  _Go:    executa a simulacao conforme programa arazenado
  _Pause: interrompe a execucao de uma simulacao, que pode ser reiniciada com
          o comando _Go
  _Halt:  termina uma simulacao, requerendo um Reset para nova simulacao
  _Rst:   forca um Reset da CPU
  _eXit:  encerra o programa simulador
  _Up:    avanca o cursor de visualizacao da memoria
  _Down:  retrocede o cursor de visualizacao da memoria
  _Help:  abre um arquivo de auxilio aa operacao do simulador
}
  CmdType = (_Clock,_Load,_Edit,_Mode,_Go,_Pause,_Halt,_Rst,_eXit,
             _Up,_Down,_Help);

//  Define os modos de operacao do simulador
{
   _Step:  modo "single step", em que a execucao eh realizada fase-a-fase para
           cada instrucao a ser executada (fetch, operand, execute), sendo
           necessario que o usuario pressione uma tecla para avancar;
   _Cycle: modo "single cycle", em que a execucao eh realizada instrucao por
           instrucao, sendonecessario que o usuario pressione uma tecla para
           avancar;
   _Full:  o programa eh executado por inteiro ("Run"), ateh que seja encontrada
           uma instrucao de HALT.
   Em qualquer modo de operacao o usuario pode dar qualquer dos comandos dispo-
   niveis para o simulador, de modo a alterar o modo, pausar ou interromper o
   processamento.
}
   ModeType = (_Step,_Cycle,_Full);

   PhaseType = (_Fetch, _Operand, _Execute, _Reset);

var
// Esta eh a estrutura basica correspondente aa arquitetura da CPU
   CPU: record
      ACC: shortint;                // Acumulador
      PC:  byte;                     // Contador de Programa
      MAR: byte;                    // Reg. de Ender. da Memoria
      MDR: byte;                    // Reg. de Dados da Memoria
      A:   byte;                    // Reg. A, associado aa ULA
      B:   byte;                    // Reg. B, associado aa ULA
      SP:  byte;                    // Stake Pointer (Ponteiro De Pilha)
      ULA: record                   // Unidade Logica e Aritmetica
         Value: Byte;                  // Valor de saida
         Z,                            // Bit de Status 'Zero'
         N,                            // Bit de Status 'Negativo'
         C:   boolean;                 // Bit de Status 'Carry'
      end;
      IR: byte;                     // Registrador de Instrucoes
      OpCode: OpCodeType;           // OpCode (decodificado do IR)
      DW: boolean;                  // Flag indicando Instrucao de 2 palavras
      ED: boolean;                  // Flag indicando Enderecamento Direto
      Mem: packed array[0..255] of byte;   // Memoria de 256 Bytes
      LenProg : integer;            // Tamanho do programa carregado na memória
    end;

    Cmd, LastCmd: CmdType;          // Comando do usuario
    CPUMode : ModeType = _Step;     // Modo de operacao selecionado
    CPU_Caption: string;

const
   NumOpCodes = 24;
// Forma simbolica para os OpCodes
   OpCodeStr: array[OpCodeType] of string[3]
              = ('HLT','NOP','NOT','JMP','JEQ','JGT','JGE','STO','LOD',
                 'CMP','ADD','SUB','AND','XOR','ORL','JCY','SHL','SHR',
                 'SRA','ROL','ROR','CAL','RET','XXX');
// Mascaras para isolar areas do IR
   OpCodeMask = $1F;    // 5-bits inferiores, que definem a identidade do OpCode
   DoubleMask = $80;    // bit identificador de instrucao de 2 palavras
   DirectMask = $40;    // bit identificador de enderecamento direto

// Identificador do programa e versao
   ProgName = 'CPU-8E Simulator';
   Version  = 'V2.2.3';
   Author   = '(R) Prof. Joel Guilherme (IESB)';

procedure CPU_Reset;
{ Reinicia a CPU, zerando todos os registradores e ressetando variaveis }
procedure ShowReg(Item: TStaticText; Val: byte); overload;
{ Mostra o conteudo de um registrador }
procedure ShowReg(Item : TStaticText; Val: string); overload;

procedure ShowCPU;
{ Atualiza na tela todos os valores internos da CPU }
procedure ShowMem(Current: byte);
{ Mostra o conteudo da Memoria da CPU, indicando a posicao da instrucao
  corrente a ser executada ou em execucao }
function LenReg(Item : TStaticText) : integer;

Implementation

uses SysUtils, Forms, Grids, Graphics, CPU8E_Panel;

procedure CPU_Reset;
{ Reinicia a CPU, zerando todos os registradores e ressetando variaveis }
begin
   with CPU do begin
      ACC := 0;
      PC  := 0;
      MAR := 0;
      MDR := 0;
      A   := 0;
      B   := 0;
      IR  := 0;
      SP  := 255;
      ULA.Value := 0;
      ULA.Z   := false;
      ULA.N   := false;
      ULA.C   := false;
      OpCode  := _HLT;
   end;
   Cmd := _Rst;
end;

function LenReg(Item : TStaticText) : integer; begin
//  Result := IfThen(Item.Name[3] in ['Z', 'N', 'C'], 1, 2);
   If (Item.Name = 'stZ') or (Item.Name = 'sxZ') or
      (Item.Name = 'stN') or (Item.Name = 'sxN') or
      (Item.Name = 'stC') or (Item.Name = 'sxC')
   then
      Result := 1
   else
      Result := 2;
end;

procedure ShowReg(Item : TStaticText; Val: byte);
{ Mostra o conteudo de um registrador. Como parametros sao passados o
  identificador do objeto e seu valor, para apresntacao na tela }
begin
  Item.Caption := copy(Item.Name, 3, 3) + ':' + IntToHex(Val, LenReg(Item));
  Item.Font.Color := clBlack;
  Application.ProcessMessages;
end;

procedure ShowReg(Item : TStaticText; Val: string);
{ Mostra o conteudo de um registrador. Como parametros sao passados o
  identificador do objeto e seu valor, para apresntacao na tela }
begin
  Item.Caption := copy(Item.Name, 3, 3) + ':' + Val;
  Item.Font.Color := clBlack;
  Application.ProcessMessages;
end;

procedure ShowCPU;
{ Atualiza na tela todos os valores internos da CPU }
begin
  with CPU, frmCPU do begin
    ShowReg(stACC,ACC);
    ShowReg(stPC,PC);
    ShowReg(stMAR,MAR);
    ShowReg(stMDR,MDR);
    ShowReg(stIR,IR);
    ShowReg(stSP,SP);
    ShowReg(stA,A);
    ShowReg(stB,B);
    ShowReg(stULA,ULA.Value);
    ShowReg(stDI, OpCodeStr[OpCode]);
    ShowReg(stZ, Byte(ULA.Z));
    ShowReg(stN, Byte(ULA.N));
    ShowReg(stC, Byte(ULA.C));
    ShowReg(sxZ, Byte(ULA.Z));
    ShowReg(sxN, Byte(ULA.N));
    ShowReg(sxC, Byte(ULA.C));
  end;
end;

type
  TSG = class(TStringGrid);

procedure ShowMem(Current: byte);
{ Mostra o conteudo da Memoria da CPU, realcando a posicao da instrucao
  corrente a ser executada ou em execucao }
var
  Sel : TGridRect;
begin
  inc(Current);
  TSG(frmCPU.sgMemoria).MoveExtend(false, 0, Current);
  Sel.Left   := 0;
  Sel.Top    := Current;
  Sel.Right  := 2;
  Sel.Bottom := Current;
     frmCPU.sgMemoria.Row := 0;
     frmCPU.sgMemoria.SetFocus;
  if Current > (257-9) then begin
     frmCPU.sgMemoria.Row := 257;
     frmCPU.sgMemoria.SetFocus;
  end else
  if Current > 9 then begin
     frmCPU.sgMemoria.Row := Current+9;
     frmCPU.sgMemoria.SetFocus;
  end;
  frmCPU.sgMemoria.Row := Current;
  frmCPU.sgMemoria.SetFocus;
  frmCPU.sgMemoria.Selection := Sel;
  Application.ProcessMessages;
end;

// Inicializacao da Unit CPU8E
begin
  CPU_Reset;
  fillchar(CPU.Mem, sizeof(CPU.Mem), 0);
end.

