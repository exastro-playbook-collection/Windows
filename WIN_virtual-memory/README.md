# Ansible Role: Windows\WIN\_virtual-memory
=======================================================

## Description
このロールは、Windowsサーバ2016上に仮想メモリを設定するために使用されます。

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
　  * VAR_WIN_virtual_memory: 
　        drive: 'c'   # pagefile path
　        type:        # タイプ
　                     # パラメータ: custom \ auto \none \system。パラメータはカスタムで、sizeパラメータは有効です。
　        size:        # 仮想メモリサイズ
　          min:       # 初期サイズ（MB）
　          max:       # 最大サイズ（MB）
　  * VAR_WIN_virtual_memory_reboot: false    # 再起動するかどうか true/false(デフォルト値)
~~~

### Optional variables

特にありません。

## Dependencies

Ansible Role: Windows\WIN\_reboot。

## Usage

1. 本Roleを用いたPlaybookを作成します。
2. 変数を必要に応じて指定します。
3. Playbookを実行します。

## Example Playbook

仮想メモリを設定する場合は、提供した以下のRoleを"roles"ディレクトリ配置したうえで、
以下のようなPlaybookを作成してください。

- フォルダ構成
~~~
 - playbook
　  │── hosts/
　  │── roles/
　  │    └── Windows/
　  │          └── WIN_virtual-memory
　  │                │── defaults
　  │                │       main.yml
　  │                │── meta
　  │                │       main.yml
　  │                │── tasks
　  │                │       main.yml
　  │                │       pre_check.yml
　  │                │       modify.yml
　  │                │       post_check.yml
　  │                └─ README.md
　  └─ win_virtual_memory.yml
~~~

- マスターPlaybook サンプル[win_virtual\_memory.yml]
~~~
#win_virtual_memory.yml
　  - name: Windows_virtual_memory
　    hosts: win
　    gather_facts: false
　    roles:
　      - role: Windows/WIN_virtual-memory
　        VAR_WIN_virtual_memory:
　          drive: 'c'
　          # type: 'system' 
　          type: 'auto' 
　          size:
　            min: 400 
　            max: 1024 
　        VAR_WIN_virtual_memory_reboot: false
　        tag:
　          -Windows_virtual_memory
　    post_tasks:
　      - name: Run reboot command
　        win_reboot:
　        when: WIN_reboot_required == true
　      - set_fact:
　            WIN_reboot_required: false
~~~

## Running Playbook

- 本roleのみを実行する場合は

~~~sh
> ansible-playbook win_virtua_memory.yml
~~~

## Evidence Description

エビデンス収集場合は、以下のようなEvidence収集用のPlaybookを作成してください。  

- エビデンスplaybook サンプル[win_virtual\_memory\_evidence.yml]
~~~
　---
　  - hosts: win
　    roles:
　      - role: gathering
　        VAR_gathering_definition_role_path: "roles/Windows/WIN_virtual-memory"
~~~

- マスターPlaybookにエビデンスコマンド追加 サンプル[win\_virtual\_memory.yml]
~~~
　---	
　  - import_playbook: win_virtual_memory_evidence.yml VAR_gathering_label=before
　  - name: Windows_virtual_memory
　    hosts: win
　    gather_facts: false
　    roles:
　      - role: Windows/WIN_virtual-memory
　        VAR_WIN_virtual_memory:
　          drive: 'c'
　          # type: 'system' 
　          type: 'auto' 
　          size:
　              min: 400 
　              max: 1024 
　        VAR_WIN_virtual_memory_reboot: false
　        tag:
　          -Windows_virtual_memory
　    post_tasks:
　      - name: Run reboot command
　        win_reboot:
　        when: WIN_reboot_required == true
　      - set_fact:
　            WIN_reboot_required: false
　  - import_playbook: win_virtual_memory_evidence.yml VAR_gathering_label=after
~~~

- エビデンス収集結果一覧
~~~
#エビデンス構成
.
└── 管理対象マシンIPアドレス
　    ├── command
　    │   ├── 0               # 管理対象マシンの仮想メモリ情報
　    │   ├── 1               # 管理対象マシンの起動時間
　    │   └── results.json    # 各コマンドの情報を格納するJSONファイル
　    └── registry
　        └── HKLM
　            └── SYSTEM
　                └── CurrentControlSet
　                    └── Control
　                        └── Session\ Manager
　                            └── Memory\ Management  # 仮想メモリ情報のレジストリ情報
　                                └── export.reg
~~~

## License

## Copyright

Copyright (c) 2017-2018 NEC Corporation

## Author Information

NEC Corporation
