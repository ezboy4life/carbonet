# Diretrizes de contribuição

Esse arquivo define a estratégia de branch que vamos seguir para que não tenha problemas de conflito no código quando estivermos usando do Git. De momento esta definido apenas a estrategia de branch que vamos estar usando porém nós podemos (caso seja necessário) definir aqui conveções de nomenclatura no código, padrões de modelo de classe, etc.

## Branches e suas funções

- **develop**: É o branch onde o desenvolvimento do projeto vai ocorrer, porém não iremos dar commit diretamente neste branch e sim vamos criar dois sub-branches cada vez que formos adicionar algo no projeto:
    -**feature**: Toda vez que formos adicionar um novo recurso no projeto vamos criar um novo branch a partir do *develop* onde esse branch terá o nome do recurso que vamos desenvolver, por exemplo: *feature/login-e-registro*.
    -**hotfix**: Teria o mesmo propósito que o branch *feature* porém é exclusivo para correção de erros, exemplo: *hotfix/erro-api*.
- **main**: É o branch principal, conforme mencionado antes o desenvolvimento vai acontecer no branch *develop* e somente daremos merge quando tivermos uma versão pronta para produção.
    - **bugfix**: Esse branch vai ser criado assim que for descoberto um erro no código do projeto em produção (ou seja, branch *main*) que precisa ser corrigido com urgência.

## Framework

Esse repositório vai abrigar exclusivamente o código para o desenvolvimento do aplicativo mobile do CarboNet, e a framework utilizada é o [Flutter](https://docs.flutter.dev/). Outras partes do projeto como o backend serão desenvolvidos em outros repositórios separados.
