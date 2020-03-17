# Ansible Role: Windows\WIN\_teaming
=======================================================

## Description
本RoleではWindows Server 2016のチーミングを変更する。

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
注意事項として、パラメータに複数のチームを設定できますが、実装で一つ目のチームのみ処理できます。

### Mandatory variables
~~~
　  * VAR_WIN_teaming:                # チーミング(LBFO)
　      - name: 'team1'                   # チーム名
　        members:                        # 所属する物理NIC
　      - name: 'Ethernet1'               # インターフェース名(設定されない場合、チーム名とする)
　        mode: 'Standby'                 # Actice（デフォルト値）/Standby
~~~

### Optional variables
~~~
　  * VAR_WIN_teaming:                # チーミング(LBFO)
　        mode: 'SwitchIndependent'       # チーミングモード、LACP/Static/SwitchIndependent（デフォルト値）
　        lb_argorithm: 'TransportPorts'  # 負荷分散アルゴリズム、TransportPorts（デフォルト値）/IPAddresses/MacAddresses/HyperVPort/Dynamic
　        interfaces:                     # 所属する論理NIC
　          - name: 'teamnic2'            # インターフェース名
　            vlan_id: 10                 # VLAN ID（デフォルト値は0）
~~~

### Dependencies

特にありません。

## Usage

1. 本Roleを用いたPlaybookを作成します。
2. 変数を必要に応じて指定します。
3. Playbookを実行します。

## Example Playbook

チーミングを変更する場合は、提供した以下のRoleを"roles"ディレクトリ配置したうえで、
以下のようなPlaybookを作成してください。

- フォルダ構成
~~~
 - playbook
　  │── hosts
　  │── roles/
　  │    └── Windows/
　  │          └── WIN_teaming
　  │                │── defaults
　  │                │       main.yml
　  │                │── tasks
　  │                │       main.yml
　  │                │       pre_check.yml
　  │                │       modify.yml
　  │                │       modify_interfaces.yml
　  │                │       modify_members.yml
　  │                │       post_check.yml
　  │                │       post_check_interfaces.yml
　  │                │       post_check_members.yml
　  │                └─ README.md
　  └─ playbook-teaming.yml  
~~~

- マスターPlaybook サンプル[playbook-teaming.yml]
~~~
# playbook-teaming.yml
　  - name: teaming setting 
　    gather_facts: true  
　    hosts: win
　    roles:
　      - role: Windows/WIN_teaming
　        VAR_WIN_teaming:
　          - name: 'team1'
　            mode: 'SwitchIndependent'
　            lb_argorithm: 'TransportPorts'
　            members:
　              - name: 'Ethernet1'
　                mode: 'Standby'
　            interfaces:
　              - name: 'teamnic2'
　                vlan_id: 10 
　        become_user: yes
　        tags:
　          - WIN_teaming 
~~~

## Running Playbook

チーミングを変更する時、以下のように実行します。  

~~~sh
> ansible-playbook playbook-teaming.yml
~~~

## Evidence Description

エビデンス収集場合は、以下のようなEvidence収集用のPlaybookを作成してください。  

- エビデンスplaybook サンプル[win\_teaming\_evidence.yml]
~~~
　  ---
　    - hosts: win
　      roles:
　        - role: gathering
　          VAR_gathering_definition_role_path: "roles/Windows/WIN_teaming"
~~~

- マスターPlaybookにエビデンスコマンド追加 サンプル[playbook-teaming.yml]
~~~
　---
　  - import_playbook: win_teaming_evidence.yml VAR_gathering_label=before
　  - name: teaming setting 
　    gather_facts: true  
　    hosts: win
　    roles:
　      - role: Windows/WIN_teaming
　        VAR_WIN_teaming:
　          - name: 'team1'
　            mode: 'SwitchIndependent'
　            lb_argorithm: 'TransportPorts'
　            members:
　              - name: 'Ethernet1'
　                mode: 'Standby'
　            interfaces:
　              - name: 'teamnic2'
　                vlan_id: 10 
　        become_user: yes
　        tags:
　          - WIN_teaming 
　  - import_playbook: win_teaming_evidence.yml VAR_gathering_label=after
~~~

- エビデンス収集結果一覧
~~~
#エビデンス構成
.
└── 管理対象マシンIPアドレス
　    └── command
　        ├── 0              # チームの名称
　        ├── 1              # チームのinterfaces
　        ├── 2              # チームのmembers
　        └── results.json   # 各コマンドの情報を格納するJSONファイル
~~~

## License

## Copyright

Copyright (c) 2017-2018 NEC Corporation

## Author Information

NEC Corporation
