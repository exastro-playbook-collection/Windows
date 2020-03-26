# Ansible Role: Windows\WIN\_hostname
=======================================================

## Description
本RoleではWindows Server 2016のホスト名を変更する。

## Supports
- 管理マシン(Ansibleサーバ)
 * Linux系OS（RHEL）
 * Ansible バージョン 2.4 以上 (動作確認バージョン 2.4, 2.9)
 * Python バージョン 2.x, 3.x  (動作確認バージョン 2.7, 3.6)
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
　  * VAR_WIN_hostname: "testpc-002"             # ホスト名
　  * VAR_WIN_hostname_type: "workgroup"         # 変更後のドメイン／ワークグループ種別
                                                     # - ドメインの場合:"domain"
                                                     # - ワークグループの場合:"workgroup"
　  * VAR_WIN_hostname_reboot: false             # コンピュータの再起動（再起動しないと設定は有効になれない）
~~~

### Optional variables
~~~
　  * VAR_WIN_hostname_workgroup: "workgroup2"   # 新たなワークグループ名（変更したい場合のみ指定）
　  * VAR_WIN_hostname_domain:                   # 新たなドメインに関する変数を設定する。（ドメインを変更する時点のみ指定）
　        name: "test1.com"                          # ドメイン名
　        ip: "192.168.1.1"                          # ドメインサーバのIPアドレス
　        user: "dutest2"                            # ドメインに登録ユーザー名
　        password: "abc123$%"                       # ドメインに登録ユーザーのパスワード
　  * VAR_WIN_hostname_current_domain_auth:      # 変更前のドメインに関する変数を設定する。（元がドメインになっている場合のみ指定）
　        user: "dutest2"                            # 変更前のドメインに登録ユーザー名
　        password: "abc123$%"                       # 変更前のドメインに登録ユーザーのパスワード
~~~

### Dependencies

特にありません。

## Usage

1. 本Roleを用いたPlaybookを作成します。
2. 変数を必要に応じて指定します。
3. Playbookを実行します。

## Example Playbook

ホスト名を変更する場合は、提供した以下のRoleを"roles"ディレクトリ配置したうえで、
以下のようなPlaybookを作成してください。

- フォルダ構成  
~~~
 - playbook
　  │── hosts
　  │── roles/
　  │    └── Windows/
　  │          └── WIN_hostname
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
　  └─ playbook-hostname.yml
~~~

- マスターPlaybook サンプル[playbook-hostname.yml]  
~~~
# playbook-hostname.yml    <ホスト名のみ変更の例>
　  - name: hostname setting
　    gather_facts: true
　    hosts: win
　    roles:
　      - role: Windows/WIN_hostname
　        VAR_WIN_hostname: "testpc-002"
　        VAR_WIN_hostname_type: "workgroup"
　        VAR_WIN_hostname_workgroup: "workgroup2"
　        VAR_WIN_hostname_domain:
　            name: "test2.com"
　            ip: "192.168.1.2"
　            user: "dutete"
　            password: "eds1234*"
　        VAR_WIN_hostname_current_domain_auth:
　            user: "dutest2"
　            password: "abc123$%"
　        VAR_WIN_hostname_reboot: true
　        become_user: yes
　        tags:
　          - WIN_hostname
~~~

~~~
# playbook-hostname.yml    <例１：コンピュータ名のみ変更、所属グループ（ワークグループ）変更なし>
　  - name: hostname setting
　    hosts: win
　    gather_facts: true
　    roles:
　      - role: Windows/WIN_hostname
　        VAR_WIN_hostname: "testpc-002"
　        VAR_WIN_hostname_type: "workgroup"
　        VAR_WIN_hostname_reboot: true
　        become_user: yes
　        tags:
　          - WIN_hostname
~~~

~~~
# playbook-hostname.yml    <例２：コンピュータ名のみ変更、所属グループ（ドメイン）変更なし>
　  - name: hostname setting
　    hosts: win
　    gather_facts: true
　    roles:
　      - role: Windows/WIN_hostname
　        VAR_WIN_hostname: "testpc-002"
　        VAR_WIN_hostname_type: "domain"
　        VAR_WIN_hostname_current_domain_auth:
　            user: "testuser01"
　            password: "abc123$%"
　        VAR_WIN_hostname_reboot: false
　        become_user: yes
　        tags:
　          - WIN_hostname
~~~

