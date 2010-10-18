Unit CPU8E_Utils;
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
  CPU8E_Utils.pas
  Esta Unit implementa algumas rotinas utilitárias para o simulador
}

interface

uses SysUtils;

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
