# Ansible Role: Windows\NEC\_WIN\_recover-os
=======================================================

## Description
本ロールは、Windows Server 2016 に起動と回復の設定を行います。

## Supports
- 管理マシン(Ansibleサーバ)
  * Linux系OS（RHEL7）
  * Ansible バージョン 2.7 以上
  * Python バージョン 2.7
- 管理対象マシン
  * Windows Server 2016

## Requirements
- 管理マシン(Ansibleサーバ)
  * Ansibleサーバは管理対象マシンへPowershell接続できる必要があります。
  * Ansibleサーバの `/etc/ansible/ansible.cfg` ファイルもしくは `{{ playbook_dir }}/ansible.cfg` ファイルに対して、以下の設定が必要です。
    `jinja2_extensions = jinja2.ext.do,jinja2.ext.i18n,jinja2.ext.loopcontrols`
- 管理対象マシン
  * Windows Server 2016
  * Powershell3.0+

## Role Variables

ロールの変数について説明します。

### Mandatory variables

特にありません。

### Optional variables

~~~
* VAR_NEC_WIN_recoveros_defaultOS_displayname: Windows Server 2016    # 「既定のオペレーティングシステム」を設定します。
* VAR_NEC_WIN_recoveros_timeOut: 30                                   # 「オペレーティングシステムも一覧を表示する時間」を設定します。
                                                                      # 値設定範囲：0～999（0に設定した場合、この項目は無効になります）
* VAR_NEC_WIN_recoveros_recoverTime:                                  # 「必要なときに修復オプションを表示する時間」を設定します。
      enabled: yes                                                    # その値により、“必要なときに修復オプションを表示する時間”が無効/有効となります。
      timeout: 30                                                     # その値により、“必要なときに修復オプションを表示する時間”のタイムアウト時間を設定できます。
                                                                      # enabled=yesの場合のみ、この項目が有効します。値設定範囲：0～200（デフォルト値：30）
* VAR_NEC_WIN_recoveros_autoReboot: yes                               # 「自動的に再起動する」を設定します。
* VAR_NEC_WIN_recoveros_DebugInfo:                                    # 「デバッグ情報の書き込み」を設定します。
      crashDumpEnabled: min                                           # 「メモリダンプ」を設定します。大小文字を区分します。
                                                                      # 値設定範囲：
                                                                      #    none    （なし）
                                                                      #    min      最小メモリダンプ（256KB）
                                                                      #    kernel   カーネルメモリダンプ
                                                                      #    perfect  完全メモリダンプ
                                                                      #    auto     自動メモリダンプ
                                                                      #    active   アクティブメモリダンプ
      dump: %SystemRoot%\MEMORY.DMP                                   # 「ダンプファイル」を設定します。大小文字を区分します。
                                                                      # crashDumpEnabled=none以外の場合、必須
                                                                      # crashDumpEnabled=noneの場合、設定不可
      overWrite: yes                                                  # 「既存のファイルに上書きする」を設定します。
                                                                      # crashDumpEnabled=noneとmin以外の場合、必須
                                                                      # crashDumpEnabled=none或はminの場合、設定不可
      alwaysKeepMemoryDump: yes                                       # 「ディスク領域が少ないときでもメモリダンプの自動削除を無効にする」を設定します。
                                                                      # crashDumpEnabled=noneとmin以外の場合、必須
                                                                      # crashDumpEnabled=none或はminの場合、設定不可
~~~

## Dependencies

特にありません。

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
　  │          └── NEC_WIN_recover-os/
　  │                │── defaults/
　  │                │       main.yml
　  │                │── files/
　  │                │       timeDisplay.ps1
　  │                │── meta/
　  │                │       main.yml
　  │                │── tasks/
　  │                │       main.yml
　  │                │── vars/
　  │                │       gathering_definition.yml
　  │                └─ README.md
　  └─ win_recoverOs.yml
~~~

