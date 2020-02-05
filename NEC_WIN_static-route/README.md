# Ansible Role: Windows\NEC\_WIN\_static-route
=======================================================

## Description
この役割は、Windowsサーバー2016上の静的ルートを設定するために使用されます。

## Supports
- 管理マシン(Ansibleサーバ)
 * Linux系OS（RHEL）
 * Ansible バージョン 2.4 以上
 * Python バージョン 2.7
- 管理対象マシン
 * Windows server 2016

## Requirements
- 管理マシン(Ansibleサーバ)
 * Ansibleホストは管理対象マシンへPowershell接続できる必要がある。
- 管理対象マシン
 * Windows Server 2016
 * Powershell3.0+

## Role Variables
Role の変数値について説明します。
注意事項：XXXXX というWindows/Linux共通の変数は廃止しました。RH_XXXXX、WIN_XXXXXというOS毎の変数設定が必要です。

### Mandatory variables
~~~
　  * VAR_NEC_WIN_static_route:    # 静的ルート設定情報を設定する。※子項目は繰り返して設定できる
　     - interface:           # ネットワークインタフェース設定名を設定する。※省略可能
　       dest:                # ネットワーク宛先のIPアドレス（Prefixを付けることは可能）を指定する。
　                            # ※destが設定されない及び0.0.0.0や、0.0.0.0/0の場合、固定ルートのゲートウェイとする。
　       gateway:             # 管理対象マシンのゲートウェイを設定する。
　       metric:              # RouteMetric を設定する。※省略可能
~~~

### Optional variables
特にありません。

## Dependencies
特にありません。

## Usage
1. 本Roleを用いたPlaybookを作成します。
2. 変数を必要に応じて指定します。
3. Playbookを実行します。

## Example Playbook

指定の静的ルートを設定する場合は、提供した以下のRoleを"roles"ディレクトリ配置したうえで、
以下のようなPlaybookを作成してください。

- フォルダ構成
~~~
 - playbook
　  │── hosts/
　  │── roles/
　  │    └── Windows/
　  │          └── NEC_WIN_static-route
　  │                │── defaults
　  │                │       main.yml
　  │                │── tasks
　  │                │       main.yml
　  │                │       pre_check.yml
　  │                │       modify.yml
　  │                │       post_check.yml
　  │                └─ README.md
　  └─ win_static_route.yml
~~~

- マスターPlaybook サンプル[win\_static\_route.yml]
~~~
#win_static_route.yml
　 - name: Windows Route
　   hosts: win
　   gather_facts: false
　   roles:
　     - role: Windows/NEC_WIN_static-route
　       VAR_NEC_WIN_static_route:
　         - interface: 'Ethernet0'
　           dest: '10.0.0.0/24'
　           gateway: '192.168.0.1'
　           metric: 100
　           metric: 256
　         - dest: '0.0.0.0/0'
　         　 gateway: '172.28.145.254'
　       tags:
　         - NEC_WIN_static-route
~~~

## Running Playbook

- 指定の静的ルートを設定する時、以下のように実行します。

~~~sh
> ansible-playbook win_name_resolve.yml
~~~

## Evidence Description

エビデンス収集場合は、以下のようなEvidence収集用のPlaybookを作成してください。

- エビデンスplaybook サンプル[win\_static\_route_evidence.yml]
~~~
　---
　  - hosts: win
　    roles:
　      - role: gathering
　        VAR_gathering_definition_role_path: "roles/Windows/NEC_WIN_static-route"
~~~

- マスターPlaybookにエビデンスコマンド追加 サンプル[win\_static_route.yml]
~~~
　---
　  - import_playbook: win_static_route_evidence.yml VAR_gathering_label=before
　  - name: Windows Route
　    hosts: win
　    gather_facts: false
　    roles:
　      - role: Windows/NEC_WIN_static-route
　        VAR_NEC_WIN_static_route:
　          - interface: 'Ethernet0'
　            dest: '10.0.0.0/24'
　            gateway: '192.168.0.1'
　            metric: 100
　          - gateway: '169.254.27.126'
　            metric: 25
　        tags:
　          - NEC_WIN_static-route
　  - import_playbook: win_static_route_evidence.yml VAR_gathering_label=after
~~~

- エビデンス収集結果一覧
~~~
#エビデンス構成
.
└── 管理対象マシンIPアドレス
　    └── command
　        ├── 0            #　静的ルート設定情報、ゲートウェイ設定情報
　        └── results.json #　各コマンドの情報を格納するJSONファイル
~~~

## License

## Copyright

Copyright (c) 2017-2018 NEC Corporation

## Author Information

NEC Corporation
