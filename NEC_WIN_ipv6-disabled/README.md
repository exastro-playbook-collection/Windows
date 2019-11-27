# Ansible Role: Windows\NEC\_WIN\_ipv6-disabled
=======================================================

## Description
本ロールは、Windows Server 2016 にIPv6無効化/有効化の設定を行います。

## Supports
- 管理マシン(Ansibleサーバ)
  * Linux系OS（RHEL7）
  * Ansible バージョン 2.7 以上
  * Python バージョン 2.7
  * Jinja2 バージョン 2.10.1
- 管理対象マシン
  * Windows Server 2016

## Requirements
- 管理マシン(Ansibleサーバ)
  * Ansibleサーバは管理対象マシンへPowershell接続できる必要があります。
- 管理対象マシン
  * Windows Server 2016
  * Powershell3.0+

## Role Variables

ロールの変数について説明します。

### Mandatory variables

特にありません。

### Optional variables

~~~
* VAR_NEC_WIN_ipv6Disabled_tunnel:    # レジストリ キーを使用して IPv6 を設定します。（★下記の表を参照すること）
      tunnel: true                    # IPv6コンポーネント Tunnel を設定します。 親項目が定義された場合、設定必須とします。
      tunnel6to4: true                # IPv6コンポーネント Tunnel6to4 を設定します。 親項目が定義された場合、設定必須とします。
      tunnelIsatap: true              # IPv6コンポーネント TunnelIsatap を設定します。 親項目が定義された場合、設定必須とします。
      tunnelTeredo: true              # IPv6コンポーネント TunnelTeredo を設定します。 親項目が定義された場合、設定必須とします。
      native: true                    # IPv6コンポーネント Native を設定します。 親項目が定義された場合、設定必須とします。
      preferIpv4: true                # IPv6コンポーネント PreferIpv4 を設定します。 親項目が定義された場合、設定必須とします。
      tunnelCp: true                  # IPv6コンポーネント TunnelCp を設定します。 親項目が定義された場合、設定必須とします。
      tunnelIpTls: true               # IPv6コンポーネント TunnelIpTls を設定します。 親項目が定義された場合、設定必須とします。
* VAR_NEC_WIN_ipv6Disabled_NICs:      # NIC毎に IPv6無効化を設定します。※子項目は繰り返して設定でき、複数のnicを設定できます。
    - nicName: Ethernet0              # NICの名前を指定します。大小文字を区別しません。
      state: enabled                  # IPv6を無効にします。大小文字を区別しません。値はdisabledとenabled以外、設定不可とします。
* VAR_NEC_WIN_ipv6Disabled_reboot: false    # 管理対象マシンがすぐ再起動するかどうか設定します。 true/false(デフォルト値)
~~~

**★各ビットで制御しているコンポーネント一覧**

| ビット名 | 制御しているコンポーネント | DisabledComponents 値の設定方法 |
|---|---|---|
| Tunnel | トンネル インターフェイスを無効にする | 0000 000**X** |
| Tunnel6to4 | 6to4 インターフェイスを無効にする | 0000 00**X**0 |
| TunnelIsatap | Isatap インターフェイスを無効にする | 0000 0**X**00 |
| TunnelTeredo | Teredo インターフェイスを無効にする | 0000 **X**000 |
| Native | native インターフェイスを無効にする (PPP も同様) | 000**X** 0000 |
| PreferIpv4 | 既定のプレフィックス ポリシーで IPv4 を優先する | 00**X**0 0000 |
| TunnelCp | CP インターフェイスを無効にする | 0**X**00 0000 |
| TunnelIpTls | IP-TLS インターフェイスを無効にする | **X**000 0000 |

**★通常の運用でIPv6機能の無効化に関する設定**

| IPv6機能の無効化 | DisabledComponents 値 |
|---|---|
| IPv6 を無効にする | 11111111 16進：0ｘFF |
| プレフィックス ポリシーで IPv6 よりも IPv4 を優先する | 00100000 16進：0ｘ20   |
| プすべての非トンネル インターフェイスで IPv6 を無効にする | 00010000 16進：0ｘ10   |
| すべてのトンネル インターフェイスで IPv6 を無効にする | 00000001 16進：0ｘ01   |
| 非トンネル インターフェイス (ループバックを除く) </br>および IPv6 トンネル インターフェイスで IPv6 を無効にする | 00010001 16進：0ｘ11   |

