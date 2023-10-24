# Sphinxとは
Sphinx はブラウザーで表示するドキュメント（オンラインマニュアル 等）を作成するツール。
元々は Python のドキュメント用に作成されたものですが、現在は多くのドキュメントを作成するのに使用されている。

# Sphinx導入
## Sphinxインストール(Windows)
### Sphinxインストール　事前作業　Minicondaの導入
まず、Windows上でPythonが動作する環境を構築する。  
1,Minicondaのサイトよりインストーラをダウンロードし、インストールを行う。  
https://docs.conda.io/projects/miniconda/en/latest/  

参考  
https://qiita.com/terahide/items/253eff6fba38c8f53746  

2,「anaconda prompt」を起動し、以下を実行しインストール確認を行う。  
conda -V  
python --version  

### Sphinxのインストール  
1,pipコマンドでインストールを実行  
pip install -U sphinx  

2,インストール確認  
sphinx-build --version  

3,マークダウンを使用するために必要なプラグインのインストール  
pip install --upgrade myst-parser  

## Sphinxインストール(linux)  
Linuxのインストール手順は以下となる。設定部分はWindowsと共通となる。  

```
sudo su -  
yum install python-sphinx  
※依存関係含めてインストール  
pip install --upgrade myst-parser  
mkdir -p /work/sphinx
cd /work/sphinx
sphinx-quickstar
```

# Sphinx設定
参考  
https://zenn.dev/y_mrok/books/sphinx-no-tsukaikata/viewer/chapter8  

1,プロジェクト作成したいフォルダに移動した後、以下コマンドを実行する。  
　今回は「C:\zyuku\work\files」とする。  

```
(base) C:\zyuku\work\files>sphinx-quickstart
Welcome to the Sphinx 7.2.6 quickstart utility.

Please enter values for the following settings (just press Enter to
accept a default value, if one is given in brackets).

Selected root path: .

You have two options for placing the build directory for Sphinx output.
Either, you use a directory "_build" within the root path, or you separate
"source" and "build" directories within the root path.
> Separate source and build directories (y/n) [n]: n

The project name will occur in several places in the built documentation.
> Project name: workmemo
> Author name(s): kuramochi
> Project release []: 1

If the documents are to be written in a language other than English,
you can select a language here by its language code. Sphinx will then
translate text that it generates into that language.

For a list of supported codes, see
https://www.sphinx-doc.org/en/master/usage/configuration.html#confval-language.
> Project language [en]: jp

Creating file C:\zyuku\work\files\conf.py.
Creating file C:\zyuku\work\files\index.rst.
Creating file C:\zyuku\work\files\Makefile.
Creating file C:\zyuku\work\files\make.bat.

Finished: An initial directory structure has been created.

You should now populate your master file C:\zyuku\work\files\index.rst and create other documentation
source files. Use the Makefile to build the docs, like so:
   make builder
where "builder" is one of the supported builders, e.g. html, latex or linkcheck.
```

2,filesの1つ上の階層に「docs」フォルダを作成し、github公開用ファイルはこちらに作成するようにする。  
　なお、「files」配下の「.md」ファイルは記事執筆時に作成する。ファイルである。読み込むファイルは「index.rst」に定義する。  
```
PS C:\zyuku\work> tree /f
フォルダー パスの一覧
ボリューム シリアル番号は 9034-2121 です
C:.
├─docs
│
└─files
    │  conf.py
    │  github.md
    │  index.rst
    │  make.bat
    │  Makefile
    │  shpinx.md
    │  その他.md
    │
    ├─_build
    ├─_static
    └─_templates
PS C:\zyuku\work>
```
3,conf.pyの編集  
それぞれ以下要件のためconf.pyを編集する。  
①、デフォルトではmdファイルを認識しないようなので設定を追記する。  

source_suffix を追記します。  
```
source_suffix = {
    '.rst': 'restructuredtext',
    '.md': 'markdown',
}
```

extensions に 'myst_parser` を追記します。  

