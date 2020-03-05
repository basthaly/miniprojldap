#!/bin/bash

ecrireEntree() {
	NOM=$(echo $1|tr '[:upper:]' '[:lower:]')
	COMPTEUR=$2
	PRENOM=$(echo $3|tr '[:upper:]' '[:lower:]')
	#echo "$COMPTEUR"
	MYUID=${PRENOM:0:3}${NOM:0:8}
	#echo $MYUID
	SSHA="{SSHA}"
	echo  "dn: uid=${MYUID},ou=etudiants,ou=personnes,dc=iutbeziers,dc=fr"
	echo  "objectClass: inetOrgPerson"
	echo  "objectClass: person"
	echo  "objectClass: organizationalPerson"
	echo  "objectClass: posixAccount"
	echo  "objectClass: shadowAccount"
	echo  "objectClass: top"
	echo  "cn: ${PRENOM}.${NOM}"
	echo  "sn: ${PRENOM}"
	echo  "givenName: ${NOM}"
	echo  "uid: ${MYUID}"
	echo  "uidNumber: ${COMPTEUR}"
	echo  "gidNumber: ${COMPTEUR}"
	echo  "homeDirectory: /home/${MYUID}"
	echo  "loginShell: /bin/bash"
	echo  "shadowExpire: 0"
	echo  "userPassword: ${SSHA}RWK9BASh/NsGzi0k4XLRm1Xt1DoEceJvtB1h1w=="
	echo -e  "mail: ${PRENOM}.${NOM}@iutbeziers.fr\n"
}

> annuaire.ldif

nbr=$(wc -l liste_tous.csv | cut -d " " -f1)
for i in `seq 1 $nbr`; do
	client=$(cat ./liste_tous.csv | tr '\n' '|' | cut -d '|' -f$i)
	prenom=$(echo $client | cut -d ";" -f1 | cut -d " " -f3-)
	nom=$(echo $client | cut -d ";" -f1 | cut -d " " -f2)
	ecrireEntree "$nom" "$i" "$prenom" >> annuaire.ldif
done