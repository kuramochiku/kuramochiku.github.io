# Sphinx(Windows) python系のドキュメント作成ツール  
## Sphinxインストール　事前作業　Minicondaの導入
まず、Windows上でPythonが動作する環境を構築します。
1,Minicondaのサイトよりインストーラをダウンロードし、インストールを行う。 
https://docs.conda.io/projects/miniconda/en/latest/  

参考 
https://qiita.com/terahide/items/253eff6fba38c8f53746  

2,「anaconda prompt」を起動し、以下を実行しインストール確認を行う。 
conda -V 
python --version  

## Sphinxのインストール 
1,pipコマンドでインストールを実行 
pip install -U sphinx  

2,インストール確認 
sphinx-build --version  

## Sphinx設定 
1,プロジェクト作成したいフォルダに移動した後、以下コマンドを実行 
sphinx-quickstart  

2,後述手順でbulidフォルダがうまくgit登録対象とならなかったため、「docs」フォルダを作成し、機能を移管する。

## あ
「index.rst」ファイルに執筆したmdファイルを記載し、ページ遷移できるようにする。
```

```

## make
```
(base) C:\zyuku\test>make html
Running Sphinx v7.2.6
loading translations [jp]... not available for built-in messages
WARNING: html_static_path entry '_static' does not exist
loading pickled environment... failed: source directory has changed
done
building [mo]: targets for 0 po files that are out of date
writing output...
building [html]: targets for 1 source files that are out of date
updating environment: [new config] 1 added, 0 changed, 0 removed
reading sources... [100%] index
C:\zyuku\test\source\index.rst:9: WARNING: toctree contains reference to nonexisting document 'sgpinx.md'
C:\zyuku\test\source\index.rst:9: WARNING: toctree contains reference to nonexisting document 'github.md'
C:\zyuku\test\source\index.rst:9: WARNING: toctree contains reference to nonexisting document 'その他.md'
looking for now-outdated files... none found
pickling environment... done
checking consistency... done
preparing documents... done
copying assets... copying static files... done
copying extra files... done
done
writing output... [100%] index
generating indices... genindex done
writing additional pages... search done
dumping search index in English (code: en)... done
dumping object inventory... done
build succeeded, 4 warnings.

The HTML pages are in docs.

(base) C:\zyuku\test>
```

よくわからないので以下は削除する。
```
:caption: Contents:

Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`
```

参考：
https://zenn.dev/y_mrok/books/sphinx-no-tsukaikata/viewer/chapter10

## マークダウンファイルを使うために
デフォルトではmdファイルを認識しないようなので以下コマンドにてプラグインをインストールする。
pip install --upgrade myst-parser

extensions に 'myst_parser` を追記します。
```
extensions = [
    'myst_parser'
]
```

source_suffix を追記します。
```
source_suffix = {
    '.rst': 'restructuredtext',
    '.md': 'markdown',
}
```
