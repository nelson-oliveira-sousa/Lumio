# Lições

Cada erro recorrente do agente vira uma linha aqui. **Na segunda ocorrência**, a lição vira regra verificável (teste, hook, cop do RuboCop ou regra do Packwerk) sempre que possível. Nenhum erro deve acontecer três vezes.

| Data | Erro | Regra | Verificação |
|---|---|---|---|
| _AAAA-MM-DD_ | _o que o agente fez de errado_ | _o que deve ser feito_ | _teste/hook que pega, ou "só doc"_ |

## Como registrar
1. Descreva o erro em uma frase, sem culpa: o que aconteceu, não quem errou.
2. Escreva a regra no imperativo.
3. Se der para verificar, crie o teste ou o hook no mesmo PR e aponte o caminho na coluna "Verificação".
4. Se a regra for inviolável, some ela também à lista do `AGENTS.md` da raiz.