- マスターPlaybook サンプル[win\_recoverOs.yml]

~~~
#win_recoverOs.yml
---
- name: Windows recoverOs playbook
  hosts: win
  gather_facts: false
  roles:
    - role: Windows/NEC_WIN_recover-os
      VAR_NEC_WIN_recoveros_defaultOS_displayname: 'Windows Server 2016'
      VAR_NEC_WIN_recoveros_timeOut: 30
      VAR_NEC_WIN_recoveros_recoverTime:
          enabled: yes
          timeout: 30
      VAR_NEC_WIN_recoveros_autoReboot: yes
      VAR_NEC_WIN_recoveros_DebugInfo:
          crashDumpEnabled: auto
          dump: '%SystemRoot%\MEMORY.DMP'
          overWrite: yes
          alwaysKeepMemoryDump: no
      tags:
        - NEC_WIN_recover-os
~~~

## Running Playbook

~~~sh
> ansible-playbook win_recoverOs.yml
~~~

### ■エビデンスを取得する場合の呼び出す方法

エビデンスを収集する場合、以下のようなEvidence収集用のPlaybookを作成してください。  

- エビデンスplaybook サンプル[win\_recoverOs\_evidence.yml]

~~~
---
- hosts: win
  roles:
    - role: gathering
　     VAR_gathering_definition_role_path: "roles/Windows/NEC_WIN_recover-os"
~~~

- マスターPlaybookにエビデンスコマンドを追加します。 サンプル[win\_recoverOs.yml]

~~~
---
- import_playbook: win_recoverOs_evidence.yml VAR_gathering_label=before

- name: Windows recoverOs playbook
  hosts: win
  gather_facts: false
  roles:
    - role: Windows/NEC_WIN_recover-os
      VAR_NEC_WIN_recoveros_defaultOS_displayname: 'Windows Server 2016'
      VAR_NEC_WIN_recoveros_timeOut: 30
      VAR_NEC_WIN_recoveros_recoverTime:
          enabled: yes
          timeout: 30
      VAR_NEC_WIN_recoveros_autoReboot: yes
      VAR_NEC_WIN_recoveros_DebugInfo:
          crashDumpEnabled: auto
          dump: '%SystemRoot%\MEMORY.DMP'
          overWrite: yes
          alwaysKeepMemoryDump: no

- import_playbook: win_recoverOs_evidence.yml VAR_gathering_label=after
~~~

- エビデンス収集結果一覧
~~~
#エビデンス構成
.
└── 管理対象マシンIPアドレス
　    ├── command
　    │   ├── 0                                #　Windows ブート情報
　    │   ├── 1                                #　「ディスク領域が少ないときでもメモリダンプの自動削除を無効にする」設定関連のレジストリ情報
　    │   ├── 2                                #　「自動的に再起動する」設定関連のレジストリ情報
　    │   ├── 3                                #　「メモリダンプ」設定関連のレジストリ情報
　    │   ├── 4                                #　「ダンプファイル」DumpFile設定関連のレジストリ情報
　    │   ├── 5                                #　「ダンプファイル」MinidumpDir設定関連のレジストリ情報
　    │   ├── 6                                #　「既存のファイルに上書きする」設定関連のレジストリ情報
　    │   ├── 7                                #　「「メモリダンプ」FilterPages設定関連のレジストリ情報
　    │   └── results.json                     #　各コマンドの情報を格納するJSONファイル
　    ├── file
　    │   └── C:
　    │       └── Windows
　    │           └── bootstat.dat             #　「必要なときに修復オプションを表示する時間」設定情報
　    └── registry
　        └── HKLM
　            └── SYSTEM
　                └── CurrentControlSet
　                    └── Control
　                        └── CrashControl
　                            └── export.reg   # Windows ブート設定関連のレジストリ情報
~~~

## License

## Copyright

Copyright (c) 2018-2019 NEC Corporation

## Author Information

NEC Corporation