## Dependencies

Ansible Role: Windows\NEC\_WIN\_reboot。

## Usage

1. 本Roleを用いたPlaybookを作成します。
2. 変数を必要に応じて設定します。
3. Playbookを実行します。

## Example Playbook

### ■エビデンスを取得しない場合の呼び出す方法

本ロールを"roles"ディレクトリに配置して、以下のようなPlaybookを作成してください。

- フォルダ構成

~~~
 - playbook/
　  │── hosts
　  │── roles/
　  │    └── Windows/
　  │          └── NEC_WIN_ipv6-disabled/
　  │                │── defaults/
　  │                │       main.yml
　  │                │── meta/
　  │                │       main.yml
　  │                │── tasks/
　  │                │       main.yml
　  │                │── vars/
　  │                │       gathering_definition.yml
　  │                └─ README.md
　  └─ win_ipv6Disabled.yml
~~~

- マスターPlaybook サンプル[win\_ipv6Disabled.yml]

~~~
#win_ipv6Disabled.yml
---
- name: Windows NameResolve playbook
  hosts: win
  gather_facts: false
  roles:
    - role: Windows/NEC_WIN_ipv6-disabled
      VAR_NEC_WIN_ipv6Disabled_tunnel:
          tunnel: true
          tunnel6to4: true
          tunnelIsatap: true
          tunnelTeredo: true
          native: true
          preferIpv4: true
          tunnelCp: true
          tunnelIpTls: true
      VAR_NEC_WIN_ipv6Disabled_NICs:
        - nicName: Ethernet0
          state: disabled
        - nicName: Ethernet1
          state: disabled
      VAR_NEC_WIN_ipv6Disabled_reboot: false
      tags:
        - NEC_WIN_ipv6-disabled
  # reboot
  post_tasks:
    - include_role:
          name: NEC_WIN_reboot
      when: NEC_WIN_reboot_required == true
~~~

## Running Playbook

~~~sh
> ansible-playbook win_ipv6Disabled.yml
~~~

### ■エビデンスを取得する場合の呼び出す方法

エビデンスを収集する場合、以下のようなEvidence収集用のPlaybookを作成してください。  

- エビデンスplaybook サンプル[win\_ipv6Disabled\_evidence.yml]

~~~
---
- hosts: win
  roles:
    - role: gathering
      VAR_gathering_definition_role_path: "roles/Windows/NEC_WIN_ipv6-disabled"
~~~

- マスターPlaybookにエビデンスコマンドを追加します。 サンプル[win\_ipv6Disabled.yml]

~~~
---
- import_playbook: win_ipv6Disabled_evidence.yml VAR_gathering_label=before

- name: Windows NameResolve playbook
  hosts: win
  gather_facts: false
  roles:
    - role: Windows/NEC_WIN_ipv6-disabled
      VAR_NEC_WIN_ipv6Disabled_tunnel:
          tunnel: true
          tunnel6to4: true
          tunnelIsatap: true
          tunnelTeredo: true
          native: true
          preferIpv4: true
          tunnelCp: true
          tunnelIpTls: true
      VAR_NEC_WIN_ipv6Disabled_NICs:
        - nicName: Ethernet0
          state: disabled
        - nicName: Ethernet1
          state: disabled
      VAR_NEC_WIN_ipv6Disabled_reboot: false

- import_playbook: win_ipv6Disabled_evidence.yml VAR_gathering_label=after
~~~

- エビデンス収集結果一覧

~~~
#エビデンス構成
.
└── 管理対象マシンIPアドレス
　    ├── command
　    │   ├── 0                                      #　ipv6コンポーネント無効化設定のレジストリ情報
　    │   ├── 1                                      #　ネットワークカード情報
　    │   ├── 2                                      #　NIC毎にipv6プロトコル情報
　    │   └── results.json                           #　各コマンドの情報を格納するJSONファイル
　    └── registry
　        └── HKLM
　            └── SYSTEM
　                └── CurrentControlSet
　                    └── Services
　                        └── Tcpip6
　                            └── Parameters
　                                    └── export.reg # ipv6コンポーネント無効化設定のレジストリ情報
~~~

## License

## Copyright

Copyright (c) 2018-2019 NEC Corporation

## Author Information

NEC Corporation
