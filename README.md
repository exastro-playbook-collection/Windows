OS-roles
===============================
# Trademarks
-----------
* Linuxは、Linus Torvalds氏の米国およびその他の国における登録商標または商標です。
* RedHat、RHEL、CentOSは、Red Hat, Inc.の米国およびその他の国における登録商標または商標です。
* Windows、PowerShellは、Microsoft Corporation の米国およびその他の国における登録商標または商標です。
* Ansibleは、Red Hat, Inc.の米国およびその他の国における登録商標または商標です。
* pythonは、Python Software Foundationの登録商標または商標です。
* NECは、日本電気株式会社の登録商標または商標です。
* その他、本ロールのコード、ファイルに記載されている会社名および製品名は、各社の登録商標または商標です。

# Description
-----------
ここでは、OSのインストールが完了後、各種OSに関する設定を行うためのRoleを提供します。
ソフトウェア製品向けRoleと異なり、利用者が構築時に必要となるRoleを適宜選択してPlaybookを作成してください。

Ansibleには、AnsibleモジュールとLinux System Roles という標準機能があります。OSの設定を実現するPlaybook開発にあたっては、次のように機能選択を検討してください。

* 機能選択する順位
  1. [Ansibleモジュール](http://docs.ansible.com/ansible/latest/modules_by_category.html)
     * Ansibleモジュールで実現したい機能が提供されている場合は、優先的にAnsibleモジュールを利用してください。
  2. [Linux System Roles](https://galaxy.ansible.com/linux-system-roles/)
     * RHEL 向けにRoleが提供されています。
       * https://access.redhat.com/articles/3050101
  3. このリポジトリで公開しているRole
     * 「Ansibleモジュール」および「Linux System Roles」では実現できないOS設定で、このリポジトリで公開されているものがある場合はご利用ください。提供しているRoleによっては、「Ansibleモジュール」および「Linux System Roles」で実現できるものも公開していますが、利用時の簡易化(管理対象サーバへ追加のパッケージをインストールしない、など)が主な目的ですので、実現したい内容に応じて使い分けてください。
  4. 自作
     * 上記選択肢に存在しない設定項目については、自作をしてください。

-------------

## 注意
OS関連のRole利用は、パラメータ内容を十分に確認し、事前評価を行ってからご利用ください。パラメータ値が誤っていると、ターゲットマシンへのアクセスができなくなるなど、トラブルが発生する可能性があります。

-------------

# OS用Roleを使うまでの前準備
-----------
OS用Roleを利用する前に、最低限以下の設定をAnsibleサーバおよびターゲットマシン(管理対象サーバ)へ事前に実施してください。

## ターゲットマシン

### RHEL
-----------
RHELサーバは、OSのインストール後、以下の設定を実施してください。（sshはデフォルトで動作している前提です）

* Ansible サーバと接続するネットワークの設定
* Ansibleがアクセスする、管理者権限のあるユーザアカウントの作成

### Windows サーバ
-----------
* [Windowsサーバの設定](docs/win_setup.md)

## Ansibleサーバ
-----------
### Ansible 本体のインストール・初期環境設定

* Ansibleのインストールを行ってください。

### ssh key の作成と配布の例
ここでは、`ansible` という一般ユーザでAnsibleを実行する想定で説明します。運用に即して適宜読み替えてください。

* ssh 公開鍵の作成
~~~
[ansible@localhost ~]$ ssh-keygen -t rsa
Generating public/private rsa key pair.
Enter file in which to save the key (/home/ansible/.ssh/id_rsa):
Created directory '/home/ansible/.ssh'.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/ansible/.ssh/id_rsa.
Your public key has been saved in /home/ansible/.ssh/id_rsa.pub.
The key fingerprint is:
...
~~~

* 公開鍵の配布
  * ターゲットマシン(Linux)にも `ansible` というユーザが作成されている前提で、公開鍵を配布します。

~~~
[ansible@localhost ~]$ ssh-copy-id -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa.pub ansible@192.168.56.104
# 最後のIPアドレスに対象とするターゲットマシン(Linux)を指定して、上記コマンドを実施してください。
~~~

# 提供Role一覧(RHEL用)

## システム設定

-----------
以下のシステム設定用ロールを提供しています。

* rsyslog設定  (NEC_RH_rsyslog)
* sshd設定     (NEC_RH_sshd)
* snmpd設定    (NEC_RH_snmpd)
* grub2設定    (NEC_RH_grub2) GRUB2: GRand Unified Bootloader version 2
* kdump設定    (NEC_RH_kdump) KDUMP: Kernel Crash Dumps
* ntp設定      (NEC_RH_ntp) NTP: Network Time Protocol
* OS再起動     (NEC_RH_reboot)
* パスワードポリシー設定 (NEC_RH_password-rules)
* 言語設定     (NEC_RH_lang)
* キーボード設定  (NEC_RH_keyboard)
* ランレベル設定  (NEC_RH_runlevel)

## ファイルの操作
-----------
* ファイルの作成／削除  (NEC_RH_file)
* ログローテートの設定  (NEC_RH_logrotate)

## ネットワーク関連の設定
-----------
RHEL のネットワーク設定は、NetworkManagerの起動有無で実現方法が異なってきます。構築対象サーバでNetworkManagerを起動してネットワーク設定を実施する場合は、Ansibleモジュールの`nmcli` を直接利用してください。
ここでは、NetworkManagerが起動していないサーバに対して、ネットワーク関連の設定を実施するRoleを公開しています。

| ロール名 | 機能概要 | NM(*)の起動 | 補足 |
|---------|---------|-------|------|
|NEC_RH_hostname|システムホスト名の変更|不要|　　|
|NEC_RH_name_resolve|DNS設定|不要|　　|
|NEC_RH_interface|ネットワークインタフェースの設定|不要|　　|
|NEC_RH_static-routing|静的ルーティングの設定|不要|　　|

(*)NM: NetworkManager

# 提供Role一覧(Windows用)
## システム設定
-----------
以下のシステム設定用ロールを提供しています。

* リモートデスクトップ接続設定(NEC_WIN_remote-desktop)
* 仮想メモリ(NEC_WIN_virtual-memory)
* ntp設定(NEC_WIN_ntp)
* OS再起動(NEC_WIN_reboot)
* UAC設定(NEC_WIN_uac)
* 起動と回復設定(NEC_WIN_recover-os)
* Windowsエラー報告設定(NEC_WIN_error-report)
* WindowsUpdate設定(NEC_WIN_windows-update)
* Powershellスクリプト実行許可設定(NEC_WIN_powershell-execution-policy)
* 組織と使用者設定(NEC_WIN_owner-organization)
* .NET Framework 3.5のインストール(NEC_WIN_dotNET35-Install)
* Administrator アカウント名変更(NEC_WIN_AdminName-change)
* ドライブレター設定(NEC_WIN_drive-letter)
* ユーザー権利割当(NEC_WIN_user-rights-assign)
* 管理者承認モードですべての管理者を実行する設定(NEC_WIN_AdminApprovalMode)

## ファイルの操作
-----------

* ファイルの作成／削除(NEC_WIN_file)
* ディレクトリ作成(NEC_WIN_directory)

## ネットワーク関連の設定
-----------

| ロール名 | 機能概要 | 補足 |
|---------|---------|------|
|NEC_WIN_hostname|システムホスト名の変更|　　|
|NEC_WIN_name_resolve|DNS設定|　　|
|NEC_WIN_network-interface|ネットワークインタフェースの設定|　　|
|NEC_WIN_static-route|静定ルーティングの設定|　　|
|NEC_WIN_network| `C:\WINDOWS\system32\drivers\etc\networks` の設定|　　|
|NEC_WIN_teaming|teamingの設定|複数のNICを束ねるチーミング機能の設定 |
|NEC_WIN_ipv6-disabled|IPv6無効化設定|　　|
|NEC_WIN_dns-suffix|DNSサフィックス設定|　　|

# 参考情報
* [SHIFT ware](https://shift-ware.github.io/ja/)
* [Ansible 実践ガイドサンプルコード](https://gitlab.com/shkitayama/ansible_practical_guide)

# Remarks
-------

# Copyright
---------
Copyright (c) 2018-2019 NEC Corporation

# Author Information
------------------
NEC Corporation