②、GitHubPagesはサイトをビルドするのにデフォルトでJekyllを利用するが、この場合「_static」や「_images」フォルダが認識されなくなってしまう。  

```
extensions = [
    'sphinx.ext.githubpages','myst_parser'
]
```
これにより、空ファイル.nojekyllが自動生成されるため、CSSや画像がうまく適用されるようになる。  

③、画面テーマの変更  
色々選ぶことはできるがこちらに変更とした。  
```
html_theme = 'nature'
```

4,make.batファイルはWindows環境でビルドするためのバッチファイルのため、今回はこちらを編集する。  
　なお、MakefileはLinux環境でビルドするためのファイルであり、今回は使用しない。  

```
@ECHO OFF

pushd %~dp0

REM Command file for Sphinx documentation

if "%SPHINXBUILD%" == "" (
	set SPHINXBUILD=sphinx-build
)
set SOURCEDIR=.
set BUILDDIR=../docs　#編集

%SPHINXBUILD% >NUL 2>NUL
if errorlevel 9009 (
	echo.
	echo.The 'sphinx-build' command was not found. Make sure you have Sphinx
	echo.installed, then set the SPHINXBUILD environment variable to point
	echo.to the full path of the 'sphinx-build' executable. Alternatively you
	echo.may add the Sphinx directory to PATH.
	echo.
	echo.If you don't have Sphinx installed, grab it from
	echo.https://www.sphinx-doc.org/
	exit /b 1
)

if "%1" == "" goto help

%SPHINXBUILD% -b %1 %SOURCEDIR% %BUILDDIR% %SPHINXOPTS% %O%　#編集
goto end

:help
%SPHINXBUILD% -M help %SOURCEDIR% %BUILDDIR% %SPHINXOPTS% %O%

:end
popd

```

5,「index.rst」ファイルに執筆したmdファイルを記載し、ページ遷移できるようにする。  
※Sphinx のインデントは半角空白 3 文字なので注意すること。  

```
Welcome to workmemo's documentation!
====================================

.. toctree::
   :maxdepth: 2
   :caption: Contents:

   ./shpinx.md
   ./github.md
   ./その他.md

Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`
```

6,ドキュメントをビルドする  
・ビルドの対象になるファイルは追加、変更されたファイルだけです。ビルドした結果が思ったものと異なる場合は docs フォルダー内の .nojekyll ファイル以外を削除し、再度ビルドしてください。  
・GitHub へ push する前に、 docs フォルダー内の .nojekyll ファイル以外を削除　→　ビルドすることをお勧めします。  
```
(base) C:\zyuku\work\files>make html
Running Sphinx v7.2.6
loading translations [jp]... not available for built-in messages
loading pickled environment... done
myst v2.0.0: MdParserConfig(commonmark_only=False, gfm_only=False, enable_extensions=set(), disable_syntax=[], all_links_external=False, url_schemes=('http', 'https', 'mailto', 'ftp'), ref_domains=None, fence_as_directive=set(), number_code_blocks=[], title_to_header=False, heading_anchors=0, heading_slug_func=None, html_meta={}, footnote_transition=True, words_per_minute=200, substitutions={}, linkify_fuzzy_links=True, dmath_allow_labels=True, dmath_allow_space=True, dmath_allow_digits=True, dmath_double_inline=False, update_mathjax=True, mathjax_classes='tex2jax_process|mathjax_process|math|output_area', enable_checkboxes=False, suppress_warnings=[], highlight_code_blocks=True)
building [mo]: targets for 0 po files that are out of date
writing output...
building [html]: targets for 0 source files that are out of date
updating environment: [extensions changed ('3')] 4 added, 0 changed, 0 removed
reading sources... [100%] その他
looking for now-outdated files... none found
pickling environment... done
checking consistency... done
preparing documents... done
copying assets... copying static files... done
copying extra files... done
done
writing output... [100%] その他
generating indices... genindex done
writing additional pages... search done
dumping search index in English (code: en)... done
dumping object inventory... done
build succeeded.

The HTML pages are in ..\docs.
```