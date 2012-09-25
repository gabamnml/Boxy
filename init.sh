#!/bin/bash
clear
while true
do
echo " "
echo "                         *************************************"
echo "                         *                                   *"
echo "                         *    Admin Console for VirtualBox   *"
echo "                         *    Version 1.0                    *"
echo "                         *                                   *"
echo "                         *************************************"
echo ""
echo "1)  List of VM's"
echo "2)  Show Run VM's"
echo "3)  Open UI Administration"
echo "4)  Host Information"
echo "5)  VM Information"
echo "6)  Up VM"
echo "7)  Shutdown VM"
echo "8)  Create VM"
echo "9)  Delete VM"
echo "10) Exit"
echo ""
read -p "Select Option: " opcion
case $opcion in
1) clear
echo "List of VM's:"
echo ""
VBoxManage list vms ;;
2) clear
echo "Run VM's:"
echo ""
VBoxManage list  runningvms 
echo ""
echo "Used Memory:"
echo ""
SO=`uname`
if [ "Darwin" = "$SO" ]; then
               open /Applications/Utilities/Activity\ Monitor.app
            else
               free -m
            fi;;
3) clear
virtualbox &;;
4) clear
VBoxManage list hostinfo ;;
5)clear
echo "List of VM"
echo ""
VBoxManage list vms
echo ""
read -p "Enter VM to show: " vminforst
VBoxManage showvminfo $vminforst | grep VRDE
echo ""
VBoxManage showvminfo $vminforst;; 
6) clear
echo "Available VM's"
echo ""
VBoxManage list vms
echo ""
read -p "Enter Name of VM:" namevm
SO=`uname`
if [ "Darwin" = "$SO" ]; then
            VBoxManage startvm $namevm -type headless
            else
read -p "Enter Port (3389-xxxx):" puerto
            VBoxHeadless -startvm $namevm -p $puerto &
            fi;;
7) clear
echo "Runing VM's"
echo ""
VBoxManage list runningvms
echo ""
read -p "Enter Name of VM:" closevm
VBoxManage controlvm $closevm poweroff;;
8)clear
echo ""
read -p "Name of new VM: " vmnew
read -p "Size Hard Drive (MB): " hdnew
read -p "Path of Hard Drive: " pathhd
echo "S.O. Availables : "
echo ""
vboxmanage list ostypes | more
read -p "Operation System: " typeos
read -p "Memory RAM (MB): " ram
read -p "Path location of image (ex: /home/user/so.iso) : " path
read -p "Port VM (3389-xxxx): " puerto2
VBoxManage createvm -name $vmnew -ostype $typeos -register
VBoxManage createhd -filename $vmnew.vdi -size $hdnew -format VDI
VBoxManage storagectl $vmnew --name "SATA Controller" --add sata --controller IntelAhci
VBoxManage storageattach "$vmnew" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium $vmnew.vdi
VBoxManage modifyvm $vmnew --memory $ram
VBoxManage storagectl $vmnew --name "IDE Controller" --add ide --controller PIIX4
VBoxManage storageattach $vmnew --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium $path
VBoxManage modifyvm $vmnew --vrde on
VBoxManage modifyvm $vmnew --vrdemulticon on --vrdeport $puerto2
VBoxManage modifyvm $vmnew --boot1 dvd
VBoxManage showvminfo $vmnew | grep VRDE;;
9)clear
echo "Delete Process"
echo ""
VBoxManage list vms
echo ""
read -p "VM to Delete :" deletevm
VBoxManage storagectl $deletevm --name "SATA Controller" --remove
VBoxManage unregistervm $deletevm --delete
VBoxManage closemedium disk $deletevm.vdi --delete
echo ""
VBoxManage list vms;;
10) clear
echo "Bye!"
break;;
*) echo "Only Options 1 to 7";;
esac
done
exit 0 
