---
stage: Plan
group: Project Management
info: To determine the technical writer assigned to the Stage/Group associated with this page, see https://handbook.gitlab.com/handbook/product/ux/technical-writing/#assignments
title: イシューの管理
---

{{< details >}}

- プラン:Free、Premium、Ultimate
- 提供形態:GitLab.com、GitLab Self-Managed、GitLab Dedicated

{{< /details >}}

GitLabイシューは、作業の追跡やチームとのコラボレーションに役立ちます。イシューを管理することで、次のことが可能になります：

- タイトル、説明、担当者、メタデータなどの詳細を編集できます。
- コンテキストと履歴を維持しながら、イシューをプロジェクト間で移動できます。
- 完了したイシューをクローズし、必要に応じて再度オープンできます。
- 一括編集を使用して、複数のイシューを効率的に更新できます。
- イシューのヘルスステータスを追跡して、進捗状況を監視し、リスクを特定できます。

## イシューを編集

{{< history >}}

- GitLab 17.7では、イシューを編集するための最小ロールがレポーターからプランナーに[変更されました](https://gitlab.com/gitlab-org/gitlab/-/merge_requests/169256)。

{{< /history >}}

イシューのタイトルと説明を編集できます。

前提要件:

- プロジェクトのプランナーロール以上を持っているか、イシューの作成者であるか、イシューの担当者である必要があります。

イシューを編集するには、次の手順に従います:

1. 左側のサイドバーで、**検索または移動**を選択して、プロジェクトを見つけます。
1. **プラン > イシュー**を選択し、イシューのタイトルを選択して表示します。
1. タイトルの右側にある**タイトルと説明を編集** ({{< icon name="pencil" >}}) を選択します。
1. 利用可能なフィールドを編集します。
1. **変更を保存**を選択します。

### イシュー説明の生成でイシューに情報を入力します

{{< details >}}

- プラン:GitLab Duo Enterprise を含む Ultimate - [トライアルを開始](https://about.gitlab.com/solutions/gitlab-duo-pro/sales/?type=free-trial)します
- 提供形態:GitLab.com
- 状態:実験
- 大規模言語モデル（LLM）:Anthropic [Claude 3.5 Sonnet](https://console.cloud.google.com/vertex-ai/publishers/anthropic/model-garden/claude-3-5-sonnet) {{< /details >}}

{{< history >}}

- [導入](https://gitlab.com/groups/gitlab-org/-/epics/10762)：GitLab 16.3 での[実験](../../../policy/development_stages_support.md#experiment)として。
- GitLab 17.6 以降では、GitLab Duoアドオンが必要になるように変更されました。

{{< /history >}}

指定した短い要約に基づいて、イシューの詳細な説明を生成します。

前提要件:

- [実験的機能とベータ機能の設定](../../gitlab_duo/turn_on_off.md#turn-on-beta-and-experimental-features)が有効になっているグループに少なくとも1つ所属している必要があります。
- イシューを作成する権限が必要です。
- プレーンテキストエディタでのみ使用できます。
- 新しいイシューを作成するときにのみ使用できます。既存のイシューの編集時に説明文を生成するサポートを追加する提案については、[イシュー474141](https://gitlab.com/gitlab-org/gitlab/-/issues/474141)を参照してください。

イシューの説明文を生成するには、次の手順に従います:

1. 新しいイシューを作成します。
1. **説明**フィールドの上にある、**GitLab Duo** ({{< icon name="tanuki-ai" >}}) **> イシューの説明文を生成**を選択します。
1. 簡単な説明文を記述し、**送信**を選択します。

イシューの説明文がAIによって生成されたテキストに置き換えられます。

この実験的機能に関するフィードバックを[イシュー409844](https://gitlab.com/gitlab-org/gitlab/-/issues/409844)で提供してください。

**データ使用量**:この機能を使用すると、入力したテキストが大規模言語モデルに送信されます。

## プロジェクトからイシューを一括編集

{{< history >}}

- GitLab 17.7では、プロジェクトからイシューを一括編集するための最小ロールがレポーターからプランナーに[変更されました](https://gitlab.com/gitlab-org/gitlab/-/merge_requests/169256)。

{{< /history >}}

プロジェクト内で複数のイシューを一度に編集できます。

前提要件:

- プロジェクトのプランナーロール以上を持っている必要があります。

複数のイシューを同時に編集するには、次の手順に従います。

1. 左側のサイドバーで、**検索または移動**を選択して、プロジェクトを見つけます。
1. **プラン > イシュー**を選択します。
1. **一括編集**を選択します。画面の右側にサイドバーが表示されます。
1. 編集する各イシューの横にあるチェックボックスを選択します。
1. サイドバーから、利用可能なフィールドを編集します。
1. **選択項目を更新**を選択します。

プロジェクト内のイシューを一括編集する場合、次の属性を編集できます。

- 状態 (開始または完了)
- [担当者](managing_issues.md#assignees)
- [エピック](../../group/epics/_index.md)
- [マイルストーン](../milestones/_index.md)
- [ラベル](../labels.md)
- [ヘルスステータス](#health-status)
- [通知](../../profile/notifications.md)サブスクリプション
- [イテレーション](../../group/iterations/_index.md)
- [機密性](confidential_issues.md)

### グループからイシューを一括編集

{{< details >}}

- プラン:Premium、Ultimate
- 提供形態:GitLab.com、GitLab Self-Managed、GitLab Dedicated

{{< /details >}}

{{< history >}}

- GitLab 17.7では、グループからイシューを一括編集するための最小ロールがレポーターからプランナーに[変更されました](https://gitlab.com/gitlab-org/gitlab/-/merge_requests/169256)。

{{< /history >}}

グループ内で複数のプロジェクトにわたって複数のイシューを編集できます。

前提要件:

- グループのプランナーロール以上を持っている必要があります。

複数のイシューを同時に編集するには、次の手順に従います。

1. 左側のサイドバーで、**検索または移動**を選択して、グループを見つけます。
1. **プラン > イシュー**を選択します。
1. **一括編集**を選択します。画面の右側にサイドバーが表示されます。
1. 編集する各イシューの横にあるチェックボックスを選択します。
1. サイドバーから、利用可能なフィールドを編集します。
1. **選択項目を更新**を選択します。

グループ内のイシューを一括編集する場合、次の属性を編集できます。

- [エピック](../../group/epics/_index.md)
- [マイルストーン](../milestones/_index.md)
- [イテレーション](../../group/iterations/_index.md)
- [ラベル](../labels.md)
- [ヘルスステータス](#health-status)

## イシューを移動

{{< history >}}

- GitLab 17.7では、イシューを移動するための最小ロールがレポーターからプランナーに[変更されました](https://gitlab.com/gitlab-org/gitlab/-/merge_requests/169256)。

{{< /history >}}

イシューを移動すると、イシューはクローズされ、対象のプロジェクトにコピーされます。元のイシューは削除されません。どこから来てどこへ行ったかを示す[システムノート](../system_notes.md)が両方のイシューに追加されます。

異なるアクセスルールを持つプロジェクトにイシューを移動する場合は注意してください。イシューを移動する前に、機密データが含まれていないことを確認してください。

前提要件:

- プロジェクトのプランナーロール以上を持っている必要があります。

イシューを移動するには、次の手順に従います:

1. 左側のサイドバーで、**検索または移動**を選択して、プロジェクトを見つけます。
1. **プラン > イシュー**を選択し、イシューを選択して表示します。
1. 右側のサイドバーで、**イシューの移動**を選択します。
1. イシューの移動先のプロジェクトを検索します。
1. **移動**を選択します。

コメントまたは説明で`/move` [クイック アクション](../quick_actions.md)を使用することもできます。

### 親イシューが移動されたときのタスクの移動

{{< history >}}

- GitLab 16.9で`move_issue_children`[フラグとともに](../../../administration/feature_flags.md)[導入されました](https://gitlab.com/gitlab-org/gitlab/-/issues/371252)。デフォルトで無効になっています。
- GitLab 16.11 で[GitLab.com および GitLab Self-Managed で有効化されました](https://gitlab.com/gitlab-org/gitlab/-/issues/371252)。
- GitLab 17.3 で[一般提供](https://gitlab.com/gitlab-org/gitlab/-/issues/371252)になりました。機能フラグ`move_issue_children`が削除されました。

{{< /history >}}

イシューを別のプロジェクトに移動すると、すべての子タスクも対象プロジェクトに移動され、移動されたイシューの子タスクのままになります。各タスクは親と同じ方法で移動されます。つまり、元のプロジェクトでクローズされ、対象のプロジェクトにコピーされます。

### イシューの一括移動

{{< details >}}

- プラン:Free、Premium、Ultimate
- 提供形態:GitLab Self-Managed、GitLab Dedicated

{{< /details >}}

{{< history >}}

- GitLab 17.7では、イシューを一括移動するための最小ロールがレポーターからプランナーに[変更されました](https://gitlab.com/gitlab-org/gitlab/-/merge_requests/169256)。

{{< /history >}}

#### イシューページから

{{< history >}}

- GitLab 15.6 で[導入](https://gitlab.com/gitlab-org/gitlab/-/issues/15991)されました。

{{< /history >}}

プロジェクト内で複数のイシューを同時に移動できます。タスクまたはテストケースを移動することはできません。

前提要件:

- プロジェクトのプランナーロール以上を持っている必要があります。

複数のイシューを同時に移動するには、次の手順に従います:

1. 左側のサイドバーで、**検索または移動**を選択して、プロジェクトを見つけます。
1. **プラン > イシュー**を選択します。
1. **一括編集**を選択します。画面の右側にサイドバーが表示されます。
1. 移動する各イシューの横にあるチェックボックスを選択します。
1. 右側のサイドバーから、**選択項目を移動**を選択します。
1. ドロップダウンリストから、移動先のプロジェクトを選択します。
1. **移動**を選択します。

#### Railsコンソールから

1つのプロジェクトから別のプロジェクトに、すべてのオープンイシューを移動できます。

前提要件:

- GitLabインスタンスのRailsコンソールへのアクセス権が必要です。

:手順:

1. オプション (推奨)。コンソールで変更を試みる前に、[バックアップを作成](../../../administration/backup_restore/_index.md)します。
1. [Railsコンソール](../../../administration/operations/rails_console.md)を開きます。
1. 次のスクリプトを実行します。`project`、`admin_user`、および`target_project`をそれぞれの値に変更してください。

   ```ruby
   project = Project.find_by_full_path('full path of the project where issues are moved from')
   issues = project.issues
   admin_user = User.find_by_username('username of admin user') # make sure user has permissions to move the issues
   target_project = Project.find_by_full_path('full path of target project where issues moved to')

   issues.each do |issue|
      if issue.state != "closed" && issue.moved_to.nil?
         Issues::MoveService.new(container: project, current_user: admin_user).execute(issue, target_project)
      else
         puts "issue with id: #{issue.id} and title: #{issue.title} was not moved"
      end
   end; nil
   ```

1. Railsコンソールを終了するには、`quit`と入力します。

## 説明リストとタスクリスト

イシューの説明で、順序付きリスト、順序なしリスト、またはタスクリストを使用する場合、次のことができます。

- ドラッグアンドドロップでリスト項目を並べ替える
- リスト項目を削除
- [タスクリスト項目をGitLabタスクに変換](../../tasks.md#from-a-task-list-item)

### タスクリスト項目を削除

{{< history >}}

- GitLab 15.9 で[導入](https://gitlab.com/gitlab-org/gitlab/-/issues/377307)されました。

{{< /history >}}

前提要件:

- プロジェクトのレポーターロール以上を持っているか、イシューの作成者または担当者である必要があります。

タスクリスト項目を含むイシューの説明で:

1. タスクリスト項目にカーソルを合わせ、オプションメニュー({{< icon name="ellipsis_v" >}}) を選択します。
1. **削除**を選択します。

タスクリスト項目がイシューの説明から削除されます。ネストされたタスクリスト項目は、1つ上のネストレベルに移動されます。

### イシューの説明にあるリスト項目を並べ替える

{{< history >}}

- GitLab 15.0 で[導入](https://gitlab.com/gitlab-org/gitlab/-/issues/15260)されました。
- GitLab 17.7では、イシューの説明にあるリスト項目を並べ替えるための最小ロールがレポーターからプランナーに[変更されました](https://gitlab.com/gitlab-org/gitlab/-/merge_requests/169256)。

{{< /history >}}

説明にリストがあるイシューを表示するときに、リスト項目を並べ替えることもできます。

前提要件:

- プロジェクトのプランナーロール以上を持っているか、イシューの作成者であるか、イシューの担当者である必要があります。
- イシューの説明には、[順序付き、順序なし](../../markdown.md#lists)、または[タスク](../../markdown.md#task-lists)リストが必要です。

イシューを表示するときにリスト項目を並べ替えるには:

1. リスト項目の行にカーソルを合わせ、グリップアイコン({{< icon name="grip" >}}) を表示します。
1. グリップアイコンを選択して保持します。
1. 行をリストの新しい位置にドラッグします。
1. グリップアイコンをリリースします。

## イシューをクローズ

{{< history >}}

- GitLab 17.7では、イシューをクローズするための最小ロールがレポーターからプランナーに[変更されました](https://gitlab.com/gitlab-org/gitlab/-/merge_requests/169256)。

{{< /history >}}

イシューが解決されたか、不要になったと判断した場合は、イシューをクローズできます。イシューはクローズとしてマークされますが、削除されません。

前提要件:

- プロジェクトのプランナーロール以上を持っているか、イシューの作成者であるか、イシューの担当者である必要があります。

イシューをクローズするには、次のいずれかの方法を実行します:

- [イシューボード](../issue_board.md)で、イシューカードをリストから**クローズ**リストにドラッグします。
- GitLab UIの他のページから:
  1. 左側のサイドバーで、**検索または移動**を選択して、プロジェクトを見つけます。
  1. **プラン > イシュー**を選択し、イシューを選択して表示します。
  1. 右上隅で、**イシューアクション** ({{< icon name="ellipsis_v" >}}) を選択し、**イシューをクローズ**を選択します。

コメントまたは説明で`/close` [クイック アクション](../quick_actions.md)を使用することもできます。

### クローズされたイシューを再度オープン

{{< history >}}

- GitLab 17.7では、クローズされたイシューを再度オープンするための最小ロールがレポーターからプランナーに[変更されました](https://gitlab.com/gitlab-org/gitlab/-/merge_requests/169256)。

{{< /history >}}

前提要件:

- プロジェクトのプランナーロール以上を持っているか、イシューの作成者であるか、イシューの担当者である必要があります。

クローズされたイシューを再度オープンするには、右上隅で**イシューアクション** ({{< icon name="ellipsis_v" >}}) を選択し、**イシューを再度オープン**を選択します。再度オープンされたイシューは、他のオープンイシューと変わりません。

コメントまたは説明で`/reopen` [クイック アクション](../quick_actions.md)を使用することもできます。

### イシューを自動的にクローズ

コミットメッセージまたはマージリクエストの説明で、特定の単語 ( _クローズパターン_という) を使用して、イシューを自動的にクローズできます。GitLab Self-Managed管理者は、[デフォルトのクローズパターンを変更](../../../administration/issue_closing_pattern.md)できます。

コミットメッセージまたはマージリクエストの説明に[クローズパターン](#default-closing-pattern)に一致するテキストが含まれている場合、一致したテキストで参照されているすべてのイシューは、次のいずれかの時点でクローズされます:

- コミットがプロジェクトの[**デフォルト**ブランチ](../repository/branches/default.md)にプッシュされます。
- コミットまたはマージリクエストがデフォルトブランチにマージされます。

たとえば、マージリクエストの説明に`Closes #4, #6, Related to #5`を含めるとします:

- MRがマージされると、イシュー`#4`と`#6`が自動的にクローズされます。
- イシュー`#5`は[関連イシュー](related_issues.md)としてマークされますが、自動的にクローズされません。

または、[イシューからマージリクエストを作成する](../merge_requests/creating_merge_requests.md#from-an-issue)と、イシューのマイルストーンとラベルが継承されます。

パフォーマンス上の理由から、既存のリポジトリからの最初のプッシュでは、イシューの自動クローズは無効になっています。

#### マージ時のユーザー責任

マージリクエストをマージするときは、対象のイシューをクローズすることが適切かどうかを確認する責任があります。ユーザーは、マージリクエストの説明と、コミットメッセージの本文にイシューのクローズパターンを含めることができます。コミットメッセージ内のクローズメッセージは見落としやすいです。どちらの場合も、マージリクエストウィジェットには、マージ時にクローズするイシューに関する情報が表示されます:

![このマージリクエストはイシュー#2754をクローズします。](../merge_requests/img/closing_pattern_v17_4.png)

マージリクエストをマージすると、GitLabは、対象のイシューをクローズする権限があることを確認します。パブリックリポジトリでは、外部ユーザーがクローズパターンを含むマージリクエストとコミットの両方を作成できるため、このチェックは重要です。マージを実行するユーザーは、マージがプロジェクトのコードとイシューに与える影響を認識することが重要です。

マージリクエストに対して[自動マージ](../merge_requests/auto_merge.md)が有効になっている場合、自動的にクローズされるイシューのリストに、それ以上の変更を加えることはできません。

#### デフォルトのクローズパターン

{{< history >}}

- GitLab 17.3 で作業アイテム（タスク、目標、または主な成果）の参照が[導入](https://gitlab.com/gitlab-org/gitlab/-/issues/465391)されました。

{{< /history >}}

イシューを自動的にクローズするには、次のキーワードの後にイシューの参照を入力します。

使用可能なキーワード:

- Close, Closes, Closed, Closing, close, closes, closed, closing
- Fix, Fixes, Fixed, Fixing, fix, fixes, fixed, fixing
- Resolve, Resolves, Resolved, Resolving, resolve, resolves, resolved, resolving
- Implement, Implements, Implemented, Implementing, implement, implements, implemented, implementing

使用可能なイシューの参照形式:

- ローカルイシュー(`#123`)。
- クロスプロジェクトイシュー(`group/project#123`)。
- イシューの完全なURL (`https://gitlab.example.com/<project_full_path>/-/issues/123`)。
- 作業アイテム（タスク、目標、または主な成果など）の完全な URL:
  - プロジェクト内(`https://gitlab.example.com/<project_full_path>/-/work_items/123`)。
  - グループ内(`https://gitlab.example.com/groups/<group_full_path>/-/work_items/123`)。

次に例を示します:

```plaintext
Awesome commit message

Fix #20, Fixes #21 and Closes group/otherproject#22.
This commit is also related to #17 and fixes #18, #19
and https://gitlab.example.com/group/otherproject/-/issues/23.
```

上記のコミットメッセージは、このコミットがプッシュされたプロジェクトの `#18`、`#19`、`#20`、および `#21` と、`group/otherproject` の `#22` および `#23` をクローズします。`#17` はパターンに一致しないためクローズされません。

コマンドラインから `git commit -m` を使用して行う複数行のコミットメッセージまたはワンライナーで、クローズパターンを使用できます。

デフォルトのイシュークローズパターン正規表現:

```shell
\b((?:[Cc]los(?:e[sd]?|ing)|\b[Ff]ix(?:e[sd]|ing)?|\b[Rr]esolv(?:e[sd]?|ing)|\b[Ii]mplement(?:s|ed|ing)?)(:?) +(?:(?:issues? +)?%{issue_ref}(?:(?: *,? +and +| *,? *)?)|([A-Z][A-Z0-9_]+-\d+))+)
```

#### イシューの自動クローズを無効にする

{{< history >}}

- GitLab 15.4 で[変更](https://gitlab.com/gitlab-org/gitlab/-/issues/240922):参照されているイシューのプロジェクト設定が、コミットまたはマージリクエストのプロジェクトではなくチェックされます。

{{< /history >}}

[プロジェクトの設定](#disable-automatic-issue-closing)で、プロジェクトごとにイシューの自動クローズ機能を無効にできます。

前提要件:

- プロジェクトのメンテナーロール以上を持っている必要があります。

イシューの自動クローズを無効にするには:

1. 左側のサイドバーで、**検索または移動**を選択して、プロジェクトを見つけます。
1. **設定 > リポジトリ**を選択します。
1. **ブランチのデフォルト**を展開します。
1. **デフォルトブランチで参照されているイシューを自動的にクローズ**チェックボックスをオフにします。
1. **変更を保存**を選択します。

参照されているイシューは引き続き表示されますが、自動的にクローズされることはありません。

この設定の変更は、新しいマージリクエストまたはコミットにのみ適用されます。すでにクローズされているイシューはそのまま残ります。イシューの自動クローズの無効化は、設定が無効化されたプロジェクト内のイシューにのみ適用されます。このプロジェクトのマージリクエストとコミットは、引き続き別のプロジェクトイシューをクローズできます。

#### イシューのクローズパターンをカスタマイズする

{{< details >}}

- プラン:Free、Premium、Ultimate
- 提供形態:GitLab Self-Managed、GitLab Dedicated

{{< /details >}}

前提要件:

- GitLabインスタンスへの[管理者アクセス](../../../administration/_index.md)権が必要です。

インストールのデフォルトの[イシューのクローズパターン](../../../administration/issue_closing_pattern.md)を変更する方法について説明します。

## 「続きを読む」で説明が切り詰められるのを防ぐ

{{< history >}}

- GitLab 17.10 で[導入](https://gitlab.com/gitlab-org/gitlab/-/merge_requests/181184)されました。

{{< /history >}}

<!-- When issues as work items are GA and feature flag `work_items_view_preference` is removed, remove the prerequisite below. -->

イシューの説明が長い場合、GitLabはその一部のみを表示します。説明全体を表示するには、**続きを読む**を選択する必要があります。この切り捨てにより、長文をスクロールせずに、ページ上の他の要素を簡単に見つけることができます。

前提要件:

- [イシューの新しいルック](issue_work_items.md)を有効にする必要があります。

説明を切り詰めるかどうかを変更するには:

1. イシューの右上隅にある**その他のアクション** ({{< icon name="ellipsis_v" >}}) を選択します。
1. 好みに応じて**説明を切り詰める**を切り替えます。

この設定は記憶され、すべてのイシュー、タスク、エピック、目標、および主な成果に影響します。

## 右側のサイドバーを非表示にする

{{< history >}}

- GitLab 17.10 で[導入](https://gitlab.com/gitlab-org/gitlab/-/merge_requests/181184)されました。

{{< /history >}}

<!-- When issues as work items are GA and feature flag `work_items_view_preference` is removed, remove the prerequisite below. -->

スペースがある場合、イシューの属性は説明の右側のサイドバーに表示されます。

前提要件:

- [イシューの新しいルック](issue_work_items.md)を有効にする必要があります。

サイドバーを非表示にして、説明のスペースを増やすには:

1. イシューの右上隅にある**その他のアクション** ({{< icon name="ellipsis_v" >}}) を選択します。
1. **サイドバーを非表示**を選択します。

この設定は記憶され、すべてのイシュー、タスク、エピック、目標、および主な成果に影響します。

サイドバーを再度表示するには:

- 上記の手順を繰り返し、**サイドバーを表示**を選択します。

## イシュータイプを変更する

{{< history >}}

- イシュータイプを変更するための最小限のロールは、GitLab 17.7 でレポーターから[変更](https://gitlab.com/gitlab-org/gitlab/-/merge_requests/169256)されたプランナーです。

{{< /history >}}

前提要件:

- プロジェクトのプランナーロール以上を持っているか、イシューの作成者であるか、イシューに割り当てられている必要があります。

イシュータイプを変更するには:

1. 左側のサイドバーで、**検索または移動**を選択して、プロジェクトを見つけます。
1. **プラン > イシュー**を選択し、イシューを選択して表示します。
1. タイトルの右側にある**タイトルと説明を編集** ({{< icon name="pencil" >}}) を選択します。
1. イシューを編集し、**イシュータイプ**ドロップダウンリストからイシュータイプを選択します:

   - イシュー
   - [インシデント](../../../operations/incident_management/_index.md)

1. **変更を保存**を選択します。

## イシューを削除する

{{< history >}}

- イシューを削除するために必要なロールは、GitLab 17.7 でオーナーからオーナーまたはプランナーに[変更](https://gitlab.com/gitlab-org/gitlab/-/merge_requests/169256)されました。

{{< /history >}}

前提要件:

- プロジェクトのプランナーまたはオーナーのロールを持っている必要があります。

イシューを削除するには:

1. 左側のサイドバーで、**検索または移動**を選択して、プロジェクトを見つけます。
1. **プラン > イシュー**を選択し、イシューを選択して表示します。
1. 右上隅にある**イシューアクション** ({{< icon name="ellipsis_v" >}}) を選択します。
1. **イシューを削除**を選択します。

または:

1. 左側のサイドバーで、**検索または移動**を選択して、プロジェクトを見つけます。
1. **プラン > イシュー**を選択し、イシューのタイトルを選択して表示します。
1. **タイトルと説明を編集** ({{< icon name="pencil" >}}) を選択します。
1. **イシューを削除**を選択します。

## イシューをエピックにプロモートする

{{< details >}}

- プラン:Premium、Ultimate
- 提供形態:GitLab.com、GitLab Self-Managed、GitLab Dedicated

{{< /details >}}

{{< history >}}

- イシューをエピックにプロモートするための最小限のロールは、GitLab 17.7 でレポーターから[変更](https://gitlab.com/gitlab-org/gitlab/-/merge_requests/169256)されたプランナーです。

{{< /history >}}

イシューを直属の親グループの[エピック](../../group/epics/_index.md)にプロモートできます。

機密イシューをエピックにプロモートすると、機密性を維持した[機密エピック](../../group/epics/manage_epics.md#make-an-epic-confidential)が作成されます。

イシューがエピックにプロモートされると:

- エピックは、イシューのプロジェクトと同じグループに作成されます。
- イシューのサブスクライバーには、エピックが作成されたことが通知されます。

次のイシューメタデータがエピックにコピーされます:

- タイトル、説明、アクティビティ、およびコメントスレッド。
- 同意および不同意。
- 参加者。
- イシューが持っていたグループラベル。
- 親エピック。

前提要件:

- イシューが属するプロジェクトはグループ内にある必要があります。
- プロジェクトの直属の親グループに対して、少なくともプランナーロールを持っている必要があります。
- 次のいずれかの条件を満たす必要があります:
  - プロジェクトに対して少なくともプランナーロールを持っている。
  - イシューの作成者である。
  - イシューに割り当てられている。

イシューをエピックにプロモートするには:

1. 左側のサイドバーで、**検索または移動**を選択して、プロジェクトを見つけます。
1. **プラン > イシュー**を選択し、イシューを選択して表示します。
1. 右上隅にある**イシューアクション** ({{< icon name="ellipsis_v" >}}) を選択します。
1. **エピックにプロモート**を選択します。

または、`/promote` [クイック アクション](../quick_actions.md#issues-merge-requests-and-epics)を使用することもできます。

## イシューをインシデントにプロモートする

{{< history >}}

- イシュー作成時にイシュータイプをインシデントとして設定するクイックアクションが GitLab 15.8 で[導入](https://gitlab.com/gitlab-org/gitlab/-/issues/376760)されました。

{{< /history >}}

`/promote_to_incident` [クイック アクション](../quick_actions.md)を使用して、イシューを[インシデント](../../../operations/incident_management/incidents.md)にプロモートできます。

## イシューをイテレーションに追加する

{{< details >}}

- プラン:Premium、Ultimate
- 提供形態:GitLab.com、GitLab Self-Managed、GitLab Dedicated

{{< /details >}}

イシューを[イテレーション](../../group/iterations/_index.md)に追加するには:

1. 左側のサイドバーで、**検索または移動**を選択して、プロジェクトを見つけます。
1. **プラン > イシュー**を選択し、イシューを選択して表示します。
1. 右側のサイドバーの**イテレーション**セクションで、**編集**を選択します。
1. ドロップダウンリストから、このイシューを追加するイテレーションを選択します。
1. ドロップダウンリストの外側の領域を選択します。

イシューをイテレーションに追加するには、次の方法もあります:

- `/iteration` [クイック アクション](../quick_actions.md#issues-merge-requests-and-epics)を使用する
- イシューをボードのイテレーションリストにドラッグする
- イシューリストからイシューを一括編集する

## 自分に割り当てられたすべてのイシューを表示する

自分に割り当てられたすべてのイシューを表示するには:

1. 左側のサイドバーで、**検索または移動**を選択します。
1. ドロップダウンリストから、**自分に割り当てられたイシュー**を選択します。

または:

- [キーボードショートカット](../../shortcuts.md)を使用するには、<kbd>Shift</kbd> + <kbd>i</kbd> を押します。
- 左側のサイドバーの上部にある**割り当てられたイシュー** ({{< icon name="issues" >}}) を選択します。

## イシューリスト

イシューリストには、プロジェクトまたはグループ内のすべてのイシューが表示されます。イシューの表示、ソート、および管理に使用できます。

イシューリストを表示するには:

1. 左側のサイドバーで、**検索または移動**を選択して、プロジェクトを見つけます。
1. **プラン > イシュー**を選択します。

イシューリストから、次のことができます:

- タイトル、担当者、ラベル、マイルストーンなどのイシューの詳細を表示します。
- さまざまな基準で[イシューをソート](sorting_issue_lists.md)します。
- イシューをフィルタリングして、特定のイシューを見つけます。
- イシューを個別にまたは一括で編集します。
- 新しいイシューを作成します。

次のセクションでは、イシューリストの操作方法について説明します。

### イシューのリストをフィルタリングする

{{< history >}}

- タイプによるフィルタリングは、GitLab 13.10 で[導入](https://gitlab.com/gitlab-org/gitlab/-/issues/322755)され、[フラグ](../../../administration/feature_flags.md) `vue_issues_list` が付けられました。デフォルトで無効になっています。
- タイプによるフィルタリングは、GitLab 14.10 の[GitLab Self-Managed で有効](https://gitlab.com/gitlab-org/gitlab/-/issues/322755)になりました。
- タイプによるフィルタリングは、GitLab 15.1 で一般的に利用可能です。[機能フラグ `vue_issues_list`](https://gitlab.com/gitlab-org/gitlab/-/issues/359966)が削除されました。
- ヘルスステータスによるフィルタリングは、GitLab 15.5 で[導入](https://gitlab.com/gitlab-org/gitlab/-/issues/218711)されました。

{{< /history >}}

イシューのリストをフィルタリングするには:

1. 左側のサイドバーで、**検索または移動**を選択して、プロジェクトを見つけます。
1. **プラン > イシュー**を選択します。
1. イシューのリストの上にある**検索またはフィルタリング結果**を選択します。
1. 表示されるドロップダウンリストで、フィルタリングする属性を選択します。
1. 属性のフィルタリングに使用する演算子を選択または入力します。次の演算子が使用可能です:
   - `=`:次と等しい
   - `!=`:次のいずれでもない
1. 属性でフィルタリングするテキストを入力します。一部の属性は、**なし**または**任意**でフィルタリングできます。
1. 複数の属性でフィルタリングするには、このプロセスを繰り返します。複数の属性は、論理`AND`で結合されます。

#### タイトルまたは説明でフィルタリングする

タイトルまたは説明のテキストについて、イシューのリストをフィルタリングするには:

1. 左側のサイドバーで、**検索または移動**を選択して、プロジェクトを見つけます。
1. **プラン > イシュー**を選択します。
1. イシューのリストの上にある**検索またはフィルタリング結果**テキストボックスに、検索する語句を入力します。
1. 表示されるドロップダウンリストで、**検索範囲**を選択し、**タイトル**または**説明**のいずれかを選択します。
1. <kbd>Enter</kbd>を押すか、検索アイコン ({{< icon name="search" >}}) を選択します。

イシューのフィルタリングでは、意味のある重要な単語を照合してクエリに答えるために、[PostgreSQL全文検索](https://www.postgresql.org/docs/current/textsearch-intro.html)が使用されます。

たとえば、`I am securing information for M&A` を検索すると、GitLab はタイトルまたは説明に `securing`、`secured`、または `information` が含まれる結果を返すことができます。ただし、GitLab は文または単語 `I`、`am`、または `M&A` を正確に一致させません。これらは語彙的に意味があるまたは重要とは見なされないためです。これは、PostgreSQL全文検索の制限事項です。

#### OR演算子でフィルタリングする

{{< history >}}

- 作成者と担当者のORフィルタリングは、GitLab 15.6 で[導入](https://gitlab.com/gitlab-org/gitlab/-/issues/23532)され、[フラグ](../../../administration/feature_flags.md) `or_issuable_queries` が付けられました。デフォルトで無効になっています。
- ラベルのORフィルタリングは、GitLab 15.8 で[導入](https://gitlab.com/gitlab-org/gitlab/-/issues/23532)され、[フラグ](../../../administration/feature_flags.md) `or_issuable_queries` が付けられました。デフォルトで無効になっています。
- GitLab 15.9 の[GitLab.com および GitLab Self-Managed で有効化](https://gitlab.com/gitlab-org/gitlab/-/merge_requests/104292)されました。
- GitLab 17.0 で[一般提供](https://gitlab.com/gitlab-org/gitlab/-/issues/296031)。機能フラグ`or_issuable_queries`が削除されました。

{{< /history >}}

OR演算子(**次のいずれか: `||`**)は、[イシューのリストをフィルター](#filter-the-list-of-issues)するときに使用できます。

- 担当者
- 作成者
- ラベル

`is one of`は、包括的なORを表します。たとえば、`Assignee is one of Sidney Jones`と`Assignee is one of Zhang Wei`でフィルタリングすると、GitLabは、`Sidney`、`Zhang`、またはその両方が担当者であるイシューを表示します。

#### IDでイシューをフィルタリング

1. 左側のサイドバーで、**検索または移動**を選択して、プロジェクトを見つけます。
1. **プラン > イシュー**を選択します。
1. **検索**ボックスに、`#`の後にイシューのIDを入力します。たとえば、`#10`というフィルターを入力すると、イシュー10のみが返されます。

![特定のIDでイシューをフィルタリング](img/issue_search_by_id_v15_0.png)

### drawerでイシューを開く

{{< details >}}

- 提供形態:GitLab Self-Managed

{{< /details >}}

{{< history >}}

- [導入](https://gitlab.com/gitlab-org/gitlab/-/issues/464063) GitLab 17.4 [フラグ](../../../administration/feature_flags.md)付き`issues_list_drawer`という名前が付けられています。デフォルトで無効になっています。

{{< /history >}}

{{< alert type="flag" >}}

この機能の可用性は、機能フラグによって制御されます。詳細については、履歴を参照してください。この機能はテストには使用できますが、本番環境での使用準備はできていません。

{{< /alert >}}

この機能が有効になっている場合、リストまたはイシューボードからイシューを選択すると、drawerで開きます。次に、イシューを編集したり、コメントを作成したりできます。

イシューをフルビューで開くには:

- 新しいタブでイシューを開きます。イシューのリストから、次のいずれかを実行します:
  - イシューを右クリックして、新しいブラウザータブで開きます。
  - <kbd>Cmd</kbd>または<kbd>Ctrl</kbd>を押しながら、イシューをクリックします。
- drawerの左上隅で、**フルビューで開く**を選択します。

![drawerで開いたイシュー。](img/issue_drawer_v17_4.png)

## イシュー参照をコピー

GitLabの別の場所でイシューを参照するには、完全なURLまたは短い参照(`namespace/project-name#123`のようなもの。ここで、`namespace`はグループまたはユーザー名のいずれかです)を使用できます。

イシュー参照をクリップボードにコピーするには:

1. 左側のサイドバーで、**検索または移動**を選択して、プロジェクトを見つけます。
1. **プラン > イシュー**を選択し、イシューを選択して表示します。
1. 右側のサイドバーの**参照**の横にある**参照のコピー**({{< icon name="copy-to-clipboard" >}})を選択します。

これで、参照を別の説明またはコメントに貼り付けることができます。

[GitLab-Flavored Markdown](../../markdown.md#gitlab-specific-references)でのイシュー参照について続きを読む

## イシューのメールアドレスをコピー

メールを送信してイシューにコメントを作成できます。このアドレスにメールを送信すると、メール本文を含むコメントが作成されます。

メールの送信によるコメントの作成、および必要な設定の詳細については、[メールを送信してコメントに返信する](../../discussions/_index.md#reply-to-a-comment-by-sending-email)を参照してください。

イシューのメールアドレスをコピーするには:

1. 左側のサイドバーで、**検索または移動**を選択して、プロジェクトを見つけます。
1. **プラン > イシュー**を選択し、イシューを選択して表示します。
1. 右側のサイドバーの**イシューメール**の横にある**参照のコピー**({{< icon name="copy-to-clipboard" >}})を選択します。

## 担当者

イシューは1人または[複数のユーザー](multiple_assignees_for_issues.md)に割り当てることができます。

担当者は必要に応じて何度でも変更できます。担当者はイシューの責任者であるという考え方です。イシューが誰かに割り当てられると、そのユーザーの**割り当てられたイシュー**ページに表示されます。

ユーザーがプロジェクトのメンバーでない場合、自分で作成するか、別のプロジェクトメンバーが割り当てる場合にのみ、イシューを割り当てることができます。

### イシューの担当者を変更

{{< history >}}

- 担当者を変更するための最小ロールが、GitLab 17.7でレポーターからプランナーに[変更](https://gitlab.com/gitlab-org/gitlab/-/merge_requests/169256)されました。

{{< /history >}}

前提要件:

- プロジェクトのプランナーロール以上を持っている必要があります。

イシューの担当者を変更するには:

1. 左側のサイドバーで、**検索または移動**を選択して、プロジェクトを見つけます。
1. **プラン > イシュー**を選択し、イシューを選択して表示します。
1. 右側のサイドバーの**担当者**セクションで、**編集**を選択します。
1. ドロップダウンリストから、担当者として追加するユーザーを選択します。
1. ドロップダウンリストの外側の領域を選択します。

担当者は、ページを更新しなくても変更されます。

## 類似イシュー

同じトピックに関するイシューの重複を防ぐために、GitLabは新しいイシューを作成するときに類似のイシューを検索します。

**新しいイシュー**ページのタイトルのテキストボックスに入力すると、GitLabは現在のプロジェクトのすべてのイシューのタイトルと説明を検索します。アクセスできるイシューのみが返されます。最後に更新された順に並べられた最大5つの類似イシューが、タイトルのテキストボックスの下に表示されます。

## ヘルスステータス

{{< details >}}

- プラン:Ultimate
- 提供形態:GitLab.com、GitLab Self-Managed、GitLab Dedicated

{{< /details >}}

{{< history >}}

- GitLab 15.4で[導入](https://gitlab.com/gitlab-org/gitlab/-/issues/218618): ヘルスステータスがイシューボードのイシューカードに表示されるようになりました。

{{< /history >}}

計画を達成する上でのリスクをより適切に追跡するために、各イシューにヘルスステータスを割り当てることができます。ヘルスステータスを使用すると、計画どおりにイシューが進捗しているか、スケジュールどおりに進捗するために注意が必要かを組織内の他の人に知らせることができます。

イシューのヘルスステータスのレビューを、毎日のスタンドアップ、プロジェクトステータスレポート、または週次ミーティングに組み込んで、計画された作業のタイムリーな配信に対するリスクに対処します。

### イシューのヘルスステータスを変更

{{< history >}}

- ヘルスステータスを変更するための最小ロールが、GitLab 17.7でレポーターからプランナーに[変更](https://gitlab.com/gitlab-org/gitlab/-/merge_requests/169256)されました。

{{< /history >}}

前提要件:

- プロジェクトのプランナーロール以上を持っている必要があります。

イシューのヘルスステータスを編集するには:

1. 左側のサイドバーで、**検索または移動**を選択して、プロジェクトを見つけます。
1. **プラン > イシュー**を選択し、イシューを選択して表示します。
1. 右側のサイドバーの**ヘルスステータス**セクションで、**編集**を選択します。
1. ドロップダウンリストから、このイシューに追加するステータスを選択します:

   - On track (緑)
   - Needs attention (琥珀)
   - At risk (赤)

イシューのヘルスステータスは以下で確認できます。

- **イシュー**ページ
- Epic Tree
- イシューボードのイシューカード

イシューが完了すると、ヘルスステータスは編集できなくなり、イシューを再度オープンするまで**編集**ボタンは無効になります。

`/health_status` および `/clear_health_status` [クイック アクション](../quick_actions.md#issues-merge-requests-and-epics)を使用して、ヘルスステータスを設定およびクリアすることもできます。

## イシューを公開

{{< details >}}

- プラン:Ultimate
- 提供形態:GitLab.com、GitLab Self-Managed、GitLab Dedicated

{{< /details >}}

ステータスページアプリケーションがプロジェクトに関連付けられている場合は、`/publish` [クイック アクション](../quick_actions.md)を使用してイシューを公開できます。

詳細については、[GitLabステータスページ](../../../operations/incident_management/status_page.md)を参照してください。

## イシュー関連のクイック アクション

[クイック アクション](../quick_actions.md#issues-merge-requests-and-epics)を使用してイシューを管理することもできます。

一部のアクションには、まだ対応するUIボタンがありません。次の操作は、**クイック アクションを使用する**場合にのみ実行できます:

- [Zoomミーティングの追加または削除](associate_zoom_meeting.md)（`/zoom`および`/remove_zoom`）。
- [イシューの公開](#publish-an-issue)（`/publish`）。
- 同じまたは別のプロジェクトにイシューを複製します（`/clone`）。
- イシューをクローズし、別のイシューの複製としてマークします（`/duplicate`）。
- プロジェクト内の別のマージリクエストまたはイシューからラベルとマイルストーンをコピーします（`/copy_metadata`）。
