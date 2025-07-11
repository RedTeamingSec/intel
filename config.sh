#!/bin/bash
echo "Mulai Install"
wget --no-check-certificate -c -i https://www.x.org/pub/individual/driver/xf86-input-libinput-1.2.1.tar.xz
tar -xf xf86-input-libinput-1.2.1.tar.xz
cd xf86-input-libinput-1.2.1
./configure $XORG_CONFIG &&
make
make install

wget --no-check-certificate -c -i https://www.x.org/pub/individual/driver/xf86-input-synaptics-1.9.2.tar.xz
tar -xf xf86-input-synaptics-1.9.2.tar.xz
cd xf86-input-synaptics-1.9.2
./configure $XORG_CONFIG &&
make
make install

wget --no-check-certificate -c -i https://anduin.linuxfromscratch.org/BLFS/xf86-video-intel/xf86-video-intel-20210222.tar.xz
tar -xf xf86-video-intel-20210222.tar.xz
cd xf86-video-intel-20210222
./autogen.sh $XORG_CONFIG     \
            --enable-kms-only \
            --enable-uxa      \
            --mandir=/usr/share/man &&
make
make install &&

mv -v /usr/share/man/man4/intel-virtual-output.4 \
      /usr/share/man/man1/intel-virtual-output.1 &&

sed -i '/\.TH/s/4/1/' /usr/share/man/man1/intel-virtual-output.1

cat >> /etc/X11/xorg.conf.d/20-intel.conf << "EOF"
Section   "Device"
        Identifier "Intel Graphics"
        Driver     "intel"
        #Option     "DRI" "2"            # DRI3 is default
        #Option     "AccelMethod"  "sna" # default
        #Option     "AccelMethod"  "uxa" # fallback
EndSection
EOF