~~~
# playbook-hostname.yml    <例３：コンピュータ名変更、所属グループ（ワークグループ）名前変更>
　  - name: hostname setting
　    hosts: win
　    gather_facts: true
　    roles:
　      - role: Windows/WIN_hostname
　        VAR_WIN_hostname: "testpc-002"
　        VAR_WIN_hostname_type: "workgroup"
　        VAR_WIN_hostname_workgroup: "testgroup01"
　        VAR_WIN_hostname_reboot: true
　        become_user: yes
　        tags:
　          - WIN_hostname
~~~

~~~
# playbook-hostname.yml    <例４：コンピュータ名変更、所属グループ（ドメイン）名前変更>
　  - name: hostname setting
　    hosts: win
　    gather_facts: true
　    roles:
　      - role: Windows/WIN_hostname
　        VAR_WIN_hostname: "testpc-002"
　        VAR_WIN_hostname_type: "domain"
　        VAR_WIN_hostname_domain:
　            name: "test1.com"
　            ip: "192.168.1.1"
　            user: "testuser02"
　            password: "abc123$%"
　        VAR_WIN_hostname_current_domain_auth:
　            user: "testuser01"
　            password: "abc123$%"
　        VAR_WIN_hostname_reboot: false
　        become_user: yes
　        tags:
　          - WIN_hostname
~~~

~~~
# playbook-hostname.yml    <例５：コンピュータ名変更、所属グループ（ドメイン→ワークグループ）変更>
　  - name: hostname setting
　    hosts: win
　    gather_facts: true
　    roles:
　      - role: Windows/WIN_hostname
　        VAR_WIN_hostname: "testpc-002"
　        VAR_WIN_hostname_type: "workgroup"
　        VAR_WIN_hostname_workgroup: "testgroup01"
　        VAR_WIN_hostname_current_domain_auth:
　            user: "testuser01"
　            password: "abc123$%"
　        VAR_WIN_hostname_reboot: false
　        become_user: yes
　        tags:
　          - WIN_hostname
~~~

~~~
# playbook-hostname.yml    <例６：コンピュータ名変更、所属グループ（ワークグループ→ドメイン）変更>
　  - name: hostname setting
　    hosts: win
　    gather_facts: true
　    roles:
　      - role: Windows/WIN_hostname
　        VAR_WIN_hostname: "testpc-002"
　        VAR_WIN_hostname_type: "domain"
　        VAR_WIN_hostname_domain
　            name: "test1.com"
　            ip: "192.168.1.1"
　            user: "testuser01"
　            password: "abc123$%"
　        VAR_WIN_hostname_reboot: false
　        become_user: yes
　        tags:
　          - WIN_hostname
~~~

## Running Playbook

ホスト名を変更する時、以下のように実行します。

~~~sh
> ansible-playbook playbook-hostname.yml
~~~

## Evidence Description

エビデンス収集場合は、以下のようなEvidence収集用のPlaybookを作成してください。

- エビデンスplaybook サンプル[win\_hostname\_evidence.yml]
~~~
　---
　  - hosts: win
　    roles:
　      - role: gathering
　        VAR_gathering_definition_role_path: "roles/Windows/WIN_hostname"
~~~

- マスターPlaybookにエビデンスコマンド追加 サンプル[playbook-hostname.yml]
~~~
　---
　  - import_playbook: win_hostname_evidence.yml VAR_gathering_label=before
　  - name: hostname setting
　    hosts: win
　    gather_facts:  true
　    roles:
　      - role: Windows/WIN_hostname
　        VAR_WIN_hostname: "testpc-002"
　        VAR_WIN_hostname_type: "workgroup"
　        VAR_WIN_hostname_workgroup: "workgroup2"
　        VAR_WIN_hostname_domain:
　            name: "test2.com"
　            ip: "192.168.1.2"
　            user: "dutete"
　            password: "eds1234*"
　        VAR_WIN_hostname_current_domain_auth:
　            user: "dutest2"
　            password: "abc123$%"
　        VAR_WIN_hostname_reboot: true
　        become_user: yes
　        tags:
　          - WIN_hostname
　  - import_playbook: win_hostname_evidence.yml VAR_gathering_label=after
~~~

- エビデンス収集結果一覧
~~~
#エビデンス構成
.
└── 管理対象マシンIPアドレス
　    ├── command
　    │   ├── 0                               #　workgroup名、ドメイン名情報
　    │   ├── 1                               #　ホストネーム情報
　    │   └── results.json                    #　各コマンドの情報を格納するJSONファイル
　    └── registry
　        └── HKLM
　            └── SYSTEM
　                └── CurrentControlSet
　                    └── Control
　                        └── ComputerName
　                           └── export.reg   #　ComputerName関連のレジストリ情報
~~~

## License

## Copyright

Copyright (c) 2017-2018 NEC Corporation

## Author Information

NEC Corporation
