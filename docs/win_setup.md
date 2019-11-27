# Ansibleから利用するためのWindows ターゲットマシン上の設定

## ターゲットマシンの条件
* PowerShell のバージョンが3以上であること
* WinRM での接続が許可されていること
* PowerShell のリモート実行が許可されていること
* 管理者グループに属したAnsibleからの接続用ユーザがあること

## WinRM の接続設定
Ansible-PJが公式に提供しているセットアップスクリプトでWinRMの接続設定を行います。

1. PowerShell を管理者権限で起動してください。
   * スタートメニューで[Windows PowerShell]アイコンを右クリックして「管理者として実行」でPowerShell を起動してください。
2. セットアップスクリプトのダウンロード
   * 以下のコマンドラインで、`ConfigureRemotingForAnsible.ps1` を入手します。

~~~
 PS C:\tmp> Invoke-WebRequest -Uri https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1 -OutFile ConfigureRemotingForAnsible.ps1
~~~

3. セットアップスクリプトを実行

~~~
 PS C:\tmp> powershell -ExecutionPolicy RemoteSigned .\ConfigureRemotingForAnsible.ps1
~~~
