#/bin/bash 

PRODUCT="captivate"
OUTDIR="../out/target/product/$PRODUCT"

NOW=$(date +"%Y%m%d")

rm -rf temp/
mkdir temp
mkdir temp/system

echo "Copying /system ..."
cp -R $OUTDIR/system/ temp/

echo "Copying tools for otapackage ..."
cp -R tools/* temp/

echo "Copying zImage ..."
cp ../kernel/samsung/2.6.35/arch/arm/boot/zImage temp/zImage

echo "Copying kernel modules ..."
cp -R ../kernel/samsung/2.6.35/drivers/net/wireless/bcm4329/bcm4329.ko temp/system/modules/

echo "Removing .git files"
find temp/ -name '.git' -exec rm -r {} \;

echo "Compressing otapackage ..."
pushd temp
zip -r ../$OUTDIR/cm7-$PRODUCT-update-unsigned.zip ./
popd

echo "Signing otapackage ..."
java -jar SignApk/signapk.jar SignApk/certificate.pem SignApk/key.pk8 $OUTDIR/cm7-$PRODUCT-update-unsigned.zip $OUTDIR/cm7-$PRODUCT-update-$NOW.zip

rm $OUTDIR/cyanogenmod7-$PRODUCT-update-unsigned.zip
rm -rf temp/
echo "cm7-$PRODUCT.zip is at $OUTDIR"
echo "Done."
