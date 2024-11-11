arvore([]).
arvore([E,Esq,Dir]) :- arvore(Esq), arvore(Dir).



contarFrequencia([],[]).
contarFrequencia(Texto, F) :- 
    sort(Texto, TextoOrd), 
    contarFrequenciaOrd(TextoOrd,F).

contarFrequenciaOrd([],[]).
contarFrequenciaOrd([C|Cs],R) :- contarFrequenciaOrd(Cs,C,1,R).

contarFrequenciaOrd([],C,F,[(C,F)]).
contarFrequenciaOrd([C|Cs],C,F,R) :- F1 is F+1, contarFrequenciaOrd(Cs,C,F1,R).
contarFrequenciaOrd([A|As],C,N,[(C,N)|Xs]) :- contarFrequenciaOrd(As,A,1,X).



contarOcorrencias(0,_,[]).
contarOcorrencias(N,X,[X|Xs]) :- N1 is N+1, (N1,X,Xs).
contarOcorrencias(N,X,[Y|Xs]) :- X /= Y, contarOcorrencias(N,X,Xs).



removerOcorrencias([],_,[]).
removerOcorrencias([X|As], X, Xs) :- removerOcorrencias(As,X,Xs).
removerOcorrencias([A|As], X, [A|Xs]) :- removerOcorrencias(As,X,Xs).



criarFolha([],[]).
criarFolha([C,F|Xs], [Leaf(C,F)|Ys]) :- criarFolha(Xs,Ys).



construirArvore([],[]).



peso(Leaf(_,F),F).

peso(Node(F,Esq,Dir),F) :- peso(Esq,Fesq), peso(Dir,fdi), F is Fesq + Fdir.



exibirTabela([]).
exibirTabela([C,F|Xs]) :- 
    write(write('    '), write(C), write('    '), write(F)),
    exibirTabela(Xs).
    


gerarCodigo(Leaf(C, _), Prefixo, [(C, Prefixo)]).

gerarCodigo(Node(_,Esq,Dir),Prefixo,SubArvores) :- 
    gerarCodigo(Esq,[0|Prefixo],SubArvEsq),
    gerarCodigo(Dir,[1|Prefixo],SubArvDir),
    append(SubArvEsq,SubArvDir,SubArvores).

gerarCodigo(arvore, Codes) :- gerarCodigo(arvore, [], Codes).
