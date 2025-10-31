# 🚀 Desafio de Projeto — Integrando Dados com MySQL Azure e Transformando com Power BI  

<div align="center">
  <img src="https://upload.wikimedia.org/wikipedia/commons/a/a8/Microsoft_Azure_Logo.svg" height="40"/> 
  <img src="https://upload.wikimedia.org/wikipedia/en/d/dd/MySQL_logo.svg" height="40"/> 
  <img src="https://upload.wikimedia.org/wikipedia/commons/c/cf/New_Power_BI_Logo.svg" height="40"/> 
</div>  

---

## 📑 Sumário  

- [🧭 Contexto do Projeto](#-contexto-do-projeto)  
- [🧱 Estrutura do Projeto](#-estrutura-do-projeto)  
- [⚙️ Ferramentas Utilizadas](#️-ferramentas-utilizadas)  
- [🧩 Conceito de Mesclar e Combinar Consultas](#-conceito-de-mesclar-e-combinar-consultas)  
- [🧰 Transformações Realizadas](#-transformações-realizadas)  
  - [📂 1. Tratamentos no MySQL (Extração e Correção do Script)](#-1-tratamentos-no-mysql-extração-e-correção-do-script)  
  - [🧮 2. Transformações no Power BI (Transformação e Limpeza dos Dados)](#-2-transformações-no-power-bi-transformação-e-limpeza-dos-dados)  
- [🧠 Consultas e Análises SQL](#-consultas-e-análises-sql)  
- [📊 Dashboard Final](#-dashboard-final)  
- [📚 Aprendizados Principais](#-aprendizados-principais)  
- [💬 Entre em Contato](#-entre-em-contato)  

---

## 🧭 Contexto do Projeto  

Este projeto faz parte do módulo **“Processamento de Dados com Power BI”**, integrante do bootcamp **Klabin - Excel e Power BI Dashboards**, desenvolvido pela [Digital Innovation One (DIO)](https://www.dio.me/).  

O desafio teve como objetivo aplicar, de forma prática e completa, o processo de **ETL (Extract, Transform, Load)** — extraindo os dados de um banco hospedado na **Azure**, transformando-os e, por fim, carregando-os no **Power BI** para análise.  

---

## 🧱 Estrutura do Projeto  

O desenvolvimento foi dividido em três principais etapas:

1. **Extract (Extração):**  
   Criação e correção do banco de dados no **Azure MySQL**, garantindo compatibilidade e integridade referencial.  

2. **Transform (Transformação):**  
   Aplicação de tratamentos e transformações nos dados utilizando o **Power Query** dentro do **Power BI**.  

3. **Load (Carregamento):**  
   Conexão direta do Power BI com a base MySQL hospedada na Azure e criação do dashboard analítico.  

---

## ⚙️ Ferramentas Utilizadas  

- ☁️ **Microsoft Azure** — hospedagem da instância MySQL  
- 🐬 **MySQL** — modelagem, correção e inserção dos dados  
- 📊 **Power BI** — transformação, análise e visualização dos dados  

---

## 🧩 Conceito de Mesclar e Combinar Consultas  

🔄 **Mesclagem (Merge):**  
Combina **colunas** de tabelas diferentes com base em um campo comum — como associar funcionários aos seus departamentos. É equivalente a um *JOIN* no SQL.  

➕ **Combinação (Append):**  
Empilha **linhas** de tabelas com a mesma estrutura — como juntar várias planilhas de meses diferentes em uma única tabela.  

✅ **Por que usar Mesclagem neste projeto?**  
As tabelas tinham informações complementares (ex.: funcionários, gerentes e departamentos).  
A mesclagem foi usada para integrar essas visões e permitir cruzamentos analíticos, enquanto a combinação não seria adequada, pois não havia dados homogêneos a empilhar:contentReference[oaicite:0]{index=0}.

---

## 🧰 Transformações Realizadas  

### 📂 1. Tratamentos no MySQL (Extração e Correção do Script)  
Conforme o relatório técnico:contentReference[oaicite:1]{index=1}:  

- Adição de **charset** e **collation** (`utf8mb4_unicode_ci`) para suportar caracteres especiais.  
- Padronização de **engine InnoDB** e nomenclatura das *constraints*.  
- Remoção de comandos redundantes e incompatíveis com o Azure Cloud Shell.  
- Correção de tipos de dados (`CHAR`, `DECIMAL`, `DATE`).  
- Ajuste de hierarquia de inserção — garantindo que gestores fossem inseridos antes dos colaboradores.  
- Criação de *foreign keys* com **ON UPDATE CASCADE** e **ON DELETE CASCADE**.  
- Padronização de nomes de chaves primárias e estrangeiras.  
- Organização das inserções por seções e tabelas para melhor manutenção e leitura.  

---

### 🧮 2. Transformações no Power BI (Transformação e Limpeza dos Dados)  
Conforme documento técnico de tratamento:contentReference[oaicite:2]{index=2}:  

- Remoção de colunas desnecessárias após a importação.  
- Alteração do tipo de dado de **Salary** para *Double Preciso*.  
- Junção de **Fname** e **Lname** em uma única coluna chamada **Cname**.  
- Mesclagem das tabelas **departament** e **dept_locations**.  
- Criação de campo único unindo **Dname** e **Location**, representando a unidade organizacional.  
- Junção de **departament** com **employee**, mapeando o nome dos donos (gerentes) de cada departamento.  
- Exclusão da coluna **Minit** por não agregar valor analítico.  
- Criação da tabela **employee_departament**, unindo colaboradores e departamentos.  
- Remoção de duplicidades após mesclagens múltiplas.  

---

## 🧠 Consultas e Análises SQL  

Durante a etapa de verificação e transformação dos dados, foram realizadas as seguintes análises no MySQL:contentReference[oaicite:3]{index=3}:

- Verificação de cabeçalhos e tipos de dados (`INFORMATION_SCHEMA.COLUMNS`).  
- Identificação de valores nulos e definição de regras de limpeza.  
- Conversão de `Salary` para tipo `DOUBLE`.  
- Identificação de colaboradores sem gerente (`Super_ssn IS NULL`).  
- Validação de integridade entre colaboradores e gestores.  
- Conferência de horas trabalhadas por projeto (`works_on`).  
- Mesclagem lógica de `employee` com `departament` e posterior inclusão dos nomes dos gerentes.  

Exemplo de query utilizada para relacionar colaboradores e gerentes:

```sql
use azure_company;

SELECT  
    CONCAT(e.Fname, ' ', e.Lname) AS Colaborador_Nome_Completo,
    CONCAT(m.Fname, ' ', m.Lname) AS Gerente_Nome_Completo
FROM employee e
LEFT JOIN employee m
    ON e.Super_ssn = m.Ssn;
```
## 📊 Dashboard Final  

O dashboard final apresenta uma análise do relacionamento entre **salários** e **horas trabalhadas**, utilizando gráficos de dispersão e indicadores gerenciais criados no **Power BI**.  

📸 **Print do Dashboard:**  
> <img width="1292" height="723" alt="Image" src="https://github.com/user-attachments/assets/80d7721c-cc38-4fd3-afb2-4dd77d074938" />

🔗 **Link de Publicação:**  
> [*(Publicação - Power BI Service)*  ](https://app.powerbi.com/view?r=eyJrIjoiNTk4ZGJjYjYtYTdiNC00M2FhLTgyZjktNTZmNDc3MmQ0ZWNlIiwidCI6IjI2YmYyOTYxLWM4NGQtNDg2Zi1hYWJiLTQxZGQwMzkwYTRiOCJ9)

---

## 📚 Aprendizados Principais  

- Correção e adaptação de scripts SQL para execução no ambiente Azure.  
- Criação de relacionamentos hierárquicos entre colaboradores e gerentes.  
- Compreensão prática do processo de ETL e das transformações no Power Query.  
- Integração entre Azure, MySQL e Power BI para análise de dados corporativos.  

---

## 💬 Entre em Contato  

<div align="left">
  <a href="https://www.linkedin.com/in/lucaspimentabarretto/" target="_blank">
    <img src="https://cdn-icons-png.flaticon.com/512/174/174857.png" width="20"/>  
    linkedin.com/in/lucaspimentabarretto/
  </a>
</div>

---

🧑‍💻 **Autor:** Lucas Pimenta Barretto  
📘 **Bootcamp:** Klabin - Excel e Power BI Dashboards (DIO)  
📅 **Ano:** 2025

