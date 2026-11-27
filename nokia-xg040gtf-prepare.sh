#!/bin/sh
# Prepare feeds + .config for nokia-xg040gtf-immortalwrt (XG-040G-TF UBI)
set -e
cd "$(dirname "$0")"
./scripts/feeds update -a
# use sbwml mosdns/luci-app-mosdns/v2ray-geodata instead of feed copies
rm -rf feeds/packages/net/mosdns feeds/packages/net/v2ray-geodata \
       package/feeds/packages/mosdns package/feeds/packages/v2ray-geodata
[ -d package/mosdns/.git ] || git clone -b v5 https://github.com/sbwml/luci-app-mosdns package/mosdns
git -C package/mosdns checkout -q a8a6caffe04167dbb17407a63463eb4ce7243873
git -C package/mosdns apply --check ../../nokia-xg040gtf/luci-app-mosdns-wan-plus-local-dns.patch 2>/dev/null && \
	git -C package/mosdns apply ../../nokia-xg040gtf/luci-app-mosdns-wan-plus-local-dns.patch
[ -d package/v2ray-geodata/.git ] || git clone --depth 1 https://github.com/sbwml/v2ray-geodata package/v2ray-geodata
./scripts/feeds install -a
./scripts/kconfig.pl + configs/an7581.config configs/release.config > .config.tmp
./scripts/kconfig.pl + .config.tmp configs/nokia-xg040gtf.config > .config
rm -f .config.tmp
make defconfig
