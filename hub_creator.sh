#!/bin/bash
echo "-------------------------------------------------------"
echo "-------------------------------------------------------"
echo "Hub Creator v0.2  - DV 2.0"
echo "-------------------------------------------------------"
echo "-------------------------------------------------------"
echo ""
echo "Observações : "
echo "    As conexões devem ser criadas via JNDI dentro do PDI pasta /simple-jndi."
echo "    Dentro do banco destino devem ser criados os schemas : "
echo "        dv"
echo "        dm"
echo "        log(opcional)"
echo "    O resultado desse script é uma transformação de hub e um script que deve ser executado no banco ANTES do KTR ser chamado no Kettle."
echo "-------------------------------------------------------"
read -p "Banco de Origem : " OLTPDB  
read -p "Banco de Destino : " EDWDB
read -p "Nome JNDI origem : " OLTP_JNDI
read -p "Nome JNDI DESTINO : " EDW_JNDI
read -p "SCHEMA (ORIGEM) : " OLTP_SCHEME
read -p "TABELA (ORIGEM) : " OLTP_TABLE  
read -p "BUSINESS KEY (ORIGEM) : " OLTP_FIELD
read -p "NOME DO HUB : " H_NAME
read -p "NOME DO SISTEMA (ORIGEM): " SISTEMA
DTA="$(date +'%d/%m/%Y')"
USU_NAME="$USER"
tipe="H_"
underscore="_"
ext=".ktr"
ktr=$tipe$SISTEMA$underscore$OLTP_TABLE$ext
cp H_SISTEMA_OLTP_TABLE.ktr $ktr
sed -i s"|SISTEMA|$SISTEMA|"g $ktr
sed -i s"|H_NAME|$H_NAME|"g $ktr
sed -i s"|ORACLE|$OLTPDB|"g $ktr
sed -i s"|VERTICA|$EDWDB|"g $ktr
sed -i s"|JNDI_OLTP|$OLTP_JNDI|"g $ktr
sed -i s"|JNDI_EDW|$EDW_JNDI|"g $ktr
sed -i s"|OLTP_SCHEME|$OLTP_SCHEME|"g $ktr
sed -i s"|OLTP_TABLE|$OLTP_TABLE|"g $ktr
sed -i s"|OLTP_FIELD|$OLTP_FIELD|"g $ktr
sed -i s"|DTA|$DTA|"g $ktr
sed -i s"|USU_NAME|$USU_NAME|"g $ktr
sed -i s"|EDWDB|$EDWDB|"g $ktr

sql1="CREATE TABLE dv.H_"
sql2=" ( "
sql3=" INTEGER, H_"
sql4="_KEY VARCHAR , H_RSRC VARCHAR , DATETIME_REFRESH TIMESTAMP ) ;"
insert=$sql1$H_NAME$sql2$OLTP_FIELD$sql3$H_NAME$sql4
echo "-------------------------------------------------------"
echo "Script de Insert : "
echo ""
echo $insert
echo ""
echo "Atenção, esse script é apenas um template, se possível encaminhe ao DBA para análise e customização."
echo "A transformação $ktr foi criada com sucesso."
echo "A transformação possui uma configuração de logs com as nomeclaturas de tabela padrão que devem ser incluidas dentro do schema log(caso deseje), "
echo "caso não tenha interesse em criar logs da transformação basta  apagar as variaveis dentro nas configurações da transformação."
