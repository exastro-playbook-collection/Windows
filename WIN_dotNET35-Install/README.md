# Ansible Role: Windows\WIN\_dotNET35-Install
=======================================================

## Description
このロールは、windows server 2016の.NET3.5をインストールするために使用されます。

## Supports  
- 管理マシン(Ansibleサーバ)  
 * Linux系OS（RHEL）  
 * Ansible バージョン 2.7 以上 (動作確認バージョン 2.7, 2.9)
 * Python バージョン 2.x, 3.x  (動作確認バージョン 2.7, 3.6)
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

特にありません。

### Optional variables

~~~
* VAR_dotNET35_Feature_Name:           # 指定された.NET3.5の機能をインストールします。
                                       # デフォルト値：NET-Framework-Core,NET-HTTP-Activation,NET-Non-HTTP-Activ
                                       # 大小文字区別しません。
                                       # 設定可能な値（機能の名前）以下の四つです。
                                       #   ・NET-Framework-Features
                                       #   ・NET-Framework-Core
                                       #   ・NET-HTTP-Activation
                                       #   ・NET-Non-HTTP-Activ
                                       # コンマで区切られた複数の値を指定できます。
                                       # 機能の名前とインストール機能は以下の対応関係があります。
                                       #   NET-Framework-Features → .NET Framework 3.5 (.NET 2.0 および 3.0を含む)
                                       #   NET-Framework-Core     → .NET Framework 3.5 (.NET 2.0 および 3.0を含む)
                                       #   NET-HTTP-Activation    → .NET Framework 3.5 (.NET 2.0 および 3.0を含む)　＋HTTP アクティブ化
                                       #   NET-Non-HTTP-Activ     → .NET Framework 3.5 (.NET 2.0 および 3.0を含む)　＋非HTTP アクティブ化
* VAR_dotNET35_Installer_Name:         # .NET Framework 3.5のインストールに使用された物件ファイル名を設定します。
                                       # デフォルト値：microsoft-windows-netfx3-ondemand-package.cab
                                       # 大小文字を区別します。
* VAR_dotNET35_Installer_URL:          # インストールパッケージのファイルのWeb格納URLを設定します。VAR_dotNET35_Installer_PATHより、こちらは優先です。
                                       # 大小文字を区別します。
* VAR_dotNET35_Installer_PATH:         # インストールパッケージのファイルの格納パスを指定します。
                                       # 大小文字を区別します。
* VAR_WIN_dotNET35_reboot          # 設定後、管理対象マシンをすぐ再起動するかどうか指定します。true/false（デフォルト値）
~~~

## Dependencies

Ansible Role: Windows\WIN\_reboot。

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
　  │          └── WIN_dotNET35-Install/
　  │                │── defaults/
　  │                │       main.yml
　  │                │── meta/
　  │                │       main.yml
　  │                │── tasks/
　  │                │       main.yml
　  │                │── vars/
　  │                │       gathering_definition.yml
　  │                └─ README.md
　  └─ win_dotNET35_Install.yml
~~~

- マスターPlaybook サンプル[win\_dotNET35\_Install.yml]

~~~
#win_dotNET35_Install.yml
---
- name: Windows .NET3.5 install playbook
  hosts: win
  gather_facts: true
  roles:
    - role: Windows/WIN_dotNET35-Install
      VAR_dotNET35_Feature_Name: NET-Framework-Core,NET-HTTP-Activation,NET-Non-HTTP-Activ
      VAR_dotNET35_Installer_Name: microsoft-windows-netfx3-ondemand-package.cab
      VAR_dotNET35_Installer_URL: http://192.168.1.1:8080/
      VAR_WIN_dotNET35_reboot: false
      tags:
        - WIN_dotNET35_Install
  # reboot
  post_tasks:
    - include_role:
          name: Windows/WIN_reboot
      when: WIN_reboot_required == true
~~~

## Running Playbook

~~~sh
> ansible-playbook win_dotNET35_Install.yml
~~~

### ■エビデンスを取得する場合の呼び出す方法

エビデンスを収集する場合、以下のようなEvidence収集用のPlaybookを作成してください。  

- エビデンスplaybook サンプル[win\_dotNET35\_Install\_evidence.yml]

~~~
---
- hosts: win
  roles:
    - role: gathering
      VAR_gathering_definition_role_path: "roles/Windows/WIN_dotNET35-Install"
~~~

- マスターPlaybookにエビデンスコマンドを追加します。 サンプル[win\_dotNET35\_Install.yml]

~~~
---
- import_playbook: win_dotNET35_Install_evidence.yml VAR_gathering_label=before

- name: Windows .NET3.5 install playbook
  hosts: win
  gather_facts: true
  roles:
    - role: Windows/WIN_dotNET35-Install
      VAR_dotNET35_Feature_Name: NET-Framework-Core,NET-HTTP-Activation,NET-Non-HTTP-Activ
      VAR_dotNET35_Installer_Name: microsoft-windows-netfx3-ondemand-package.cab
      VAR_dotNET35_Installer_PATH: /share/installer/
      VAR_WIN_dotNET35_reboot: false 
      tags:
        - WIN_dotNET35_Install
  # reboot
  post_tasks:
    - include_role:
          name: Windows/WIN_reboot
      when: WIN_reboot_required == true

- import_playbook: win_dotNET35_Install_evidence.yml VAR_gathering_label=after
~~~

- エビデンス収集結果一覧

~~~
#エビデンス構成
.
└── 管理対象マシンIPアドレス
　    └── command
　        ├── 0                                      #　NET-Framework-Features がインストールされたか情報
　        ├── 1                                      #　Framework-Core がインストールされたか情報
　        ├── 2                                      #　NET-HTTP-Activation がインストールされたか情報
　        ├── 3                                      #　NET-Non-HTTP-Activ がインストールされたか情報
　        └── results.json                           #　各コマンドの情報を格納するJSONファイル
~~~

## License

## Copyright

Copyright (c) 2018-2019 NEC Corporation

## Author Information

NEC Corporation
