commit=9a05eaccb7b473b5485b564d559a9236f1071b62
fstest=ntfs-3g-pjd-fstest-8af5670
cd $fstest && git diff --patch --relative $commit -- . >../fstest-darwin.patch
