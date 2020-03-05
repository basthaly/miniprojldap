#!/bin/bash

ecrire_Group(){
	GROUPE=$1
	if [ $(echo $GROUPE | cut -c3) = "B" ]; then
		echo "dn: cn=$GROUPE,ou=TDB,ou=groups,dc=iutbeziers,dc=fr"
	else
		echo "dn: cn=$GROUPE,ou=TDA,ou=groups,dc=iutbeziers,dc=fr"
	fi
}

ecrire_member() {
	NOM=$(echo $1|tr '[:upper:]' '[:lower:]')
	COMPTEUR=$2
	PRENOM=$(echo $3|tr '[:upper:]' '[:lower:]')
	GROUPE=$4
	echo "member: uid=$(echo $PRENOM | cut -c1-3)$NOM, ou=etudiants, ou=personnes, dc=iutbeziers, dc=fr "
}

nbr=$(wc -l liste_tous.csv | cut -d " " -f1)
group=$(cat liste_tous.csv | cut -d ";" -f2 | sort -u)
nbr_group=$(echo $group | wc -l)

> groupe.ldif

for j in `seq 1 4`; do
	ecrire_Group "$(echo $group | tr '\n' ' ' | cut -d' ' -f$j)" >> groupe.ldif
	for i in `seq 1 $nbr`; do
		client=$(cat ./liste_tous.csv | tr '\n' '|' | cut -d '|' -f$i)
		groupe=$(echo $client | cut -d ";" -f2)
		if [ "$groupe" = "$(echo $group | tr '\n' ' ' | cut -d' ' -f$j)" ]; then
			prenom=$(echo $client | cut -d ";" -f1 | cut -d " " -f3-)
			nom=$(echo $client | cut -d ";" -f1 | cut -d " " -f2)
			ecrire_member "$nom" "$i" "$prenom" >> groupe.ldif
		fi
	done
	echo "" >> groupe.ldif
done