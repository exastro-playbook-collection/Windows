# Ansible Role: Windows\NEC\_WIN\_network-interface
=======================================================
## Description
このロールは、Windows Server 2016のネットワークのインタフェースを変更するために使用されます。

## Supports
- 管理マシン(Ansibleサーバ)
 * Linux系OS（RHEL）
 * Ansible バージョン 2.4 以上
 * Python バージョン 2.7
- 管理対象マシン
 * Windows Server 2016

## Requirements
- 管理マシン(Ansibleサーバ)
 * Ansibleホストは管理対象マシンへPowershell接続できる必要がある。
- 管理対象マシン
 * Windows Server 2016
 * Powershell3.0+

## Role Variables
Role の変数値について説明します。

### Mandatory variables
~~~
　  * VAR_NEC_WIN_network_interface:
　      - name: "Ethernet0"                     #インターフェース名
　        ipaddresses:                          #複数設定できること
　          - ip: "172.28.87.99"                #IPアドレス(IPv6非対応)
　            prefix: 25                        #prefix
　            gateway: "172.28.87.126"          #ゲートウェイ
　        dhcp: false                           #DHCP有効:true/無効:false（デフォルト値）
　        netbios: "dhcp"                       #NetBIOS:enabled/disabled/dhcp（デフォルト値）
　        state: "Up"                           #状態(有効:up（デフォルト値）/無効:disabled)
~~~
### Optional variables

特にありません。

### Dependencies

特にありません。

## Usage

1. 本Roleを用いたPlaybookを作成します。
2. 変数を必要に応じて指定します。
3. Playbookを実行します。

## Example Playbook

インタフェースを変更する場合は、提供した以下のRoleを"roles"ディレクトリ配置したうえで、
以下のようなPlaybookを作成してください。

- フォルダ構成
~~~
 - playbook
　  │── hosts
　  │── roles/
　  │    └── Windows/
　  │          └── NEC_WIN_network-interface
　  │                │── defaults
　  │                │       main.yml
　  │                │── tasks
　  │                │       main.yml
　  │                │       pre_check.yml
　  │                │       pre_check_ipaddresses.yml
　  │                │       modify_1.yml
　  │                │       modify_2.yml
　  │                │       modify_3.yml
　  │                └─ README.md
　  └─ playbook-interface.yml
~~~

- マスターPlaybook サンプル[playbook-interface.yml]
~~~
　 - name: interface setting
　   gather_facts: true
　   hosts: win
　   roles:
　     - role: Windows/NEC_WIN_network-interface
　       become_user: yes
　       VAR_NEC_WIN_network_interface:
　         - name: "Ethernet1"
　           ipaddresses:
　         - ip: "172.28.145.200"
　           prefix: "25"
　           gateway: "172.28.145.254"
　           dhcp: false
　           netbios: "dhcp"
　           state: "Up"
　       tags:
　         - NEC_WIN_network-interface
~~~

## Running Playbook

インタフェースを変更する時、以下のように実行します。

~~~sh
> ansible-playbook playbook-interface.yml
~~~

## Evidence Description

エビデンス収集場合は、以下のようなEvidence収集用のPlaybookを作成してください。

- エビデンスplaybook サンプル[win\_interface\_evidence.yml]
~~~
　---
　  - hosts: win
　  　 roles:
　  　   - role: gathering
　  　     VAR_gathering_definition_role_path: "roles/Windows/NEC_WIN_network-interface"
~~~

- マスターPlaybookにエビデンスコマンド追加 サンプル[playbook-interface.yml]
~~~
　---
　  - import_playbook: win_interface_evidence.yml VAR_gathering_label=before
　  - name: interface setting
　    hosts: win
　    gather_facts: true
　    roles:
　      - role: Windows/NEC_WIN_network-interface
　        become_user: yes
　        VAR_NEC_WIN_network_interface:
　          - name: "Ethernet1"
　      　     ipaddresses:
　          - ip: "192.168.145.200"
　            prefix: 25
　            gateway: "192.168.145.254"
　       　    dhcp: false
　            netbios: "dhcp"
　            state: "up"
　        tags:
　          - NEC_WIN_network-interface
　  - import_playbook: win_interface_evidence.yml VAR_gathering_label=after
~~~

- エビデンス収集結果一覧
~~~
#エビデンス構成
.
└── 管理対象マシンIPアドレス
　  └── command
　       ├── 0            #　ネットワークインタフェース関連情報
　       ├── 1            #　静的なIPアドレス情報
　       ├── 2            #　Gateway設定情報、DHCP有効設定情報1、NetBIOS設定情報
　       ├── 3            #　DHCP有効設定情報2
　       └── results.json #　各コマンドの情報を格納するJSONファイル
~~~

## License

## Copyright

Copyright (c) 2017-2018 NEC Corporation

## Author Information

NEC Corporation
