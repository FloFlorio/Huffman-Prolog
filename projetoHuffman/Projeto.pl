% Lê o conteúdo de um arquivo
ler_arquivo(Nome, Conteudo) :-
    open(Nome, read, Stream),
    read_string(Stream, _, Conteudo),
    close(Stream).

% Escreve conteúdo em um arquivo
escrever_arquivo(Nome, Conteudo) :-
    open(Nome, write, Stream),
    write(Stream, Conteudo),
    close(Stream).

% Conta a frequência de cada caractere no texto
contar_frequencia(Texto, Frequencias) :-
    msort(Texto, TextoOrd), % Ordena o texto para agrupar caracteres iguais
    contar_frequencia_ord(TextoOrd, Frequencias).

% Conta os caracteres ordenados
contar_frequencia_ord([], []).
contar_frequencia_ord([C|Cs], [(C, Freq)|Resto]) :-
    contar_ocorrencias(C, [C|Cs], Freq, Restantes),
    contar_frequencia_ord(Restantes, Resto).

% Conta quantas vezes o caractere aparece no início da lista
contar_ocorrencias(_, [], 0, []).
contar_ocorrencias(C, [C|Cs], Freq, Restantes) :-
    contar_ocorrencias(C, Cs, Freq1, Restantes),
    Freq is Freq1 + 1.
contar_ocorrencias(C, [X|Xs], 0, [X|Xs]) :-
    C \= X.

% Cria uma lista de folhas para a árvore de Huffman
criar_folhas(Frequencias, Folhas) :-
    maplist(criar_folha, Frequencias, Folhas).

criar_folha((C, Freq), folha(C, Freq)).

% Constrói a árvore de Huffman
construir_arvore([Arvore], Arvore).
construir_arvore(Folhas, Arvore) :-
    sort(2, @=<, Folhas, Ordenado),
    Ordenado = [Esq, Dir|Resto],
    combinar(Esq, Dir, NovoNo),
    construir_arvore([NovoNo|Resto], Arvore).

combinar(folha(C1, F1), folha(C2, F2), no(F, folha(C1, F1), folha(C2, F2))) :-
    F is F1 + F2.
combinar(no(F1, Esq1, Dir1), folha(C2, F2), no(F, no(F1, Esq1, Dir1), folha(C2, F2))) :-
    F is F1 + F2.
combinar(folha(C1, F1), no(F2, Esq2, Dir2), no(F, folha(C1, F1), no(F2, Esq2, Dir2))) :-
    F is F1 + F2.
combinar(no(F1, Esq1, Dir1), no(F2, Esq2, Dir2), no(F, no(F1, Esq1, Dir1), no(F2, Esq2, Dir2))) :-
    F is F1 + F2.

% Gera o código de Huffman para cada caractere
gerar_codigos(folha(C, _), Prefixo, [(C, Prefixo)]).
gerar_codigos(no(_, Esq, Dir), Prefixo, Codigos) :-
    gerar_codigos(Esq, [0|Prefixo], CodEsq),
    gerar_codigos(Dir, [1|Prefixo], CodDir),
    append(CodEsq, CodDir, Codigos).

% Codifica o texto com os códigos de Huffman
codificar_texto(_, [], []).
codificar_texto(Codigos, [C|Texto], Codificado) :-
    member((C, Codigo), Codigos),
    codificar_texto(Codigos, Texto, CodResto),
    append(Codigo, CodResto, Codificado).

% Função principal
huffman(ArquivoEntrada, ArquivoSaida) :-
    ler_arquivo(ArquivoEntrada, Conteudo),
    string_chars(Conteudo, Chars),
    contar_frequencia(Chars, Frequencias),
    criar_folhas(Frequencias, Folhas),
    construir_arvore(Folhas, Arvore),
    gerar_codigos(Arvore, [], Codigos),
    codificar_texto(Codigos, Chars, Codificado),
    atomic_list_concat(Codificado, '', Resultado),
    escrever_arquivo(ArquivoSaida, Resultado),
    writeln('Arquivo codificado salvo em: '),
    writeln(ArquivoSaida).
