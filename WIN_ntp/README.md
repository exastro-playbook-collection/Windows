# Ansible Role: Windows\WIN\_ntp
=======================================================

## Description
本RoleではWindows Server 2016のntpを設定する。

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
　  * VAR_WIN_ntp_DataTime:              # GUIでインターネット時刻設定の関連情報、※省略不可
　        Servers:                           # インターネット時刻サーバーを指定する。複数個サーバーを設定可
　          - "time.windows.com"
　          - "time.nist.gov"
　          - "192.168.1.1"
　        default: 1                         # Serversに設定されたサーバーに既定有効のサーバーの順を指定する。1から指定する。
　  * VAR_WIN_ntp:                       # NTP設定の関連情報を設定する。※省略可能
　        NtpServer: "time.windows.com,0x9"  # NTP タイム ソースのドメイン ネーム システム (DNS) 名または IP アドレスを指定する。
　                                           # この値は、"dnsName,flags" の形式で指定する ("flags" は、DNS ホストのフラグの 16 進数ビットマスク)。
　                                           # 省略可能、省略された場合、変数VAR_WIN_ntp_DataTime.Serversにdefaultで指定されたサーバーにより、
　                                           # "dnsName,0x9" のように設定する。
　        Type: "NTP"                        # W32time で使用される認証を制御する。NTP（デフォルト値）/NT5DS/NoSync/AllSync
　        CrossSiteSyncFlags: 2              # ビットマスクで指定され、W32time が自身のサイト外にあるタイム ソースを選択する方法を制御する。
　                                           # 使用可能な値は、0、1、および 2 。
　        ResolvePeerBackoffMaxTimes: 7      # 発見処理が再開されるまでに、W32time が DNS の名前解決を試行する回数を制御する。
　        ResolvePeerBackoffMinutes: 15      # 分単位で指定され、DNS の名前解決が失敗した場合に、次に名前解決が試行されるまでに W32time が待機する時間を制御する。
　                                           # 既定値は 　15 分。
　        SpecialPollInterval: 3600          # 秒単位で指定され、タイム ソースが特別なポーリング間隔を使用するように設定されている場合に、
　                                           # 手動で設定されたタイム ソースがポーリングされる間隔を制御する。既定値は 3600 秒 (1 時間)。
　        EventLogFlags: 1                   # イベント ビューアーのシステム ログに記録できるイベントを制御するビットマスク。
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

ntpを変更する場合は、提供した以下のRoleを"roles"ディレクトリ配置したうえで、
以下のようなPlaybookを作成してください。

- フォルダ構成
~~~
 - playbook
　  │── hosts
　  │── roles/
　  │    └── Windows/
　  │          └── WIN_ntp
　  │                │── defaults
　  │                │       main.yml
　  │                │── tasks
　  │                │       main.yml
　  │                │       pre_check.yml
　  │                │       modify.yml
　  │                │       post_check.yml
　  │                └─ README.md
　  └─ playbook-ntp.yml
~~~

- マスターPlaybook サンプル[playbook-ntp.yml]
~~~
# playbook-ntp.yml
　  - name: ntp setting 
　    gather_facts: true
　    hosts: win
　    roles:
　      - role: Windows/WIN_ntp
　        VAR_WIN_ntp_DataTime:
　            Servers: 
　              - "time.windows.com"
　              - "time.nist.gov"
　              - "192.168.1.1"
　            default: 1 
　        VAR_WIN_ntp: 
　            NtpServer: "time.windows.com,0x9"
　            Type: "NTP"
　            CrossSiteSyncFlags: 2
　            ResolvePeerBackoffMaxTimes: 7
　            ResolvePeerBackoffMinutes: 15
　            SpecialPollInterval: 3600
　            EventLogFlags: 1
　        become_user: yes
　        tags:
　          - WIN_ntp 
~~~

## Running Playbook

ntpを変更する時、以下のように実行します。  

~~~sh
> ansible-playbook playbook-ntp.yml
~~~

## Evidence Description

エビデンス収集場合は、以下のようなEvidence収集用のPlaybookを作成してください。  

- エビデンスplaybook サンプル[win\_ntp\_evidence.yml]
~~~
　---
　  - hosts: win
　    roles:
　      - role: gathering
　        VAR_gathering_definition_role_path: "roles/Windows/WIN_ntp"
~~~

- マスターPlaybookにエビデンスコマンド追加 サンプル[playbook-ntp.yml]
~~~
　---
　  - import_playbook: win_ntp_evidence.yml VAR_gathering_label=before
　  - name: ntp setting 
　    gather_facts: true
　    hosts: win
　    roles:
　      - role: Windows/WIN_ntp
　        VAR_WIN_ntp_DataTime:  
　            Servers: 
　              - "time.windows.com"
　              - "time.nist.gov"
　              - "192.168.1.1"
　            default: 1 
　        VAR_WIN_ntp: 
　            NtpServer: "time.windows.com,0x9"
　            Type: "NTP"
　            CrossSiteSyncFlags: 2
　            ResolvePeerBackoffMaxTimes: 7
　            ResolvePeerBackoffMinutes: 15
　            SpecialPollInterval: 3600
　            EventLogFlags: 1
　        become_user: yes
　        tags:
　          - WIN_ntp 
　  - import_playbook: win_ntp_evidence.yml VAR_gathering_label=after
~~~

- エビデンス収集結果一覧
~~~
#エビデンス構成
.
└── 管理対象マシンIPアドレス
　    └── command
　        ├── 0              # w32timeサービス状態
　        ├── 1              # インターネット時刻設定の関連情報
　        ├── 2              # w32timeサービスのParametersの関連情報
　        ├── 3              # w32timeサービスのNtpClientの関連情報
　        └── results.json   # 各コマンドの情報を格納するJSONファイル
~~~

## License

## Copyright

Copyright (c) 2017-2018 NEC Corporation

## Author Information

NEC Corporation
