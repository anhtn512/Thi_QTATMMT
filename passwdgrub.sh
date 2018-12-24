grub-md5-crypt
read -p "patse pass copy o tren: " passgrub
sed -i "s|timeout=5|timeout=5\npassword --md5 $passgrub|" /boot/grub/grub.conf
echo "Done!!!"