mkdir work
busybox unzip -oq original.zip -d work
mkdir -p boot/zzz
mkdir -p vbmeta/keys
mkdir output
tar xzvf avbtool.tgz -C vbmeta/
mv work/vbmeta* vbmeta/keys/vbmeta.img
busybox unzip -oq magisk.apk -d boot/zzz
mv main/boot_patch.sh boot/
mv main/sign_avb.sh vbmeta/
git clone https://github.com/TomKing062/vendor_sprd_proprietories-source_packimage.git
cp -a vendor_sprd_proprietories-source_packimage/sign_image/v3/prebuilt/* work/
cp -a main/config work/
if [ -d extra_key ]; then cp -f extra_key/* work/config/; fi
cp vendor_sprd_proprietories-source_packimage/sign_image/v3/sign_image_v3.sh work/
gcc -o work/get-raw-image vendor_sprd_proprietories-source_packimage/sign_image/get-raw-image.c
chmod +x work/*
cd vendor_sprd_proprietories-source_packimage/sign_vbmeta
make
chmod +x generate_sign_script_for_vbmeta
cp generate_sign_script_for_vbmeta ../../vbmeta/keys/
cd ../../vbmeta/keys/
./generate_sign_script_for_vbmeta vbmeta.img
mv sign_vbmeta.sh ../
mv padding.py ../
cd ../..
cp work/config/rsa4096_vbmeta.pem vbmeta/
chmod +x vbmeta/*
sudo rm -f /usr/bin/python /usr/bin/python3.6 /usr/bin/python3.6m /usr/local/bin/python
sudo ln -sf /usr/bin/python2.7 /usr/bin/python
cd work

if [ -f "splloader.bin" ]; then
    ./get-raw-image "splloader.bin"
    RETVAL=$?
    if [ $RETVAL -eq 0 ]; then
        mv splloader.bin u-boot-spl-16k.bin
    else
        exit 1
    fi
fi

if [ -f "u-boot-spl-16k-sign.bin" ]; then
    ./get-raw-image "u-boot-spl-16k-sign.bin"
    RETVAL=$?
    if [ $RETVAL -eq 0 ]; then
        mv u-boot-spl-16k-sign.bin u-boot-spl-16k.bin
    else
        exit 1
    fi
fi

if [ -f "u-boot-spl-16k-emmc-sign.bin" ]; then
    ./get-raw-image "u-boot-spl-16k-emmc-sign.bin"
    RETVAL=$?
    if [ $RETVAL -eq 0 ]; then
        mv u-boot-spl-16k-emmc-sign.bin u-boot-spl-16k-emmc.bin
    else
        exit 1
    fi
fi

if [ -f "u-boot-spl-16k-ufs-sign.bin" ]; then
    ./get-raw-image "u-boot-spl-16k-ufs-sign.bin"
    RETVAL=$?
    if [ $RETVAL -eq 0 ]; then
        mv u-boot-spl-16k-ufs-sign.bin u-boot-spl-16k-ufs.bin
    else
        exit 1
    fi
fi

if [ -f "uboot.bin" ]; then
    ./get-raw-image "uboot.bin"
    RETVAL=$?
    if [ $RETVAL -eq 0 ]; then
        mv uboot.bin u-boot.bin
    else
        exit 1
    fi
fi

if [ -f "sml.bin" ]; then
    ./get-raw-image "sml.bin"
    RETVAL=$?
    if [ $RETVAL -ne 0 ]; then
        exit 1
    fi
fi

if [ -f "tos.bin" ]; then
    ./get-raw-image "tos.bin"
    RETVAL=$?
    if [ $RETVAL -ne 0 ]; then
        exit 1
    fi
elif [ -f "trustos.bin" ]; then
    ./get-raw-image "trustos.bin"
    RETVAL=$?
    if [ $RETVAL -eq 0 ]; then
        mv "trustos.bin" "tos.bin"
    else
        exit 1
    fi
fi

./get-raw-image "teecfg.bin"
RETVAL=$?
if [ $RETVAL -ne 0 ]; then
    rm teecfg.bin
fi

cd ..

mv work/init_boot* boot/boot.img
RETVAL=$?
if [ $RETVAL -eq 0 ]; then
    cp work/config/rsa4096_init_boot.pem vbmeta/rsa4096_init_boot.pem
    cp -f work/config/rsa4096_init_boot_pub.bin vbmeta/keys/rsa4096_init_boot_pub.bin
    cd boot
    ./boot_patch.sh
    cd ../vbmeta
    ./sign_avb.sh init_boot ../boot/boot.img ../boot/patched.img
    cp ../boot/patched.img ../output/init_boot.img
    cd ..
fi

mv work/boot* boot/boot_real.img
RETVAL=$?
if [ $RETVAL -eq 0 ]; then
    cp work/config/rsa4096_boot.pem vbmeta/rsa4096_boot.pem
    cp -f work/config/rsa4096_boot_pub.bin vbmeta/keys/rsa4096_boot_pub.bin
    if [ -f output/init_boot.img ]; then
        cd vbmeta
        ./sign_avb.sh boot ../boot/boot_real.img ../boot/boot_real.img
        cp ../boot/boot_real.img ../output/boot.img
    else
        cd boot
	cp -f boot_real.img boot.img
        ./boot_patch.sh
        cd ../vbmeta
        ./sign_avb.sh boot ../boot/boot.img ../boot/patched.img
        cp ../boot/patched.img ../output/boot.img
    fi
    cd ..
fi

mkdir dtbo
mv work/dtbo* dtbo/dtbo.img
RETVAL=$?
if [ $RETVAL -eq 0 ]; then
    cp work/config/rsa4096_boot.pem vbmeta/rsa4096_dtbo.pem
    cp -f work/config/rsa4096_boot_pub.bin vbmeta/keys/rsa4096_dtbo_pub.bin
    cd vbmeta
    ./sign_avb.sh dtbo ../dtbo/dtbo.img ../dtbo/dtbo.img
    cp ../dtbo/dtbo.img ../output/dtbo.img
    cd ..
fi

mkdir dtb
mv work/dtb* dtb/dtb.img
RETVAL=$?
if [ $RETVAL -eq 0 ]; then
    cp work/config/rsa4096_boot.pem vbmeta/rsa4096_dtb.pem
    cp -f work/config/rsa4096_boot_pub.bin vbmeta/keys/rsa4096_dtb_pub.bin
    cd vbmeta
    ./sign_avb.sh dtb ../dtb/dtb.img ../dtb/dtb.img
    cp ../dtb/dtb.img ../output/dtb.img
    cd ..
fi

mkdir recovery
mv work/recovery* recovery/recovery.img
RETVAL=$?
if [ $RETVAL -eq 0 ]; then
    cp work/config/rsa4096_recovery.pem vbmeta/
    cp -f work/config/rsa4096_recovery_pub.bin vbmeta/keys/
    cd vbmeta
    ./sign_avb.sh recovery ../recovery/recovery.img ../recovery/recovery.img
    cp ../recovery/recovery.img ../output/recovery.img
    cd ..
fi

cd vbmeta
./sign_vbmeta.sh
python padding.py
cp vbmeta-sign-custom.img ../output/vbmeta.img

cd ../work
./sign_image_v3.sh
cp *-sign.bin ../output/
cd ..
zip -r -v resigned.zip output
