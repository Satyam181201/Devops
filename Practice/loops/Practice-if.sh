#!/bin/bash

n=1

if [ "$n" -ge 5 ]; then
	echo "Bigger"
elif [ "$n" -eq 10 ] ; then
	echo "Same value : $n" 
else 
	echo "other value"
fi


name="Satyam"

if [ "$name" = "satyam" ]; then
	echo "Different Value"
elif [ "$name" = "Satyam" ]; then
	echo "Same value"
else 
	echo "other value"
fi 
