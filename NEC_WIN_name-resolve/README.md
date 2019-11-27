# Ansible Role: Windows\NEC\_WIN\_name-resolve
=======================================================

## Description
このロールは、windows server 2016の名前解決を設定するために使用されます。

## Supports  
- 管理マシン(Ansibleサーバ)  
 * Linux系OS（RHEL）  
 * Ansible バージョン 2.4 以上  
 * Python バージョン 2.7  
- 管理対象マシン
 * Windows Server 2016

## Requirements
- 管理マシン(Ansibleサーバ)
 * Ansibleホストは管理対象マシントへPowershell接続できる必要がある。
- 管理対象マシン
 * Windows Server 2016
 * Powershell3.0+

## Role Variables
Role の変数値について説明します。

### Mandatory variables
~~~
　  * VAR_NEC_name_resolve_hosts:  # （あるいはVAR_NEC_WIN_name_resolve_hosts）hostsファイルに設定する情報を設定する。※子項目は繰り返して設定できる。
　      - ip:                      # IPアドレス(IPv6非対応)  
　        hostname:                # ホストネームを指定する。
　  * VAR_NEC_name_resolve_dns:    # （あるいはVAR_NEC_WIN_name_resolve_dns）DNSサーバに関する情報を設定する。※子項目は繰り返して設定できる。
　      - servers:                 # DNSサーバのIPを指定する。複数のDNSサーバを設定できる。
　        suffix                   # DNSサフィックス
~~~

### Optional variables

~~~
　  * VAR_NEC_name_resolve_dns:    # （あるいはVAR_NEC_WIN_name_resolve_dns）DNSサーバに関する情報を設定する。※子項目は繰り返して設定できる。
　      - nic_name:                # NIC名を設定する。設定しない場合、Find-NetRouteでserversのプライマリDNSサーバのIPにより自動的に取得する。 
~~~

## Dependencies

特にありません。

## Usage

1. 本Roleを用いたPlaybookを作成します。
2. 変数を必要に応じて指定します。
3. Playbookを実行します。

## Example Playbook

名前解決を設定する場合は、提供した以下のRoleを"roles"ディレクトリ配置したうえで、
以下のようなPlaybookを作成してください。

- フォルダ構成
~~~
 - playbook
　  │── hosts/
　  │── roles/
　  │    └── Windows/
　  │          └── NEC_WIN_name-resolve
　  │                │── defaults
　  │                │       main.yml
　  │                │── tasks
　  │                │       main.yml
　  │                │       modify.yml
　  │                └─ README.md
　  └─ win_name_resolve.yml
~~~

- マスターPlaybook サンプル[win\_name\_resolve.yml]
~~~
#win_name_resolve.yml
　  - name: Windows NameResolve  playbook
　    hosts: win
　    gather_facts: false
　    roles:
　      - role: Windows/NEC_WIN_name-resolve
　        VAR_NEC_name_resolve_hosts:
　          - ip: '192.168.127.10'
　            hostname: 'target10'
　          - ip: '192.168.127.20'
　            hostname: 'target20'
　        VAR_NEC_name_resolve_dns:
　          - servers:
　              - '172.28.181.10'
　              - '192.168.127.1'
　            suffix: 'test1.com'
　          - nic_name： Ethernet0
　            servers:
　              - '169.254.27.5'
　              - '127.0.1.1'
　            suffix: 'localdomain'
　        tags:
　          - NEC_WIN_name-resolve
~~~

## Running Playbook

- 名前解決を設定する時、以下のように実行します。

~~~sh
> ansible-playbook win_name_resolve.yml
~~~

## Evidence Description

エビデンス収集場合は、以下のようなEvidence収集用のPlaybookを作成してください。  

- エビデンスplaybook サンプル[win\_name\_resolve_evidence.yml]
~~~
　---
　  - hosts: win
　    roles:
　      - role: gathering
　        VAR_gathering_definition_role_path: "roles/Windows/NEC_WIN_name-resolve"
~~~

- マスターPlaybookにエビデンスコマンド追加 サンプル[win\_name\_resolve.yml]
~~~
　---
　  - import_playbook: win_name_resolve_evidence.yml VAR_gathering_label=before
　  - name: Windows NameResolve playbook
　    hosts: win
　    gather_facts:  true
　    roles:
　      - role: Windows/NEC_WIN_name-resolve
　        VAR_NEC_name_resolve_hosts:
　          - ip: '192.168.127.10'
　            hostname: 'target10'
　          - ip: '192.168.127.20'
　            hostname: 'target20'
　        VAR_NEC_name_resolve_dns:
　          - servers:
　              - '172.28.181.10'
　              - '192.168.127.1'
　            suffix: 'test1.com'
　        tags:
　          - NEC_WIN_name-resolve
　  - import_playbook: win_name_resolve_evidence.yml VAR_gathering_label=after
~~~

- エビデンス収集結果一覧
~~~
#エビデンス構成
.
└── 管理対象マシンIPアドレス
　    ├── command
　    │   ├── 0                                      #　管理対象マシンのNIC情報
　    │   ├── 1                                      #　DNSサーバのIP設定情報
　    │   ├── 2                                      #　DNSサーバのsuffix設定情報
　    │   └── results.json                           #　各コマンドの情報を格納するJSONファイル
　    ├── file
　    │   └── C:
　    │       └── Windows
　    │           └── System32
　    │               └── drivers
　    │                   └── etc
　    │                       └── hosts              #　hosts関連の配置ファイル
　    └── registry
　        └── HKLM
　            └── SYSTEM
　                └── ControlSet002
　                    └── Services
　                        └── Tcpip
　                            └── Parameters
　                                └── Interfaces
　                                    └── export.reg # DNSサーバのIP設定関連のレジストリ情報
~~~

## License

## Copyright

Copyright (c) 2017-2018 NEC Corporation

## Author Information

NEC Corporation
