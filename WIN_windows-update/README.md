# Ansible Role: Windows\WIN\_windows-update
=======================================================

## Description
本ロールは、Windows Server 2016 にWindowsUpdateの設定を行います。

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
- 管理対象マシン
  * Windows Server 2016
  * Powershell3.0+

## Role Variables

ロールの変数について説明します。

### Mandatory variables
特にありません。

### Optional variables

~~~
* VAR_WIN_update_AU:                      # 「自動更新を構成する」を設定します。
      status: enabled                         # 構成状態を指定します。大小文字を区別しません。
                                              # 設定可能な値：notConfigured：未構成（Default）、enabled：有効、disabled：無効
      AUOptions: 4                            # 自動更新設定オプション
                                              # 設定可能な値：
                                              #   2： 更新プログラムをダウンロードする前、およびインストールする前に通知します。
                                              #   3： 更新プログラムを自動的にダウンロードし、インストールの準備ができたら通知します。（Default）
                                              #   4： 更新プログラムを自動的にダウンロードし、以下に指定されたスケジュールでインストールします。
                                              #   5： ローカルの管理者が構成モードを選択し、自動更新による更新の通知とインストールを実行できるようにします。
      automaticMaintenanceEnabled: enabled    # 自動メンテナンス時にインストールするかどうかを指定します。大小文字を区別しません。
                                              # Statusがenabledの場合、以下の値を設定できます。
                                              #   disabled：指定されたスケジュールでインストールします。（Default）
                                              #   enabled：自動メンテナンス時に、更新プログラムをインストールします。
      scheduledInstallDay: 1                  # 自動ダウンロードしインストールを実行する更新日を指定します。
                                              # Statusがenabledの場合、入力する可能な値：0-7（ディフォルト値：0）となります。
      scheduledInstallTime: 5                 # 自動ダウンロードしインストールを実行する更新時間を指定します。
                                              # Statusがenabledの場合、入力する可能な値：0-23（ディフォルト値：3）となります。
      allowMUUpdateService: enabled           # 他の Microsoft 製品の更新プログラムのインストールを指定します。Statusがenabledの場合、以下の値を設定できます。
                                              # Statusがenabledの場合、以下の値を設定できます。
                                              #   disabled：他の Microsoft 製品の更新プログラムをインストールしない。（Default）
                                              #   enabled：他の Microsoft 製品の更新プログラムをインストールする。
* VAR_WIN_update_WU:                      # 「イントラネットの Microsoft 更新サービスの場所を指定する」を設定します。
      status: enabled                         # 構成状態を指定します。大小文字を区別しません。
                                              # 設定可能な値：notConfigured：未構成（Default）、enabled：有効、disabled：無効
      WUServer: http://AAA.BBB.com:8530       # 更新を検出するためのイントラネットの更新サービスを設定します。大小文字を区別しません。
                                              # Statusがenabledの場合、設定必須となります。
      WUStatusServer: http://XXX.YYY.com:8530 # イントラネット統計サーバーを設定します。大小文字を区別しません。
                                              # Statusがenabledの場合、設定必須となります。
* VAR_WIN_update_targetGroup:             # 「クライアント側のターゲットを有効にする」を設定します。
      status: enabled                         # 構成状態を指定します。大小文字を区別しません。
                                              # 設定可能な値：notConfigured：未構成（Default）、enabled：有効、disabled：無効
      targetGroup: TestGroup01                # イントラネットの Microsoft 更新サービスから更新プログラムを受信するために使用されるターゲットの
                                              # グループ名を指定します。大小文字を区別しません。
                                              # Statusがenabledの場合、設定必須となります。
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
　  │          └── WIN_windows-update/
　  │                │── defaults/
　  │                │       main.yml
　  │                │── meta/
　  │                │       main.yml
　  │                │── tasks/
　  │                │       main.yml
　  │                │       pre_check.yml
　  │                │       modify_AU.yml
　  │                │       modify_TG.yml
　  │                │       modify_WU.yml
　  │                │       delete_empty_key.yml
　  │                │── vars/
　  │                │       gathering_definition.yml
　  │                └─ README.md
　  └─ win_windows-update.yml
~~~

- マスターPlaybook サンプル[win\_windows-update.yml]

~~~
#win_windows-update.yml
---
- name: windows update setting
  hosts: win
  gather_facts: true
  roles: 
    - role: Windows/WIN_windows-update
      VAR_WIN_update_AU:
          status: enabled
          automaticMaintenanceEnabled: enabled
          AUOptions: 4
          scheduledInstallDay: 1
          scheduledInstallTime: 5
          allowMUUpdateService: enabled
      VAR_WIN_update_WU:
          status: enabled
          WUServer: http://AAA.BBB.com:8530
          WUStatusServer: http://XXX.YYY.com:8530
      VAR_WIN_update_targetGroup:
          status: enabled
          targetGroup: TestGroup01
      tags:
        - WIN_windows-update
~~~

## Running Playbook

~~~
> ansible-playbook win_windows-update.yml
~~~

### ■エビデンスを取得する場合の呼び出す方法

エビデンスを収集する場合、以下のようなEvidence収集用のPlaybookを作成してください。  

- エビデンスplaybook サンプル[win\windows-update_evidence.yml]

~~~
---
- hosts: win
  roles:
    - role: gathering
      VAR_gathering_definition_role_path: "roles/Windows/WIN_windows-update"
~~~

- マスターPlaybookにエビデンスコマンドを追加します。 サンプル[win\windows-update.yml]

~~~
---
- import_playbook: win_windows-update_evidence.yml VAR_gathering_label=before

- name: windows update setting
  hosts: win
  gather_facts: true
  roles: 
    - role: Windows/WIN_windows-update
      VAR_WIN_update_AU:
          status: enabled
          automaticMaintenanceEnabled: enabled
          AUOptions: 4
          scheduledInstallDay: 1
          scheduledInstallTime: 5
          allowMUUpdateService: enabled
      VAR_WIN_update_WU:
          status: enabled
          WUServer: http://AAA.BBB.com:8530
          WUStatusServer: http://XXX.YYY.com:8530
      VAR_WIN_update_targetGroup:
          status: enabled
          targetGroup: TestGroup01
      tags:
        - WIN_windows-update

- import_playbook: win_windows-update_evidence.yml VAR_gathering_label=after
~~~

- エビデンス収集結果一覧

~~~
#エビデンス構成
.
└── 管理対象マシンIPアドレス
　    ├── command
　    │   ├── 0                                      #　"HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"の情報
　    │   ├── 1                                      #　"HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"の情報
　    │   └── results.json                           #　各コマンドの情報を格納するJSONファイル
　    └── registry
　        └──HKLM
　            └──SOFTWARE
　                └──Policies
　                    └──Microsoft
　                        └──Windows
　                            └──WindowsUpdate
　                                └──export.reg
~~~

## License

## Copyright

Copyright (c) 2018-2019 NEC Corporation

## Author Information

NEC Corporation
