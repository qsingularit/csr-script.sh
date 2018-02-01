#!/bin/bash
# Description : Script to automate bulk script CSR and KEY generation for different domains.
#
# You might need to install additional tool:
#
#sudo apt-get install expect
#
#Or on Red Hat based systems like CentOS:
#
#sudo yum install expect
#
#
# Script variables live here.

######  ---->>> Start EDIT HERE: <<<----  #######
#												#
#												#
	 Country_Name="US"
	 State_or_Province_Name="New_York"
	 Locality_Name="New_York"
	 Organization_Name="COMANYNAME"
	 Organizational_Unit_Name="IT"
	 Email_Address="it@COMPANYNAME.com"
#												#
#												#
######  ---->>> Stop EDIT HERE: <<<----  ########

#
#
#
#
# Script's variable. DO NOT EDIT.	
workdir=$(pwd)
Common_Name=$2

# Verification of user input

if [ "$#" -eq "0" ]
	then
		echo -ne '\nError. Please check your input and try again. \n\n'
        echo -ne '\tOpen the script with any editor and adjust your variables first.\n\n'
		echo -ne "\tUsage: '/.csr-gen.sh [wild|single] common_name' \n\n"
		echo -ne 'You will find new folder named by domain with CSR and KEY in it\n\n'
    
		exit 1
    else

	mkdir -p $2 && cd $2 &&
	
	if [ "$1" == "wild" ]
		then
			req_name="wild.$2"
			req_com_name="*.$2"
		else
			req_name=$2
			req_com_name=$2
	fi
	
	openssl genrsa -out $req_name.key 2048 &&
	 expect <<EOF
		spawn openssl req -new -key "$req_name.key" -out "$req_name.csr"
		expect -re {Country Name \(2 letter code\) [^:]*:} {send "$Country_Name\r"}
		expect -re {State or Province Name \(full name\) [^:]*:} {send "$State_or_Province_Name\n"}
		expect -re {Locality Name \(eg, city\) [^:]*:} {send "$Locality_Name\n"}
		expect -re {Organization Name \(eg, company\) [^:]*:} {send "$Organization_Name\n"}
		expect -re {Organizational Unit Name \(eg, section\) [^:]*:} {send "$Organizational_Unit_Name\n"}
		expect -re {Common Name \(eg, your name or your server\'s hostname\) [^:]*:} {send "$req_com_name\n"}
		expect -re {Email Address [^:]*:} {send "$Email_Address\n"}
		expect -re {A challenge password [^:]*:} {send "\r"}
		expect -re {An optional company name [^:]*:} {send "\r"}
		expect eof
EOF
	
fi &&

echo 'All set!' 
echo -en "You will find your files here $workdir/$2 \n\r" &&

exit 0
