% Define a estrutura da árvore binária
arvore([]). % Caso base 
arvore([E,Esq,Dir]) :- 
    arvore(Esq), arvore(Dir). % Um nó interno tem uma subárvore esquerda e uma subárvore direita


% Conta a frequência dos caracteres no texto
contarFrequencia([],[]). % Caso base 
contarFrequencia(Texto, F) :- 
    msort(Texto, TextoOrd), % Ordena o texto
    contarFrequenciaOrd(TextoOrd,F). % Conta as ocorrências dos caracteres no texto ordenado

% Contagem de ocorrências de caracteres ordenados
contarFrequenciaOrd([],[]). % Caso base 
contarFrequenciaOrd([C|Cs],R) :- contarFrequenciaOrd(Cs,C,1,R).

contarFrequenciaOrd([],C,F,[(C,F)]).
contarFrequenciaOrd([C|Cs],C,F,R) :- 
    F1 is F+1, contarFrequenciaOrd(Cs,C,F1,R). % Conta ocorrências do caractere atual
contarFrequenciaOrd([A|As],C,N,[(C,N)|Xs]) :- 
    contarFrequenciaOrd(As,A,1,X). % Remove as ocorrências contadas


% Conta as ocorrências de X em uma lista
contarOcorrencias(0,_,[]). % Caso base 
contarOcorrencias(N,X,[X|Xs]) :- 
    N1 is N+1, (N1,X,Xs). % Incrementa a contagem e continua na lista
contarOcorrencias(N,X,[Y|Xs]) :- 
    X /= Y, contarOcorrencias(N,X,Xs). % Ignora o caractere e continua na lista


% Remove as ocorrências de X de uma lista
removerOcorrencias([],_,[]). % Caso base
removerOcorrencias([X|As], X, Xs) :- 
    removerOcorrencias(As,X,Xs). % Ignora o caractere e continua na lista
removerOcorrencias([A|As], X, [A|Xs]) :- 
    removerOcorrencias(As,X,Xs). Mantém o caractere e continua na lista


% Cria uma lista de folhas para os caracteres e suas frequências
criarFolha([],[]). % Caso base 
criarFolha([C,F|Xs], [Leaf(C,F)|Ys]) :- 
    criarFolha(Xs,Ys). % Cria uma folha para cada par de caractere e frequência


% Constrói a árvore de Huffman
construirArvore([],[]). % Caso base vazio


% Calcula o peso (frequência) de uma folha
peso(Leaf(_,F),F). 

% Calcula o peso (frequência) de um nó interno
peso(Node(F,Esq,Dir),F) :- 
    peso(Esq,Fesq), % Peso nó esquerdo
    peso(Dir,fdi), % Peso nó direito
    F is Fesq + Fdir. % Soma dos pesos


% Exibe a tabela de caracteres e suas frequências
exibirTabela([]). % Caso base 
exibirTabela([C,F|Xs]) :- 
    write(write('    '), write(C), write('    '), write(F)),
    exibirTabela(Xs).
    

% Gera o código de Huffman para cada caractere
gerarCodigo(Leaf(C, _), Prefixo, [(C, Prefixo)]).

gerarCodigo(Node(_,Esq,Dir),Prefixo,SubArvores) :- 
    gerarCodigo(Esq,[0|Prefixo],SubArvEsq), % Adiciona '0' ao prefixo para a esquerda
    gerarCodigo(Dir,[1|Prefixo],SubArvDir), % Adiciona '1' ao prefixo para a direita
    append(SubArvEsq,SubArvDir,SubArvores). % Combina os resultados das subárvores

% Inicia a recursão com um código vazio
gerarCodigo(arvore, Codes) :- gerarCodigo(arvore, [], Codes).



% Se o caractere for encontrado na tabela
codificarTexto(_,[],[]). % Caso base
codificarTexto(Tabela, [C|Cs], R) :- 
    encontrarCodigo(X, Tabela, Codigo), % Busca o código
    codificarTexto(Tabela,Cs,R),
    append(Codigo,Xs,R).

% Caso em que o caractere não tem código, retornamos uma string vazia.
codificarTexto(_,[C|Cs],R) :- \+ 
    encontrarCodigo(C, _, _), % Caso em que o caractere X não está na tabela
    codificarTexto(_,Cs,R)

% Busca o código associado ao caractere C na tabela.
encontrarCodigo(C,[C,Codigo|_],Codigo). % Se C for o primeiro, retorna o código.
encontrarCodigo(C,[_|Ys],Codigo) :- encontrarCodigo(C,Ys,Codigo)



% Função auxiliar para exibir a tabela de códigos de Huffman
exibirTabelaCodigos([]). % Caso base
exibirTabelaCodigos([C,Codigo|Cs]) :- 
    write(C), write(': '), write(Codigo),nl,
    exibirTabelaCodigos(Cs).