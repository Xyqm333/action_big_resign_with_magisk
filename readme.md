## noavb(v2/v3)

|                                               | android 9                                                    | android 10(+)                                                |
| --------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| ums312/ums512/ud710 (not-fused or public key) | splloader+uboot+sml+trustos+vbmeta                           | splloader+uboot+sml+trustos+teecfg+vbmeta                    |
| ums312/ums512/ud710 (fused)                   | uboot+sml+trustos+vbmeta<br />see note for splloader information | uboot+sml+trustos+teecfg+vbmeta<br />see note for splloader information |
| other cpu (not-fused or public key)           | splloader+uboot+sml+trustos+vbmeta                           | splloader+uboot+sml+trustos+teecfg+vbmeta                    |
| other cpu (fused)                             | UNSUPPORTED                                                  | UNSUPPORTED                                                  |

## resign(v2/v3)

This method works with both unlocked and locked BL, but wiping userdata might be still needed. (vmbeta change will affect data encryption)

|                                               | android 9                                                    | android 10(+)                                                | android 14(+) / kernel 5.15(+)                               |
| --------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| ums312/ums512/ud710 (not-fused or public key) | splloader+uboot+sml+trustos+vbmeta+(boot)+(recovery)         | splloader+uboot+sml+trustos+teecfg+vbmeta+(boot)+(recovery)  | splloader+uboot+sml+trustos+teecfg+vbmeta+(init_boot)+(boot)+(recovery) |
| ums312/ums512/ud710 (fused)                   | uboot+sml+trustos+vbmeta+(boot)+(recovery)<br />see note for splloader information | uboot+sml+trustos+teecfg+vbmeta+(boot)+(recovery)<br />see note for splloader information | uboot+sml+trustos+teecfg+vbmeta+(init_boot)+(boot)+(recovery)<br />see note for splloader information |
| other cpu (not-fused or public key)           | splloader+uboot+sml+trustos+vbmeta+(boot)+(recovery)         | splloader+uboot+sml+trustos+teecfg+vbmeta+(boot)+(recovery)  | splloader+uboot+sml+trustos+teecfg+vbmeta+(init_boot)+(boot)+(recovery) |
| other cpu (fused)                             | UNSUPPORTED                                                  | UNSUPPORTED                                                  | UNSUPPORTED                                                  |

#### Note for ums312/ums512/ud710 (fused)：

​	on android 9/10, use gen_spl-unlock-legacy ([source_code](https://raw.githubusercontent.com/TomKing062/CVE-2022-38694_unlock_bootloader/info/gen_spl-unlock-legacy.c)|[windows_prebuilt](https://github.com/TomKing062/spreadtrum_flash/releases/latest)) to get patched splloader, then process with [CVE-2022-38691](https://github.com/TomKing062/CVE-2022-38691_38692)

​	on android 11(+), use gen_spl-unlock ([source_code](https://raw.githubusercontent.com/TomKing062/CVE-2022-38694_unlock_bootloader/info/gen_spl-unlock.c)|[windows_prebuilt](https://github.com/TomKing062/spreadtrum_flash/releases/latest)) to get patched splloader, then process with [CVE-2022-38691](https://github.com/TomKing062/CVE-2022-38691_38692)

#### Note for ums9230/ums9620/ums9621：

​	use noavb_v3/resign_v3

#### Note for android 9：

​	if resign in main branch not work for you, try use resign in a9_boot_with_recovery_cpio branch
  <img width="1645" height="627" alt="image" src="https://github.com/user-attachments/assets/c28f37b6-e044-44f2-b0e7-7ce29e541501" />

