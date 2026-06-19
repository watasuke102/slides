#import "@watasuke102/slide:1.0.0": *
#show: slides.with()

#template_title_main(
  [在学生活動紹介],
  [2026-03-27 | 筑波大学 情報メディア創成学類 オープンキャンパス (春) \ 情報メディア創成学類 3年 渡辺耀介],
)

#template_basic(
  align(horizon, grid(
    rows: 2,
    columns: 2,
    column-gutter: 1cm,
    image("img/icon512.jpg", width: 5.3cm),
    grid.cell(rowspan: 2, [
      #change_text_size(15pt)[*渡辺耀介*]\ #text(fill: gray2)[WATANABE Yosuke]
      - インターネットで *わたすけ* (\@watasuke1024) として生活しています
      - 宇部高専 制御情報工学科 #change_text_size(-3pt)[(山口県, ～2025.03)]\
        → 筑波大学 情報メディア創成学類 #change_text_size(-3pt)[(*3年次編入*)]
      - インタラクティブプログラミング研究室\ (*IPLAB*) WAVEチーム
      - 趣味：*ソフトウェア開発*、作曲、料理
    ]),
    align(bottom, image("img/humanForm.png", width: 5.3cm)),
  )),
)

#template_center(
  upper: [
    == 高専時代 (1)
    - 英単語テストの対策がダルかった
    - テスト対策問題を作ってクラス内に共有できるサービス「*TAGether*」を作った
      - Next.js, TypeScript, MySQL
    - けっこう多くの人に使ってもらえた
  ],
  image("img/tagether_logo.png"),
)
#template_center(
  upper: [
    == 高専時代 (2)
    - VRヘッドセットでPCのウィンドウを管理するソフトを開発
    - 2022年度の*未踏アドバンスト*という事業に採択された
      - 情報処理推進機構 (*IPA*) からお金をもらったり、メンターという指導者にアドバイスを貰ったりしつつ開発できる
  ],
  image("img/zwin-zen.jpg"),
)
#template_center(
  upper: [
    == 高専時代 (3)
    - 高専祭という文化祭みたいなやつの*広報部長*になった
    - パンフレット・Webサイト・エンディング動画を制作
  ],
  image("img/kosensai.jpg"),
)
#template_basic[
  == 高専～大学
  - セキュリティや情報に関する技術を集中して学ぶ合宿\ 「*セキュリティ・キャンプ*」に参加
  - 2022：#underline[CPU自作ゼミ]
  - 2023：#underline[ネクストキャンプ]
  - 2025：#underline[チューター]（主にCコンパイラゼミ）
  - 筑波大学はセキュリティ・キャンプ参加率が高い！（たぶん）
    - 2025 Cコンパイラゼミ受講者4人のうち半分が筑波大学生
]

#for i in range(6) {
  template_basic[
    == なぜ編入？
    #(
      (
        [- 高専在学中にHCIという分野を知る],
        [- HCIやりてえ～],
        [- 筑波大学にIPLABというHCIをやっている研究室がある],
        [- IPLABいきてえ～],
        [→行けました],
      )
        .slice(0, i)
        .join()
    )
  ]
}
#template_center(caption: [編入体験記をブログに残している], box(
  inset: 10pt,
  stroke: 2pt + white,
  image("img/blog.jpg"),
))

#template_basic[
  == 大学生活 (1)
  部活、サークル
  - 映画研究部
    - 名前が仰々しいが、実態は映画を観るだけ
  - 作曲サークル
    - ほぼ毎月、テーマを決めて曲を作り、ミニアルバムを公開
    - 2025年に7曲つくった
]
#template_center(
  upper: [
    == 大学生活 (2)
    - *COJT* というおもしろ授業がある
    - FPGAというハードウェアをいじって映像を出力する
    - 2025年度の間ずっと取り組んでいた
  ],
  caption: [
    下の方にある装置がFPGA #change_text_size(-5pt, text(fill: gray1)[(Field Programmable Gate Array)])
  ],
  image("img/cojt_pattern.jpg"),
)
#template_basic[
  == 大学生活 (3)
  プレゼンをする機会が増えた
  - 昨年11月：Terminal Night \#1#change_text_size(-3pt)[（ターミナルに関するイベント）]
  - 不定期：#underline[*UNTIL. LT*]#change_text_size(-3pt)[（*筑波大*の有志による情報系スライド発表会）]
  - 先週：Kernel/VM#change_text_size(-3pt)[（コンピュータいじりに関するイベント）]
]
#template_center(
  upper: [
    == 大学生活 (4)
    学会にボランティアとして参加した（今月初頭）
  ],
  image("img/interaction.jpg", height: 1fr),
)

#pagebreak()
