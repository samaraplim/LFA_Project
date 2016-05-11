
Instruções para compilar e executar: 
- bison:  bison -d projetoSam.y
- flex:   flex -o projetoSam.lex.c projetoSam.lex
- compilar: gcc -o projetoSam projetoSam.lex.c projetoSam.tab.c -lfl -lm
- executar: ./projetoSam
- para usar a calculadora: calculo operando operador operando (ex. calculo 5+4)