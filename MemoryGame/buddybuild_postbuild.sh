echo "Uploading IPAs and dSYMs to Crashlytics"

CRASHLYTICS_API_KEY="eb9ffa7e0ff37394ba43349359acbe1c79be66b8 eccb19e5cc96a214abff0bfa444d95d19ca722ca925a7ff30ffd9018f8cd74bc"
echo "Uploading to Fabric via command line"  
$BUDDYBUILD_WORKSPACE/Pods/Fabric/upload-symbols -a $CRASHLYTICS_API_KEY -p ios $BUDDYBUILD_PRODUCT_DIR
