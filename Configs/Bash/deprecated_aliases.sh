alias checkvpn='until ping -c1 173.226.206.206 >/dev/null 2>&1; do sleep 5 ; done'
alias desktop='ssh mcarruth@192.168.40.11'
alias qemu='make && ./provision.sh -X -i images -q -S -c && cinderblock -i provision -Q host/usr/bin/qemu-system-ppc'
alias ungron="gron --ungron"
alias vauth='vault auth -method=ldap username=$USER'
alias vssh='vault ssh -role otp_key_role'

